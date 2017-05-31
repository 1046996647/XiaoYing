//
//  SecretController.m
//  XiaoYing
//
//  Created by ZWL on 15/12/16.
//  Copyright © 2015年 ZWL. All rights reserved.
//
#define place kScreen_Width / 4


#import "AuthoritySettingVC.h"
#import "Switch.h"
#import "AuthoritySettingCell.h"
#import "CustomAlertViewVC.h"
#import "PermissionModel.h"
#import "PersonalpermissionVC.h"
#import "JobModel.h"
#import "CustomKnownView.h"
#import "WorkerMessageVC.h"
#import "DocumentFounctionVC.h"
#import "ModuleModel.h"
@interface AuthoritySettingVC()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_sectionArr;
}
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic) long int value; //人事管理所获得的权限个数
@property (nonatomic, strong)NSMutableArray *powerOfFutureArray;
@property (nonatomic, strong)NSMutableArray *powerOfPictureArray;
@property (nonatomic, strong)NSMutableArray *powerOfViewArray;
@property (nonatomic, strong)NSMutableArray *powerOfPictureArrayT;
@property (nonatomic, strong)NSMutableArray *pictureOfAlreadyArrayT;
@property (nonatomic, strong)NSMutableArray *allPerssion;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *backViewT;
@property (nonatomic, strong) NSString *tempStr;  //人事管理
@property (nonatomic, strong) NSString *tempStrOfManager;  //综合管理
@property (nonatomic, strong)NSMutableArray *totleID;  //获得的权限的ID的总和
@property (nonatomic, strong)NSMutableArray *tempPersonallModelArray;  //人事管理里边获得的权限数据的model
@property (nonatomic, strong)NSMutableArray *tempPersonalIdArray;
@property (nonatomic, strong)NSMutableArray *tempManagerModelArray;  //综合管理里边获得的权限数据的model
@property (nonatomic, strong)NSMutableArray *tempManagerIdArray;
@property (nonatomic, strong)NSMutableArray *idOfAlreadyArray;
@property (nonatomic, strong)NSMutableArray *persissionNetArray;
@property (nonatomic, strong)NSMutableArray *persissionAlreadyArray;
@property (nonatomic, strong)NSMutableArray *persissionIDAlreadyArray;
@property (nonatomic, strong)NSMutableArray *persissionPersonalArray;  //人事管理里边的权限
@property (nonatomic, strong)NSMutableArray *persissionManagerArray;  //综合管理里边的权限
@property (nonatomic, strong)NSMutableArray *documentIDArray;  //企业文档里边的权限的id
@property (nonatomic, strong)NSMutableArray *documentModelArray;  //企业文档里边的权限的model
@property (nonatomic, strong)NSMutableArray *selectedDataSource; //标记企业文档里边选中的权限
@property (nonatomic, strong)NSString *tempString;
@property (nonatomic, strong)NSString *documentID;  //企业文档的ID
@property (nonatomic, strong)UIImageView *labelView;
@property (nonatomic, assign)CGFloat CountOfPressionAlready;
@end;

