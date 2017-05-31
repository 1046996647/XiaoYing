//
//  MoveFileViewController.m
//  XiaoYing
//
//  Created by chenchanghua on 16/12/8.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "MoveFileViewController.h"
#import "DocumentViewModel.h"
#import "DocumentModel.h"
#import "CompanyFileManageController.h"

@interface MoveFileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *moveFileTableView;
@property (nonatomic, strong) NSMutableArray *folderModelArray;

@end

@implementation MoveFileViewController

- (UITableView *)moveFileTableView
{
    if (!_moveFileTableView) {
        _moveFileTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
        _moveFileTableView.backgroundColor = [UIColor clearColor];
        _moveFileTableView.delegate = self;
        _moveFileTableView.dataSource = self;
        _moveFileTableView.tableFooterView = [[UIView alloc] init];
        if ([_moveFileTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_moveFileTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_moveFileTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_moveFileTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _moveFileTableView;
}

- (void)setupBottomView
{
    //滑动视图引起的特殊位置，再减64
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-64-44, kScreen_Width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];

    //顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:topView];
    
    //确定移动按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, kScreen_Width, 44);
    [btn setTitle:@"确认移动" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(movieSureAction) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:btn];
    
}

- (void)movieSureAction
{
    //1.发起网络请求
    [DocumentViewModel removeFileToDestributeFolderId:self.folderId fileId:self.fileId success:^(NSDictionary *dataList) {
        
        NSLog(@"移动文件成功:%@", dataList);
        
        //2.服务端成功后，展示图片告知成功
        [self showImageAnimalAction];
        
        //3.最后跳转到企业文档管理的首页
        NSArray  *controlArray = self.navigationController.childViewControllers;
        for (UIViewController * vc in controlArray) {
            
            if ([vc isKindOfClass:[CompanyFileManageController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        
    } failed:^(NSError *error) {
        
        NSLog(@"移动文件失败:%@", error);
    }];

}

//转移成功之后显示的图片
- (void)showImageAnimalAction {
    UIImageView *moveSuccessImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"finish_move"]];
    [moveSuccessImage setFrame:CGRectMake((kScreen_Width - 190) / 2, (kScreen_Height - 90) / 2 - 100, 190, 90)];
    [self.moveFileTableView addSubview:moveSuccessImage];
    [moveSuccessImage setHidden:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatCount:1.0];
    [UIView commitAnimations];
    
    [moveSuccessImage setHidden:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    
    self.navigationItem.title = [NSString stringWithFormat:@"移动至%@", self.folderName];
    
    [self.view addSubview: self.moveFileTableView];
    
    [self getfolderListBaseOnParentFolderId:self.folderId];
    
    [self setupBottomView];
    
}

//根据文件夹id获取该文件夹下的文件夹列表数据
- (void)getfolderListBaseOnParentFolderId:(NSString *)folderId
{
    [DocumentViewModel getDocumentListDataWithFolderId:folderId success:^(NSArray *documentListArray) {
        //根据传过来测总的文档数据，按文件夹和文件两种类型进行分类
        NSMutableArray *folderArray = [NSMutableArray array];
        for (DocumentModel *documentModel in [DocumentModel getModelArrayFromModelArray:documentListArray]) {
            if (documentModel.documentType == 0) { //代表文件夹
                [folderArray addObject:documentModel];
            }
        }
        
        NSLog(@"folderArray~~%@", folderArray);
        self.folderModelArray = folderArray;//数据源
        [self.moveFileTableView reloadData];//根据数据源刷新UI
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@", error);
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.folderModelArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击文件夹进入该文件夹里面
    //.....
    DocumentModel *documentModel = self.folderModelArray[indexPath.row];
    MoveFileViewController *moveFileVC = [[MoveFileViewController alloc] init];
    moveFileVC.folderName = documentModel.documentName;
    moveFileVC.folderId = documentModel.documentId;
    moveFileVC.fileId = self.fileId;
    [self.navigationController pushViewController:moveFileVC animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    DocumentModel *documentModel = self.folderModelArray[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"file_department"];
    cell.textLabel.text = documentModel.documentName;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    return cell;
}

@end
