//
//  DisplayDocumentViewController.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/13.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "DisplayDocumentViewController.h"
#import "XYExtend.h"
#import "AlertViewVC.h"
#import "CompanyDocumentTableView.h"
#import "DepartmentDocumentTableView.h"
#import "PersonDocumentTableView.h"
#import "LocalDocumentTableView.h"
#import "CreateDocumentFolderViewController.h"

#import "FileTypeVC.h"
#import "FileOperateVC.h"

#import "TransportDocumentViewController.h"

#import "DocumentVM.h"
#import "DocumentMergeModel.h"

#import "EmployeeViewModel.h"
#import "SearchFileVC.h"


@interface DisplayDocumentViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) CompanyDocumentTableView *companyDocumentTV;
@property (nonatomic, strong) DepartmentDocumentTableView *departmentDocumentTV;
@property (nonatomic, strong) PersonDocumentTableView *personDocumentTV;

@property (nonatomic, strong) AlertViewVC *alertVC; //推出的Alertview

@property (nonatomic, assign) NSInteger startNum;
@property (nonatomic, assign) NSInteger orderType;



@end

@implementation DisplayDocumentViewController
{
    UIView *_coverView;//展开下拉框后的覆盖视图
    UIView *_nextView;//下拉框
}

- (NSMutableArray *)folderAllPathArr
{
    if (!_folderAllPathArr) {
        _folderAllPathArr = [NSMutableArray array];
        [_folderAllPathArr addObject:self.departmentName];
    }
    return _folderAllPathArr;
}

- (CompanyDocumentTableView *)companyDocumentTV
{
    if (!_companyDocumentTV) {
        _companyDocumentTV = [[CompanyDocumentTableView alloc] initWithFrame:CGRectMake(kScreen_Width * 0, 50, kScreen_Width, kScreen_Height - 50 - 64) style:UITableViewStylePlain];
    }
    return _companyDocumentTV;
}

- (DepartmentDocumentTableView *)departmentDocumentTV
{
    if (!_departmentDocumentTV) {
        _departmentDocumentTV = [[DepartmentDocumentTableView alloc] initWithFrame:CGRectMake(kScreen_Width * 0, 50, kScreen_Width, kScreen_Height - 50 - 64) style:UITableViewStylePlain];
    }
    return _departmentDocumentTV;
}

- (PersonDocumentTableView *)personDocumentTV
{
    if (!_personDocumentTV) {
        _personDocumentTV = [[PersonDocumentTableView alloc] initWithFrame:CGRectMake(kScreen_Width * 0, 50, kScreen_Width, kScreen_Height - 50 - 64) style:UITableViewStylePlain];
    }
    return _personDocumentTV;
}

- (void)getCompanyDataFromWebWithOrderType:(NSInteger)orderType
{
    //获得公司级别的文件列表
    [DocumentVM getDocumentListDataWithFolderId:self.folderId departmentIds:@"" textKey:@"" pageIndex:1 pageSize:1000 orderType:orderType isasc:2 success:^(NSArray *documentListArray) {
        
        [_companyDocumentTV.mj_header endRefreshing];
        NSLog(@"获取公司级别的文件列表成功：%@", documentListArray);
        _startNum++;
        [self.companyDocumentTV.documentListArray addObjectsFromArray:documentListArray];
        if (documentListArray.count > 0) {
            [_companyDocumentTV.mj_footer endRefreshing];
            
        }
        else {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [_companyDocumentTV.mj_footer endRefreshingWithNoMoreData];
            //            _tableView.mj_footer.automaticallyHidden = YES;
        }
        
        //根据传过来汇总的文档数据，按文件夹和文件两种类型进行分类
        NSMutableArray *folderArray = [NSMutableArray array];
        NSMutableArray *fileArray = [NSMutableArray array];
        for (DocumentMergeModel *documentModel in [DocumentMergeModel getModelArrayFromModelArray:self.companyDocumentTV.documentListArray]) {
            if (documentModel.documentType == 0) { //代表文件夹
                [folderArray addObject:documentModel];
            }else { //代表文件
                [fileArray addObject:documentModel];
            }
        }
        self.companyDocumentTV.folderArray = folderArray.copy;
        self.companyDocumentTV.fileArray = fileArray.copy;
        
    } failed:^(NSError *error) {
        
        
    }];
}