@implementation AuthoritySettingVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initChangeData];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    self.title = @"权限设置";
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 65)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [self.view addSubview:view];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12 , 5, 50, 50)];
    imgView.layer.cornerRadius = 5;
    imgView.clipsToBounds = YES;
    NSString *iconStr = [NSString replaceString:_model.FaceURL Withstr1:@"100" str2:@"100" str3:@"c"];
    [imgView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"newfriends"]];
    [view addSubview:imgView];
    
    _labelView = [[UIImageView alloc]initWithFrame:CGRectMake(imgView.width - 20, imgView.height - 20, 20, 20)];
    _labelView.image = [UIImage imageNamed:@"appointer2"];
    _labelView.hidden = YES;
    if ([_isManagerYesOrNo isEqualToString:@"YES"]) {
        _labelView.hidden = NO;
    }
    [imgView addSubview:_labelView];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right + 10 , 10, kScreen_Width - imgView.right - 22, 16)];
    nameLab.font = [UIFont systemFontOfSize:16];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.text = _model.EmployeeName;
    nameLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [view addSubview:nameLab];
    
    NSString *textOfpositionLab = @"";
    for (NSDictionary *dic in _model.Jobs) {
        NSString *str = dic[@"DepartmentName"];
        if ([str isEqualToString:_departmentName]) {

            if (![str isEqualToString:@""]) {
                textOfpositionLab = [NSString stringWithFormat:@"%@-%@",dic[@"DepartmentName"],dic[@"JobName"]];
            }else {
                textOfpositionLab = [NSString stringWithFormat:@"%@-%@",[UserInfo getcompanyName],dic[@"JobName"]];
            }
        }
    }
    
    UILabel *positionLab = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right + 10 , nameLab.bottom + 10, kScreen_Width - imgView.right - 22, 14)];
    positionLab.font = [UIFont systemFontOfSize:14];
    positionLab.textAlignment = NSTextAlignmentLeft;
    positionLab.text = textOfpositionLab;
    positionLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [view addSubview:positionLab];

    
    //组标题
    _sectionArr = @[@"获得的权限",@"未获得的权限"];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, view.bottom, kScreen_Width, kScreen_Height - 49 - view.height - 12) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [self footView];
    
    //导航栏的保存按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(GivePerssionToSommeOneAction)];

    [self initData];
    
    //获取已经获得的权限
    [self GetlistOfAlreadyURLAction];
}

#pragma mark --已获权限的数据--
//已有权限
- (void)GetlistOfAlreadyURLAction {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"加载中...";
    NSString *urlStr = [NSString stringWithFormat:@"%@&profileid=%@&departmentId=%@",GetlistOfAlreadyURL, _model.ProfileId,_tempDepartmentId];
    [AFNetClient GET_Path:urlStr completed:^(NSData *stringData, id JSONDict) {
     
        NSNumber *code = JSONDict[@"Code"];
        if ([code isEqual:@0]) {

            [self parserAlreadyData:JSONDict];
            [self GetlistOfFunctionURLAction];
        }
        NSLog(@"获取已有权限列表成功__-111---------%@", JSONDict);
    } failed:^(NSError *error) {
        [_hud setHidden:YES];
        NSLog(@"---%@", error);
    }];
}

