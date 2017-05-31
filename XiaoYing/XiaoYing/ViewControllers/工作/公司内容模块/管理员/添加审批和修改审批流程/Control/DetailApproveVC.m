//
//  ApproveManageVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DetailApproveVC.h"
#import "FootView.h"
#import "ApprovePopupVC.h"
#import "ManageCell.h"
#import "NewApproveFlowVC.h"
#import "XYSearchBar.h"
#import "EditApproveFlowVC.h"
#import "SearchResultView.h"


#define LimitNum 20


@interface DetailApproveVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    BOOL _isToTop;
    int _startNum;

}

@property (nonatomic,strong) UITableView *approveTable;
@property (nonatomic,copy)   NSMutableArray *approveArr;
@property (nonatomic,strong) FootView *footView;//新建流程和多选
@property (nonatomic,strong) UIView *currentView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) SearchResultView *searchView;

@property(nonatomic,strong)UIButton * button;


@property (nonatomic,strong) UIButton *leftbt;
@property (nonatomic,assign) CheckType checkType;

@property (nonatomic,copy) NSMutableArray *deleteArr;



@end

@implementation DetailApproveVC

// 懒加载
- (NSMutableArray *)deleteArr
{
    if (!_deleteArr) {
        _deleteArr = [NSMutableArray array];
    }
    return _deleteArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    //    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    [self initUI];
    
    self.leftbt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftbt.frame = CGRectMake(6, (44-20)/2.0, 40, 20);
    [self.leftbt setTitle:@"退出" forState:UIControlStateNormal];
    [self.leftbt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftbt.hidden = YES;
    self.leftbt.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.leftbt addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.leftbt];
    
    // 分页起始位置
    _startNum = 1;
    _approveArr = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_isToTop) {
        
        // 请求数据
        [self requestData];
    }
    
}

- (void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
    
    
    NSString *typeStr = [NSString stringWithFormat:@"%@&CategoryId=%@&Name=%@&PageIndex=%d&PageSize=%d",GetType,_model.ID, @"", _startNum, LimitNum];
    [AFNetClient GET_Path:typeStr completed:^(NSData *stringData, id JSONDict) {
        
        [hud hide:YES];
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
            _startNum = _startNum+LimitNum;

            NSMutableArray *arrM = [NSMutableArray array];
            for (NSDictionary *dic in JSONDict[@"Data"]) {
                NewApprovalModel *model = [[NewApprovalModel alloc] initWithContentsOfDic:dic];
                [arrM addObject:model];
            }
            
            if (arrM.count > 0) {
                [_approveTable.mj_footer endRefreshing];
                
            }
            else {
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [_approveTable.mj_footer endRefreshingWithNoMoreData];
                //            _tableView.mj_footer.automaticallyHidden = YES;
            }
            
            [_approveArr addObjectsFromArray:arrM]; ;
            [_approveTable reloadData];
        }
        //        NSLog(@"%@",JSONDict[@"Message"]);
//        if (_dataList.count > 0 && !_isToTop) {
//            NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
//            [_tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
//        }
        
        _isToTop = YES;
        
        
    } failed:^(NSError *error) {
        
        [_approveTable.mj_footer endRefreshing];

        NSLog(@"%@",error);
        
    }];
}


//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    [self.view endEditing:YES];
//
//}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"查找审批种类";
        _searchBar.showsCancelButton = NO;
        _searchBar.tintColor = [UIColor colorWithHexString:@"#f99740"];// 取消字体颜色和光标颜色
        [_searchBar setBackgroundImage:[UIImage new]];
        _searchBar.barTintColor = [UIColor colorWithHexString:@"#efeff4"];
    }
    return _searchBar;
}

- (SearchResultView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchResultView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64)];
        _searchView.tag = 101;
        __weak typeof(self) weakSelf = self;
        _searchView.searchBlock = ^(void) {
            [weakSelf searchBarCancelButtonClicked:weakSelf.searchBar];
        };
        _searchView.refreshBlock = ^(void) {
            _isToTop = NO;
            _startNum = 1;
            [weakSelf.approveArr removeAllObjects];
        };
    }
    return _searchView;
}
//初始化UI控件
- (void)initUI{
    
    
    // 表视图
    self.approveTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-44) style:UITableViewStylePlain];
    self.approveTable.tableHeaderView = self.searchBar;
    self.approveTable.tableFooterView = [[UIView alloc] init];
    self.approveTable.delegate = self;
    self.approveTable.dataSource = self;
    self.approveTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.approveTable];
    
    
    self.footView = [[FootView alloc] initWithFrame:CGRectMake(0, kScreen_Height-44-64, kScreen_Width, 44)];
    self.footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footView];
    [self.footView.leftbt setTitle:@"新建审批种类" forState:UIControlStateNormal];
    [self.footView.rightbt setTitle:@"操作" forState:UIControlStateNormal];
    [self.footView.leftbt addTarget:self action:@selector(creatAndManySelectway:) forControlEvents:UIControlEventTouchUpInside];
    [self.footView.rightbt addTarget:self action:@selector(creatAndManySelectway:) forControlEvents:UIControlEventTouchUpInside];
    
    // 上拉刷新
//    self.approveTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        // 请求数据
//        [self requestData];
//    }];
    
    
}

// 退出事件
- (void)exitAction:(UIButton *)btn
{
    [self.navigationItem.leftBarButtonItems lastObject].customView.hidden = NO;
    btn.hidden = YES;
    
    // 单元格显示样式
    self.checkType = CheckTypeDownload;
    [self.approveTable reloadData];
    
    //底部视图
    [UIView animateWithDuration:.5 animations:^{
        self.currentView.alpha = 0;
        [self.currentView removeFromSuperview];
    }];
    
    [UIView animateWithDuration:.5 animations:^{
        self.footView.alpha = 1;
        [self.view addSubview:self.footView];
    }];
}

