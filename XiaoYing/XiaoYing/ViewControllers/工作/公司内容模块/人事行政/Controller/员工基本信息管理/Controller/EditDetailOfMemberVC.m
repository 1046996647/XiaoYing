//
//  EditDetailOfMemberVC.m
//  XiaoYing
//
//  Created by ZWL on 16/10/6.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "EditDetailOfMemberVC.h"
#import "CheckPersonInfo.h"
#import "XYNewWorkerPermissionViewController.h"
#import "InputMemberInfoVC.h"
#import "SexController.h"
#import "ZWLDatePickerView.h"
#import "BirthdayController.h"
#import "PopViewVC.h"
#import "MemberInfoModel.h"
#import "SelectUnitVC.h"
#import "XYPositionViewController.h"
#import "XYJobModel.h"
#import "MemberJobModel.h"
#import "EmployeeModel.h"
#import "EmployeeDeparture.h"
#import "BXTextField.h"
@interface EditDetailOfMemberVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EmployeeDepartureDelegate>
{
    UIView *_baseView;
    NSArray *_cellArr1;
    UIImageView *userImg;
    UIImageView *frontImg;
    UIImageView *reverseImg;
    BXTextField *textfield;
}
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSMutableArray *arrayJob;
@property (nonatomic,strong) UIView *superView;
@property (nonatomic,strong) NSString *tempStr;
@property (nonatomic,strong) UITableView *approveTable;
@property (nonatomic,strong) UITapGestureRecognizer *tempBtn;
@property (nonatomic,strong) NSMutableArray *cellArr2;
@property (nonatomic,strong) NSMutableArray *cellArr3;
@property (nonatomic,strong) NSMutableArray *arrayInfo;
@property (nonatomic,strong) NSMutableArray *companyJobIds;
@property (nonatomic,strong) NSMutableArray *tempArray;
@property (nonatomic,strong) NSString *Str;
@property (nonatomic) CGFloat tempheight;
@property (nonatomic, strong) XYNewWorkerPermissionViewController *workerVC;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *tempImage;
@property (nonatomic, strong) UIImageView *tempImage1;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *emailLab;
@property (nonatomic,strong) MemberInfoModel *model;

@property (nonatomic, strong) NSArray *departments;


@end

@implementation EditDetailOfMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑成员信息";
    
    [self initData];
    
    //导航栏的保存按钮
    [self initRightBtn];
    
    [self initUI];
    
    [self setTableView];
    
    //获取员工基本信息
    [self GetDetailOfEmployeeAction];
    
}


- (void)GetDetailOfEmployeeAction {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
//    _hud.labelText = @"加载中...";
    NSString *urlStr = [GetDetailOfEmployee stringByAppendingFormat:@"&ProfileId=%@",_employeeModel.ProfileId];
    [AFNetClient GET_Path:urlStr completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
    
        if (1 == [code integerValue]) {
            [MBProgressHUD showMessage:[JSONDict objectForKey:@"Message"] toView:self.view];
        } else {

            [self parserNetData:JSONDict];
        }
        [_hud setHidden:YES];
    } failed:^(NSError *error) {
        [_hud setHidden:YES];
        [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
    }];
}

