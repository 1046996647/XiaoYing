//
//  NoticeViewController.m
//  XiaoYing
//
//  Created by ZWL on 15/11/10.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "NoticeViewController.h"
//#import "SearchVC.h"
#import "IssueNoticeVC.h"
#import "CellDetail.h"
#import "AppliedViewController.h"
#import "NoticeCell.h"
#import "WangUrlHelp.h"
#import "CompanyDetailModel.h"
#import "UITableView+showMessageView.h"
#import "BirthdayController.h"
#import "DatepickerView.h"


@interface NoticeViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    AppDelegate *app;
    UIButton *_previousButton;        // 前一个被点击的button
    NSMutableArray *_companyArray;    // 装载公司公告的数组
    NSMutableArray *_departmentArray; // 装载部门公告的数组
    NSMutableArray *_searchArray;     // 装载搜索结果的数组
    MBProgressHUD *_hud;              // 菊花
    NSInteger _currentCompanyPage;    // 当前公司公告的页数
    NSInteger _currentDepartmentPage; // 当前部门公告的页数
    NSInteger _currentSearchPage;     // 当前搜索界面的页数
    NSInteger _pageSize;              // 每页显示的内容数目
    UIButton *_selectStartTimeButton; // 筛选中开始的时间按钮
    UIButton *_selectEndTimeButton;   // 筛选中结束的时间按钮
    NSMutableArray *_permissionArray; // 允许申请的部门
    NSMutableArray *_departmentIDArray;// 部门IDarray
    NSArray *_departments;              // 所有部门数组
}
@property (nonatomic,strong) UIView *viewHead;//公告与公司的头
@property(nonatomic,strong)UIScrollView *scrollView;//装载表视图的滚动视图
//@property (nonatomic,strong) SearchVC *m_search;
@property (nonatomic) BOOL isClick;
@property (nonatomic) BOOL isClickCancle;  //标记取消按钮是否被点击
@property(nonatomic,strong)UITableView *companyTableView;//公司公告表
@property(nonatomic,strong)UITableView *departmentTableView;//部门公告表
@property(nonatomic,strong)UISearchBar *searchBar;//搜索
@property(nonatomic,strong)UITableView *searchResultView;//点击搜索按钮之后出现的搜索界面
@property(nonatomic,strong)UIView *ViewForSearch;//当搜索时的背景图
@property(nonatomic,strong)NSString *startDate;//查询的起始时间
@property(nonatomic,strong)NSString *endDate;//查询的终止时间
@property(nonatomic,strong)NSString *key;//查询关键字
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化三个将要装载公告的数组
    _companyArray = [NSMutableArray array];
    _departmentArray = [NSMutableArray array];
    _searchArray = [NSMutableArray array];
    _permissionArray = [NSMutableArray array];
    //初始化一些页数相关
    _pageSize = 20;
    _currentCompanyPage = 1;
    _currentDepartmentPage = 1;
    _currentSearchPage = 1;
    self.title = @"公告";
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发公告" style:UIBarButtonItemStylePlain target:self action:@selector(IssueAnnounce)];
    _startDate = @"";
    _endDate = @"";
    _key = @"";
    [self getDepartmentArray];
    [self getAllDepartment];
    [self GetCompanyNoticeActionWithStart:_startDate andEnd:_startDate andKey:_key andIsSearch:NO];
    [self setScroll];
    [self initUI];
    [self creatTable];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载中";
    //[self initView];
    
    
}