- (void)getDepartmentDataFromWebWithOrderType:(NSInteger)orderType
{
    //获得部门级别的文件列表
    //1.首先获取当前用户的岗位信息
    [EmployeeViewModel getEmployeeMessageSuccess:^(NSArray *identityNameArray, NSArray *departmentIdArray, NSArray *departmentNameArray) {
        
        NSMutableArray *tempDepartmentIdArr = [NSMutableArray array];
        for (NSString *tempName in departmentIdArray) {
            if (![tempName isEqualToString:@""]) {
                [tempDepartmentIdArr addObject:tempName];
            }
        }
        NSString *departmentIdsStr = [tempDepartmentIdArr componentsJoinedByString:@","];
        
        //2.
        [DocumentVM getDocumentListDataWithFolderId:self.folderId departmentIds:departmentIdsStr textKey:@"" pageIndex:1 pageSize:1000 orderType:orderType isasc:2 success:^(NSArray *documentListArray) {
            
            [self.departmentDocumentTV.mj_header endRefreshing];

            NSLog(@"获取部门级别的文件列表成功：%@", documentListArray);
            _startNum++;
            [self.departmentDocumentTV.documentListArray addObjectsFromArray:documentListArray];
            if (documentListArray.count > 0) {
                [self.departmentDocumentTV.mj_footer endRefreshing];
                
            }
            else {
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [self.departmentDocumentTV.mj_footer endRefreshingWithNoMoreData];
                //            _tableView.mj_footer.automaticallyHidden = YES;
            }
            
            //根据传过来汇总的文档数据，按文件夹和文件两种类型进行分类
            NSMutableArray *folderArray = [NSMutableArray array];
            NSMutableArray *fileArray = [NSMutableArray array];
            for (DocumentMergeModel *documentModel in [DocumentMergeModel getModelArrayFromModelArray:self.departmentDocumentTV.documentListArray]) {
                if (documentModel.documentType == 0) { //代表文件夹
                    [folderArray addObject:documentModel];
                }else { //代表文件
                    [fileArray addObject:documentModel];
                }
            }
            self.departmentDocumentTV.folderArray = folderArray.copy;
            self.departmentDocumentTV.fileArray = fileArray.copy;
            
        } failed:^(NSError *error) {
            
            
        }];
        
    } failed:^(NSError *error) {
        
        
    }];
}

- (void)getPersonDataFromWebWithOrderType:(NSInteger)orderType
{
    //获得个人级别的文件列表
    [DocumentVM personGetDocumentListDataWithFolderId:self.folderId textKey:@"" pageIndex:1 pageSize:1000 orderType:orderType isasc:2 success:^(NSArray *documentListArray) {
        
        NSLog(@"获取个人级别的文件列表成功：%@", documentListArray);
        
        [self.personDocumentTV.mj_header endRefreshing];

        _startNum++;
        [self.personDocumentTV.documentListArray addObjectsFromArray:documentListArray];
        if (documentListArray.count > 0) {
            [self.personDocumentTV.mj_footer endRefreshing];
            
        }
        else {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.personDocumentTV.mj_footer endRefreshingWithNoMoreData];
            //            _tableView.mj_footer.automaticallyHidden = YES;
        }

        //根据传过来汇总的文档数据，按文件夹和文件两种类型进行分类
        NSMutableArray *folderArray = [NSMutableArray array];
        NSMutableArray *fileArray = [NSMutableArray array];
        for (DocumentMergeModel *documentModel in [DocumentMergeModel getModelArrayFromModelArray:self.personDocumentTV.documentListArray]) {
            if (documentModel.documentType == 0) { //代表文件夹
                [folderArray addObject:documentModel];
            }else { //代表文件
                [fileArray addObject:documentModel];
            }
        }
        self.personDocumentTV.folderArray = folderArray.copy;
        self.personDocumentTV.fileArray = fileArray.copy;
        
    } failed:^(NSError *error) {
        
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.folderName;
    
    [self setupBaseViewContent];
    
    [self setupNavigationItemContent];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    switch (self.displayDocumentType) {
        case 1:
            
            [self getCompanyDataFromWebWithOrderType:self.orderType];
            break;
            
        case 2:
            
            [self getDepartmentDataFromWebWithOrderType:self.orderType];
            break;
            
        case 3:
            
            [self getPersonDataFromWebWithOrderType:self.orderType];
            break;
    }
}


- (void)setupBaseViewContent
{
    //搜索栏
    UISearchBar *documentSearchView = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    [documentSearchView setBackgroundImage:[UIImage new]];
    documentSearchView.barTintColor = [UIColor colorWithHexString:@"#efeff4"];
    documentSearchView.placeholder = @"查找文档";
    documentSearchView.delegate = self;
    [self.view addSubview:documentSearchView];
    
    
    //tableView
    switch (self.displayDocumentType) {
        case 1: {
            [self.view addSubview:self.companyDocumentTV];
            // 下拉刷新
            _companyDocumentTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self refreshDoc];
            }];
            
            // 上拉刷新
            _companyDocumentTV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [self getCompanyDataFromWebWithOrderType:self.orderType];
            }];
            break;
        }
            

            
        case 2: {
            [self.view addSubview:self.departmentDocumentTV];
            // 下拉刷新
            _departmentDocumentTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self refreshDoc];
            }];
            
            // 上拉刷新
            _departmentDocumentTV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [self getDepartmentDataFromWebWithOrderType:self.orderType];
            }];
            break;
        }
            

            
        case 3: {
            [self.view addSubview:self.personDocumentTV];
            // 下拉刷新
            _personDocumentTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self refreshDoc];
            }];
            
            // 上拉刷新
            _personDocumentTV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [self getPersonDataFromWebWithOrderType:self.orderType];
            }];
            break;
        }
            

    }
    _startNum = 1;
    _orderType = 1;

}