- (void)parserNetData:(id)respond {
    NSMutableDictionary *dic = respond[@"Data"];
    [_model setValuesForKeysWithDictionary:dic];

    NSMutableArray *array = dic[@"Jobs"];
    for (NSMutableDictionary *dicJob in array) {
        [_companyJobIds addObject:dicJob[@"CompanyJobId"]];
        if (![dicJob[@"JobName"] isKindOfClass:[NSNull class]] && [dicJob[@"IsMastJob"] isEqual:@1]) {
            _cellArr2[7] = dicJob[@"JobName"];
            _cellArr3[7] = dicJob[@"JobName"];
        }else {
            MemberJobModel *model = [[MemberJobModel alloc]init];
            [model setValuesForKeysWithDictionary:dicJob];
            [_arrayJob addObject:model];                   /*-----有兼职的时候会用到这个数组--*/
        }
    }
    if (![dic[@"Signer"] isKindOfClass:[NSNull class]] && ![dic[@"Signer"] isEqualToString:@""]) {
         _Singer = dic[@"Signer"];
    }
    if (![dic[@"Name"] isKindOfClass:[NSNull class]] && ![dic[@"Name"] isEqualToString:@""]) {
        _cellArr2[0] = dic[@"Name"];
        _cellArr3[0] = dic[@"Name"];
    }
    if (![dic[@"EmployeeNo"] isKindOfClass:[NSNull class]] && ![dic[@"EmployeeNo"]isEqualToString:@""]) {
        _cellArr2[1] = dic[@"EmployeeNo"];
        _cellArr3[1] = dic[@"EmployeeNo"];
    }
    if (![dic[@"Mobile"] isKindOfClass:[NSNull class]] && ![dic[@"Mobile"]isEqualToString:@""]) {
        _cellArr2[2] = dic[@"Mobile"];
        _cellArr3[2] = dic[@"Mobile"];
    }
    if (![dic[@"Gender"] isKindOfClass:[NSNull class]] && ![dic[@"Gender"]isEqual:@0]) {
        if ([dic[@"Gender"] isEqual:@1]) {
            _model.Gender = @"1";
            _cellArr2[3] = @"男";
            _cellArr3[3] = @"男";
        }else {
            _model.Gender = @"2";
            _cellArr2[3] = @"女";
            _cellArr3[3] = @"女";
        }
    }
    if (![dic[@"Birthday"] isKindOfClass:[NSNull class]]) {
        NSString *str = @" 00:00:00";
        NSString *tempStr = dic[@"Birthday"];
        if (![tempStr containsString:str]) {
            tempStr = [NSString stringWithFormat:@"%@%@",tempStr, str];
        }
        NSArray *array = [tempStr componentsSeparatedByString:@" "];
        _tempStr = array[1];
        _cellArr2[4] = array[0];
        _cellArr3[4] = array[0];
    }
    if (![dic[@"RealAddress"] isKindOfClass:[NSNull class]] && ![dic[@"RealAddress"]isEqualToString:@""]) {
        _model.RealAddress = dic[@"RealAddress"];
        _cellArr2[5] = dic[@"RealAddress"];
        _cellArr3[5] = dic[@"RealAddress"];
    }
    if (![dic[@"DepartmentName"] isKindOfClass:[NSNull class]]) {
        if ([dic[@"DepartmentName"] isEqualToString:@""]) {
            _cellArr2[6] = [UserInfo getcompanyName];
            _cellArr3[6] = [UserInfo getcompanyName];
        }else {
            _cellArr2[6] = dic[@"DepartmentName"];
            _cellArr3[6] = dic[@"DepartmentName"];
        }
    }
    if (![dic[@"Memo"] isKindOfClass:[NSNull class]]) {
        _Str = dic[@"Memo"];
    }
    
    [self initUI];
    [_approveTable reloadData];
}

