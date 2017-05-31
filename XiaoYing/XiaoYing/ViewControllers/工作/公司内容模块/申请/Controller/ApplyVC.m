//
//  ApprovalVC.m
//  XiaoYing
//
//  Created by ZWL on 15/11/10.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "ApplyVC.h"
#import "ApplyCell.h"
#import "ApplyProcessVC.h"
#import "NewApplyVC.h"
#import "CreateApplyVC.h"
#import "UIColor+Expend.h"
#import "XYPositionViewController.h"
#import "ApplyViewModel.h"
#import "ApplicationModel.h"
#import "XYExtend.h"

#import "UITableView+showMessageView.h"

@interface ApplyVC () <UITableViewDataSource,UITableViewDelegate>
{
    UIButton *_underwayButton;      // 进行中按钮
    UIButton *_overedButton;        // 已结束按钮
    UIImageView *_backImage;        // 红色一条线
    
    UIScrollView *_baseScrollView;      //放置两个表视图的ScrollView
    UITableView *_ongingTableView;      // 进行中的表视图
    UITableView *_completedTableView;   // 已结束的表视图
    
    MBProgressHUD *_waitHUD;         //waitHUD

}

@property (nonatomic, strong) UISearchBar *humanSearch;//收索框
@property (nonatomic, strong) UITableView *searchResultTableView;// 搜索结果的表视图

@property (nonatomic, assign) NSInteger pageForSearchResultApplication; // 当前搜索结果列表的页数
@property (nonatomic, strong) NSMutableArray *searchResultArrayForPage; // 分页获取的搜索结果的申请数组
@property (nonatomic, strong) NSMutableArray *searchResultApplicationModelArray; // 搜索结果的ApplicationModel的数组

@property (nonatomic, assign) NSInteger pageSizeForLoadData; // 分页获取数据时每页的数据条数
@property (nonatomic, assign) NSInteger pageForOngingApplication; // 当前进行中列表的页数
@property (nonatomic, assign) NSInteger pageForCompletedApplication; // 当前已结束列表的页数
@property (nonatomic, strong) NSMutableArray *ongingArrayForPage; // 分页获取的进行中的申请数组
@property (nonatomic, strong) NSMutableArray *completedArrayForPage; // 分页获取的已结束的申请数组
@property (nonatomic, strong) NSMutableArray *ongingApplicationModelArray; // 进行中的ApplicationModel的数组
@property (nonatomic, strong) NSMutableArray *completedApplicationModelArray; // 已结束的ApplicationModel的数组

@end

@implementation ApplyVC

- (UITableView *)searchResultTableView
{
    if (!_searchResultTableView) {
        _searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64) style:UITableViewStylePlain];
        _searchResultTableView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        _searchResultTableView.tableFooterView = [[UIView alloc] init];
        _searchResultTableView.delegate = self;
        _searchResultTableView.dataSource = self;
        _searchResultTableView.contentSize = CGSizeMake(kScreen_Width+100, kScreen_Height - 93 - 64);
        
        if ([_searchResultTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_searchResultTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_searchResultTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_searchResultTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        __weak typeof(self)weakSelf = self;
        
        // 搜索结果的表视图下拉刷新
        _searchResultTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

            typeof(self)strongSelf = weakSelf;
            strongSelf.pageForSearchResultApplication = 1;
            
            if ([self.humanSearch.text isEqualToString:@""]) { //如果搜索栏没有任何内容，则不发起请求
                
                if ([_searchResultTableView.mj_header isRefreshing]) {
                    [_searchResultTableView.mj_header endRefreshing];
                }
                if ([_searchResultTableView.mj_footer isRefreshing]) {
                    [_searchResultTableView.mj_footer endRefreshing];
                }

            }else { //如果搜索栏有任何内容，则发起请求
            
                [strongSelf loadSearchResultDataFromWebWithBeginPage:strongSelf.pageForSearchResultApplication pageSize:strongSelf.pageSizeForLoadData searchText:self.humanSearch.text];
            }
            
        }];
        
        // 搜索结果的表视图上拉加载
        _searchResultTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            typeof(self)strongSelf = weakSelf;
            strongSelf.pageForSearchResultApplication ++;
            [strongSelf loadSearchResultDataFromWebWithBeginPage:strongSelf.pageForSearchResultApplication pageSize:strongSelf.pageSizeForLoadData searchText:self.humanSearch.text];
        }];
    }
    return _searchResultTableView;
}

