//
//  ApproveManageVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "ApproveManageVC.h"
#import "FootView.h"
#import "ApprovePopupVC.h"
#import "ManageCell.h"
#import "DetailApproveVC.h"
#import "NewApprovalModel.h"
#import "SearchResultView.h"

@interface ApproveManageVC ()<UISearchBarDelegate>

@property (nonatomic,strong) UITableView *approveTable;
@property (nonatomic,copy) NSMutableArray *approveArr;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) SearchResultView *searchView;

@property (nonatomic,strong) FootView *footView;//新建流程和多选
@property (nonatomic,strong) UIView *currentView;

@property (nonatomic,strong) UIButton *leftbt;
@property (nonatomic,strong) UIButton *rightbt;

@property (nonatomic,assign) CheckType checkType;
@property (nonatomic,copy) NSMutableArray *deleteArr;
@property (nonatomic,strong) UIButton *button;




@end

@implementation ApproveManageVC


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
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
//    self.automaticallyAdjustsScrollViewInsets = YES;
    [self initUI];
    
    self.leftbt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftbt.frame = CGRectMake(6, (44-20)/2.0, 40, 20);
    [self.leftbt setTitle:@"退出" forState:UIControlStateNormal];
    [self.leftbt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftbt.hidden = YES;
    self.leftbt.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.leftbt addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.leftbt];
    
    self.rightbt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightbt.frame = CGRectMake(kScreen_Width-60-6, (44-20)/2.0, 60, 20);
    self.rightbt.hidden = YES;
    [self.rightbt setTitle:@"重命名" forState:UIControlStateNormal];
    [self.rightbt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightbt.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rightbt addTarget:self action:@selector(renameAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.rightbt];
    
    // 请求数据
    [self requestData];
    
    // 审批类型数据的刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshApprovalType) name:@"kRefreshApprovalTypeNotification" object:nil];
    
}

- (void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
    
    [AFNetClient GET_Path:GetCategory completed:^(NSData *stringData, id JSONDict) {
        
        [hud hide:YES];
        
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
            
            _approveArr = arrM;
            [_approveTable reloadData];
        }
//        NSLog(@"%@",JSONDict[@"Message"]);

        
    } failed:^(NSError *error) {
        
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
        _searchBar.placeholder = @"查找审批类型";
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
        _searchView.tag = 100;
        
        __weak typeof(self) weakSelf = self;
        _searchView.searchBlock = ^(void) {
            [weakSelf searchBarCancelButtonClicked:weakSelf.searchBar];
        };
    }
    return _searchView;
}

//初始化UI控件
- (void)initUI{
    
    // 表视图
    self.approveTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-44-64) style:UITableViewStylePlain];