- (void)initUI {
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];

        [self.view addSubview:_baseView];
        userImg = [[UIImageView alloc]init];
        userImg.tag = 100;
        [userImg sizeToFit];
        _imageView = [[UIImageView alloc]init];
        userImg.frame = CGRectMake(12, 12, 150/2, 176/2);
        userImg.userInteractionEnabled =  YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(picImageAction:)];
        [userImg addGestureRecognizer:tap2];
        [_baseView addSubview:userImg];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(userImg.right+12, userImg.top, kScreen_Width-(userImg.right+12), 44)];
        label.backgroundColor = [UIColor whiteColor];
        [_baseView addSubview:label];

        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(userImg.right+12, userImg.top, kScreen_Width-(userImg.right+12+36), 44)];
        _titleLab.textColor = [UIColor colorWithHexString:@"#848484"];
        _titleLab.userInteractionEnabled = YES;
        _titleLab.backgroundColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:16];
        [_baseView addSubview:_titleLab];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkAction)];
        [_titleLab addGestureRecognizer:tap];

        
        UIImageView *editImg = [[UIImageView alloc] initWithFrame:CGRectMake(_baseView.width-12-24, 24, 24, 20)];
        editImg.image = [UIImage imageNamed:@"id"];
        [_baseView addSubview:editImg];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(label.left, label.bottom, label.width, .5)];
        line1.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
        [_baseView addSubview:line1];
        
        _emailLab = [[UILabel alloc] initWithFrame:CGRectMake(userImg.right+12, line1.bottom, label.width, 44)];
        _emailLab.textColor = [UIColor colorWithHexString:@"#848484"];
        _emailLab.backgroundColor = [UIColor whiteColor];
        _emailLab.userInteractionEnabled = YES;
        _emailLab.font = [UIFont systemFontOfSize:16];
        [_baseView addSubview:_emailLab];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkAction)];
        [_emailLab addGestureRecognizer:tap1];
        
        // 身份证和照片部分
        _superView = [[UIView alloc] initWithFrame:CGRectMake(12, _emailLab.bottom+12, kScreen_Width-24, 0)];
        _superView.backgroundColor = [UIColor whiteColor];
        [_baseView addSubview:_superView];
        
        textfield = [[BXTextField alloc] initWithFrame:CGRectMake(10, 0, _superView.width-20, 34)];
        [textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        textfield.font = [UIFont systemFontOfSize:14];
        //_textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        textfield.textColor = [UIColor colorWithHexString:@"#333333"];
        textfield.placeholder = @"请输入18位身份证号";
        [_superView addSubview:textfield];
        
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(textfield.left, 30, textfield.width-12, .5)];
        line2.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
        [_superView addSubview:line2];
        
        UIButton *identityImg = [UIButton buttonWithType:UIButtonTypeCustom];
        identityImg.frame = CGRectMake(line2.right+3, 13, 12, 15);
        [identityImg setImage:[UIImage imageNamed:@"validation_grey"] forState:UIControlStateNormal];
        [identityImg setImage:[UIImage imageNamed:@"validation_green"] forState:UIControlStateSelected];
        [_superView addSubview:identityImg];
        
        frontImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, line2.bottom+10, 266/2, 166/2)];
        frontImg.tag = 101;
        frontImg.backgroundColor = [UIColor redColor];
        frontImg.userInteractionEnabled =  YES;
         UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(picImageAction:)];
        [frontImg addGestureRecognizer:tap3];
        [_superView addSubview:frontImg];
        
        reverseImg = [[UIImageView alloc]initWithFrame:CGRectMake(_superView.width-10-266/2, line2.bottom+10, 266/2, 166/2)];
        reverseImg.tag = 102;
        reverseImg.userInteractionEnabled =  YES;
        UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(picImageAction:)];
        [reverseImg addGestureRecognizer:tap5];
        [_superView addSubview:reverseImg];
        
        _superView.height = reverseImg.bottom+10;
        _baseView.height = _superView.bottom+12;

    }
    if (_model.Nick != NULL) {
         _titleLab.text = [NSString stringWithFormat:@"  %@", _model.Nick];
    }
    if (_model.xiaoYingHao != NULL) {
        _emailLab.text  = [NSString stringWithFormat:@"  %@", _model.xiaoYingHao];
    }
    
    textfield.text = _model.LicenseNumber;
    
    NSString *iconURL = [NSString replaceString:_model.EmployeeFaceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [userImg sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"head"]];
  
    NSString *iconURL1 = [NSString replaceString:_model.LicenseCarFrontUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [frontImg sd_setImageWithURL:[NSURL URLWithString:iconURL1] placeholderImage:[UIImage imageNamed:@"id_before"]];

    NSString *iconURL2 = [NSString replaceString:_model.LicenseCarBackUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [reverseImg sd_setImageWithURL:[NSURL URLWithString:iconURL2] placeholderImage:[UIImage imageNamed:@"id_after"]];
}

- (void)setTableView {
    // 表视图
    self.approveTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:UITableViewStylePlain];
    self.approveTable.tableHeaderView = _baseView;
    self.approveTable.delegate = self;
    self.approveTable.dataSource = self;
    self.approveTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.approveTable];
    
    UIView * foot =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 80)];
    self.approveTable.tableFooterView = foot;
    UIButton * btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    
    NSString *profileId = [UserInfo userID];

    //自己，公司创建者，公司领导人不能离职
    if ([_employeeModel.ProfileId isEqual:profileId] || [_employeeModel.RoleType isEqual:@128] || [[UserInfo GetTopLeaderOfCompany] isEqualToString:_employeeModel.ProfileId]) {
        [btn setTitleColor:[UIColor colorWithHexString:@"#cccccc"] forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
    }else {
        [btn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    }

    [btn setTitle:@"该员工已离职?" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leaveMemberAction) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    btn.frame = CGRectMake(12, 15, kScreen_Width - 24, 44);
    [foot addSubview:btn];
}

- (void)initData {
    _cellArr1 = @[@"姓名",@"工号",@"手机",@"性别",@"出生日期",@"地址",@"单元",@"职位"];
    _cellArr2 = [NSMutableArray arrayWithObjects:@"输入真实姓名",@"输入员工号",@"输入号码",@"选择性别",@"选择日期",@"输入地址",@"选择单元",@"选择职位", nil];
    _cellArr3 = [NSMutableArray arrayWithObjects:@"$",@"$",@"$",@"$",@"$",@"$",@"$",@"$", nil];
    _arrayInfo = [NSMutableArray array];
    _model = [[MemberInfoModel alloc]init];
    _companyJobIds = [NSMutableArray array];
    _arrayJob = [NSMutableArray array];
    _tempArray = [NSMutableArray array];
}

//导航栏的保存按钮
- (void)initRightBtn {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)rightBtnAction:(UIButton *)btn {
    NSLog(@"保存");
    [self ModifyDetailOfEmployeeAction];
}
- (void)leaveMemberAction {
      NSLog(@"该员工已离职");
    EmployeeDeparture *departureVC = [[EmployeeDeparture alloc] init];
    departureVC.delegate = self;

    //模态
    departureVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    departureVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    departureVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.navigationController presentViewController:departureVC animated:YES completion:nil];
}