- (NSMutableArray *)searchResultApplicationModelArray
{
    if (!_searchResultApplicationModelArray) {
        _searchResultApplicationModelArray = [NSMutableArray array];
    }
    return _searchResultApplicationModelArray;
}

- (NSMutableArray *)ongingApplicationModelArray
{
    if (!_ongingApplicationModelArray) {
        _ongingApplicationModelArray = [NSMutableArray array];
    }
    return _ongingApplicationModelArray;
}

- (NSMutableArray *)completedApplicationModelArray
{
    if (!_completedApplicationModelArray) {
        _completedApplicationModelArray = [NSMutableArray array];
    }
    return _completedApplicationModelArray;
}

- (void)setupMonitor
{
    // 申请被通过的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyAgreeAction) name:kApplyAgreeNotification object:nil];
    
    // 申请被拒绝的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyRefuseAction) name:kApplyRefuseNotification object:nil];
}


// kApplyAgreeNotification--socket通知处理
- (void)applyAgreeAction
{
    //1.进行中的列表主动刷新
    [_ongingTableView.mj_header beginRefreshing];
    
    //2.已结束上出现红点
    [_overedButton.titleLabel showRedAtOffSetX:0 AndOffSetY:0 OrValue:@"2"];
}

// kApplyRefuseNotification--socket通知处理
- (void)applyRefuseAction
{
    //1.进行中的列表主动刷新
    [_ongingTableView.mj_header beginRefreshing];
    
    //2.已结束上出现红点
    [_overedButton.titleLabel showRedAtOffSetX:0 AndOffSetY:0 OrValue:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMonitor];
    
    self.title=@"申请";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setupTableView];
    
    self.pageForOngingApplication = 1;
    self.pageForCompletedApplication = 1;
    self.pageForSearchResultApplication = 1;
    self.pageSizeForLoadData = 10;
    
    [self loadDataFromWeb];
    
}

- (void)loadDataFromWeb
{
    self.pageForOngingApplication = 1;
    self.pageForCompletedApplication = 1;
    [self.ongingApplicationModelArray removeAllObjects];
    [self.completedApplicationModelArray removeAllObjects];
    
    [_ongingTableView reloadData];
    [_completedTableView reloadData];
    
    [_ongingTableView.mj_header beginRefreshing];
    [_completedTableView.mj_header beginRefreshing];
}

