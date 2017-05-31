//
//  ApprovalVC.m
//  XiaoYing
//
//  Created by ZWL on 15/11/10.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "ApplyVC.h"
//#import "ApplyCell.h"
#import "ApproalCell.h"
//#import "ApplicationModel.h"
#import "ApproalProcessVC.h"
#import "NewApplyVC.h"
#import "UIColor+Expend.h"
#import "ApprovalModel.h"
#import "UITableView+showMessageView.h"
#import "WangUrlHelp.h"


@interface ApprovalManageVC () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *array;                 // 数组
    ApprovalModel *model;           // 数据
    UIButton *_underway;            // 进行中
    UIButton *_overed;              // 已结束
    UIImageView *_backImage;        // 红色bar
    UITableView *_tableView;        // 待审批表视图
    NSString *_approvalURL;         // 分页获取待审批数组的URL
    NSString *_overApprovaledURL;   // 分页获取已审批数组的URL
    NSInteger _currentApprovalPage; // 当前待审批数组的页数
    NSInteger _currentOverApprovaledPage; //当前已审批数组的页数
    NSInteger _currentSearchPage;    // 当前搜索界面的页数
    NSInteger _pageSize;            // 每页显示的内容，目前先写死
    NSMutableArray *_approvalArray;           // 装载审批model的数组
    NSMutableArray *_overApprovaledsArray; // 装载已审批model的数组
    MBProgressHUD *_hud;            // 菊花
    UIScrollView *_scrollView;       // 装载表视图的滚动视图
    UITableView *_overedTableView;   //已审批表视图
    UIButton *_previousButton;       //上一个被点击的button
    NSMutableArray *_searchArray; //装载查找到的
    NSMutableArray *_applyRevokesArray;//申请撤销的数组
    UIView *_redPointView; //在待我审批上面的小红点
}

@property (nonatomic,strong) UIButton *addBtn;  // 图片添加按钮
//@property (nonatomic,strong) XYSearchBar *humanSearch;//收索框
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,strong) MJRefreshAutoNormalFooter *tableViewFooter;
@property(nonatomic,strong)MJRefreshAutoNormalFooter *overedTableViewFooter;
@property(nonatomic,strong)MJRefreshAutoNormalFooter *searchResultViewFooter;
@property(nonatomic,strong)UITableView *searchResultView;//点击搜索按钮之后出现的搜索界面
@property(nonatomic,strong)UISearchBar *searchBar;//搜索
@property(nonatomic,strong)UIView *ViewForSearch;       //当搜索时的背景图
@end

@implementation ApprovalManageVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"审批";
    _approvalArray = [NSMutableArray array];
    _overApprovaledsArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    _currentApprovalPage = 1;
    _currentOverApprovaledPage = 1;
    _pageSize = 20;
    
    [self loadApprovalData];
   // [self loadOverApprovaledData];
    [self setScrollView];
    [self _createTable];
    //监听是否有新的流程待审核的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newApproval:) name:kCheckApprovalAuditingNotification object:nil];
    //监听是否有申请被撤销
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(approvalRevoked:) name:kCheckApplyRevokeNotification object:nil];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载中";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [self.humanSearch resignFirstResponder];
//    self.humanSearch.searchButton.hidden = YES;
    
    [_searchBar resignFirstResponder];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _applyRevokesArray = [NSMutableArray array];
    if (_searchBar.top != 0) {//如果还在搜索阶段，隐藏导航栏
        self.navigationController.navigationBarHidden = YES;
    }
}


/**
 *  创建表视图
 */