- (void)employDepareture {
    [self LeavedOfEmployeeAction];
}

//该员工已离职
- (void)LeavedOfEmployeeAction {
    MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud1.mode = MBProgressHUDModeIndeterminate;
    hud1.labelText = @"离职中...";
    NSString *strURL = [LeavedEmloyee stringByAppendingFormat:@"&EmployeePorfileId=%@",_employeeModel.ProfileId];
    
    [AFNetClient POST_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if ([code isEqual:@1]) {
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
        }else {
            [self getAllEmployeeMessage];
        }
        [hud1 setHidden:YES];
        NSLog(@"---%@", JSONDict);
    } failed:^(NSError *error) {
        [hud1 setHidden:YES];
        NSLog(@"_______________________%@", error);
    }];
}


//修改员工信息
- (void)ModifyDetailOfEmployeeAction {
    if ([_model.Name isEqualToString:@""]) {
        [MBProgressHUD showMessage:@"姓名不能为空!" toView:self.view];
        return;
    }
    if (textfield.text.length > 0 && ![RegexTool validateIdentityCard:textfield.text]) {
        [MBProgressHUD showMessage:@"身份证输入不正确！" toView:self.approveTable];
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"保存中...";
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setValue:_model.ProfileId forKey:@"profileId"];
    [paraDic setValue:textfield.text forKey:@"licenseNumber"];
    [paraDic setValue:_model.LicenseCarFrontUrl forKey:@"licenseCarFrontUrl"];
    [paraDic setValue:_model.LicenseCarBackUrl forKey:@"licenseCarBackUrl"];
    [paraDic setValue:_model.EmployeeFaceUrl forKey:@"faceUrl"];
    [paraDic setValue:_model.Name forKey:@"name"];
    [paraDic setValue:_model.EmployeeNo forKey:@"employeeNo"];
    [paraDic setValue:_model.Mobile forKey:@"mobile"];
    if ([_model.Gender isEqualToString:@"1"]) {
        [paraDic setValue:@1 forKey:@"gender"];
    }else {
        [paraDic setValue:@2 forKey:@"gender"];
    }
    [paraDic setValue:_model.Birthday forKey:@"birthday"];
    [paraDic setValue:_model.RealAddress forKey:@"address"];
    [paraDic setValue:_model.DepartmentId forKey:@"departmentId"];
    [paraDic setValue:_companyJobIds forKey:@"companyJobIds"];
    [paraDic setValue:_Str forKey:@"memo"];

    
    [AFNetClient POST_Path:ModifyDetailOfEmployee params:paraDic completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if ([code isEqual:@0]) {
           
            [self getAllEmployeeMessage];

            NSLog(@"-----------------------%@",JSONDict);
            
        }else {
            [_hud setHidden:YES];
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
        }
    } failed:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


- (void)getAllEmployeeMessage {
    
    NSInteger pageIndex = 1;
    NSInteger pageSize = 1000;
    NSString *strURL = [GetAllEmployee stringByAppendingFormat:@"&pageIndex=%ld&PageSize=%ld",pageIndex, pageSize];
    //获取公司所有职员信息
    [AFNetClient GET_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            [_hud hide:YES];
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
            self.referMember(arrM1, array1);
            [self popViewController:@"WorkerMessageVC"];
        }
    } failed:^(NSError *error) {
        [_hud hide:YES];
        [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
    }];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [_cellArr2 count];
    }
    if (section == 1) {
        return _arrayJob.count * 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && _tempheight > 17) {
        return _tempheight + 32;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
        
    }
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = _cellArr1[indexPath.row];
        cell.detailTextLabel.text = _cellArr2[indexPath.row];
        if (![_cellArr3[indexPath.row] isEqualToString:@"$"]) {
            cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        }else {
            cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
        }
    }
    if (indexPath.section == 1 && _arrayJob.count > 0) {
        cell.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < _arrayJob.count; i++) {
            [array addObject:@"兼任单元"];
            [array addObject:@"兼任职位"];
        }
        cell.textLabel.text = array[indexPath.row];
        
        MemberJobModel *model = _arrayJob[indexPath.row / 2];
        if (indexPath.row % 2 == 1) {
            cell.detailTextLabel.text = model.JobName;
        }else {
            cell.detailTextLabel.text = model.DepartmentName;
        }
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = @"输入备注内容";
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (_Str.length > 0) {
            NSDictionary *attrs = @{NSFontAttributeName:cell.textLabel.font};
            CGSize maxSize = CGSizeMake(kScreen_Width - 24, 0);
            CGSize size = [_Str boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
            _tempheight = size.height;
            cell.height = size.height + 32;
            cell.textLabel.frame = CGRectMake(12, 12, size.width, size.height);
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = _Str;
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        }else {
            _tempheight = 0;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ((indexPath.section == 0 && indexPath.row < 3) || indexPath.section == 2 || (indexPath.section == 0 && indexPath.row == 5)) {
        InputMemberInfoVC *inputMemberInfoVC =[[InputMemberInfoVC alloc] init];
        inputMemberInfoVC.valueBlock = ^(NSString *tempStr) {
            if (indexPath.section == 0) {
                switch (indexPath.row) {
                    case 0:
                        if ([tempStr isEqualToString:@"$"]) {
                            _model.Name = @"";
                            _cellArr2[0] = @"输入真是姓名";
                            _cellArr3[0] = @"$";
                        }else {
                            _model.Name = tempStr;
                            _cellArr2[0] = tempStr;
                            _cellArr3[0] = tempStr;
                        }
                        
                        break;
                    case 1:
                        if ([tempStr isEqualToString:@"$"]) {
                            _model.EmployeeNo = @"";
                            _cellArr2[1] = @"输入员工号";
                            _cellArr3[1] = @"$";
                        }else {
                            _model.EmployeeNo = tempStr;
                            _cellArr2[1] = tempStr;
                            _cellArr3[1] = tempStr;
                        }
                        break;
                    case 2:
                        if ([tempStr isEqualToString:@"$"]) {
                            _model.Mobile = @"";
                            _cellArr2[2] = @"输入手机号";
                            _cellArr3[2] = @"$";
                        }else {
                            _model.Mobile = tempStr;
                            _cellArr2[2] = tempStr;
                            _cellArr3[2] = tempStr;
                        }
                        break;
                    case 5:
                        if ([tempStr isEqualToString:@"$"]) {
                            _model.RealAddress = @"";
                            _cellArr2[5] = @"输入地址";
                            _cellArr3[5] = @"$";
                        }else {
                            _model.RealAddress = tempStr;
                            _cellArr2[5] = tempStr;
                            _cellArr3[5] = tempStr;
                        }
                        break;
                    default:
                        break;
            }
            }else {
                if ([tempStr isEqualToString:@"$"]) {
                    _Str = @"";
                }else {
                    _Str = tempStr;
                }
              }
            [tableView reloadData];
        };
        inputMemberInfoVC.indexPath = indexPath;
        if (indexPath.section == 2) {
            inputMemberInfoVC.DetailOfCell = _Str;
        }else {
            if (![_cellArr3[indexPath.row] isEqualToString:@"$"]) {
                inputMemberInfoVC.DetailOfCell = _cellArr2[indexPath.row];
            }
        }
        
        [self.navigationController pushViewController:inputMemberInfoVC animated:YES];
    }
    
    if (indexPath.row == 3 && indexPath.section == 0) {
        PopViewVC *popViewVC  = [[PopViewVC alloc] init];
        popViewVC.titleArr = @[@"男",@"女"];
        popViewVC.clickBlock = ^(NSInteger indexRow) {
            
            if (indexRow == 0) {
                _model.Gender = @"1";
                _cellArr2[3] = @"男";
                _cellArr3[3] = @"男";
            } else {
                _model.Gender = @"2";
                _cellArr2[3] = @"女";
                _cellArr3[3] = @"女";
            }
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        popViewVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //淡出淡入
        popViewVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //        self.definesPresentationContext = YES; //不盖住整个屏幕
        popViewVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [self presentViewController:popViewVC animated:YES completion:nil];
    }
    //生日
    if (indexPath.row == 4 && indexPath.section == 0) {
        //日期选择视图
        ZWLDatePickerView *datepickerView = [[ZWLDatePickerView alloc] initWithFrame:CGRectMake(0,kScreen_Height - 270, kScreen_Width, 270)];
        if (![_cellArr2[4] isEqualToString:@"出生日期"]) {
            datepickerView.dateStr = @"";
        }else {
            datepickerView.dateStr = _cellArr2[4];
        }
        datepickerView.dataBlock = ^(NSString *dateStr){
            _cellArr2[4] = dateStr;
            _cellArr3[4] = dateStr;
            NSString *birthdayStr = [NSString stringWithFormat:@"%@ %@", dateStr, _tempStr];
            _model.Birthday = birthdayStr;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        BirthdayController *birthdayCtrl = [[BirthdayController alloc] init];
        birthdayCtrl.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //      self.definesPresentationContext = YES; //不盖住整个屏幕
        //淡出淡入
        birthdayCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        birthdayCtrl.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [birthdayCtrl.view addSubview:datepickerView];
        
        [self presentViewController:birthdayCtrl animated:YES completion:nil];
    }
    if (indexPath.row == 6 && indexPath.section == 0) {
        if ([[UserInfo GetTopLeaderOfCompany] isEqualToString:_employeeModel.ProfileId]) {
            //此人为公司最高领导人部门不能修改
            [MBProgressHUD showMessage:@"该员工为公司最高领导人，不能更换其所属单元！" toView:self.view];
        }else
            if (![[UserInfo GetTopLeaderOfCompany] isEqualToString:_employeeModel.ProfileId] && (_employeeModel.isMastLeader || _employeeModel.isConcurrentLeader)) {
            //此人为部门领导人部门不能修改
            [MBProgressHUD showMessage:@"该员工为本单元领导人，不能更换其所属单元！" toView:self.view];
        }else
        {
            SelectUnitVC *selectUnitVC = [[SelectUnitVC alloc]init];
            selectUnitVC.superTitle = _cellArr2[6];
            selectUnitVC.ParentID = _model.DepartmentId;
            selectUnitVC.comanyName = [UserInfo getcompanyName];
//            selectUnitVC.departments = self.departments;
            selectUnitVC.superRanks = _superRanks;
            selectUnitVC.title = @"选择单元";
            selectUnitVC.sendUnitBlock = ^(DepartmentModel *model) {
                if (model.superTitle != NULL) {
                    
                    _superRanks = model.superRanks;
                    _model.DepartmentId = model.ParentID;
                    _cellArr2[6] = model.superTitle;
                    _cellArr3[6] = model.superTitle;
                }
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:selectUnitVC animated:YES];
        }
    }
    if (indexPath.row == 7 && indexPath.section == 0) {
        
        XYPositionViewController *positionVc = [[XYPositionViewController alloc] init];
        [positionVc getJobMessageWithOldJobName:_cellArr2[7] successBlock:^(XYJobModel *jobModel) {
            
            NSLog(@"jobModel~~~!!!~~~%@", jobModel);

            if (_companyJobIds.count > 0) {
                [_companyJobIds replaceObjectAtIndex:0 withObject:jobModel.jobId];
            }else {
                [_companyJobIds addObject:jobModel.jobId];
            }
            
            _cellArr2[7] = jobModel.jobName;
            _cellArr3[7] = jobModel.jobName;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }];
        [self.navigationController pushViewController:positionVc animated:YES];
    }
}
//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 0;
            break;
        case 2:
            return 35;
            break;
        default:
            break;
    }
    return 0;
}
//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 35)];
        view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        //组标题
        UILabel *sectionLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, 150, 20)];
        sectionLab.font = [UIFont systemFontOfSize:14];
        sectionLab.textColor = [UIColor colorWithHexString:@"#848484"];
        sectionLab.text = @"备注";
        [view addSubview:sectionLab];
        
        return view;
    }
    return nil;
}