- (void)creatAndManySelectway:(UIButton *)bt{
    if (bt.tag == 10001) {
        //        NSLog(@"新建流程");
        NewApproveFlowVC *newApproveFlowVC = [[NewApproveFlowVC alloc] init];
        newApproveFlowVC.title = @"新建审批种类";
        newApproveFlowVC.categoryID = _model.ID;
        [self.navigationController pushViewController:newApproveFlowVC animated:YES];
        newApproveFlowVC.refreshBlock = ^(void) {
            
            _isToTop = NO;
            _startNum = 1;
            [_approveArr removeAllObjects];
        };
        
    }else if (bt.tag == 10002){
        
        [self.navigationItem.leftBarButtonItems lastObject].customView.hidden = YES;
        self.leftbt.hidden = NO;
        
        // 单元格显示样式
        self.checkType = CheckTypeSelected;
        [self.approveTable reloadData];
        
        // 移除
        self.footView.alpha = 0;
        [self.footView removeFromSuperview];
        
        // 删除视图
        UIView *currentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-44, kScreen_Width, 44)];
        currentView.alpha = 0;
        [self.view addSubview:currentView];
        self.currentView = currentView;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorWithHexString:@"#f94040"];
        button.frame = currentView.bounds;
        [button setTitle:@"删除" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [currentView addSubview:button];
        self.button = button;
        
        //动画
        [UIView animateWithDuration:.5 animations:^{
            currentView.alpha = 1;
        }];
        //        SelectManyViewController *manyvc1 = [[SelectManyViewController alloc] init];
        //
        //        manyvc1.title = @"审批流程管理";
        //        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        //        [self.navigationController pushViewController:manyvc1 animated:YES];
    }
}


// 删除事件
- (void)deleteAction
{
    
    NSMutableArray *ids = [NSMutableArray array];
    for (NewApprovalModel *model in _deleteArr) {
        [ids addObject:model.ObjectID];
    }
    
    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
    [paramDic  setValue:ids forKey:@"TypeID"];
    
    [AFNetClient  POST_Path:Deltype params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        //        [hud hide:YES];
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            _startNum = _startNum - (int)_deleteArr.count;
            [_approveArr removeObjectsInArray:_deleteArr];
            [_approveTable reloadData];
            
            NSLog(@"%@",JSONDict[@"Message"]);
        }

        [self exitAction:self.leftbt];

    } failed:^(NSError *error) {
        NSLog(@"请求失败Error--%ld",(long)error.code);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.checkType == CheckTypeDelete || self.checkType == CheckTypeSelected) {
        return;
    }
    
    NewApprovalModel *model = _approveArr[indexPath.row];

    EditApproveFlowVC *editVC = [[EditApproveFlowVC alloc] init];
    
    editVC.title = @"编辑审批种类";
    editVC.TypeId = model.ObjectID;
    [self.navigationController pushViewController:editVC animated:YES];
    editVC.refreshBlock = ^(void) {
        
        _isToTop = NO;
        _startNum = 1;
        [_approveArr removeAllObjects];
    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[ManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.deleteBlock = ^(NewApprovalModel *model) {
            
            if (model.isSelected == YES) {
                [self.deleteArr addObject:model];
            } else {
                [self.deleteArr removeObject:model];
                
            }
            [self.approveTable reloadData];
            
            NSString *countStr = nil;
            if (self.deleteArr.count == 0) {
                self.button.userInteractionEnabled = NO;
                
                countStr = @"删除";
            } else {
                self.button.userInteractionEnabled = YES;
                countStr = [NSString stringWithFormat:@"删除(%ld)",self.deleteArr.count];
                
            }
            [self.button setTitle:countStr forState:UIControlStateNormal];
        };

    }
    NewApprovalModel *model = _approveArr[indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.textLabel.text = model.Name;
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.checkType = self.checkType;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.approveArr.count;
}

#pragma mark - UISearchBarDelegate
//// 查找
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSString *searchStr = [NSString stringWithFormat:@"%@&CategoryId=%@&Name=%@&PageIndex=%d&PageSize=%d",SearchCategory,_model.ID, self.searchBar.text, 1, 1000];
    
    [AFNetClient GET_Path:searchStr completed:^(NSData *stringData, id JSONDict) {
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            NSMutableArray *arrM = [NSMutableArray array];
            for (NSDictionary *dic in JSONDict[@"Data"]) {
                NewApprovalModel *model = [[NewApprovalModel alloc] initWithContentsOfDic:dic];
                [arrM addObject:model];
            }
            
            self.searchView.approveArr = arrM;
            [self.searchView.approveTable reloadData];
        }
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    
    [UIView animateWithDuration:0.35 animations:^{
        self.navigationController.navigationBarHidden = YES;
        
        _approveTable.top = 20;
        //        _searchBar.frame = CGRectMake(0, 20, kScreen_Width, 44);
        _searchBar.showsCancelButton = YES;
        
        [self.searchView.approveTable reloadData];
        [self.view addSubview:self.searchView];
    }];
    
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.navigationController.navigationBarHidden = NO;
    _approveTable.top = 0;
    
    [self.searchView.approveArr removeAllObjects];
    self.searchView.approveArr = nil;
    
    [self.searchView removeFromSuperview];
    //    _searchBar.frame = CGRectMake(0, 64, kScreen_Width, 44);
    
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    //    _isSearch = NO;
    //    [_friendTableView reloadData];
}

@end