//    self.approveTable.tableHeaderView = self.humanSearch;
    self.approveTable.tableHeaderView = self.searchBar;
    self.approveTable.tableFooterView = [UIView new];
    self.approveTable.delegate = self;
    self.approveTable.dataSource = self;
    self.approveTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.approveTable];
    
    
    self.footView = [[FootView alloc] initWithFrame:CGRectMake(0, kScreen_Height-44-64, kScreen_Width, 44)];
    self.footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footView];
    [self.footView.leftbt setTitle:@"新建审批类型" forState:UIControlStateNormal];
    [self.footView.rightbt setTitle:@"操作" forState:UIControlStateNormal];
    [self.footView.leftbt addTarget:self action:@selector(creatAndManySelectway:) forControlEvents:UIControlEventTouchUpInside];
    [self.footView.rightbt addTarget:self action:@selector(creatAndManySelectway:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 退出事件
- (void)exitAction:(UIButton *)btn
{
    [self.navigationItem.leftBarButtonItems lastObject].customView.hidden = NO;
//    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
    btn.hidden = YES;
    self.rightbt.hidden = YES;
    [self.rightbt setTitle:@"重命名" forState:UIControlStateNormal];

    
    // 单元格显示样式
    self.checkType = CheckTypeDownload;
    
    // 改变表视图的高度
    self.approveTable.height = kScreen_Height-64-44;
    
    // 设置不选中
    for (NewApprovalModel *model in self.approveArr) {
        model.isSelected = NO;
    }
    
    [self.approveTable reloadData];
    
    // 删除的数组清空
    [self.deleteArr removeAllObjects];
    self.deleteArr = nil;
    
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

// 重命名事件
- (void)renameAction:(UIButton *)btn
{
    if ([btn.currentTitle isEqualToString:@"重命名"]) {
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        
        self.checkType = CheckTypeDelete;
        
        // 改变表视图的高度
        self.approveTable.height = kScreen_Height-64;
        
        // 设置不选中
        for (NewApprovalModel *model in self.approveArr) {
            model.isSelected = NO;
        }
        
        [self.approveTable reloadData];
        
        // 删除的数组清空
        [self.deleteArr removeAllObjects];
        self.deleteArr = nil;
        [self.button setTitle:@"删除" forState:UIControlStateNormal];

    }
    else if ([btn.currentTitle isEqualToString:@"删除"]){

        self.checkType = CheckTypeSelected;
        
        // 改变表视图的高度
        self.approveTable.height = kScreen_Height-64-44;
        [self.approveTable reloadData];
        
        [btn setTitle:@"重命名" forState:UIControlStateNormal];
        
    }
}

- (void)creatAndManySelectway:(UIButton *)bt{
    if (bt.tag == 10001) {
//        NSLog(@"新建流程");
//        SelectApproveVC *selectvc = [[SelectApproveVC alloc] init];
//        selectvc.title = @"选择审批类型";
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//        [self.navigationController pushViewController:selectvc animated:YES];
        ApprovePopupVC *approvePopupVC = [[ApprovePopupVC alloc] init];
        approvePopupVC.markText = bt.currentTitle;
        approvePopupVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //淡出淡入
        approvePopupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //            self.definesPresentationContext = YES; //不盖住整个屏幕
        approvePopupVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [self presentViewController:approvePopupVC animated:YES completion:nil];
        
        
    }else if (bt.tag == 10002){
        [self.navigationItem.leftBarButtonItems lastObject].customView.hidden = YES;
//        self.navigationItem.leftBarButtonItem.customView.hidden = YES;
        self.leftbt.hidden = NO;
//        self.rightbt.hidden = NO;
        
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
        button.userInteractionEnabled = NO;
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
     }
}


// 删除类型
- (void)deleteAction
{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"正在加载...";
    
    NSMutableArray *ids = [NSMutableArray array];
    for (NewApprovalModel *model in _deleteArr) {
        [ids addObject:model.ID];
    }
    
    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
    [paramDic  setValue:ids forKey:@"categoryIDs"];
    
    [AFNetClient  POST_Path:DeleteCategory params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        
//        [hud hide:YES];
        
        [self requestData];
        
        NSLog(@"%@",JSONDict[@"Message"]);
        [self exitAction:self.leftbt];
        
    } failed:^(NSError *error) {
        NSLog(@"请求失败Error--%@",error);
    }];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];


    if (self.checkType == CheckTypeDelete || self.checkType == CheckTypeSelected) {
        return;
    }
    
    NewApprovalModel *model = self.approveArr[indexPath.row];
    
//    if (model.TypesList.count > 0) {
//        DetailApproveVC *detailApproveVC = [[DetailApproveVC alloc] init];
//        detailApproveVC.title = model.Name;
//        detailApproveVC.model = model;
//        [self.navigationController pushViewController:detailApproveVC animated:YES];
//    }
    DetailApproveVC *detailApproveVC = [[DetailApproveVC alloc] init];
    detailApproveVC.title = model.Name;
    detailApproveVC.model = model;
    [self.navigationController pushViewController:detailApproveVC animated:YES];

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
//    cell.selected = NO;
    cell.checkType = self.checkType;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _approveArr.count;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate
//// 查找
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSString *searchStr = [NSString stringWithFormat:@"%@&Name=%@&PageIndex=%d&PageSize=%d",SearchCategory,self.searchBar.text, 1, 1000];
    
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
        
        [self.view addSubview:self.searchView];
    }];
    
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.navigationController.navigationBarHidden = NO;
    _approveTable.top = 0;
    
    [self.searchView removeFromSuperview];
    self.searchView = nil;
//    _searchBar.frame = CGRectMake(0, 64, kScreen_Width, 44);

    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
//    _isSearch = NO;
    //    [_friendTableView reloadData];
}

#pragma mark - 审批类型添加的通知方法
- (void)refreshApprovalType
{
    [self requestData];
}


@end
