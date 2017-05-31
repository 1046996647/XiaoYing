//
//  MemorandumVC.m
//  XiaoYing
//
//  Created by ZWL on 15/11/10.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "MemorandumVC.h"
#import "NewMemorandumVC.h"
#import "WangUrlHelp.h"
#import "DetailMemoryVC.h"
#import "HomeCell.h"
#define LimitNum 5

@interface MemorandumVC () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataList;
    BOOL _isToTop;
    //    WLLoadingView *_loadingView;
    //    WLRequestFailView *_failView;
    int _startNum;
}

@end

@implementation MemorandumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.title = @"备忘录";
    
    // 起始位置
    _startNum = 0;
    _dataList = [NSMutableArray array];
    
    //列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self.view addSubview:_tableView];
    
    // 新建按钮
    UIButton *newCreate = [UIButton buttonWithType:UIButtonTypeCustom];
    newCreate.frame = CGRectMake(0, 0, 30, 30);
    [newCreate setImage:[UIImage imageNamed:@"white_add"] forState:UIControlStateNormal];
    [newCreate addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newCreate];
    
    // =====================第一种样式=======================
    
    //    // 上拉刷新
    //    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    //    // 禁止自动加载
    //    footer.automaticallyRefresh = NO;
    //
    ////    // 设置文字
    ////    [footer setTitle:@"Click or drag up to refresh" forState:MJRefreshStateIdle];
    ////    [footer setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
    ////    [footer setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
    ////
    ////    // 设置字体
    ////    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    ////
    ////    // 设置颜色
    ////    footer.stateLabel.textColor = [UIColor blueColor];
    //
    //    // 设置footer
    //    _tableView.mj_footer = footer;
    
    
    // =====================第二种样式=======================
    // 上拉刷新
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestData];
    }];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!_isToTop) {
        
        // 请求数据
        [self requestData];
    }
    
}


#pragma mark - 网络加载方法 methods
// 请求数据
- (void)requestData
{
//    if (_dataList.count == 0) {
//        [self.view addSubview:self.loadingView];
//        
//    }
    
    NSString *getStr = [NSString stringWithFormat:@"%@&start=%d&limit=%d",GetMemory, _startNum, LimitNum];
    [AFNetClient GET_Path:getStr completed:^(NSData *stringData, id JSONDict) {
        
        _startNum = _startNum+LimitNum;
        
        NSLog(@"%@",JSONDict);
        
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dic in JSONDict[@"Data"]) {
            SendMemoryModel *model = [[SendMemoryModel alloc] initWithContentsOfDic:dic];
            [arrM addObject:model];
        }
        
        if (arrM.count > 0) {
            [_tableView.mj_footer endRefreshing];
            
        }
        else {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            //            _tableView.mj_footer.automaticallyHidden = YES;
        }
        
        [_dataList addObjectsFromArray:arrM]; ;
        [_tableView reloadData];
        
        if (_dataList.count > 0 && !_isToTop) {
            NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
            [_tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
        _isToTop = YES;
        
    } failed:^(NSError *error) {
        
        [_tableView.mj_footer endRefreshing];
        
            [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
    }];
}

// 重新加载
- (void)resumeRequestAction
{
    
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnAction:(UIButton *)btn{
    
    //    _isToTop = YES;
    
    NewMemorandumVC *createVC = [[NewMemorandumVC alloc] init];
    createVC.refreshBlock = ^(void) {
        
        _isToTop = NO;
        _startNum = 0;
        [_dataList removeAllObjects];
    };
    [self.navigationController pushViewController:createVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"cell";
    
    HomeCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.deleteBlock = ^(SendMemoryModel *model)
        {
            _startNum--;
            [_dataList removeObject:model];
            [_tableView reloadData];
        };
        
    }
    cell.model = _dataList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    _isToTop = YES;
    
    SendMemoryModel *model = _dataList[indexPath.row];
    DetailMemoryVC *detailMemoryVC = [[DetailMemoryVC alloc] init];
    detailMemoryVC.dataArr = model.dataArr;
    detailMemoryVC.Id = model.Id;
    detailMemoryVC.refreshBlock = ^(void) {
        _isToTop = NO;
        _startNum = 0;
        [_dataList removeAllObjects];
        
    };
    [self.navigationController pushViewController:detailMemoryVC animated:YES];
}


//去掉最后单元格最下面的线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}


@end