- (void)_createTable{
    
    // 待我审批
    _underway = [UIButton buttonWithType:UIButtonTypeCustom];
    _underway.frame = CGRectMake(0, 44, kScreen_Width / 2.0, 48);
    [_underway setTitle:@"待我审批" forState:UIControlStateNormal];
    _underway.selected = YES;
    _previousButton = _underway;
    [_underway setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateSelected];
    [_underway setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
    _underway.titleLabel.font = [UIFont systemFontOfSize:14];
    _underway.tag = 100;
    [_underway addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_underway];
    
    //设置小红点
    _redPointView = [[UIView alloc]init];
    _redPointView.backgroundColor = [UIColor redColor];
    UILabel *testLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 500, 500)];
    testLabel.text = @"待我审批";
    testLabel.font = [UIFont systemFontOfSize:14];
    [testLabel sizeToFit];
    _redPointView.frame = CGRectMake(0, 0, 10, 10);
    _redPointView.top = _underway.height / 2;
    _redPointView.left = _underway.width / 2;
    _redPointView.left = _redPointView.left + testLabel.width/2 - 5;
    _redPointView.top = _redPointView.top - testLabel.height/2 - 5;
    _redPointView.layer.cornerRadius = _redPointView.width / 2;
    _redPointView.layer.masksToBounds = YES;
    [_underway addSubview:_redPointView];
    _redPointView.hidden = YES;
    
    
    // 我已审批
    _overed = [UIButton buttonWithType:UIButtonTypeCustom];
    _overed.frame = CGRectMake(kScreen_Width / 2.0 , 44, kScreen_Width / 2, 48);
    [_overed setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateSelected];
    [_overed setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
    [_overed setTitle:@"我已审批" forState:UIControlStateNormal];
    _overed.titleLabel.font = [UIFont systemFontOfSize:14];
    [_overed addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _overed.tag = 101;
    [self.view addSubview:_overed];
    
    
    // 背景颜色
    _underway.backgroundColor = [UIColor whiteColor];
    _overed.backgroundColor = [UIColor whiteColor];
    
    // 红色bar
    _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 47 + 44, kScreen_Width / 2, 2)];
    _backImage.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [self.view addSubview:_backImage];
    
    // 搜索审批
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"查找审批";
    _searchBar.showsCancelButton = NO;
    _searchBar.tintColor = [UIColor colorWithHexString:@"#f99740"];// 取消字体颜色和光标颜色
    [_searchBar setBackgroundImage:[UIImage new]];
    _searchBar.barTintColor = [UIColor colorWithHexString:@"#efeff4"];
    [self.view addSubview:_searchBar];
    
    // 表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 49 , kScreen_Width, _scrollView.height - 49 ) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    //_tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
     __block __weak __typeof(&*self)weakSelf = self;
    //添加下拉刷新
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentApprovalPage = 1;
        _currentOverApprovaledPage = 1;
        [weakSelf loadApprovalData];
    }];
    //添加上拉加载
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreDataForApproal];
    }];
    _tableView.contentInset = UIEdgeInsetsMake(44, 0, 64, 0);
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [_scrollView addSubview:_tableView];
    
    _overedTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreen_Width, 49 , kScreen_Width, _scrollView.height - 49) style:UITableViewStylePlain];
    //_overedTableView.contentInset = UIEdgeInsetsMake(94, 0, 0, 0);
    
    _overedTableView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
   // _overedTableView.tableFooterView = [[UIView alloc] init];
    _overedTableView.delegate = self;
    _overedTableView.dataSource = self;
    _overedTableView.showsVerticalScrollIndicator = NO;
    //添加下拉刷新
    _overedTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentApprovalPage = 1;
        _currentOverApprovaledPage = 1;
        [weakSelf loadApprovalData];
    }];
    //添加上拉加载
