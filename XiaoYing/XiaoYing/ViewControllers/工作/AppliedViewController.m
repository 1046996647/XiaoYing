//
//  AppliedViewController.m
//  XiaoYing
//
//  Created by MengFanBiao on 15/10/21.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "AppliedViewController.h"
#import "UserInfo.h"
#import "WorkHead.h"
#import "ApprovalManageVC.h"
#import "ApplyForJoinTheCompanyModel.h"
#import "AttendanceVC.h"
#import "FinancialAffairsVC.h"
#import "CompanyFileController.h"
#import "ApplyVC.h"
#import "DelegateViewController.h"
#import "JoinInTheCompany.h"
#import "DropDownView.h"
#import "HeadViewOfWork.h"
#import "CreateMyCompanyView.h"
#import "JoinTheCompanyView.h"
#import "ManagerOperateVC.h"
#import "ApplyVoucherViewController.h"
#import "PushViewOfSecretManageView.h"
#import "RCIM.h"
#import "CustomKnownView.h"
#import "PermissionOfWork.h"
#import "EnterprisesDocumentViewController.h"//企业文档-合并版

@interface AppliedViewController ()<DropDownViewDelegate, CustomKnownViewDelegate>
{
    //当已经加入公司的时候
    UICollectionView *workCollection;
    NSArray *_arrData;
    AppDelegate *app;
    UIPageControl *pageControl;
}
@property (nonatomic,strong) NSString *havePermission;  //区分考勤里边的考勤管理，是否有这个权限
@property (nonatomic,strong) CustomKnownView *costomVC;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) CreateMyCompanyView *createVC;
@property (nonatomic,strong) MoreViewController *moreViewController;/**<更多界面控制器*/
@property (nonatomic,strong) WJXCollectionView *collectionView;/**<九宫格collectionview*/
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) UILabel *SwipeLab;
@property (nonatomic,strong) NSMutableArray *permissionArray;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) NSString *tempDepartment;
@property (nonatomic,strong) UISwipeGestureRecognizer *UpSW;
@property (nonatomic,strong) UISwipeGestureRecognizer *DownSW;
@property (nonatomic,strong) UIButton *leftB;
@property (nonatomic,strong) DropDownView *dropView;
@property (nonatomic,strong) HeadViewOfWork *headView;
@property (nonatomic)BOOL isSelected;
@property (nonatomic)BOOL isJointheCompany;
@end

@implementation AppliedViewController

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_isSelected == YES) {
        [self removeTempView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabvc showCustomTabbar];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString  :@"#efeff4"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    NSMutableArray *array = [ZWLCacheData unarchiveObjectWithFile:PermissionsPath];
    if (array.count > 0) {
        self.navigationItem.title = [UserInfo getcompanyName];
        [self initUI];
        //权限
        [self parserPermissionsNetData:array];
    }else {
        [self getdata];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(switchCompanyAction:) name:@"RefreshHeadView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getdata) name:@"GoBackOfCreateCompany" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeCompanyName) name:@"ChangeCompanyName" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(HaveCompanyApply) name:@"RefershTabelViewOfApply" object:nil];
    
    // 老同事辞职了
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(studentJoinOrLeaveAction:) name:kColleagueLeaveNotification object:nil];
    
    // 新同事加入了部门
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(studentJoinOrLeaveAction:) name:kColleagueJoinNotification object:nil];
    
    // 企业架构更新了！
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(departmentMessageChange) name:kDepartmentRefreshNotification object:nil];
    
    // 企业员工变化了！
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(employeeMessageChange) name:kEmployeeRefreshNotification object:nil];
    
    //监听是否退出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeNotification) name:@"StartExit" object:nil];
}


#pragma mark --加入公司或者离职之后--(可能会出现问题)
- (void)studentJoinOrLeaveAction:(NSNotification *)not {
    
    _costomVC = [[CustomKnownView alloc] init];
    _costomVC.delegate = self;
    _costomVC.dic = not.object;
    [self.view addSubview:_costomVC];
}