- (void)checkAction {
    CheckPersonInfo *checkPersonInfo = [[CheckPersonInfo alloc] init];
    checkPersonInfo.Nick = _model.Nick;
    checkPersonInfo.XiaoYinCode = _model.xiaoYingHao;
    checkPersonInfo.Singer = _Singer;
    checkPersonInfo.region = _model.Address;
    checkPersonInfo.FaceUrl = _model.ProfileFaceUrl;

    checkPersonInfo.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    checkPersonInfo.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //self.definesPresentationContext = YES; //不盖住整个屏幕
    checkPersonInfo.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:checkPersonInfo animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate

//选取后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"info:%@",info[UIImagePickerControllerOriginalImage]);
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"上传中...";
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(img, 0.5f);
    NSString *strBase64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic  setValue:strBase64 forKey:@"data"];
    [paraDic  setValue:@"photo.png" forKey:@"fileName"];
    [paraDic  setValue:@"0" forKey:@"category"];
    [AFNetClient POST_Path:FileUploadURl params:paraDic completed:^(NSData *stringData, id JSONDict) {

        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0]) {
            
            if (self.tempBtn.view.tag == 100) {
                _model.EmployeeFaceUrl = JSONDict[@"Data"][@"FormatUrl"];
                userImg.image = img;
            }
            else if (self.tempBtn.view.tag == 101) {

                _model.LicenseCarFrontUrl = JSONDict[@"Data"][@"FormatUrl"];
                frontImg.image = img;
            }else {
                
                _model.LicenseCarBackUrl = JSONDict[@"Data"][@"FormatUrl"];
                reverseImg.image = img;
            }
            [_hud setHidden:YES];
            NSLog(@"---------------------->>>>>>%@",JSONDict);
        }else {
            [_hud setHidden:YES];
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
        }
       
    } failed:^(NSError *error) {
        NSLog(@"---------------------->>>>>>%@",error);
    }];
    //    [app.tabvc showCustomTabbar];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//取消后调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)picImageAction:(id)sender {
    self.tempBtn = sender;
    PopViewVC *popViewVC  = [[PopViewVC alloc] init];
    popViewVC.titleArr = @[@"相册",@"拍照"];
    popViewVC.clickBlock = ^(NSInteger indexRow) {
        if (indexRow == 0) {
            
            // 创建相册控制器
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            // 设置类型
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            // 设置为静态图像类型
            pickerController.mediaTypes = @[@"public.image"];
            // 设置代理对象
            pickerController.delegate = self;
            // 设置选择后的图片可以被编辑
            //            pickerController.allowsEditing=YES;
            
            // 跳转到相册页面
            [self presentViewController:pickerController animated:YES completion:nil];
            
        } else {
            NSLog(@"打开摄像头");
            // 判断当前设备是否有摄像头
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                
                // 创建相册控制器
                UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
                // 设置类型
                pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                // 设置代理对象
                pickerController.delegate = self;
                //                pickerController.allowsEditing=YES;
                // 跳转到相册页面
                [self presentViewController:pickerController animated:YES completion:nil];
            } else {
                
                
                MLCompatibleAlert *alert = [[MLCompatibleAlert alloc]
                                            initWithPreferredStyle: MLAlertStyleAlert //MLAlertStyleActionSheet
                                            title:@"打开摄像头失败"
                                            message:@"没有检测到摄像头"
                                            delegate:nil
                                            cancelButtonTitle:@"确定"
                                            destructiveButtonTitle:nil
                                            otherButtonTitles:nil,nil];
                [alert showAlertWithParent:self];
            }
        }
    };
    popViewVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    popViewVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //  self.definesPresentationContext = YES; //不盖住整个屏幕
    popViewVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:popViewVC animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == textfield) {
        if (textField.text.length > 18) {
            textField.text = [textField.text substringToIndex:18];
        }
    }
}

@end
