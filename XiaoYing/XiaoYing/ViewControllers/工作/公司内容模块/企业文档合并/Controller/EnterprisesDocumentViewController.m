//
//  EnterprisesDocumentViewController.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/5.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "EnterprisesDocumentViewController.h"
#import "XYExtend.h"
#import "AlertViewVC.h"
#import "CompanyDocumentTableView.h"
#import "DepartmentDocumentTableView.h"
#import "PersonDocumentTableView.h"
#import "LocalDocumentTableView.h"
#import "CreateDocumentFolderViewController.h"
#import "ZFDownloadManager.h"
#import "FileTypeVC.h"
#import "FileOperateVC.h"

#import "TransportDocumentViewController.h"

#import "DocumentVM.h"
#import "DocumentMergeModel.h"

#import "EmployeeViewModel.h"
#import "SearchFileVC.h"

#define LimitNum 10


@interface EnterprisesDocumentViewController ()<UIScrollViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UIView *categoryBtnView;

@property (nonatomic, strong) UIButton *companyCategoryBtn;
@property (nonatomic, strong) UIButton *departmentCategoryBtn;
@property (nonatomic, strong) UIButton *personCategoryBtn;
@property (nonatomic, strong) UIButton *localCategoryBtn;

@property (nonatomic, strong) UIImageView *redLineView;

@property (nonatomic, strong) UIScrollView *baseScrollView;

@property (nonatomic, strong) CompanyDocumentTableView *companyDocumentTV;
@property (nonatomic, strong) DepartmentDocumentTableView *departmentDocumentTV;
@property (nonatomic, strong) PersonDocumentTableView *personDocumentTV;
@property (nonatomic, strong) LocalDocumentTableView *localDocumentTV;

@property (nonatomic, strong) AlertViewVC *alertVC; //推出的Alertview
@property (nonatomic, strong) UISearchBar *documentSearchView;

@property (nonatomic, assign) NSInteger companyStartNum;
@property (nonatomic, assign) NSInteger departmentStartNum;
@property (nonatomic, assign) NSInteger personStartNum;

@property (nonatomic, assign) NSInteger orderType;


@end

@implementation EnterprisesDocumentViewController
{
    UIView *_coverView;//展开下拉框后的覆盖视图
    UIView *_nextView;//下拉框
}

- (CompanyDocumentTableView *)companyDocumentTV
{
    if (!_companyDocumentTV) {
        _companyDocumentTV = [[CompanyDocumentTableView alloc] initWithFrame:CGRectMake(kScreen_Width * 0, 0, kScreen_Width, kScreen_Height - 90 - 64) style:UITableViewStylePlain];
    }
    return _companyDocumentTV;
}

- (DepartmentDocumentTableView *)departmentDocumentTV
{
    if (!_departmentDocumentTV) {
        _departmentDocumentTV = [[DepartmentDocumentTableView alloc] initWithFrame:CGRectMake(kScreen_Width * 1, 0, kScreen_Width, kScreen_Height - 90 - 64) style:UITableViewStylePlain];
    }
    return _departmentDocumentTV;
}

- (PersonDocumentTableView *)personDocumentTV
{
    if (!_personDocumentTV) {
        _personDocumentTV = [[PersonDocumentTableView alloc] initWithFrame:CGRectMake(kScreen_Width * 2, 0, kScreen_Width, kScreen_Height - 90 - 64) style:UITableViewStylePlain];
    }
    return _personDocumentTV;
}

- (LocalDocumentTableView *)localDocumentTV
{
    if (!_localDocumentTV) {
        _localDocumentTV = [[LocalDocumentTableView alloc] initWithFrame:CGRectMake(kScreen_Width * 3, 0, kScreen_Width, kScreen_Height - 90 - 64) style:UITableViewStylePlain];
    }
    return _localDocumentTV;
}

- (void)getDataFromWebWithOrderType:(NSInteger)orderType
{
    [self getCompanyFileWithOrderType:orderType];
    [self getDepartmentFileWithOrderType:orderType];
    [self getpersonFileWithOrderType:orderType];
    
    
    //本地数据
    self.localDocumentTV.downloadedArray = [ZFDownloadManager sharedInstance].downloadedArray;
}