- (void)removeCustonViewFromSuperView {
    [_costomVC.littleView removeFromSuperview];
    [_costomVC.coverView removeFromSuperview];
    [_costomVC removeFromSuperview];
    _costomVC = nil;
}

- (void)referBehindResign{
    [self removeCustonViewFromSuperView];
    for (UIView *view in self.view.subviews) {
        if ([view isEqual: _createVC]) {
            [_createVC removeFromSuperview];
        }
    }
    _isJointheCompany = YES;
    [self getdata];
}

- (void)ChangeCompanyName {
    self.navigationItem.title = [UserInfo getcompanyName];
    [self GetDetailofMyBusinessCardAction];
}

- (void)initUI {
    _leftB = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftB setImage:[UIImage imageNamed:@"in"] forState:UIControlStateNormal];
    _leftB.frame = CGRectMake(0, 0, 30, 30);
    _leftB.tag = 102;
    [_leftB addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBa = [[UIBarButtonItem alloc] initWithCustomView:_leftB];
    [self.navigationItem setLeftBarButtonItem:leftBa];
    
    UIButton *rightB = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightB setImage:[UIImage imageNamed:@"change"] forState:UIControlStateNormal];
    rightB.frame = CGRectMake(0, 0, 30, 30);
    rightB.tag = 103;
    [rightB addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBa = [[UIBarButtonItem alloc] initWithCustomView:rightB];
    [self.navigationItem setRightBarButtonItem:rightBa];
    
    if (!_headView) {
        _headView = [[HeadViewOfWork alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 156)];
        _headView.mark = 1;
    }
    [self.view addSubview:_headView];
}

//右上角按钮点击事件
- (void)btnAction:(UIButton *)btn {
    
    if (btn.tag == 102) {
        JoinInTheCompany *joinInTheCompany = [[JoinInTheCompany alloc]init];
        [self.navigationController pushViewController:joinInTheCompany animated:YES];
        return;
    }
    if (btn.tag == 103) {
        if (_isSelected == NO) {
            _dropView = [[DropDownView alloc]initWithFrame:self.view.bounds];
            _dropView.delegate = self;
            __block AppliedViewController *appliedVC = self;
            _dropView.blockValue = ^(NSString *str) {
                btn.userInteractionEnabled = YES;
                if ([str isEqualToString:@"failed"]) {
                    [appliedVC removeTempView];
                }
            };
            [self.view addSubview:_dropView];
            btn.userInteractionEnabled = NO;
            _isSelected = YES;
        }else {
            [self removeTempView];
        }
    }
}


- (void)removeTempView {
    [_dropView.tableView removeFromSuperview];
    [_dropView.coverView removeFromSuperview];
    [_dropView removeFromSuperview];
    _dropView = nil;
    _isSelected = NO;
}

- (void)switchCompanyAction:(NSNotification *)not {
    NSMutableArray *array = not.object;
    _isJointheCompany = YES;
    [self refershWorkPageWithSwitchCompany:array];
}

//更新工作界面内容
- (void)refershWorkPageWithSwitchCompany:(NSMutableArray *)array {
    //更新权限
    [self parserPermissionsNetData:array];
    //更新名片
    [self GetDetailofMyBusinessCardAction];
}

- (void)GetDetailofMyBusinessCardAction {
    [AFNetClient GET_Path:GetDetailofMyBusinessCard completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            [MBProgressHUD showMessage:[JSONDict objectForKey:@"Message"] toView:self.view];
        } else {
            [self paraserNetData:JSONDict];
        }
    } failed:^(NSError *error) {
        
        [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
    }];
    // 缓存组织架构和员工信息
    [self GetDepartmentURlAction:0];
}