#pragma mark - 初始化界面 methods
-(void)initUI{
    _viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 46)];
    _viewHead.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_viewHead];
    
    _companybt = [UIButton buttonWithType:UIButtonTypeCustom];
    _companybt.frame =CGRectMake(0, 0, (kScreen_Width - 1) / 7  * 3, 44);
    _companybt.tag = 1;
    _previousButton = _companybt;
    [_companybt setTitle:@"公司" forState:UIControlStateNormal];
    _companybt.titleLabel.font = [UIFont systemFontOfSize:18];
    [_companybt setTitleColor:[UIColor colorWithHexString:@"#848484"] forState:UIControlStateNormal];
    _companybt.selected = YES;
     [_companybt setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateSelected];
    [_companybt addTarget:self action:@selector(PressCompanyAndDepartmentButton:) forControlEvents:UIControlEventTouchUpInside];
    [_viewHead addSubview:_companybt];
    
    _departmentbt = [UIButton buttonWithType:UIButtonTypeCustom];
    _departmentbt.frame =CGRectMake((kScreen_Width -1) / 7 * 3, 0, (kScreen_Width -1) / 7 * 3, 44);
    _departmentbt.tag = 2;
    [_departmentbt setTitle:@"部门" forState:UIControlStateNormal];
    _departmentbt.titleLabel.font = [UIFont systemFontOfSize:18];
    [_departmentbt setTitleColor:[UIColor colorWithHexString:@"#848484"] forState:UIControlStateNormal];
    [_departmentbt setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateSelected];
    [_departmentbt addTarget:self action:@selector(PressCompanyAndDepartmentButton:) forControlEvents:UIControlEventTouchUpInside];
    [_viewHead addSubview:_departmentbt];
    
    _viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44,(kScreen_Width - 0.5) / 7 * 3, 2)];
    _viewLine.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [_viewHead addSubview:_viewLine];
    
    
    //部门与筛选中间的分割线
    _labelLine = [[UILabel alloc] initWithFrame:CGRectMake((kScreen_Width -1) / 7  * 6 , 10, 0.5, 29)];
    _labelLine.backgroundColor = [UIColor colorWithHexString:@"#848484"];
    _labelLine.alpha = 0.4;
    [_viewHead addSubview:_labelLine];
    
    //筛选按钮
    _screenBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreen_Width -1) / 7  * 6  + 1, 0, kScreen_Width / 7, 49)];
    [_screenBtn setImage:[UIImage imageNamed:@"choose_task"] forState:UIControlStateNormal];
    [_screenBtn addTarget:self action:@selector(screenAction) forControlEvents:UIControlEventTouchUpInside];
    [_viewHead addSubview:_screenBtn];
    
    // 搜索公告
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 46, kScreenWidth, 44)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"查找公告";
    _searchBar.showsCancelButton = NO;
    _searchBar.tintColor = [UIColor colorWithHexString:@"#f99740"];// 取消字体颜色和光标颜色
    [_searchBar setBackgroundImage:[UIImage new]];
    _searchBar.barTintColor = [UIColor colorWithHexString:@"#efeff4"];
    [self.view addSubview:_searchBar];

}

#pragma mark - 创建公司和部门的表视图 methods
-(void)creatTable{
    //公司公告表视图
    _companyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _searchBar.bottom, kScreenWidth, _scrollView.height - 49)style:UITableViewStylePlain];
    _companyTableView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    _companyTableView.tableFooterView.backgroundColor = [UIColor clearColor];
    _companyTableView.delegate = self;
    _companyTableView.dataSource = self;
    _companyTableView.showsVerticalScrollIndicator = NO;
    
     __block __weak __typeof(&*self)weakSelf = self;
    //添加下拉刷新
    _companyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentCompanyPage = 1;
        [weakSelf GetCompanyNoticeActionWithStart:_startDate andEnd:_startDate andKey:_key andIsSearch:NO];
    }];
    //添加上拉加载
    _companyTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _currentCompanyPage ++;
        [weakSelf GetCompanyNoticeActionWithStart:_startDate andEnd:_startDate andKey:_key andIsSearch:NO];
    }];
    
    //取消cell分割线左边空白
    if ([_companyTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_companyTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_companyTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_companyTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [_scrollView addSubview:_companyTableView];
    
    //部门公告表视图
    _departmentTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, _searchBar.bottom, kScreenWidth, _scrollView.height - 49)style:UITableViewStylePlain];
    _departmentTableView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    _departmentTableView.tableFooterView.backgroundColor = [UIColor clearColor];
    _departmentTableView.delegate = self;
    _departmentTableView.dataSource = self;
    _departmentTableView.showsVerticalScrollIndicator = NO;
    //添加下拉刷新
    _departmentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentDepartmentPage = 1;
         [weakSelf GetDepartmentNoticeActionWithStart:_startDate andEnd:_startDate andKey:_key andIsSearch:NO];
    }];
    //添加上拉加载
    _departmentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _currentDepartmentPage ++;
        [weakSelf GetDepartmentNoticeActionWithStart:_startDate andEnd:_startDate andKey:_key andIsSearch:NO];
    }];
    //取消cell分割线左边空白
    if ([_departmentTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_departmentTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_departmentTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_departmentTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [_scrollView addSubview:_departmentTableView];
    
    _scrollView.contentSize = CGSizeMake(kScreen_Width * 2 , kScreen_Height);
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    //取消弹簧效果
    _scrollView.bounces = NO;
}

#pragma mark - 按钮点击事件 methods
-(void)PressCompanyAndDepartmentButton:(UIButton *)bt{
    _previousButton.selected = NO;
    bt.selected = YES;
    _previousButton  = bt;
    
    NSInteger index = bt.tag - 1;
    //当按钮点击的时候,将underLine也跟随移动位置
    [UIView animateWithDuration:0.25 animations:^{
        _viewLine.frame = CGRectMake((bt.tag - 1) * (kScreen_Width -0.5) / 7 * 3, 44, (kScreen_Width -0.5) / 7 * 3, 2);
        
        CGFloat offsetX = index * _scrollView.frame.size.width;
        _scrollView.contentOffset = CGPointMake(offsetX, _scrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        nil;
    }];
}

#pragma mark - UITableViewDataSource
//行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _companyTableView) {//公司公告
        return _companyArray.count;
    }else if (tableView == _departmentTableView){//部门公告
        return _departmentArray.count;
    }else{
        return _searchArray.count;
    }
}