//    _overedTableViewFooter.stateLabel.hidden = YES;
//    _overedTableViewFooter.refreshingTitleHidden = YES;
    _overedTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreDataForOverApproaled];
    }];
    if ([_overedTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_overedTableView setSeparatorInset:UIEdgeInsetsZero];
        }
    if ([_overedTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_overedTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    _overedTableView.contentInset = UIEdgeInsetsMake(44, 0, 64, 0);
    [_scrollView addSubview:_overedTableView];
    
    _scrollView.contentSize = CGSizeMake(kScreen_Width * 2 , kScreen_Height);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    //取消弹簧效果
    _scrollView.bounces = NO;
   
}

/**
 *  按钮点击事件
 *
 *  @param btn
 */
- (void)buttonAction:(UIButton *)btn {
    _previousButton.selected = NO;
    btn.selected = YES;
    _previousButton  = btn;
    
    NSInteger index = btn.tag - 100;
    //当按钮点击的时候,将underLine也跟随移动位置
    [UIView animateWithDuration:0.25 animations:^{
    _backImage.frame = CGRectMake((btn.tag - 100) * kScreen_Width / 2, 47 + 44, kScreen_Width / 2, 2);
    
    CGFloat offsetX = index * _scrollView.frame.size.width;
    _scrollView.contentOffset = CGPointMake(offsetX, _scrollView.contentOffset.y);
    } completion:^(BOOL finished) {
            nil;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableViewDataSource
// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {//未审批
        // return 5;
        return _approvalArray.count;
       
    }else if(tableView == _overedTableView){//已审批
        //return 3;
        return _overApprovaledsArray.count;
    }else{//搜索结果
       
        return _searchArray.count;
    }
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApproalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        cell = [[ApproalCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (tableView == _tableView) {//未审批
        cell.overed = NO;
        cell.approvalModel = _approvalArray[indexPath.row];
    }else if(tableView == _overedTableView){//已审批
        cell.overed = YES;
        cell.approvalModel = _overApprovaledsArray[indexPath.row];
    }else{
        cell.approvalModel = _searchArray[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableView delegateMethods

//单元格将要出现
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

// 选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ApproalProcessVC *processVC = [[ApproalProcessVC alloc] init];
    //    processVC.type = _type;
    ApprovalModel *approvalModel = [ApprovalModel new];
    if (tableView == _tableView) {//待我审批
        approvalModel = _approvalArray[indexPath.row];
    }else{
        approvalModel = _overApprovaledsArray[indexPath.row];
        if (tableView == _overedTableView) {//已审批
            processVC.overed = YES;
            NSArray *timeArray = [approvalModel.timeSpan componentsSeparatedByString:@"分"];
            NSString *timeStr = timeArray[0];
            NSInteger time = [timeStr integerValue];
            processVC.useTime = time;
        }else{
            approvalModel = _searchArray[indexPath.row];
            self.navigationController.navigationBarHidden = NO;
        }
        // NSLog(@"timeStr:%ld",time);
    }
    if (approvalModel.applySysType == 1) {//是公告
        processVC.isAffiche = YES;
    }
    processVC.applyRequestID = approvalModel.applyID;
    processVC.progress = approvalModel.progress;
    processVC.statusDesc = approvalModel.statusDesc;
    NSInteger state = approvalModel.status;
    processVC.state = state;
    processVC.approalBlock = ^(){
//        [_hud show:YES];
        [_hud removeFromSuperview];
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _currentApprovalPage = 1;
        _currentOverApprovaledPage = 1;
        [self loadApprovalData];
    };
    processVC.applyRevokes = _applyRevokesArray.copy;
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:processVC animated:YES];
    
}

//高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

// 区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


#pragma mark - 网络加载方法 methods
/**
 *  加载待审批的数组
 */
-(void)loadApprovalData{
    _redPointView.hidden = _redPointView.hidden == YES?YES:NO;
    _approvalURL = APPROVAL_GET_TOBEAPPROVALED,_currentApprovalPage,_pageSize];
    [AFNetClient GET_Path:_approvalURL completed:^(NSData *stringData, id JSONDict) {
        NSLog(@"code:%@",JSONDict[@"Code"]);
        NSNumber *codeNumber = JSONDict[@"Code"];
        NSInteger code = [codeNumber integerValue];
        if (code == 0) {
            NSArray *recordsArray = JSONDict[@"Data"][@"Records"];
            NSLog(@"recordsArray.count:%ld",recordsArray.count);
            _approvalArray = [[ApprovalModel getModelArrayFromModelArray:recordsArray] mutableCopy];
            for (NSDictionary *dic in recordsArray) {
                NSLog(@"dic:%@",dic);
            }
            [_tableView reloadData];
            [self loadOverApprovaledData];
        }else{
            [MBProgressHUD showMessage:JSONDict[@"Message"]];
        }

    } failed:^(NSError *error) {
         NSLog(@"请求失败Error--%ld",(long)error.code);
    }];
}

/**
 *  加载已审批的数组
 */
-(void)loadOverApprovaledData{
    //让小红点隐藏
    _redPointView.hidden = YES;
    _overApprovaledURL = APPROVAL_GET_OVERAPPROVALED,_currentOverApprovaledPage,_pageSize];
    NSLog(@"AAAATOKEN:%@",_overApprovaledURL);
    [AFNetClient GET_Path:_overApprovaledURL completed:^(NSData *stringData, id JSONDict) {
        NSNumber *codeNumber = JSONDict[@"Code"];
        NSInteger code = [codeNumber integerValue];
        if (code == 0) {
            NSArray *recordsArray = JSONDict[@"Data"][@"Records"];
            _overApprovaledsArray = [[ApprovalModel getModelArrayFromModelArray:recordsArray] mutableCopy];
            
            [_overedTableView reloadData];
            [_hud hide:YES];
            [_tableView.mj_header endRefreshing];
            [_overedTableView.mj_header endRefreshing];
        }else{
            [_hud hide:YES];
            [MBProgressHUD showMessage:JSONDict[@"Message"]];
        }
    
    } failed:^(NSError *error) {
        NSLog(@"请求失败Error--%ld",(long)error.code);
    }];
}

/**
 *  加载更多的数据（为了待审批的数组）
 */
-(void)loadMoreDataForApproal{
    _currentApprovalPage++;
    _approvalURL = APPROVAL_GET_TOBEAPPROVALED,_currentApprovalPage,_pageSize];
    NSMutableArray *previousArray = _approvalArray;
    [AFNetClient GET_Path:_approvalURL completed:^(NSData *stringData, id JSONDict) {
        NSNumber *codeNumber = JSONDict[@"Code"];
        NSInteger code = [codeNumber integerValue];
        if (code == 0) {
            NSArray *recordsArray = JSONDict[@"Data"][@"Records"];
            NSLog(@"recordsArray.count:%ld",recordsArray.count);
            NSArray *newArray = [ApprovalModel getModelArrayFromModelArray:recordsArray];
            [_approvalArray addObjectsFromArray:newArray];
            [_tableView reloadData];
            if (_approvalArray.count == previousArray.count) {//没有新的数据
                _tableViewFooter.stateLabel.hidden = YES;
                
            }else{
                _tableViewFooter.stateLabel.text=@"上拉加载更多";
            }
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [MBProgressHUD showMessage:JSONDict[@"Message"]];
        }
       
    } failed:^(NSError *error) {
        NSLog(@"请求失败Error--%ld",(long)error.code);
    }];
}

/**
 *  加载更多的数据（为了已审批的数组）
 */
-(void)loadMoreDataForOverApproaled{
    _currentOverApprovaledPage++;
    _overApprovaledURL = APPROVAL_GET_OVERAPPROVALED,_currentOverApprovaledPage,_pageSize];
    NSMutableArray *previousArray = _overApprovaledsArray;
    [AFNetClient GET_Path:_overApprovaledURL completed:^(NSData *stringData, id JSONDict) {
        NSLog(@"jsonDic:%@",JSONDict);
        NSNumber *codeNumber = JSONDict[@"Code"];
        NSInteger code = [codeNumber integerValue];
        if (code == 0) {
            NSArray *recordsArray = JSONDict[@"Data"][@"Records"];
            NSArray *newArray = [ApprovalModel getModelArrayFromModelArray:recordsArray];
            NSLog(@"newarray:%@",newArray);
            [_overApprovaledsArray addObjectsFromArray:newArray];
            [_overedTableView reloadData];
            if (_overApprovaledsArray.count == previousArray.count) {//没有新的数据
                _overedTableViewFooter.stateLabel.hidden = YES;
                
            }else{
                _overedTableViewFooter.stateLabel.text=@"上拉加载更多";
            }
            [_overedTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [MBProgressHUD showMessage:JSONDict[@"Message"]];
        }
        
    } failed:^(NSError *error) {
        NSLog(@"请求失败Error--%ld",(long)error.code);
    }];
}

/**
 *  加载更多的数据（为了搜索的数组）
 */
-(void)loadMoreDataForSearch{
    _currentSearchPage++;
    NSString *searchUrl = APPROVAL_SEARCHAPPROVAL,_searchBar.text,_currentSearchPage,_pageSize];
    [AFNetClient POST_Path:searchUrl completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            [MBProgressHUD showMessage:msg toView:self.view];
        }else{
            NSArray *recordsArray = JSONDict[@"Data"][@"Records"];
            NSLog(@"recordArray:%@",recordsArray);
            NSArray *newArray = [ApprovalModel getModelArrayFromModelArray:recordsArray];
            [_searchArray addObjectsFromArray:newArray];
            [self.searchResultView reloadData];
        }
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
        [_hud hide:YES];
    }];
}