- (void)paraserNetData:(id)responder {
    
    NSMutableDictionary *dic = responder[@"Data"];
    if (![dic[@"FaceUrl"] isKindOfClass:[NSNull class]]) {
        NSString *iconStr = [NSString replaceString:dic[@"FaceUrl"] Withstr1:@"100" str2:@"100" str3:@"c"];
        [_headView.imageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"LOGO"]];
        [UserInfo saveFaceURLOfCard:iconStr];
    }else {
        [UserInfo saveFaceURLOfCard:nil];
    }
    if (![dic[@"Name"] isKindOfClass:[NSNull class]]) {
        _headView.label.text = dic[@"Name"];
        [UserInfo saveNameOfCard:dic[@"Name"]];
    }else {
        [UserInfo saveNameOfCard:@""];
    }
    NSMutableArray *array = dic[@"Jobs"];
    if (array.count > 0) {
        for (NSMutableDictionary *dic in array) {
            if ([dic[@"IsMastJob"]  isEqual: @1]) {
                if (![dic[@"DepartmentName"] isKindOfClass:[NSNull class]]) {
                    _headView.label2.text = dic[@"DepartmentName"];
                    [UserInfo saveDepartmentOfCard:dic[@"DepartmentName"]];
                }else {
                    _headView.label2.text = [UserInfo getcompanyName];
                    [UserInfo saveDepartmentOfCard:[UserInfo getcompanyName]];
                }
                if (![dic[@"JobName"] isKindOfClass:[NSNull class]]) {
                    _headView.label3.text = dic[@"JobName"];
                    [UserInfo savePositionOfCard:dic[@"JobName"]];
                }else {
                    [UserInfo savePositionOfCard:@""];
                }
            }
        }
    }
}

-(void)getdata{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    //    _hud.labelText = @"加载中...";
    [AFNetClient GET_Path:ListOfMyCompanyURl completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if (![JSONDict[@"Data"] isKindOfClass:[NSNull class]]) {
            [self parserNetData:JSONDict];
            [UserInfo saveJoinCompany_YesOrNo:[NSString stringWithFormat:@"%@",code]];
            [self initUI];
            
            [_collectionView.mj_header endRefreshing];
        }else {
            [AFNetClient POST_Path:ListOfCompanyURl completed:^(NSData *stringData, id JSONDict) {
                NSNumber *code=[JSONDict objectForKey:@"Code"];
                
                if ([code isEqual:@0]) {
                    NSMutableArray *array = JSONDict[@"Data"];
                    self.navigationItem.leftBarButtonItem = nil;
                    self.navigationItem.rightBarButtonItem = nil;
                    if (array.count > 0) {
                        //没加入公司，但有申请列表的情况
                        [self HaveCompanyApply];
                    }else {
                        //没加入公司，也没有申请列表的情况
                        [self NOTHaveCompanyApply];
                    }
                    [self removeHUDAction];
                }
            } failed:^(NSError *error) {
                [self removeHUDAction];
                NSLog(@"---->>>>>%@",error);
            }];
        }
    } failed:^(NSError *error) {
        [self removeHUDAction];
        NSLog(@"error： %@",error);
    }];
}

//没加入公司，但有申请列表的情况
- (void)HaveCompanyApply {
    self.navigationItem.title = @"工作";
    if (_createVC == nil) {
        _createVC = [[CreateMyCompanyView alloc]initWithFrame:self.view.bounds];
    }
    _createVC.joinVC.frame = CGRectMake(12, _createVC.backView.top + 10, kScreen_Width - 24, kScreen_Height - _createVC.backView.top - 64 - 59);
    [self.view addSubview:_createVC];
    [UserInfo saveJoinCompany_YesOrNo:@"1"];
    
}

//没加入公司，也没有申请列表的情况
- (void)NOTHaveCompanyApply {
    self.navigationItem.title = @"工作";
    if (_createVC == nil) {
        _createVC = [[CreateMyCompanyView alloc]initWithFrame:self.view.bounds];
    }
    _createVC.joinVC.hidden = YES;
    [self.view addSubview:_createVC];
    [UserInfo saveJoinCompany_YesOrNo:@"1"];
}

