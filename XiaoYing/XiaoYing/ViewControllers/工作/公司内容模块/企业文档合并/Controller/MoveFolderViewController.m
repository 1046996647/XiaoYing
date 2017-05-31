//
//  MoveFolderViewController.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/14.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "MoveFolderViewController.h"
#import "DocumentVM.h"
#import "DocumentMergeModel.h"

@interface MoveFolderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *folderTableView;
@property (nonatomic, strong) NSMutableArray *folderModelArray;

@end

@implementation MoveFolderViewController

- (UITableView *)folderTableView
{
    if (!_folderTableView) {
        _folderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
        _folderTableView.backgroundColor = [UIColor clearColor];
        _folderTableView.delegate = self;
        _folderTableView.dataSource = self;
        _folderTableView.tableFooterView = [[UIView alloc] init];
        if ([_folderTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_folderTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_folderTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_folderTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _folderTableView;
}

- (void)setupNavigationContent
{
    UIBarButtonItem *certenBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(selectSureAction)];
    certenBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = certenBtn;
}

- (void)selectSureAction
{
    //1.整理好要传输的数据
    
    //2.传输数据
    self.movePlaceBlock(self.departmentId, self.folderName, self.folderId);
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    
    self.navigationItem.title = [NSString stringWithFormat:@"移动至%@", self.folderName];
    
    [self.view addSubview:self.folderTableView];
    
    [self setupNavigationContent];
    
    if ([self.departmentId isEqualToString:@" "]) { //个人级别文档
        
        [self personGetFolderListBaseOnParentFolderId:self.folderId departmentId:self.departmentId];
    }else {
        [self getFolderListBaseOnParentFolderId:self.folderId departmentId:self.departmentId];
    }
    
    if (self.navigationController.viewControllers.count==1) {
        
        self.navigationItem.leftBarButtonItems.lastObject.customView.hidden = YES;
        //取消Bar按钮
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
        backItem.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = backItem;

    }
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //隐藏标签栏
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabvc hideCustomTabbar];
}

- (void)leftAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//根据父文件夹id和部门id获取文件夹列表数据（企业级别）
- (void)getFolderListBaseOnParentFolderId:(NSString *)folderId departmentId:(NSString *)departmentId
{
    [DocumentVM getDocumentListDataWithFolderId:folderId departmentIds:departmentId textKey:@"" pageIndex:1 pageSize:1000 orderType:1 isasc:2 success:^(NSArray *documentListArray) {
        
        //根据传过来测总的文档数据，按文件夹和文件两种类型进行分类
        NSMutableArray *folderArray = [NSMutableArray array];
        for (DocumentMergeModel *documentModel in [DocumentMergeModel getModelArrayFromModelArray:documentListArray]) {
            if (documentModel.documentType == 0) { //代表文件夹
                [folderArray addObject:documentModel];
            }
        }
        
        self.folderModelArray = folderArray;//数据源
        [self.folderTableView reloadData];//根据数据源刷新UI
        
    } failed:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

//根据父文件夹id和部门id获取文件夹列表数据（个人级别）
- (void)personGetFolderListBaseOnParentFolderId:(NSString *)folderId departmentId:(NSString *)departmentId
{
    [DocumentVM personGetDocumentListDataWithFolderId:folderId textKey:@"" pageIndex:1 pageSize:1000 orderType:1 isasc:1 success:^(NSArray *documentListArray) {
        
        //根据传过来测总的文档数据，按文件夹和文件两种类型进行分类
        NSMutableArray *folderArray = [NSMutableArray array];
        for (DocumentMergeModel *documentModel in [DocumentMergeModel getModelArrayFromModelArray:documentListArray]) {
            if (documentModel.documentType == 0) { //代表文件夹
                [folderArray addObject:documentModel];
            }
        }
        
        self.folderModelArray = folderArray;//数据源
        [self.folderTableView reloadData];//根据数据源刷新UI
        
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
    DocumentMergeModel *documentModel = self.folderModelArray[indexPath.row];
    MoveFolderViewController *selectFolderVC = [[MoveFolderViewController alloc] init];
    selectFolderVC.folderName = documentModel.documentName;
    selectFolderVC.folderId = documentModel.documentId;
    selectFolderVC.departmentId = self.departmentId;
    selectFolderVC.movePlaceBlock = self.movePlaceBlock;
    [self.navigationController pushViewController:selectFolderVC animated:YES];
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
    
    DocumentMergeModel *documentModel = self.folderModelArray[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"file_department"];
    cell.textLabel.text = documentModel.documentName;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    return cell;
}

@end