// 数据刷新方法！！！
- (void)refreshDoc
{
    _startNum = 1;
    
    [_companyDocumentTV.documentListArray removeAllObjects];
    [_departmentDocumentTV.documentListArray removeAllObjects];
    [_personDocumentTV.documentListArray removeAllObjects];
    
    switch (self.displayDocumentType) {
        case 1:
            
            [self getCompanyDataFromWebWithOrderType:_orderType];
            break;
            
        case 2:
            
            [self getDepartmentDataFromWebWithOrderType:_orderType];
            break;
            
        case 3:
            
            [self getPersonDataFromWebWithOrderType:_orderType];
            break;
    }
}

- (void)setupNavigationItemContent
{
    [self setupMenuView];
    
    //右边的菜单按钮
    HSBlockButton *menuBtn = [HSBlockButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(10, 0, 40, 20);
    [menuBtn setImage:[UIImage imageNamed:@"more_white"] forState:UIControlStateNormal];
    [menuBtn addTouchUpInsideBlock:^(UIButton *button) {
        if (_coverView.hidden) {
            [_coverView setHidden:NO];
            [_nextView setHidden:NO];
        }else {
            [_coverView setHidden:YES];
            [_nextView setHidden:YES];
        }
        
    }];
    UIBarButtonItem *menuBarBtn = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    [self.navigationItem setRightBarButtonItem:menuBarBtn];
}

- (void)setupMenuView
{
    __weak typeof(self) weakSelf = self;
    
    //
    AppDelegate *appDelelgate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _coverView.hidden = YES;
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTheMenuViewAction)];
    [_coverView addGestureRecognizer:singleFingerTap];
    [appDelelgate.window addSubview:_coverView];
    
    //
    _nextView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width-120-10, 64.5, 120, 40*4+.5*3)];
    _nextView.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    _nextView.hidden = YES;
    [_coverView  addSubview:_nextView];
    
    //菜单项上面的按钮
    NSArray *menuNameArr = @[@"上传文件", @"新建文件夹", @"排序方式", @"传输列表"];
    //1.上传文件
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadBtn.frame = CGRectMake(0, 0, 120, 40);
    [uploadBtn setTitle:[menuNameArr objectAtIndex:0] forState:UIControlStateNormal];
    [uploadBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    uploadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [uploadBtn addTarget:self action:@selector(uploadBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_nextView addSubview:uploadBtn];
    
    //2.新建文件夹
    HSBlockButton *createFolderBtn = [HSBlockButton buttonWithType:UIButtonTypeCustom];
    createFolderBtn.frame = CGRectMake(0, 40.5, 120, 40);
    [createFolderBtn setTitle:[menuNameArr objectAtIndex:1] forState:UIControlStateNormal];
    [createFolderBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    createFolderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [createFolderBtn addTouchUpInsideBlock:^(UIButton *button) {
        
        //1.隐藏菜单界面
        [self performSelector:@selector(hideTheMenuViewAction)];
        
        //2.数据准备
        NSString *departmentId = weakSelf.departmentId;
        NSString *parantFolderId = weakSelf.folderId;
        NSString *folderPathStr = [weakSelf.folderAllPathArr componentsJoinedByString:@"\n>"];
        
        //3.显示新建文件夹界面
        CreateDocumentFolderViewController *createDocumentFolderVC = [[CreateDocumentFolderViewController alloc] init];
        createDocumentFolderVC.departmentPlaceId = departmentId;
        createDocumentFolderVC.folderPlaceId = parantFolderId;
        createDocumentFolderVC.originFolderPath = folderPathStr;
        UINavigationController *createDocumentFolderNVC = [[UINavigationController alloc] initWithRootViewController:createDocumentFolderVC];
        createDocumentFolderNVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        createDocumentFolderNVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [weakSelf presentViewController:createDocumentFolderNVC animated:YES completion:nil];
    }];
    [_nextView addSubview:createFolderBtn];
    
    //3.排序方式(sortBtnAction:)
    UIButton *sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sortBtn.frame = CGRectMake(0, 81, 120, 40);
    [sortBtn setTitle:[menuNameArr objectAtIndex:2] forState:UIControlStateNormal];
    [sortBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    sortBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sortBtn addTarget:self action:@selector(sortBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_nextView addSubview:sortBtn];
    
    //4.传输列表
    HSBlockButton *transListBtn = [HSBlockButton buttonWithType:UIButtonTypeCustom];
    transListBtn.frame = CGRectMake(0, 121.5, 120, 40);
    [transListBtn setTitle:[menuNameArr objectAtIndex:3] forState:UIControlStateNormal];
    [transListBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    transListBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [transListBtn addTouchUpInsideBlock:^(UIButton *button) {
        //1.隐藏菜单界面
        [self performSelector:@selector(hideTheMenuViewAction)];
        //2.push出传输列表VC
        TransportDocumentViewController *transportDocumentVC = [[TransportDocumentViewController alloc] init];
        [self.navigationController pushViewController:transportDocumentVC animated:YES];
    }];
    [_nextView addSubview:transListBtn];
    
    //菜单项上的分隔线
    for (int i = 0; i < menuNameArr.count - 1; i ++) {
        UIView *separationLine = [[UIView alloc] initWithFrame:CGRectMake(15, (40.5+40*i), 90, 0.5)];
        separationLine.backgroundColor = [UIColor whiteColor];
        [_nextView addSubview:separationLine];
    }
    
}

- (void)hideTheMenuViewAction
{
    [_coverView setHidden:YES];
    [_nextView setHidden:YES];
}

#pragma buttonAction

//1.上传文件
- (void) uploadBtnAction
{
    //1.隐藏菜单界面
    [self performSelector:@selector(hideTheMenuViewAction)];
    
    //2.数据准备
    NSString *departmentId = self.departmentId;
    NSString *parantFolderId = self.folderId;
    NSString *folderPathStr = [self.folderAllPathArr componentsJoinedByString:@">"];
    
    //3.显示上传的文件类型VC
    FileTypeVC *vc  = [[FileTypeVC alloc] init];
    vc.departmentPlaceId = departmentId;
    vc.folderPlaceId = parantFolderId;
    vc.originFolderPath = folderPathStr;
    vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.9];
    [self presentViewController:vc animated:YES completion:nil];
}

//3.排序方式
- (void)sortBtnAction:(UIButton *)btn
{
    //1.隐藏菜单界面
    [self performSelector:@selector(hideTheMenuViewAction)];
    
    //2.显示alertVC
    __weak typeof(self)weakSelf = self;
    
    self.alertVC = [[AlertViewVC alloc] init];
    
    [self.alertVC addAlertMessageWithAlertName:@"按名称排序" andEventBlock:^{
        
        weakSelf.orderType = 2;
        switch (weakSelf.displayDocumentType) {
            case 1:
                
                [weakSelf getCompanyDataFromWebWithOrderType:weakSelf.orderType];
                break;
                
            case 2:
                
                [weakSelf getDepartmentDataFromWebWithOrderType:weakSelf.orderType];
                break;
                
            case 3:
                
                [weakSelf getPersonDataFromWebWithOrderType:weakSelf.orderType];
                break;
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.alertVC addAlertMessageWithAlertName:@"按时间排序" andEventBlock:^{
        weakSelf.orderType = 1;

        switch (weakSelf.displayDocumentType) {
            case 1:
                
                [weakSelf getCompanyDataFromWebWithOrderType:weakSelf.orderType];
                break;
                
            case 2:
                
                [weakSelf getDepartmentDataFromWebWithOrderType:weakSelf.orderType];
                break;
                
            case 3:
                
                [weakSelf getPersonDataFromWebWithOrderType:weakSelf.orderType];
                break;
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.alertVC addAlertMessageWithAlertName:@"按类型排序" andEventBlock:^{
        weakSelf.orderType = 3;

        switch (weakSelf.displayDocumentType) {
            case 1:
                
                [weakSelf getCompanyDataFromWebWithOrderType:weakSelf.orderType];
                break;
                
            case 2:
                [weakSelf getDepartmentDataFromWebWithOrderType:weakSelf.orderType];

                 break;
                
            case 3:
                
                [weakSelf getPersonDataFromWebWithOrderType:weakSelf.orderType];
                break;
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.alertVC addAlertMessageWithAlertName:@"取消" andEventBlock:^{
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    self.alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.alertVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:self.alertVC animated:YES completion:nil];
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    SearchFileVC *vc = [[SearchFileVC alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
    
}

@end