- (void)parserNetData:(id)respond {
    NSMutableArray *array = respond[@"Data"];
    NSMutableDictionary *targetDic = nil;
    for (NSMutableDictionary *dic in array) {
        //有默认当前公司
        if ([dic[@"LastEnter"] isEqual:@1]) {
            targetDic = dic;
            break;
        }
    }
    if (targetDic == NULL) {
        targetDic = [array firstObject];
    }
    //找到当前公司，切换公司获取功能列表
    [self getFunctionWithSwitchCompanyAction:targetDic[@"CompanyCode"]];
    
    [UserInfo saveCompanyId:targetDic[@"CompanyCode"]];
    [UserInfo savecompanyName:targetDic[@"CompanyName"]];
    [UserInfo saveUserRole:targetDic[@"Role"]];
    self.navigationItem.title = targetDic[@"CompanyName"];
    
    //公司最高领导人
    [UserInfo saveTopLeaderOfCompany:targetDic[@"AdminProfileId"]];
}


// 切换公司,获取功能列表
- (void)getFunctionWithSwitchCompanyAction:(NSString *)companyID {
    NSString *strURL = [SwitchCompany stringByAppendingFormat:@"&TargetCompanyId=%@", companyID];
    [AFNetClient  POST_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0]) {
            NSMutableArray *array = JSONDict[@"Data"];
            [ZWLCacheData archiveObject:array toFile:PermissionsPath];
            //更新工作界面内容
            [self refershWorkPageWithSwitchCompany:array];
            
        }else {
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
        }
    } failed:^(NSError *error) {
    }];
}

- (void)parserPermissionsNetData:(NSMutableArray *)array{
    _permissionArray = [NSMutableArray array];
    for (NSMutableDictionary *dic in array) {
        PermissionOfWork *model = [[PermissionOfWork alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        if ([model.ParentID isEqualToString:@""]) {
            [_permissionArray addObject:model];
        }
        if ([model.Name isEqualToString:@"考勤管理"] && [model.Enable isEqual:@1]) {
            _havePermission = @"havePermission";
        }
    }
    [self initTableview:nil];
}


-(void)initTableview:(NSString *)newUser{
    [self removeHUDAction];
    if (_isJointheCompany == YES) {
        _collectionView.PermissionsArray = _permissionArray;
        [_collectionView reloadData];
        _isJointheCompany = NO;
        return;
    }
    if (_collectionView == nil) {
        
        NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"mainGrid.plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:filepath];
        
        if (array == nil) {
            NSString *filepath = [[NSBundle mainBundle] pathForResource:@"mainGrid.plist" ofType:nil];
            array = [NSArray arrayWithContentsOfFile:filepath];
        }
        
        _dataArray = array.mutableCopy;
        CGRect frame = CGRectMake(0, 156, kScreenWidth,kScreenHeight-64-49-156);
        
        _collectionView = [MoveCollectionHandle MoveCollectionHandle:self withView:self.view withData:_dataArray withFrame:
                           frame numOfItems:4  OperateType:DemonOperateTypeDelete  DelectBtnBlock:^(NSIndexPath *indexPath)
                           {
                               NSDictionary *dic = _dataArray[indexPath.row];
                               self.moreViewController.Datadic = dic;
                               [_dataArray removeObjectAtIndex:indexPath.row];
                               [_dataArray writeToFile:filepath atomically:YES];
                           } moveEndBlock:^(NSIndexPath *beginIndex, NSIndexPath *endIndex)
                           {
                               id dataModel = _dataArray[beginIndex.row];
                               [_dataArray removeObjectAtIndex:beginIndex.row];
                               [_dataArray insertObject:dataModel atIndex:endIndex.row];
                               [_dataArray writeToFile:filepath atomically:YES];
                           } selectedBtnBlock:^(NSIndexPath *selectedIndex, NSString *selectTitle)
                           {
                               if (selectedIndex.row == _dataArray.count-1)
                               {
                                   __block typeof(self)blockSelf = self;
                                   self.moreViewController.addBlock = ^(NSDictionary *addDictionary){
                                       [blockSelf.dataArray insertObject:addDictionary atIndex:_dataArray.count-1];
                                       [blockSelf.dataArray writeToFile:filepath atomically:YES];
                                   };
                                   
                                   [self.navigationController pushViewController:self.moreViewController animated:YES];
                                   return ;
                               }
                               else
                               {
                                   //跳转
                                   if (selectTitle != nil) {
                                       [self jumpNext:selectTitle];
                                   }else {
                                       [MBProgressHUD showMessage:@"您无权使用" toView:self.view];
                                   }
                               }
                               _collectionView.PermissionsArray = _permissionArray;
                               _collectionView.alwaysBounceVertical = YES;
                               _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
                           }];
        //下拉加载
        __block AppliedViewController *appView = self;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _isJointheCompany = YES;
            [appView getFunctionWithSwitchCompanyAction:[UserInfo getCompanyId]];
        }];
        [_collectionView.mj_header beginRefreshing];
    }
}