//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[NoticeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (tableView == _companyTableView) {//公司公告
        cell.model = _companyArray[indexPath.row];
        cell.isDepartment = NO;
    }else if (tableView == _departmentTableView){//部门公告
        cell.model = _departmentArray[indexPath.row];
        cell.isDepartment = YES;
    }else{//搜索公告
        cell.model = _searchArray[indexPath.row];
        if (_departmentbt.selected == NO) {//搜索公司公告
            cell.isDepartment = NO;
        }else{//搜索部门公告
            cell.isDepartment = YES;
        }

    }
    return cell;
}

#pragma mark - UITableView delegateMethods
//单元格将要出现(消除cell左边)
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消高亮状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CellDetail *detailVC = [[CellDetail alloc]init];
    if (tableView == _companyTableView) {//公司公告
        CompanyDetailModel *model = _companyArray[indexPath.row];
        detailVC.afficheid = model.Id;
    }else if (tableView == _departmentTableView){//部门公告
        CompanyDetailModel *model = _departmentArray[indexPath.row];
        detailVC.afficheid = model.Id;
    }else{//搜索公告
        CompanyDetailModel *model = _searchArray[indexPath.row];
        detailVC.afficheid = model.Id;
        detailVC.isSearch = YES;
    }
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
}

//高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

// 区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

#pragma mark - 创建滚动视图 methods
-(void)setScroll{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    _scrollView.delegate = self;
}


#pragma mark - 网络加载方法 methods
//获取公司公告
- (void)GetCompanyNoticeActionWithStart:(NSString *)start andEnd:(NSString *)end andKey:(NSString *)key andIsSearch:(BOOL)isSearch {
    _companyArray = [NSMutableArray array];
    NSString *strURL = nil;
    if (isSearch == NO) {
       strURL = AFFICHE_GETBYCOMPANY, start, end, key,_currentCompanyPage,_pageSize];
    }else{
        strURL = AFFICHE_GETBYCOMPANY, start, end, key,_currentSearchPage,_pageSize];
    }
        [AFNetClient GET_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        
        if (code.integerValue == 0) {
            NSLog(@"获取公司公告>>>>成功");
            NSArray *dataArray = JSONDict[@"Data"];
            NSArray *newArray = [CompanyDetailModel getModelArrayFromModelArray:dataArray];
            if (isSearch == NO) {
                [_companyArray addObjectsFromArray:newArray];
                [_companyTableView reloadData];
                if (![start isEqualToString:@""]) {//未做日期的筛选
                    [_hud hide:YES];
                    _hud = nil;

                }else{
                     [self GetDepartmentNoticeActionWithStart:start andEnd:end andKey:key andIsSearch:NO];
                }
                [_companyTableView.mj_header endRefreshing];
                [_companyTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_searchArray addObjectsFromArray:newArray];
                //如果没有搜索结果的时候，显示没有搜索到结果图片
                [_searchResultView tableViewDisplayNotFoundViewWithRowCount:_searchArray.count];

                [_searchResultView reloadData];
                [_hud hide:YES];
                _hud = nil;
            }
        }else{
            [_hud hide:YES];
            _hud = nil;
            NSString *message = JSONDict[@"Message"];
            [MBProgressHUD showMessage:message];
        }
        
    } failed:^(NSError *error) {
        NSLog(@"失败**********=======>>>%@",error);
        [_hud hide:YES];
        _hud = nil;
    }];
}

