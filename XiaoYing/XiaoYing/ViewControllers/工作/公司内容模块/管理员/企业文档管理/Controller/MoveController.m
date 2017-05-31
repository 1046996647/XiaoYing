//
//  MoveController.m
//  XiaoYing
//
//  Created by ZWL on 16/1/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "MoveController.h"
#import "CreateFolderController.h"
#import "DeleteDocumentController.h"
#import "ScienceVC.h"

@interface MoveController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;
}

@property (nonatomic, strong)NSString *str;
@property (nonatomic,strong) UIImageView *moveImage;//推出的图片
@property (nonatomic,strong) UIButton *btn;//导航栏右上角按钮
@property (nonatomic,strong) XYSearchBar *searchBar;//查找控件

@end

@implementation MoveController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self initBasic];
    
    //表的头视图
    [self initHeaderView];
    
    //新建文件和确认移动
    [self initBottomView];
    
}

- (void)initData {
    _arrayTitle = [NSMutableArray arrayWithObjects:@"科技产业部",@"部门文档", @"新建文件夹",nil];

}

- (void)initBasic {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.title = @"移动至企业文档管理";
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-44) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:_tableView];
}


//表的头视图
- (void)initHeaderView
{
    //头视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    //查找文档
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [headerView addSubview:view];
    
    UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addbtn.frame = CGRectMake(12, 7, 35, 30);
    [addbtn setImage:[UIImage imageNamed:@"folderjia"] forState:UIControlStateNormal];
    [addbtn addTarget:self action:@selector(addIntroduceOfcell) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addbtn];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(59, 9, 1, 26)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#848484"];
    viewLine.alpha = 0.4;
    [headerView addSubview:viewLine];
    
    
    _searchBar = [[XYSearchBar alloc]init];
    _searchBar.searchButton.frame =CGRectMake(kScreen_Width - 67 - 31, 14, 16, 16);
    _searchBar.frame = CGRectMake(67, 0, kScreen_Width - 67, 44);
    _searchBar.placeholder = @"查找文档";
    _searchBar.delegate = self;
    [_searchBar.searchButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_searchBar];
    

    
    //分割线
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreen_Width, .5)];
    sepView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [headerView addSubview:sepView];
    
    _tableView.tableHeaderView = headerView;
}


//确认移动
- (void)initBottomView {
   
    //滑动视图引起的特殊位置，再减64
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-64-44, kScreen_Width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];

    
    //顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:topView];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, kScreen_Width, 44);
    [btn setTitle:@"确认移动" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(movieSureAction) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:btn];
    
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width/2.0, (44-20)/2, .5, 20)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView];
}

//新建文件夹和确认移动
- (void)movieSureAction {
     NSLog(@"sureAction");
    
    [self imageAnimalAction];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(backAction) userInfo:nil repeats:nil];   
}

- (void) backAction {
   [_moveImage setHidden:YES];
}


//转移成功之后显示的图片
- (void)imageAnimalAction {
    _moveImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"finish_move"]];
    [_moveImage setFrame:CGRectMake((kScreen_Width - 190) / 2, (kScreen_Height - 90) / 2 - 100, 190, 90)];
    [_tableView addSubview:_moveImage];
    [_moveImage setHidden:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatCount:1.0];
    [UIView commitAnimations];
  
    [_moveImage setHidden:NO];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrayTitle.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ScienceVC *scienceVC = [[ScienceVC alloc]init];
    [self.navigationController pushViewController:scienceVC animated:YES];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }

    cell.imageView.image = [UIImage imageNamed:@"file_department"];
    cell.textLabel.text = _arrayTitle[indexPath.row];
    cell.detailTextLabel.text = @"科技产业部";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];

    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    return cell;
}


#pragma mark - UISearchBarDelegate

//进入这一个界面的时候
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"1");
}
//出现光标的时候
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    _searchBar.showsCancelButton = NO;
    _searchBar.searchButton.hidden = NO;
    
    NSLog(@"2");
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton=NO;
    _searchBar.searchButton.hidden = YES;
    [searchBar resignFirstResponder];
    searchBar.text=@"";
//    [self initBottomView];
    NSLog(@"222取消");
    
}
//输入框输入字符的时候
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"3");
    
}
//
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"4");
}


//清除事件
- (void)clearAction  {
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.searchBar.searchButton.hidden = YES;
}
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.searchButton.hidden = NO;
    return YES;
}

/**
 *添加文件夹
 */
- (void)addFolderNew {
//    FileNewController *fileNewController = [[FileNewController alloc] init];
//    fileNewController.markText = @"新建文件夹";
//    fileNewController.type = @"企业文档管理2";
//    fileNewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    //淡出淡入
//    fileNewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    fileNewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
//    [self presentViewController:fileNewController animated:YES completion:nil];


}

- (void)addIntroduceOfcell {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"新建文件夹" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancleAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *write = alertController.textFields.firstObject;
        _str = write.text;
      
        [self addCellAction];
    }];
    [sureAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @" 新建介绍";
        textField.clearsOnBeginEditing = YES;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.textColor = [UIColor blackColor];
    }];

    [alertController addAction:cancleAction];
    [alertController addAction:sureAction];
    
    [self presentViewController:alertController animated:YES completion:^{
    }];
    
}

- (void)addCellAction {
    if (![_str  isEqual: @""]) {
        [_arrayTitle addObject:_str];
    }else {
        [_arrayTitle addObject:@"新建文件夹"];
    }
    [_tableView reloadData];
}

@end