-(void)jumpNext:(NSString *)str{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    if ([str isEqualToString:@"邮箱"]) {
        MailVC *mail = [[MailVC alloc] init];
        [self.navigationController pushViewController:mail animated:YES];
    }else if ([str isEqualToString:@"审批"]){
        ApprovalManageVC *approve = [[ApprovalManageVC alloc] init];
        [self.navigationController pushViewController:approve animated:YES];
    }else if ([str isEqualToString:@"综合管理"]){
        
        [self isNeedpassword];
    }else if ([str isEqualToString:@"公告"]){
        NoticeViewController *notice = [[NoticeViewController alloc] init];
        [self.navigationController pushViewController:notice animated:YES];
    }else if ([str isEqualToString:@"人事管理"]){
        [self.navigationController pushViewController:[[PersonnelVC alloc]init] animated:YES];
    }else if ([str isEqualToString:@"客户关系"]){
        [self.navigationController pushViewController:[[RelationVC alloc]init] animated:YES];
    }else if ([str isEqualToString:@"备忘录"]){
        [self.navigationController pushViewController:[[MemorandumVC alloc]init] animated:YES];
    }else if ([str isEqualToString:@"企业文档"]){
        /*
         CompanyFileController *companyFileController = [[CompanyFileController alloc] init];
         [self.navigationController pushViewController:companyFileController animated:YES];
         */
        
        EnterprisesDocumentViewController *enterprisesDocumentVC = [[EnterprisesDocumentViewController alloc] init];
        [self.navigationController pushViewController:enterprisesDocumentVC animated:YES];
        
    }else if ([str isEqualToString:@"考勤"]){
        AttendanceVC *attendVC = [[AttendanceVC alloc] init];
        attendVC.havePermission = _havePermission;
        [self.navigationController pushViewController:attendVC animated:YES];
    }else if ([str isEqualToString:@"财务"]){
        [self.navigationController pushViewController:[[FinancialAffairsVC alloc] init] animated:YES];
    }else if ([str isEqualToString:@"申请"]){
        [self.navigationController pushViewController:[[ApplyVC alloc] init] animated:YES];
    }else if ([str isEqualToString:@"委派"]){
        [self.navigationController pushViewController:[[DelegateViewController alloc] init] animated:YES];
    }else if ([str isEqualToString:@"申请凭证"]){
        [self.navigationController pushViewController:[[ApplyVoucherViewController alloc] init] animated:YES];
    }
    
}

- (MoreViewController *)moreViewController {
    if (!_moreViewController)
    {
        _moreViewController = [[MoreViewController alloc] initWithNuberItems:4];
    }
    return _moreViewController;
}