- (void)parserAlreadyData:(id)response {
    NSMutableArray *array = response[@"Data"];
    NSMutableArray *arrayOfPermission = [NSMutableArray array];
    NSString *persionalID = nil;
    NSString *PermissionID = nil;
    for (NSMutableDictionary *dic in array) {
        PermissionModel *model = [[PermissionModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        if ([_allPerssion containsObject:model.Name]) {
            [arrayOfPermission addObject:model];
            if ([model.Name isEqualToString:@"人事管理"]) {
                persionalID = model.ID;
            }
            if ([model.Name isEqualToString:@"综合管理"]) {
                PermissionID = model.ID;
            }
            if ([model.Name isEqualToString:@"企业文档"]) {
                for (NSMutableDictionary *dic1 in dic[@"FuncList"]) {
                    ModuleModel *modModel = [[ModuleModel alloc]init];
                    [modModel setValuesForKeysWithDictionary:dic1];
                    if ([dic1[@"Enable"] isEqual:@1]) {
                        [_documentIDArray addObject:dic1[@"Id"]];
                        [_selectedDataSource addObject:@"1"];
                    }else {
                        [_selectedDataSource addObject:@"0"];
                    }
                    [_documentModelArray addObject:modModel];
                }
            }
        }
    }
    for (PermissionModel *model in arrayOfPermission) {
            //外层权限
            if ([model.ParentID isEqualToString:@""]||[model.Name isEqualToString:@"考勤管理"]||[model.Name isEqualToString:@"行政管理"]) {
                [_persissionIDAlreadyArray addObject:model.ID];
                [_persissionAlreadyArray addObject:model];
            }else {
                //人事管理里边的权限
                if ([model.ParentID isEqualToString:persionalID]) {
                    [_tempPersonalIdArray addObject:model.ID];
                    [_tempPersonallModelArray addObject:model];
                }else
                    //综合管理里边的权限
                    if ( [model.ParentID isEqualToString:PermissionID]) {
                        [_tempManagerIdArray addObject:model.ID];
                        [_tempManagerModelArray addObject:model];
                    }
            }
    }
     _CountOfPressionAlready = _persissionIDAlreadyArray.count + _tempPersonalIdArray.count + _tempManagerIdArray.count;
}

#pragma mark --所有权限的数据--    
//所有权限
- (void)GetlistOfFunctionURLAction {

    [AFNetClient GET_Path:GetMyManageFunc completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if ([code isEqual:@0]) {
            [self parserNetData:JSONDict];
        }
        NSLog(@"获取所有权限列表成功__----------%@", JSONDict);
        [_hud setHidden:YES];
    } failed:^(NSError *error) {
        [_hud setHidden:YES];
        NSLog(@"---%@", error);
    }];
}
- (void)parserNetData:(id)response {
    NSMutableArray *array = response[@"Data"];
    NSMutableArray *arrayOfPermission = [NSMutableArray array];
    NSString *persionalID = nil;
    NSString *PermissionID = nil;
    for (NSMutableDictionary *dic in array) {
        PermissionModel *model = [[PermissionModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        if ([_allPerssion containsObject:model.Name]) {
        [arrayOfPermission addObject:model];
        if ([model.Name isEqualToString:@"人事管理"]) {
            persionalID = model.ID;
        }
        if ([model.Name isEqualToString:@"综合管理"]) {
            PermissionID = model.ID;
        }
        }
    }
    for (PermissionModel *model in arrayOfPermission) {
        //外层权限
        if ([model.ParentID isEqualToString:@""] || [model.Name isEqualToString:@"考勤管理"]||[model.Name isEqualToString:@"行政管理"]) {
            //排除已有权限
            if (![_persissionIDAlreadyArray containsObject:model.ID]) {
                [_persissionNetArray addObject:model];
            }
        }else {
            //人事管理里边的权限
            if (![_tempPersonalIdArray containsObject:model.ID] && [model.ParentID isEqualToString:persionalID]) {
                [_persissionPersonalArray addObject:model];
            }else
                //综合管理里边的权限(创建者进来可以配置所有权限，超级管理员进来可以配置除了权限管理之外的权限，后期可能会改)
                if ([[UserInfo getUserRole] isEqual:@128]) {
                    if (![_tempManagerIdArray containsObject:model.ID] && [model.ParentID isEqualToString:PermissionID]) {
                        [_persissionManagerArray addObject:model];
                    }
                }else {
                    if (![_tempManagerIdArray containsObject:model.ID] && [model.ParentID isEqualToString:PermissionID] && ![model.Name isEqualToString:@"权限管理"]) {
                        [_persissionManagerArray addObject:model];
                    }
                }
        }
    }
    [self initChangeData];
    [_tableView reloadData];
}

- (void)initChangeData {
    _tempStr = [NSString stringWithFormat:@"人事管理 \n %ld/%ld", _tempPersonallModelArray.count, _persissionPersonalArray.count + _tempPersonallModelArray.count];
    _tempStrOfManager  = [NSString stringWithFormat:@"综合管理 \n %ld/%ld", _tempManagerModelArray.count, _persissionManagerArray.count + _tempManagerModelArray.count];
    _powerOfFutureArray = [NSMutableArray arrayWithObjects:_tempStr ,_tempStrOfManager, @"财务", @"考勤管理",@"行政管理",@"企业文档", nil];
}

- (void)initData {
    _allPerssion = [NSMutableArray arrayWithObjects:@"人事管理" , @"行政管理", @"财务", @"考勤管理", @"企业信息管理", @"组织架构管理", @"企业文档", @"权限管理", @"审批类型管理", @"公告管理",@"员工基本信息管理",@"职位管理",@"新同事",@"员工合同管理",@"人事提醒",@"招聘信息",@"数据备份",@"综合管理",@"数据备份",nil];
    _powerOfPictureArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"hrd_gray"],[UIImage imageNamed:@"hrd_m_grey"],[UIImage imageNamed:@"financial_m_grey"],[UIImage imageNamed:@"attendance_m_grey"]               ,[UIImage imageNamed:@"admin_m_grey"],[UIImage imageNamed:@"file_m_grey"], nil];

    _powerOfPictureArrayT = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"hrd_red"],[UIImage imageNamed:@"hrd_m_color"],[UIImage imageNamed:@"financial_m_color"],[UIImage imageNamed:@"attendance_m_color"],[UIImage imageNamed:@"admin_m_color"],[UIImage imageNamed:@"file_m_color"],nil];
    _powerOfViewArray = [NSMutableArray array];
    //已获得的权利
    _idOfAlreadyArray = [NSMutableArray array];
    _persissionNetArray = [NSMutableArray array];
    _persissionPersonalArray = [NSMutableArray array];
    _persissionAlreadyArray = [NSMutableArray array];
    _persissionIDAlreadyArray = [NSMutableArray array];
    _tempPersonalIdArray = [NSMutableArray array];
    _totleID = [NSMutableArray array];
    _tempPersonallModelArray = [NSMutableArray array];
    _persissionManagerArray = [NSMutableArray array];
    _tempManagerModelArray = [NSMutableArray array];
    _tempManagerIdArray = [NSMutableArray array];
    _documentIDArray = [NSMutableArray array];
    _documentModelArray = [NSMutableArray array];
    _selectedDataSource = [NSMutableArray array];
}