- (void)loadOngingDataFromWebWithBeginPage:(NSInteger)beginPage pageSize:(NSInteger)pageSize
{
    __weak typeof(self)weakSelf = self;
    
    [ApplyViewModel getOngingApplicationDataWithBeginPage:beginPage pageSize:pageSize success:^(NSArray *applicationDataList) {
        
        NSLog(@"获取正在进行中的申请列表:%@", applicationDataList);
        
        if (beginPage == 1) {
            [_ongingApplicationModelArray removeAllObjects];
            [_ongingTableView.mj_footer resetNoMoreData];
        }
        
        self.ongingArrayForPage = [ApplicationModel getModelArrayFromModelArray:applicationDataList];
        
        if (weakSelf.ongingArrayForPage.count == 0) {
            [_ongingTableView.mj_footer endRefreshingWithNoMoreData];
            
            if ([_ongingTableView.mj_header isRefreshing]) {
                [_ongingTableView.mj_header endRefreshing];
            }
            if ([_ongingTableView.mj_footer isRefreshing]) {
                [_ongingTableView.mj_footer endRefreshing];
            }
            
            [_ongingTableView reloadData];
            return ;
        }
        
        [weakSelf.ongingApplicationModelArray addObjectsFromArray:weakSelf.ongingArrayForPage];
        
        if ([_ongingTableView.mj_header isRefreshing]) {
            [_ongingTableView.mj_header endRefreshing];
        }
        if ([_ongingTableView.mj_footer isRefreshing]) {
            [_ongingTableView.mj_footer endRefreshing];
        }
        
        [_ongingTableView reloadData];
        
    } failed:^(NSError *error) {
        
        if ([_ongingTableView.mj_header isRefreshing]) {
            [_ongingTableView.mj_header endRefreshing];
        }
        if ([_ongingTableView.mj_footer isRefreshing]) {
            [_ongingTableView.mj_footer endRefreshing];
        }
        
        NSLog(@"获取正在进行中的申请列表失败:%@", error);
    }];
}

- (void)loadCompletedDataFromWebWithBeginPage:(NSInteger)beginPage pageSize:(NSInteger)pageSize
{
    [ApplyViewModel getCompletedApplicationDataWithBeginPage:beginPage pageSize:pageSize success:^(NSArray *applicationDataList) {
        
        NSLog(@"获取已结束的申请列表:%@", applicationDataList);
        
        if (beginPage == 1) {
            [_completedApplicationModelArray removeAllObjects];
            [_completedTableView.mj_footer resetNoMoreData];
            [_overedButton.titleLabel hideRedPoint];//刷新数据时，红点消失
        }
        
        self.completedArrayForPage = [ApplicationModel getModelArrayFromModelArray:applicationDataList];
        
        if (self.completedArrayForPage.count == 0) {
            [_completedTableView.mj_footer endRefreshingWithNoMoreData];
            
            if ([_completedTableView.mj_header isRefreshing]) {
                [_completedTableView.mj_header endRefreshing];
            }
            if ([_completedTableView.mj_footer isRefreshing]) {
                [_completedTableView.mj_footer endRefreshing];
            }
            
            [_completedTableView reloadData];
            return ;
        }

        [self.completedApplicationModelArray addObjectsFromArray:self.completedArrayForPage];
        
        if ([_completedTableView.mj_header isRefreshing]) {
            [_completedTableView.mj_header endRefreshing];
        }
        if ([_completedTableView.mj_footer isRefreshing]) {
            [_completedTableView.mj_footer endRefreshing];
        }
        
        [_completedTableView reloadData];
        
    } failed:^(NSError *error) {
        
        if ([_completedTableView.mj_header isRefreshing]) {
            [_completedTableView.mj_header endRefreshing];
        }
        if ([_completedTableView.mj_footer isRefreshing]) {
            [_completedTableView.mj_footer endRefreshing];
        }
        
        NSLog(@"获取已结束的申请列表失败:%@", error);
    }];
}