//获得公司级别的文件列表
- (void)getCompanyFileWithOrderType:(NSInteger)orderType
{
    //获得公司级别的文件列表
    [DocumentVM getDocumentListDataWithFolderId:@"" departmentIds:@"" textKey:@"" pageIndex:_companyStartNum pageSize:LimitNum orderType:orderType isasc:2 success:^(NSArray *documentListArray) {
        
        [_companyDocumentTV.mj_header endRefreshing];

        NSLog(@"获取公司级别的文件列表成功：%@", documentListArray);
        _companyStartNum++;
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
        self.companyDocumentTV.folderArray = folderArray;
        self.companyDocumentTV.fileArray = fileArray;
        
        
    } failed:^(NSError *error) {
        
        
    }];
}

//获得部门级别的文件列表
- (void)getDepartmentFileWithOrderType:(NSInteger)orderType
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
        
        if (tempDepartmentIdArr.count > 0) {
            NSString *departmentIdsStr = [tempDepartmentIdArr componentsJoinedByString:@","];
            
            
            //2.
            [DocumentVM getDocumentListDataWithFolderId:@"" departmentIds:departmentIdsStr textKey:@"" pageIndex:_departmentStartNum pageSize:LimitNum orderType:orderType isasc:2 success:^(NSArray *documentListArray) {
                
                [self.departmentDocumentTV.mj_header endRefreshing];
                NSLog(@"获取部门级别的文件列表成功：%@", documentListArray);
                
                _departmentStartNum++;
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
                self.departmentDocumentTV.folderArray = folderArray;
                self.departmentDocumentTV.fileArray = fileArray;
                
            } failed:^(NSError *error) {
                
                
            }];
        }
        
        
    } failed:^(NSError *error) {
        
        
    }];

}

//获得个人级别的文件列表
- (void)getpersonFileWithOrderType:(NSInteger)orderType
{
    //获得个人级别的文件列表
    [DocumentVM personGetDocumentListDataWithFolderId:@"" textKey:@"" pageIndex:_personStartNum pageSize:LimitNum orderType:orderType isasc:2 success:^(NSArray *documentListArray) {
        
        [self.personDocumentTV.mj_header endRefreshing];
        NSLog(@"获取个人级别的文件列表成功：%@", documentListArray);
        
        _personStartNum++;
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
        self.personDocumentTV.folderArray = folderArray;
        self.personDocumentTV.fileArray = fileArray;
        
    } failed:^(NSError *error) {
        
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //默认显示
    self.navigationItem.title = @"公司文档";
    
    [self setupBaseViewContent];
    
    [self setupNavigationItemContent];
    
    // 这里是全部刷新(公司、部门、个人），可优化！！！
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDoc) name:@"kRefreshDocNotification" object:nil];
    
    //刷新本地数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downedRefersh) name:@"kDownloadNotification" object:nil];
    
    //排序类型
    _orderType = 1;
    
    // 下拉刷新
    _companyDocumentTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshDoc];
    }];
    
    // 上拉刷新
    _companyDocumentTV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getCompanyFileWithOrderType:_orderType];
    }];
    _companyStartNum = 1;
    
    // 下拉刷新
    _departmentDocumentTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshDoc];
    }];
    
    // 上拉刷新
    _departmentDocumentTV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getDepartmentFileWithOrderType:_orderType];
    }];
    _departmentStartNum = 1;
//    
    // 下拉刷新
    _personDocumentTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshDoc];
    }];
    
    // 上拉刷新
    _personDocumentTV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getpersonFileWithOrderType:_orderType];
    }];
    _personStartNum = 1;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self getDataFromWebWithOrderType:1];
    [self refreshDoc];


}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.documentSearchView resignFirstResponder];
}


- (void)downedRefersh {
    self.localDocumentTV.downloadedArray = [ZFDownloadManager sharedInstance].downloadedArray;
//    [self.localDocumentTV reloadData];
}


// 数据刷新通知调用方法！！！
- (void)refreshDoc
{
    _companyStartNum = 1;
    _departmentStartNum = 1;
    _personStartNum = 1;
    
    [_companyDocumentTV.documentListArray removeAllObjects];
    [_departmentDocumentTV.documentListArray removeAllObjects];
    [_personDocumentTV.documentListArray removeAllObjects];
    
    [self getDataFromWebWithOrderType:_orderType];

}