//修改员工信息
- (void)GivePerssionToSommeOneAction {
    [_totleID removeAllObjects];
    [_totleID addObjectsFromArray:_idOfAlreadyArray];
    [_totleID addObjectsFromArray:_tempPersonalIdArray];
    [_totleID addObjectsFromArray:_tempManagerIdArray];

    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    [paraDic setObject:_model.ProfileId forKey:@"profileId"];
    [paraDic setObject:_totleID forKey:@"functionModuleIds"];
    [paraDic setObject:_tempDepartmentId forKey:@"departmentId"];
    [paraDic setObject:_documentIDArray forKey:@"functionPermissionIds"];
    [AFNetClient POST_Path:GivePerssionToSommeOneURL params:paraDic completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if ([code isEqual:@0]) {

            //ROleType有变化才网络请求 修改缓存的员工信息，否则直接跳回
            if ((_CountOfPressionAlready == 0 && _totleID.count > 0) || (_CountOfPressionAlready > 0 && _totleID.count == 0) ) {
                [self getAllEmployeeMessage];
            }else {
                [self popViewController:@"WorkerMessageVC"];
            }
        }else {
            if ([JSONDict[@"Message"] isEqualToString:@"未找到员工信息"]) {
                CustomKnownView *costomVC = [[CustomKnownView alloc] init];
                costomVC.tempDepartmentId = _tempDepartmentId;
                costomVC.ManagerProfileId = _ManagerProfileId;
                [self.view addSubview:costomVC];
            }else {
                [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
            }
        }
    } failed:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)getAllEmployeeMessage {
    NSString *strURL = [GetAllEmployee stringByAppendingFormat:@"&pageIndex=1&PageSize=1000"];
    //获取公司所有职员信息
    [AFNetClient GET_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
            NSMutableArray *array1 = JSONDict[@"Data"];
            [ZWLCacheData archiveObject:array1 toFile:EmployeesPath];
            NSMutableArray *arrM1 = [NSMutableArray array];
            
            for (NSDictionary *dic in array1) {
                if ([_tempDepartmentId isEqualToString:@""]) {
                    if ([dic[@"DepartmentId"] isEqualToString:@""] || [[UserInfo GetTopLeaderOfCompany] isEqualToString:dic[@"ProfileId"]]) {
                        EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
                        [arrM1 addObject:model];
                        
                        if ([dic[@"DepartmentId"] isEqualToString:@""] && [[UserInfo GetTopLeaderOfCompany] isEqualToString:dic[@"ProfileId"]]) {
                            model.isMastLeader = YES;
                        } else if ([[UserInfo GetTopLeaderOfCompany] isEqualToString:dic[@"ProfileId"]])
                        {
                            model.isConcurrentLeader = YES;
                        }
                    }
                }
                else {
                    if ([dic[@"DepartmentId"] isEqualToString:_tempDepartmentId] || [_ManagerProfileId isEqualToString:dic[@"ProfileId"]]) {
                        EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
                        [arrM1 addObject:model];
                        
                        if ([dic[@"DepartmentId"] isEqualToString:_tempDepartmentId] && [_ManagerProfileId isEqualToString:dic[@"ProfileId"]]) {
                            model.isMastLeader = YES;
                        } else if ([_ManagerProfileId isEqualToString:dic[@"ProfileId"]])
                        {
                            model.isConcurrentLeader = YES;
                        }
                    }
                }
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refershWorkerMessageVC" object:nil];
            [self popViewController:@"WorkerMessageVC"];
        }
    } failed:^(NSError *error) {
        [_hud hide:YES];        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
            return 0;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (_persissionAlreadyArray.count == 0){
            return 44;
        }
        return _backView.height;
    }else {
         if (_persissionNetArray.count == 0) {
            return 44;
        }
        return _backViewT.height;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        AuthoritySettingCell *cell = nil;
        if (indexPath.section == 1) {
            if (_persissionAlreadyArray.count == 0) {
                cell = [[AuthoritySettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            }else {
            if (cell == nil) {
                cell = [[AuthoritySettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            }
            UIView *view = [self powerOfAlreadyView];
            [cell.contentView addSubview:view];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
      if (indexPath.section == 2) {
          if (_persissionNetArray.count == 0) {
              cell = [[AuthoritySettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
          }else {
          if (cell == nil) {
              cell = [[AuthoritySettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
          }
          UIView *view = [self powerOfFutureView];
          [cell.contentView addSubview:view];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          }
          return cell;
       }
    return nil;
}

//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 35;
    }
}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 35)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    //组标题
    UILabel *sectionLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 13, 150, 20)];
    sectionLab.font = [UIFont systemFontOfSize:14];
    sectionLab.textColor = [UIColor colorWithHexString:@"#848484"];
    sectionLab.text = _sectionArr[section-1];
    [view addSubview:sectionLab];
    return view;
}
//获得的权限
- (UIView *)powerOfAlreadyView{
    if (_idOfAlreadyArray.count > 0) {
        [_idOfAlreadyArray removeAllObjects];
    }
    if (_backView == nil) {
        self.backView = [[UIView alloc]initWithFrame:CGRectZero];
        _backView.backgroundColor = [UIColor whiteColor];
    }else {
        for (UIView *view in _backView.subviews) {
            [view removeFromSuperview];
        }
    }
    for (int i = 0; i < _persissionAlreadyArray.count; i++) {
        NSInteger index = i % 4;
        NSInteger page = i / 4;
        UIView *view  = [[UIView alloc]init];
        view.frame = CGRectMake(place * index , 12 + 70 * page, place, 58);
        view.userInteractionEnabled = YES;
        view.tag = i + 70;
        _backView.frame = CGRectMake(0, 0, kScreen_Width, 70 * (page + 1));
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((place - 36) / 2, 0, 38, 30)];
        [view addSubview:imageV];
        
        UILabel *label = [self Z_createLabelWithTitle:@"" buttonFrame:CGRectMake(8 , imageV.bottom + 3, place - 16, 30) textFont:10];
        [view addSubview:label];
        
        PermissionModel *model = _persissionAlreadyArray[i];
        
        for (int j = 0; j < _powerOfFutureArray.count; j++) {
            if ([model.Name isEqualToString:@"人事管理"]) {
                
                if (![_idOfAlreadyArray containsObject:model.ID]) {
                    [_idOfAlreadyArray addObject:model.ID];
                }
                label.text = _powerOfFutureArray[0];
                imageV.image = _powerOfPictureArrayT[0];
                view.tag = 666;
            }else
                if ([model.Name isEqualToString:@"综合管理"]) {
                    if (![_idOfAlreadyArray containsObject:model.ID]) {
                        [_idOfAlreadyArray addObject:model.ID];
                    }
                    label.text = _powerOfFutureArray[1];
                    imageV.image = _powerOfPictureArrayT[1];
                    view.tag = 999;
                }else
                    if ([model.Name isEqualToString:@"企业文档"]) {
                        if (![_idOfAlreadyArray containsObject:model.ID]) {
                            [_idOfAlreadyArray addObject:model.ID];
                        }
                        _documentID = model.ID;
                        label.text = _powerOfFutureArray[5];
                        imageV.image = _powerOfPictureArrayT[5];
                        view.tag = 888;
                    }else
                    if ([model.Name isEqualToString: _powerOfFutureArray[j]]) {
                        [_idOfAlreadyArray addObject:model.ID];
                        label.text = _powerOfFutureArray[j];
                        imageV.image = _powerOfPictureArrayT[j];
                    }
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [view addGestureRecognizer:tap];
        [_backView addSubview:view];
    }
    return _backView;
}

//未获得的权限
- (UIView *)powerOfFutureView {
    if (_backViewT == nil) {
        self.backViewT = [[UIView alloc]initWithFrame:CGRectZero];
        _backViewT.backgroundColor = [UIColor whiteColor];
    }else {
        for (UIView *view in _backViewT.subviews) {
            [view removeFromSuperview];
        }
    }
    for (int i = 0; i < _persissionNetArray.count; i++) {
        NSInteger index = i % 4;
        NSInteger page = i / 4;
        UIView *view  = [[UIView alloc]init];
        view.frame = CGRectMake(place * index , 12 + 70 * page, place, 58);
        view.userInteractionEnabled = YES;
        view.tag = i + 50;
        _backViewT.frame = CGRectMake(0, 0, kScreen_Width, 70 * (page + 1));
        
        UILabel *label = [self Z_createLabelWithTitle:@"" buttonFrame:CGRectMake(8 , 33, place - 16, 30)textFont:10];
        [view addSubview:label];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((place - 36) / 2, 0, 38, 30)];
        [view addSubview:imageV];
        
        PermissionModel *model = _persissionNetArray[i];
        for (int j = 0; j < _powerOfFutureArray.count; j++) {
            if ([model.Name isEqualToString:@"人事管理"]) {
                label.text = _powerOfFutureArray[0];
                imageV.image = _powerOfPictureArray[0];
                view.tag = 666;
            }else
                if ([model.Name isEqualToString:@"综合管理"]) {
                    label.text = _powerOfFutureArray[1];
                    imageV.image = _powerOfPictureArray[1];
                    view.tag = 999;
                }else
                    if ([model.Name isEqualToString: _powerOfFutureArray[j]]) {
                        label.text = _powerOfFutureArray[j];
                        imageV.image = _powerOfPictureArray[j];
                    }
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [view addGestureRecognizer:tap];
        [_powerOfViewArray addObject:view];
        [_backViewT addSubview:view];
    }
    return _backViewT ;
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    UIView *view = (UIView *)sender.view;
    if (view.tag > 665) {
        [self popToNextView:sender];
    }else
            if (view.tag < 65) {
                [_persissionAlreadyArray addObject:[_persissionNetArray objectAtIndex:view.tag - 50]];
                [_persissionNetArray removeObjectAtIndex:view.tag - 50];
            }else {
                [_persissionNetArray addObject:[_persissionAlreadyArray objectAtIndex:view.tag - 70]];
                [_persissionAlreadyArray removeObjectAtIndex:view.tag - 70];
                [_idOfAlreadyArray removeObjectAtIndex:view.tag - 70];
            }
    [_tableView reloadData];
}

- (void)popToNextView:(UITapGestureRecognizer *)sender {
    UIView *view = (UIView *)sender.view;
    PersonalpermissionVC *perVc = [[PersonalpermissionVC alloc]init];
    if (view.tag == 888) {
        DocumentFounctionVC *documentVC = [[DocumentFounctionVC alloc]init];
        documentVC.tempDataSource = _documentModelArray;
        documentVC.selectedDataSource = _selectedDataSource;
        documentVC.blockArray = ^(NSMutableArray *array, NSMutableArray *array1) {
            [_documentIDArray removeAllObjects];
            [_documentIDArray addObjectsFromArray:array];
            
            [_selectedDataSource removeAllObjects];
            [_selectedDataSource addObjectsFromArray:array1];
        };
        [self.navigationController pushViewController:documentVC animated:YES];
        return;
    }
    if (view.tag == 666) {
        perVc.title = @"人事管理权限";
        //已获得的权限
        perVc.modelOfAlreadyArray = _tempPersonallModelArray;
        //未获得的权限
        perVc.persissionNetArray = _persissionPersonalArray;
        perVc.passWord = ^(NSMutableArray *array, NSMutableArray *array1, NSMutableArray *array2) {
            [_tempPersonallModelArray removeAllObjects];
            [_tempPersonallModelArray addObjectsFromArray:array];
            
            [_persissionPersonalArray removeAllObjects];
            [_persissionPersonalArray addObjectsFromArray:array1];
            
            [_tempPersonalIdArray removeAllObjects];
            [_tempPersonalIdArray addObjectsFromArray:array2];
            
            //判断人事管理是否是获得的权限
            [self personalManagerMoveAction:_tempPersonalIdArray.count tap:sender whichPart:@"人事管理"];
        };
    }else {
        perVc.title = @"综合管理权限";
        //已获得的权限
        perVc.modelOfAlreadyArray = _tempManagerModelArray;
        //未获得的权限
        perVc.persissionNetArray = _persissionManagerArray;
        perVc.passWord = ^(NSMutableArray *array, NSMutableArray *array1, NSMutableArray *array2) {
            [_tempManagerModelArray removeAllObjects];
            [_tempManagerModelArray addObjectsFromArray:array];
            
            [_persissionManagerArray removeAllObjects];
            [_persissionManagerArray addObjectsFromArray:array1];
            
            [_tempManagerIdArray removeAllObjects];
            [_tempManagerIdArray addObjectsFromArray:array2];
            
            //判断综合管理是否是获得的权限
            [self personalManagerMoveAction:_tempManagerIdArray.count tap:sender whichPart:@"综合管理"];
        };
    }
    [self.navigationController pushViewController:perVc animated:YES];
}

- (void)personalManagerMoveAction:(long int)Value tap:(UITapGestureRecognizer *)sender whichPart:(NSString *)strID {
        if (Value > 0) {
            for (int i = 0; i < _persissionNetArray.count; i++) {
                PermissionModel *model = _persissionNetArray[i];
                if ([model.Name isEqualToString:strID]) {
                    [_persissionAlreadyArray addObject:model];
                    [_persissionNetArray removeObject:model];
                    break;
                }
            }
        }else {
            for (int i = 0; i < _persissionAlreadyArray.count; i++) {
                PermissionModel *model = _persissionAlreadyArray[i];
                if ([model.Name isEqualToString:strID]) {
                    [_persissionNetArray addObject:model];
                    [_persissionAlreadyArray removeObject:model];
                    [_idOfAlreadyArray removeObject:model.ID];
                }
            }
    }
    [_tableView reloadData];
}

//tableView的区尾
- (UIView *)footView {
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, _tableView.height - 106, kScreen_Width, 106)];
    footView.backgroundColor = [UIColor colorWithHexString:@"#efeffc"];
    
    UILabel *label = [self Z_createLabelWithTitle:@"温馨提示:若权限未获得，该员工将无法使用该功能!" buttonFrame:CGRectMake(12, 15, kScreen_Width - 24, 15) textFont:12];
    [footView addSubview:label];
    
    UIButton *secretBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secretBtn.clipsToBounds = YES;
    secretBtn.layer.cornerRadius = 5.0;
    secretBtn.frame = CGRectMake( 12, label.bottom + 15, kScreen_Width - 24, 44);
    secretBtn.backgroundColor = [UIColor colorWithHexString:@"#f94040"];
    [secretBtn setTitle:@"重置管理员密码" forState:UIControlStateNormal];
    secretBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [secretBtn addTarget:self action:@selector(setSecretAction) forControlEvents:UIControlEventTouchUpInside];
    [secretBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footView addSubview:secretBtn];
    return footView;
}

- (void)setSecretAction {
    CustomAlertViewVC *alerView = [[CustomAlertViewVC alloc] init];
    alerView.tempProfileId = _model.ProfileId;
    alerView.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    alerView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    alerView.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:alerView animated:YES completion:nil];
}

#pragma mark --Z_Label--
- (UILabel *)Z_createLabelWithTitle:(NSString *)title
                        buttonFrame:(CGRect)frame
                        textFont:(CGFloat)font{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:font];
    label.numberOfLines = 2;
    label.textColor = [UIColor colorWithHexString:@"#848484"];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end