- (void)loadSearchResultDataFromWebWithBeginPage:(NSInteger)beginPage pageSize:(NSInteger)pageSize searchText:(NSString *)searchText
{
    [ApplyViewModel getSearchResultApplicationDataWithSearchText:self.humanSearch.text beginPage:self.pageForSearchResultApplication pageSize:self.pageSizeForLoadData success:^(NSArray *applicationDataList) {
        
        if (beginPage == 1) {
            [_searchResultApplicationModelArray removeAllObjects];
            [_searchResultTableView.mj_footer resetNoMoreData];
        }
        self.searchResultArrayForPage = [ApplicationModel getModelArrayFromModelArray:applicationDataList];
        
        if (self.searchResultArrayForPage.count == 0) {
            [_searchResultTableView.mj_footer endRefreshingWithNoMoreData];
            
            if ([_searchResultTableView.mj_header isRefreshing]) {
                [_searchResultTableView.mj_header endRefreshing];
            }
            if ([_searchResultTableView.mj_footer isRefreshing]) {
                [_searchResultTableView.mj_footer endRefreshing];
            }
            
            //如果没有搜索结果的时候，显示没有搜索到结果图片
            [_searchResultTableView tableViewDisplayNotFoundViewWithRowCount:beginPage -1];//为了区别下拉没有更多数据，但是刷新是有数据的
            
            return ;
        }
        [self.searchResultApplicationModelArray addObjectsFromArray:self.searchResultArrayForPage];
        
        if ([_searchResultTableView.mj_header isRefreshing]) {
            [_searchResultTableView.mj_header endRefreshing];
        }
        if ([_searchResultTableView.mj_footer isRefreshing]) {
            [_searchResultTableView.mj_footer endRefreshing];
        }
        
        //如果没有搜索结果的时候，显示没有搜索到结果图片
        [_searchResultTableView tableViewDisplayNotFoundViewWithRowCount:self.searchResultApplicationModelArray.count];
        
        [_searchResultTableView reloadData];
        
    } failed:^(NSError *error) {
        
        if ([_searchResultTableView.mj_header isRefreshing]) {
            [_searchResultTableView.mj_header endRefreshing];
        }
        if ([_searchResultTableView.mj_footer isRefreshing]) {
            [_searchResultTableView.mj_footer endRefreshing];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*
    if (self.humanSearch.showsCancelButton) {
        [self.humanSearch becomeFirstResponder];
    }
    */
    
    if (self.humanSearch.top != 0) {//如果还在搜索阶段，隐藏导航栏
        self.navigationController.navigationBarHidden = YES;
    }

}

//创建表视图
- (void)setupTableView{
    
    __weak typeof(self)weakSelf = self;
    
    // 搜索框
    HSSearchTableView *searchTableView = [[HSSearchTableView alloc] initWithPreviousViewController:self searchResultTableView:self.searchResultTableView searchResultDataArray:self.searchResultApplicationModelArray searchHappenBlock:^{
        
        //后台服务器接口未完善
        typeof(self)strongSelf = weakSelf;
        
        [strongSelf loadSearchResultDataFromWebWithBeginPage:strongSelf.pageForSearchResultApplication pageSize:strongSelf.pageSizeForLoadData searchText:strongSelf.humanSearch.text];
        
    }];
    
    [self.view addSubview:searchTableView]; //为了增强HSSearchTableView的对象的生命周期
    searchTableView.beforeShowSearchBarFrame = CGRectMake(0, 0, kScreen_Width, 44);
    self.humanSearch = searchTableView.searchBar;
    [self.view addSubview:self.humanSearch];
    
    // 进行中按钮(buttonAction:)
    _underwayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _underwayButton.frame = CGRectMake(0, self.humanSearch.bottom + 1, kScreen_Width / 2.0, 48);
    _underwayButton.backgroundColor = [UIColor whiteColor];
    [_underwayButton setTitle:@"进行中" forState:UIControlStateNormal];
    _underwayButton.selected = YES;
    [_underwayButton setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateSelected];
    [_underwayButton setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
    _underwayButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _underwayButton.tag = 100;
    [_underwayButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_underwayButton];
    
    
    // 已结束按钮(buttonAction:)
    _overedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _overedButton.frame = CGRectMake(kScreen_Width / 2.0 , self.humanSearch.bottom + 1, kScreen_Width / 2, 48);
    _overedButton.backgroundColor = [UIColor whiteColor];
    [_overedButton setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateSelected];
    [_overedButton setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
    [_overedButton setTitle:@"已结束" forState:UIControlStateNormal];
    _overedButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_overedButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _overedButton.tag = 101;
    [self.view addSubview:_overedButton];
    
    // 红色一条线
    _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, _underwayButton.bottom - 1, kScreen_Width / 2, 2)];
    _backImage.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [self.view addSubview:_backImage];
    
    // 放置两个表视图的ScrollView
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _backImage.bottom, kScreen_Width, kScreen_Height - 64 - _backImage.bottom)];
    _baseScrollView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    _baseScrollView.delegate = self;
    _baseScrollView.contentSize = CGSizeMake(kScreen_Width * 2 , kScreen_Height - 64 - _backImage.bottom);
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    _baseScrollView.bounces = NO;//取消弹簧效果
    [self.view addSubview:_baseScrollView];

    // 进行中的表视图
    _ongingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64 - _backImage.bottom) style:UITableViewStylePlain];
    _ongingTableView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    _ongingTableView.tableFooterView = [[UIView alloc] init];
    _ongingTableView.delegate = self;
    _ongingTableView.dataSource = self;
    _ongingTableView.contentSize = CGSizeMake(kScreen_Width+100, kScreen_Height - 93 - 64);
    
    if ([_ongingTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_ongingTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_ongingTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_ongingTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    // 进行中的表视图下拉刷新
    _ongingTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSLog(@"进行中的列表的下拉刷新");
        typeof(self)strongSelf = weakSelf;
        strongSelf.pageForOngingApplication = 1;
        [strongSelf loadOngingDataFromWebWithBeginPage:strongSelf.pageForOngingApplication pageSize:strongSelf.pageSizeForLoadData];

    }];
    
    // 进行中的表视图上拉加载
    _ongingTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        typeof(self)strongSelf = weakSelf;
        strongSelf.pageForOngingApplication ++;
        [strongSelf loadOngingDataFromWebWithBeginPage:strongSelf.pageForOngingApplication pageSize:strongSelf.pageSizeForLoadData];
    }];
    
    [_baseScrollView addSubview:_ongingTableView];
    
    // 已结束的表视图
    _completedTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreen_Width,0, kScreen_Width, kScreen_Height - 64 - _backImage.bottom) style:UITableViewStylePlain];
    _completedTableView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    _completedTableView.tableFooterView = [[UIView alloc] init];
    _completedTableView.delegate = self;
    _completedTableView.dataSource = self;
    _completedTableView.contentSize = CGSizeMake(kScreen_Width+100, kScreen_Height - 93 - 64);
    
    if ([_completedTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_completedTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_completedTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_completedTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    // 已结束的表视图下拉刷新
    _completedTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSLog(@"已结束的列表的下拉刷新");
        typeof(self)strongSelf = weakSelf;
        strongSelf.pageForCompletedApplication = 1;
        [strongSelf loadCompletedDataFromWebWithBeginPage:strongSelf.pageForCompletedApplication pageSize:strongSelf.pageSizeForLoadData];
    }];
    
    _completedTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        typeof(self)strongSelf = weakSelf;
        strongSelf.pageForCompletedApplication ++;
        [strongSelf loadCompletedDataFromWebWithBeginPage:strongSelf.pageForCompletedApplication pageSize:strongSelf.pageSizeForLoadData];
    }];
    
    [_baseScrollView addSubview:_completedTableView];
    
    // 新建申请按钮(btnAction:)
    UIButton *newCreate = [UIButton buttonWithType:UIButtonTypeCustom];
    newCreate.frame = CGRectMake(0, 0, 30, 30);
    [newCreate setImage:[UIImage imageNamed:@"add_approva"] forState:UIControlStateNormal];
    [newCreate addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newCreate];
}