//获取部门公告
- (void)GetDepartmentNoticeActionWithStart:(NSString *)start andEnd:(NSString *)end andKey:(NSString *)key andIsSearch:(BOOL)isSearch {
    _departmentArray = [NSMutableArray array];
    NSString *strURL = nil;
    if (isSearch == NO) {
        strURL = AFFICHE_GETBYDEPARTMENT, start, end, key,_currentDepartmentPage,_pageSize];
    }else{
        strURL = AFFICHE_GETBYDEPARTMENT, start, end, key,_currentSearchPage,_pageSize];
    }
    [AFNetClient GET_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if (code.integerValue == 0){
            NSLog(@"获取部门公告>>>>成功");
            NSArray *dataArray = JSONDict[@"Data"];
            NSArray *newArray = [CompanyDetailModel getModelArrayFromModelArray:dataArray];
            if (isSearch == NO) {
                [_departmentArray addObjectsFromArray:newArray];
                [_departmentTableView reloadData];
                [_departmentTableView.mj_header endRefreshing];
                [_departmentTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_searchArray addObject:newArray];
                //如果没有搜索结果的时候，显示没有搜索到结果图片
                [_searchResultView tableViewDisplayNotFoundViewWithRowCount:_searchArray.count];
                [_searchResultView reloadData];
            }
            [_hud hide:YES];
            _hud = nil;
        }else{
            [_hud hide:YES];
            _hud = nil;
            NSString *message = JSONDict[@"Message"];
            [MBProgressHUD showMessage:message];
        }
} failed:^(NSError *error) {
        NSLog(@"失败**********=======>>>%@",error);
    }];
}

//获取允许申请的部门数组
-(void)getDepartmentArray{
    NSString *strUrl = AFFICHE_GETPERMISSION;
    [AFNetClient POST_Path:strUrl completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if (code.integerValue == 0){
            NSArray *dataArray = JSONDict[@"Data"];
            for (NSDictionary *subDic in dataArray) {
                NSNumber *type = [subDic objectForKey:@"Type"];
                if (type.integerValue == 0) {//允许申请
                    NSString *departmentId = [subDic objectForKey:@"DepartmentId"];
                    [_permissionArray addObject:departmentId];
                }
            }
        }
        
    } failed:^(NSError *error) {
        NSLog(@"失败**********=======>>>%@",error);
    }];
}

//获取所有公司所有部门
-(void)getAllDepartment{
    _departmentIDArray = [NSMutableArray array];
    NSString *strUrl = [NSString stringWithFormat:@"%@/api/department/allDepartment?Token=%@",BaseUrl1,[UserInfo getToken]];
    [AFNetClient GET_Path:strUrl completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if (code.integerValue == 0){
            NSArray *array = JSONDict[@"Data"];
            _departments = array;
            for (NSDictionary *subDic in array) {
                NSLog(@"部门：%@",subDic[@"Title"]);
                NSString *title = subDic[@"Title"];
                NSString *depaID = subDic[@"DepartmentId"];
                if (![title isEqualToString:@"人事行政部"]) {
                    [_departmentIDArray addObject:depaID];
                }
            }
            
        }
    } failed:^(NSError *error) {
        NSLog(@"失败**********=======>>>%@",error);
    }];
}