- (void)setupBaseViewContent
{
    NSArray *categaryNameArr = @[@"公司", @"部门", @"个人", @"本地"];
    
    CGFloat gap = 37;
    CGFloat with = (kScreen_Width - gap * (categaryNameArr.count + 1)) / categaryNameArr.count;
    CGFloat high = 40;
    
    //放置分类按钮的view
    self.categoryBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
    self.categoryBtnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.categoryBtnView];
    
    //‘公司’按钮
    self.companyCategoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.companyCategoryBtn.frame = CGRectMake(gap*1 + with*0, 0, with, high);
    self.companyCategoryBtn.backgroundColor = [UIColor  whiteColor];
    [self.companyCategoryBtn setTitle:[categaryNameArr objectAtIndex:0] forState:UIControlStateNormal];
    [self.companyCategoryBtn setSelected:YES];
    [self.companyCategoryBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [self.companyCategoryBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateSelected];
    self.companyCategoryBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.companyCategoryBtn addTarget:self action:@selector(categoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryBtnView addSubview:self.companyCategoryBtn];
    
    //‘部门’按钮
    self.departmentCategoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.departmentCategoryBtn.frame = CGRectMake(gap*2 + with*1, 0, with, high);
    self.departmentCategoryBtn.backgroundColor = [UIColor  whiteColor];
    [self.departmentCategoryBtn setTitle:[categaryNameArr objectAtIndex:1] forState:UIControlStateNormal];
    [self.departmentCategoryBtn setSelected:NO];
    [self.departmentCategoryBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [self.departmentCategoryBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateSelected];
    self.departmentCategoryBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.departmentCategoryBtn addTarget:self action:@selector(categoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryBtnView addSubview:self.departmentCategoryBtn];
    
    //‘个人’按钮
    self.personCategoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.personCategoryBtn.frame = CGRectMake(gap*3 + with*2, 0, with, high);
    self.personCategoryBtn.backgroundColor = [UIColor  whiteColor];
    [self.personCategoryBtn setTitle:[categaryNameArr objectAtIndex:2] forState:UIControlStateNormal];
    [self.personCategoryBtn setSelected:NO];
    [self.personCategoryBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [self.personCategoryBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateSelected];
    self.personCategoryBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.personCategoryBtn addTarget:self action:@selector(categoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryBtnView addSubview:self.personCategoryBtn];
    
    //‘本地’按钮
    self.localCategoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.localCategoryBtn.frame = CGRectMake(gap*4 + with*3, 0, with, high);
    self.localCategoryBtn.backgroundColor = [UIColor  whiteColor];
    [self.localCategoryBtn setTitle:[categaryNameArr objectAtIndex:3] forState:UIControlStateNormal];
    [self.localCategoryBtn setSelected:NO];
    [self.localCategoryBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [self.localCategoryBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateSelected];
    self.localCategoryBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.localCategoryBtn addTarget:self action:@selector(categoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryBtnView addSubview:self.localCategoryBtn];
    
    //红色一条线
    self.redLineView = [[UIImageView alloc] initWithFrame:CGRectMake(gap, self.companyCategoryBtn.bottom - 2, with, 2)];
    self.redLineView.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [self.categoryBtnView addSubview:self.redLineView];
    
    //搜索栏
    UISearchBar *documentSearchView = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 40, kScreen_Width, 50)];
    [documentSearchView setBackgroundImage:[UIImage new]];
    documentSearchView.barTintColor = [UIColor colorWithHexString:@"#efeff4"];
    documentSearchView.placeholder = @"查找文档";
    documentSearchView.delegate = self;
    [self.view addSubview:documentSearchView];
    self.documentSearchView = documentSearchView;
    
    //scrollView
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90, kScreen_Width, kScreen_Height - 90 - 64)];
    self.baseScrollView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.baseScrollView.delegate = self;
    self.baseScrollView.contentSize = CGSizeMake(kScreen_Width * 4 , kScreen_Height - 90 - 64);
    self.baseScrollView.pagingEnabled = YES;
    self.baseScrollView.showsVerticalScrollIndicator = NO;
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    self.baseScrollView.bounces = NO;//取消弹簧效果
    [self.view addSubview:self.baseScrollView];
    
    //tableViews
    [self.baseScrollView addSubview:self.companyDocumentTV];
    [self.baseScrollView addSubview:self.departmentDocumentTV];
    [self.baseScrollView addSubview:self.personDocumentTV];
    [self.baseScrollView addSubview:self.localDocumentTV];
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
        NSString *departmentId = [[NSString alloc] init];
        NSString *parantFolderId = [[NSString alloc] init];
        NSString *folderPathStr = [[NSString alloc] init];
            
        if (weakSelf.companyCategoryBtn.selected) {
            departmentId = @"";
            parantFolderId = @"";
            folderPathStr = [NSString stringWithFormat:@"%@>根目录",[UserInfo getcompanyName]];
            
        } else if (weakSelf.departmentCategoryBtn.selected) {
            departmentId = @"";
            parantFolderId = @"";
            folderPathStr = @"";
            
        } else if (weakSelf.personCategoryBtn.selected) {
            departmentId = @" "; //用@" "与公司的@""相区别
            parantFolderId = @"";
            folderPathStr = @"个人>根目录";
        
        } else {
            departmentId = @"";
            parantFolderId = @"";
            folderPathStr = @"";
            
        }
        
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
- (void)categoryBtnAction:(UIButton *)btn
{
    //改变导航栏上的title
    self.navigationItem.title = [NSString stringWithFormat:@"%@文档", btn.titleLabel.text];
    
    //按钮字体颜色的变化
    [self.companyCategoryBtn setSelected:NO];
    [self.departmentCategoryBtn setSelected:NO];
    [self.personCategoryBtn setSelected:NO];
    [self.localCategoryBtn setSelected:NO];
    
    [btn setSelected:YES];
    
    //_____Animation
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    //改变红线的位置
    [self.redLineView setFrame:CGRectMake(btn.left, btn.bottom - 2, btn.width, 2)];
    
    //改变scroll的内容偏移
    CGFloat offsetX = [@[@"公司", @"部门", @"个人", @"本地"] indexOfObject:btn.titleLabel.text] * kScreen_Width;
    self.baseScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    [UIView commitAnimations];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.baseScrollView) {//只有当scrollView不是tableView才会触发下面的方法
        //根据偏移量计算页码
        NSUInteger page = scrollView.contentOffset.x / kScreen_Width;
        
        switch (page) {
            case 0:
                [self categoryBtnAction:self.companyCategoryBtn];
                break;
            
            case 1:
                [self categoryBtnAction:self.departmentCategoryBtn];
                break;
                
            case 2:
                [self categoryBtnAction:self.personCategoryBtn];
                break;
                
            case 3:
                [self categoryBtnAction:self.localCategoryBtn];
                break;
        }//endswitch
        
    }//endif
}