//点击“进行中”或者“已结束”
- (void)buttonAction:(UIButton *)btn {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    _backImage.frame = CGRectMake((btn.tag - 100) * kScreen_Width / 2, _underwayButton.bottom - 1, kScreen_Width / 2, 2);
    
    CGFloat offsetX = (btn.tag - 100) * _baseScrollView.frame.size.width;
    _baseScrollView.contentOffset = CGPointMake(offsetX, _baseScrollView.contentOffset.y);
    
    [UIView commitAnimations];
    
    if (btn.tag == 100) {
        // 进行中
        _overedButton.selected = NO;
        _underwayButton.selected = YES;
        [_ongingTableView reloadData];

    }else if(btn.tag == 101) {
        // 已结束
        _underwayButton.selected = NO;
        _overedButton.selected = YES;
        [_completedTableView reloadData];

    }
}


//点击新建申请按钮后，跳转到NewApplyVC控时器
-(void)btnAction:(UIButton *)btn{
    
    /**
    NewApplyVC *newApplyVC=[[NewApplyVC alloc]init];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:newApplyVC animated:YES];
    **/
    
    
    CreateApplyVC *createApplyVC=[[CreateApplyVC alloc]init];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:createApplyVC animated:YES];
    
     
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _baseScrollView) {//只有当scrollView不是tableView才会触发下面的方法
        //根据偏移量计算页码
        NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
        
        UIButton *button = (page == 0) ? _underwayButton : _overedButton;
        [self buttonAction:button];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableViewDataSource
// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _ongingTableView) {
        return self.ongingApplicationModelArray.count;
        
    }else if (tableView == _completedTableView) {
        return self.completedApplicationModelArray.count;
        
    }else {
        return self.searchResultApplicationModelArray.count;
        
    }
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ApplyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (tableView == _ongingTableView) {
        cell.applicationModel = [self.ongingApplicationModelArray objectAtIndex:indexPath.row];
        return cell;
        
    }else if (tableView == _completedTableView) {
        cell.applicationModel = [self.completedApplicationModelArray objectAtIndex:indexPath.row];
        return cell;
        
    }else {
        cell.applicationModel = [self.searchResultApplicationModelArray objectAtIndex:indexPath.row];
        return cell;
    }
}