-(void)IssueAnnounce{
    IssueNoticeVC *issue = [[IssueNoticeVC alloc] init];
    issue.title= @"发公告";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    if (_permissionArray.count == 0) {
        [MBProgressHUD showMessage:@"您没有权限发公告"];
    }else{
        issue.departmentIdArray = _permissionArray;
        issue.deparments = _departments;
        [self.navigationController pushViewController:issue animated:YES];
         __block __weak __typeof(&*self)weakSelf = self;
        issue.sendBlock = ^(){
            _hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            _hud.labelText = @"正在加载中";
           [weakSelf GetCompanyNoticeActionWithStart:_startDate andEnd:_startDate andKey:_key andIsSearch:NO];
        };
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 筛选相关 methods
//筛选按钮
- (void)screenAction {
    if ( self.isClick == NO) {
        [self layOutSubView];
    }
    self.isClick = YES;
}

- (void)layOutSubView {
    //筛选时下层遮盖
    [self backgroundViewa];
    //筛选视图上边控件
    [self subViewOnScreenView];
}

//筛选时下层遮盖
- (void)backgroundViewa {
    _belowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64 + 51, kScreen_Width, kScreen_Height - 64 - 49)];
    _belowBtn.backgroundColor = [UIColor blackColor];
    _belowBtn.alpha = 0.5;
    [_belowBtn addTarget:self action:@selector(belowViewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_belowBtn];
    _screenrView = [[UIView alloc] initWithFrame:CGRectMake(0, 46, kScreen_Width, 30 * 3 + 4 * 12 + 44 - 7)];
    _screenrView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_screenrView];
}

//筛选视图上边控件
- (void)subViewOnScreenView {
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 20, 30)];
    label1.text = @"从";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:16];
    [_screenrView addSubview:label1];
    
    _selectStartTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectStartTimeButton.frame = CGRectMake(60, 12, kScreen_Width - 75, 30);
    _selectStartTimeButton.layer.cornerRadius = 5;
    _selectStartTimeButton.layer.borderWidth = .5;
    _selectStartTimeButton.layer.masksToBounds = YES;
    _selectStartTimeButton.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
    [_selectStartTimeButton setTitle:@"yyyy-mm-dd" forState:UIControlStateNormal];
    [_selectStartTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selectStartTimeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _selectStartTimeButton.tag = 10;
    [_selectStartTimeButton addTarget:self action:@selector(chooseTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_screenrView addSubview:_selectStartTimeButton];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, _selectStartTimeButton.bottom + 12, 20, 30)];
    label2.text = @"至";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:16];
    [_screenrView addSubview:label2];
    
    _selectEndTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectEndTimeButton.frame = CGRectMake(60, _selectStartTimeButton.bottom + 12,kScreen_Width - 75, 30);
    _selectEndTimeButton.layer.cornerRadius = 5;
    _selectEndTimeButton.layer.borderWidth = .5;
    _selectEndTimeButton.layer.masksToBounds = YES;
    _selectEndTimeButton.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
    [_selectEndTimeButton setTitle:@"yyyy-mm-dd" forState:UIControlStateNormal];
    [_selectEndTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selectEndTimeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _selectEndTimeButton.tag = 11;
    [_selectEndTimeButton addTarget:self action:@selector(chooseTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_screenrView addSubview:_selectEndTimeButton];
    
    if (![_startDate isEqualToString:@""]) {
        [_selectStartTimeButton setTitle:_startDate forState:UIControlStateNormal];
        [_selectEndTimeButton setTitle:_endDate forState:UIControlStateNormal];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, _selectEndTimeButton.bottom + 17, 20, 20)];
    [button setBackgroundImage:[UIImage imageNamed:@"choose2-none"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(screenViewBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_screenrView addSubview:button];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(60, _selectEndTimeButton.bottom + 12, kScreen_Width - 82, 30)];
    label3.text = @"取消筛选";
    label3.textColor = [UIColor colorWithHexString:@"#848484"];
    label3.textAlignment = NSTextAlignmentLeft;
    label3.font = [UIFont systemFontOfSize:14];
    [_screenrView addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 4 * 12 + 3 * 30 - 11, kScreen_Width,0.5)];
    label4.backgroundColor = [UIColor colorWithHexString:@"#d7d5dc"];
    [_screenrView addSubview:label4];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 4 * 12 + 3 * 30 - 11, kScreen_Width,44)];
    [button2 setTitle:@"确定" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    button2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button2 addTarget:self action:@selector(makeSureAction) forControlEvents:UIControlEventTouchUpInside];
    [_screenrView addSubview:button2];
}