//  是否必须设置管理员初始密码
- (void)isNeedpassword {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
    
    [AFNetClient GET_Path:Needpassword completed:^(NSData *stringData, id JSONDict) {
        
        [hud hide:YES];
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0]) {
            
            BOOL need = [[JSONDict objectForKey:@"Data"] boolValue];
            if (need) {
                AttendantVC *attened = [[AttendantVC alloc] init];
                [self.navigationController pushViewController:attened animated:YES];
            }
            else {
                ManagerOperateVC *operateVC = [[ManagerOperateVC alloc] init];
                [self.navigationController pushViewController:operateVC animated:YES];
            }
            
        }else {
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
            
        }
    } failed:^(NSError *error) {
        
        [hud hide:YES];
        
        NSLog(@"------------->>>>>>%@",error);
    }];
}

- (void)removeHUDAction {
    [_collectionView.mj_header endRefreshing];
    for (UIView *subView in self.view.subviews) {
        if (subView == _hud) {
            [_hud removeFromSuperview];
            _hud = nil;
        }
    }
}

- (void)removeCoverView {
    self.navigationItem.title = [UserInfo getcompanyName];
    [self removeTempView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)departmentMessageChange
{
    [self GetDepartmentURlAction:1];
}

// 所有部门
- (void)GetDepartmentURlAction:(int)type {
    
    [AFNetClient GET_Path:GetDepartmentURl completed:^(NSData *stringData, id JSONDict) {
        NSArray *arr = JSONDict[@"Data"];
        [ZWLCacheData archiveObject:arr toFile:DepartmentsPath];
        
        if (type == 0) {// 0:重刷聊天同事界面
            [self getAllEmployeeMessage:type];
            
        }
        
    } failed:^(NSError *error) {
        
    }];
    
    
}

- (void)employeeMessageChange {
    [self getAllEmployeeMessage:1];
}

- (void)getAllEmployeeMessage:(int)type {
    
    NSInteger pageIndex = 1;
    NSInteger pageSize = 10000;
    NSString *strURL = [GetAllEmployee stringByAppendingFormat:@"&pageIndex=%ld&PageSize=%ld",pageIndex, pageSize];
    //获取公司所有职员信息
    [AFNetClient GET_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
            //            [[RCIM sharedRCIM] clearUserInfoCache];
            
            NSArray *arr = JSONDict[@"Data"];
            if ([arr isKindOfClass:[NSNull class]]) {
                return ;
            }
            [ZWLCacheData archiveObject:arr toFile:EmployeesPath];
            
            for (NSDictionary *dic in arr) {
                
                if (![dic[@"ProfileId"] isEqualToString:[UserInfo userID]]) {
                    RCUserInfo * user =[[RCUserInfo alloc]init];
                    user.userId = dic[@"ProfileId"];
                    user.name = dic[@"EmployeeName"];
                    NSString *iconURL = [NSString replaceString:dic[@"FaceURL"] Withstr1:@"100" str2:@"100" str3:@"c"];
                    user.portraitUri = iconURL;
                    /*!
                     更新SDK中的用户信息缓存
                     
                     @param userInfo     需要更新的用户信息
                     @param userId       需要更新的用户ID
                     
                     @discussion 使用此方法，可以更新SDK缓存的用户信息。
                     但是处于性能和使用场景权衡，SDK不会在当前View立即自动刷新（会在切换到其他View的时候再刷新该用户的显示信息）。
                     如果您想立即刷新，您可以在会话列表或者聊天界面reload强制刷新。
                     */
                    [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
                }
                
            }
            
            // 会话列表刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshConversionList" object:nil];
            
            if (type == 0) {// 0:重刷聊天同事界面
                // 刷新部门和员工信息！
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshInfoNotification object:nil];
            }
            
            // 是否是同事数据刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshIsEmployeeNotification" object:nil];
            
        }
    } failed:^(NSError *error) {
        
        [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
        
    }];
}


@end