//单元格将要出现
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

// 选中后，跳转到ApplyProcessVC
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ApplyProcessVC *processVC = [[ApplyProcessVC alloc] init];

    if (tableView == _ongingTableView) {
        
        ApplicationModel *applicationModel = self.ongingApplicationModelArray[indexPath.row];
        processVC.applyRequestId = applicationModel.applyID;
        processVC.status = applicationModel.status;
        processVC.statusDesc = applicationModel.statusDesc;
        processVC.statusDescColor = applicationModel.statusDescColor;
        processVC.progress = applicationModel.progress;
        
        processVC.showRevokeView = YES; //撤销
        processVC.showBottomView = NO; //重新申请、越级申请
    }else if (tableView == _completedTableView) {
    
        ApplicationModel *applicationModel = self.completedApplicationModelArray[indexPath.row];
        processVC.applyRequestId = applicationModel.applyID;
        processVC.status = applicationModel.status;
        processVC.statusDesc = applicationModel.statusDesc;
        processVC.statusDescColor = applicationModel.statusDescColor;
        processVC.progress = applicationModel.progress;
        
        processVC.showRevokeView = NO;
        processVC.showBottomView = ( (applicationModel.status == 4) || (applicationModel.status == 5) || (applicationModel.status == 6) )? NO : YES;
        
    }else { // 搜索列表时

        ApplicationModel *applicationModel = self.searchResultApplicationModelArray[indexPath.row];
        processVC.applyRequestId = applicationModel.applyID;
        processVC.status = applicationModel.status;
        processVC.statusDesc = applicationModel.statusDesc;
        processVC.statusDescColor = applicationModel.statusDescColor;
        processVC.progress = applicationModel.progress;
        
        processVC.showRevokeView = ( (applicationModel.status == 0) || (applicationModel.status == 1) || (applicationModel.status == 3) )? YES : NO; //撤销
        processVC.showBottomView = (applicationModel.status == 2)? YES : NO; //重新申请、越级申请
        
    }
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:processVC animated:YES];
}

//高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

@end