- (void)screenViewBtn:(UIButton *)btn{
    NSLog(@"您点击了取消筛选按钮");
    if (self.isClickCancle == NO) {
        [btn setBackgroundImage:[UIImage imageNamed:@"choose2"] forState:UIControlStateNormal];
        self.isClickCancle = YES;
    }else {
        [btn setBackgroundImage:[UIImage imageNamed:@"choose2-none"] forState:UIControlStateNormal];
        self.isClickCancle = NO;
    }
}


- (void)makeSureAction {
    
    if (self.isClickCancle == NO && ![_selectStartTimeButton.titleLabel.text isEqualToString:@"yyyy-mm-dd"] && ![_selectEndTimeButton.titleLabel.text isEqualToString:@"yyyy-mm-dd"]) {//没有点击取消按钮并且开始和结束的日期也都选上了
//        [self belowViewAction];
//        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        _hud.labelText = @"正在加载中";
//        _startDate = _selectStartTimeButton.titleLabel.text;
//        _endDate = _selectEndTimeButton.titleLabel.text;
//        if (_departmentbt.selected == NO) {//如果是公司公告
//            [self GetCompanyNoticeActionWithStart:_startDate andEnd:_endDate andKey:@"" andIsSearch:NO];
//        }else{//如果是部门公告
//            [self GetDepartmentNoticeActionWithStart:_startDate andEnd:_endDate andKey:@"" andIsSearch:NO];
//        }
        
        _startDate = _selectStartTimeButton.titleLabel.text;
        _endDate = _selectEndTimeButton.titleLabel.text;
        
        if (![_startDate isEqualToString:@""] && ![_endDate isEqualToString:@""]) {
            NSDate *startDate = [self dateFromString:_startDate];
            NSDate *endDate = [self dateFromString:_endDate];
            
            if ([startDate compare:endDate] == NSOrderedDescending) {//如果开始时间晚于起始时间
                [MBProgressHUD showMessage:@"起始时间不能晚于终止时间"];
            }else{
                [self belowViewAction];
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"正在加载中";
                _key = @"";
                
                if (_departmentbt.selected == NO) {//如果是公司公告
                    _companyArray = [NSMutableArray array];
                     [self GetCompanyNoticeActionWithStart:_startDate andEnd:_endDate andKey:@"" andIsSearch:NO];
                }else{//如果是部门公告
                    _departmentArray = [NSMutableArray array];
                     [self GetDepartmentNoticeActionWithStart:_startDate andEnd:_endDate andKey:@"" andIsSearch:NO];
                }
            }
        }

    }
        if(self.isClickCancle == NO && ([_selectStartTimeButton.titleLabel.text isEqualToString:@"yyyy-mm-dd"] || [_selectEndTimeButton.titleLabel.text isEqualToString:@"yyyy-mm-dd"])){//没有点击取消按钮但是存在有日期没有悬赏
            [MBProgressHUD showMessage:@"请填完整筛选日期"];
        }
    
    if (self.isClickCancle == YES) {//如果点击了取消筛选按钮
        [self belowViewAction];
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"正在加载中";
        _startDate = @"";
        _endDate = @"";
        if (_departmentbt.selected == NO) {//如果是公司公告
            [self GetCompanyNoticeActionWithStart:_startDate andEnd:_endDate andKey:@"" andIsSearch:YES];
        }else{//如果是部门公告
            [self GetDepartmentNoticeActionWithStart:_startDate andEnd:_endDate andKey:@"" andIsSearch:YES];
        }
    }
    
    NSLog(@"确定");
}

- (void)belowViewAction {
    [_belowBtn removeFromSuperview];
    [_screenrView removeFromSuperview];
    
    self.isClick = NO;
}