#pragma mark - scroll methods
/**
 *  创建滚动视图
 */
-(void)setScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    _scrollView.delegate = self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {//只有当scrollView不是tableView才会触发下面的方法
        //根据偏移量计算页码
        NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
        
        UIButton *button = page == 0?_underway:_overed;
        [self buttonAction:button];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
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
        _searchResultView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
        _searchResultView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        //去除底部分割线
        _searchResultView.tableFooterView = [UIView new];
        _searchResultView.delegate = self;
        _searchResultView.dataSource = self;
         __block __weak __typeof(&*self)weakSelf = self;
        //添加上拉加载
        _searchResultViewFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreDataForApproal];
        }];
        // footer.stateLabel.hidden = YES;
        _searchResultViewFooter.stateLabel.hidden = YES;
        _searchResultViewFooter.refreshingTitleHidden = YES;
        _searchResultView.mj_footer = _searchResultViewFooter;
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
        _searchBar.top = 0;
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
    _currentSearchPage = 1;
    NSString *searchUrl = APPROVAL_SEARCHAPPROVAL,_searchBar.text,_currentSearchPage,_pageSize];
    
    [AFNetClient GET_Path:searchUrl completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if (1 == [code integerValue]) {
            [_hud hide:YES];
            NSString *msg = [JSONDict objectForKey:@"Message"];
            [MBProgressHUD showMessage:msg toView:self.view];
        }else{
            NSArray *recordsArray = JSONDict[@"Data"][@"Records"];
            NSLog(@"recordArray:%@",recordsArray);
            NSArray *newArray = [ApprovalModel getModelArrayFromModelArray:recordsArray];
            [_searchArray addObjectsFromArray:newArray];
            
            //如果没有搜索结果的时候，显示没有搜索到结果图片
            [_searchResultView tableViewDisplayNotFoundViewWithRowCount:_searchArray.count];
            [self.searchResultView reloadData];
            [_hud hide:YES];
        }
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
        [_hud hide:YES];
        [MBProgressHUD showMessage:@"网络错误，请稍候再试" toView:self.view];
    }];
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

#pragma mark - 监听是否有新的审批的方法 methods
-(void)newApproval:(NSNotification*)noti{
    _redPointView.hidden = NO;
    NSLog(@"shoudao");
}

#pragma mark - 监听是否有申请被撤销 methods
-(void)approvalRevoked:(NSNotification*)noti{
    NSString *applyId = noti.object;
    [_applyRevokesArray addObject:applyId];
}
   
@end

