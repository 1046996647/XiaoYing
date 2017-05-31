//
//  ScienceVC.m
//  XiaoYing
//
//  Created by GZH on 16/7/6.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "ScienceVC.h"
#import "CreateFolderController.h"
#import "CompanyFileManageController.h"
#import "FileManageTableView.h"
@interface ScienceVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
}
@property (nonatomic,strong) XYSearchBar *searchBar;//查找控件
@property (nonatomic,strong) UIImageView *moveImage;//推出的图片

@end

@implementation ScienceVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"移动至科技产业部";
    
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

    [self initHeaderView];
    [self initBottomView];
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
    [addbtn addTarget:self action:@selector(addFolderNew) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addbtn];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(59, 9, 1, 26)];
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#848484"];
    viewLine.alpha = 0.4;
    [headerView addSubview:viewLine];
    
    
    _searchBar = [[XYSearchBar alloc]init];
    _searchBar.searchButton.frame =CGRectMake(kScreen_Width - 67 - 31, 14, 16, 16);
    _searchBar.barTintColor = [UIColor blackColor];
    _searchBar.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    _searchBar.frame = CGRectMake(67, 0, kScreen_Width - 67, 44);
    _searchBar.showsCancelButton = NO;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.placeholder = @"查找文档";
    _searchBar.delegate = self;
    _searchBar.searchButton.hidden = YES;
    [_searchBar.searchButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_searchBar];
    
    
    //分割线
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreen_Width, .5)];
    sepView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [headerView addSubview:sepView];
    
    _tableView.tableHeaderView = headerView;
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

 
//    [self.navigationController pushViewController:self animated:YES];
    
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
    
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"file_department"];
        cell.textLabel.text = @"UI组";
        cell.detailTextLabel.text = @"科技产业部";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"file"];
        cell.textLabel.text = @"产品组";
        
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    return cell;
}

//确认移动
- (void)initBottomView
{
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
- (void)addFolderNew {
    CreateFolderController *fileNewController = [[CreateFolderController alloc] init];
    fileNewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    fileNewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    fileNewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:fileNewController animated:YES completion:nil];
}




//清除事件
- (void)clearAction  {
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.searchBar.searchButton.hidden = YES;
}

//新建文件夹和确认移动
- (void)movieSureAction {
    NSLog(@"sureAction");
   
    [self imageAnimalAction];
    [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(backAction) userInfo:nil repeats:nil];
    
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





















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