#pragma buttonAction

//1.上传文件
- (void) uploadBtnAction
{
    //1.隐藏菜单界面
    [self performSelector:@selector(hideTheMenuViewAction)];
    
    //2.数据准备
    NSString *departmentId = [[NSString alloc] init];
    NSString *parantFolderId = [[NSString alloc] init];
    NSString *folderPathStr = [[NSString alloc] init];
    
    if (self.companyCategoryBtn.selected) {
        departmentId = @"";
        parantFolderId = @"";
        folderPathStr = [NSString stringWithFormat:@"%@>根目录",[UserInfo getcompanyName]];
        
    } else if (self.departmentCategoryBtn.selected) {
        departmentId = @"";
        parantFolderId = @"";
        folderPathStr = @"";
        
    } else if (self.personCategoryBtn.selected) {
        departmentId = @" "; //用@" "与公司的@""相区别
        parantFolderId = @"";
        folderPathStr = @"个人>根目录";
        
    } else {
        departmentId = @"";
        parantFolderId = @"";
        folderPathStr = @"";
        
    }
    
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
        
        _orderType = 2;
//        [weakSelf getDataFromWebWithOrderType:2];
        [weakSelf refreshDoc];

        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.alertVC addAlertMessageWithAlertName:@"按时间排序" andEventBlock:^{
        
        _orderType = 1;
        [weakSelf refreshDoc];
//        [weakSelf getDataFromWebWithOrderType:1];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.alertVC addAlertMessageWithAlertName:@"按类型排序" andEventBlock:^{
        _orderType = 3;
        [weakSelf refreshDoc];
//        [weakSelf getDataFromWebWithOrderType:3];
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
    vc.type = self.navigationItem.title;
    [self presentViewController:vc animated:NO completion:nil];
    
}

@end