-(void)chooseTimeAction:(UIButton*)button{
    DatepickerView *datepickerView = [[DatepickerView alloc] initWithFrame:CGRectMake(0,kScreen_Height - 320, kScreen_Width, 320)];
        if (![button.titleLabel.text isEqualToString:@"yyyy-mm-dd"]) {
            datepickerView.dateStr = button.titleLabel.text;
        }else{
            datepickerView.dateStr = @"";
        }
    
    if (button.tag == 11 && ![_selectStartTimeButton.titleLabel.text isEqualToString:@"yyyy-mm-dd"]) {//如果已经设置了开始时间的话，那么结束时间一定要比这个要大
        datepickerView.minDateStr = _selectStartTimeButton.titleLabel.text;
    }else{
        datepickerView.minDateStr = @"";
    }
    datepickerView.dataBlock = ^(NSString *dateStr){
        [button setTitle:dateStr forState:UIControlStateNormal];
    };
    UIViewController *dateController = [UIViewController new];
    dateController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    self.definesPresentationContext = YES; //不盖住整个屏幕
    dateController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [dateController.view addSubview:datepickerView];
    [self presentViewController:dateController animated:YES completion:nil];
}

#pragma mark - 懒加载 lazyLoad
-(UITableView*)searchResultView{
    if (_searchResultView == nil) {
        //初始化搜索的数组
        _searchArray = [NSMutableArray array];
        _searchResultView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64) style:UITableViewStylePlain];
        //消除分割线左边的空白
        if ([_searchResultView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_searchResultView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_searchResultView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_searchResultView setLayoutMargins:UIEdgeInsetsZero];
        }
        _searchResultView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        //去除底部分割线
        _searchResultView.tableFooterView = [UIView new];
        _searchResultView.delegate = self;
        _searchResultView.dataSource = self;
    }
    return _searchResultView;
}

-(UIView*)ViewForSearch{
    if (_ViewForSearch == nil) {
        _ViewForSearch = [[UIView alloc]initWithFrame:self.view.bounds];
        _ViewForSearch.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 63.5, kScreen_Width, 1)];
        sepView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [_ViewForSearch addSubview:sepView];
    }
    return _ViewForSearch;
}

#pragma mark - UISearchBar delegateMethods
//当搜索之后
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.35 animations:^{
        
        self.navigationController.navigationBarHidden = YES;
        _searchBar.showsCancelButton = YES;
        _searchBar.top = 20;
        [self.view addSubview:self.ViewForSearch];
        [self.view bringSubviewToFront:_searchBar];
        [self.view addSubview:self.searchResultView];
    }];
}

//当点击了取消按钮之后
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.35 animations:^{
        self.navigationController.navigationBarHidden = NO;
        _searchBar.top = 46;
        [self.searchResultView removeFromSuperview];
        self.searchResultView = nil;
        [self.self.ViewForSearch removeFromSuperview];
        self.self.ViewForSearch = nil;
        _searchBar.showsCancelButton = NO;
        [_searchBar resignFirstResponder];
        _searchBar.text = @"";
    }];
}

//当点击了搜索按钮之后
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchBarResignAndChangeUI];
    [_hud removeFromSuperViewOnHide];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载中";
    _key = searchBar.text;
    NSString *start = @"";
    NSString *end = @"";
    if (_departmentbt.selected == NO) {//搜索公司公告
        [self GetCompanyNoticeActionWithStart:start andEnd:end andKey:_key andIsSearch:YES];
    }else{//搜索部门公告
        [self GetDepartmentNoticeActionWithStart:start andEnd:end andKey:_key andIsSearch:YES];
    }
   }

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self searchBarResignAndChangeUI];
}

- (void)searchBarResignAndChangeUI{
    
    [_searchBar resignFirstResponder];//失去第一响应
    
    [self changeSearchBarCancelBtnTitleColor:_searchBar];//改变布局
    
}

#pragma mark - 遍历改变搜索框 取消按钮的文字颜色

- (void)changeSearchBarCancelBtnTitleColor:(UIView *)view{
    
    if (view) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *getBtn = (UIButton *)view;
            
            [getBtn setEnabled:YES];//设置可用
            
            [getBtn setUserInteractionEnabled:YES];
            
            
            [getBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateReserved];
            
            [getBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateDisabled];
            
            return;
            
        }else{
            
            for (UIView *subView in view.subviews) {
                
                [self changeSearchBarCancelBtnTitleColor:subView];
                
            }
            
        }
        
    }else{
        
        return;
        
    }
    
}

//NSDate转换成string
-(NSString *)getDateStringFromString:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

//将字符串转换成日期
-(NSDate *)dateFromString:(NSString *)string{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:string];
    return date;
}



@end
