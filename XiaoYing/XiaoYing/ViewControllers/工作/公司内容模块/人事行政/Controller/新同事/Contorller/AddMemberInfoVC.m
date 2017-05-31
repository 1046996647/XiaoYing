//
//  MemberInfoVC.m
//  XiaoYing
//
//  Created by MengFanBiao on 16/6/13.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "AddMemberInfoVC.h"
#import "CheckPersonInfo.h"
#import "XYNewWorkerPermissionViewController.h"
#import "InputMemberInfoVC.h"
#import "SexController.h"
#import "ZWLDatePickerView.h"
#import "BirthdayController.h"
#import "SelectUnitVC.h"
#import "PopViewVC.h"
#import "XYJobModel.h"
#import "XYPositionViewController.h"
#import "EmployeeModel.h"
#import "BXTextField.h"
@interface AddMemberInfoVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIView *_baseView;
    NSArray *_cellArr1;
    UIButton *userImg;
    UIButton *frontImg;
    UIButton *reverseImg;
}
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSString *iconStr;
@property (nonatomic,strong) NSString *frontStr;
@property (nonatomic,strong) NSString *backStr;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *employeeNo;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *readyAddress;
@property (nonatomic,strong) NSString *birthday;
@property (nonatomic, copy) NSString *companyJobId;
@property (nonatomic,strong) UITableView *approveTable;
@property (nonatomic,strong) UIButton *tempBtn;
@property (nonatomic,strong) NSMutableArray *cellArr2;
@property (nonatomic,strong) NSMutableArray *cellArr3;
@property (nonatomic,strong) NSMutableArray *arrayInfo;
@property (nonatomic,strong) NSString *Str;
@property (nonatomic) CGFloat tempheight;
@property (nonatomic, strong) BXTextField *textfield;
@property (nonatomic, strong) XYNewWorkerPermissionViewController *workerVC;
@property (nonatomic, strong) NSArray *departments;
@property (nonatomic, strong) NSString *DepartmentId;
@property (nonatomic, strong) NSNumber *superRanks;
@property (nonatomic, strong) NSString *UnitTitle;
@end

@implementation AddMemberInfoVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    
    self.title = self.titleStr;
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
    [self.view addSubview:_baseView];
    
    userImg = [UIButton buttonWithType:UIButtonTypeCustom];
    userImg.tag = 100;
    userImg.frame = CGRectMake(12, 12, 150/2, 176/2);
    
    [userImg setImage:[UIImage imageNamed:@"head"] forState:UIControlStateNormal];
    [userImg addTarget:self action:@selector(picImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:userImg];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(userImg.right+12, userImg.top, kScreen_Width-(userImg.right+12), 44)];
    titleLab.textColor = [UIColor colorWithHexString:@"#848484"];
    titleLab.userInteractionEnabled = YES;
    titleLab.text = [NSString stringWithFormat:@"  %@", _Nick];
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:16];
    [_baseView addSubview:titleLab];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkAction)];
    [titleLab addGestureRecognizer:tap];
    
    UIImageView *editImg = [[UIImageView alloc] initWithFrame:CGRectMake(_baseView.width-12-24, 24, 24, 20)];
    editImg.image = [UIImage imageNamed:@"id"];
    [_baseView addSubview:editImg];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(titleLab.left, titleLab.bottom, titleLab.width, .5)];
    line1.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [_baseView addSubview:line1];
    
    UILabel *emailLab = [[UILabel alloc] initWithFrame:CGRectMake(userImg.right+12, line1.bottom, titleLab.width, 44)];
    emailLab.textColor = [UIColor colorWithHexString:@"#848484"];
    emailLab.text = [NSString stringWithFormat:@"  %@", _XiaoYinCode];
    emailLab.backgroundColor = [UIColor whiteColor];
    emailLab.userInteractionEnabled = YES;
    emailLab.font = [UIFont systemFontOfSize:16];
    [_baseView addSubview:emailLab];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkAction)];
    [emailLab addGestureRecognizer:tap1];
    
    // 身份证和照片部分
    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(12, emailLab.bottom+12, kScreen_Width-24, 0)];
    superView.backgroundColor = [UIColor whiteColor];
    [_baseView addSubview:superView];
    
    _textfield = [[BXTextField alloc] initWithFrame:CGRectMake(10, 0, superView.width-20, 34)];
    _textfield.textColor = [UIColor colorWithHexString:@"#cccccc"];
    [_textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textfield.font = [UIFont systemFontOfSize:14];
//    _textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textfield.textColor = [UIColor colorWithHexString:@"#333333"];
    _textfield.placeholder = @"请输入18位身份证号";
    [superView addSubview:_textfield];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(_textfield.left, 30, _textfield.width-12, .5)];
    line2.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [superView addSubview:line2];
    
    UIButton *identityImg = [UIButton buttonWithType:UIButtonTypeCustom];
    identityImg.frame = CGRectMake(line2.right+3, 13, 12, 15);
    [identityImg setImage:[UIImage imageNamed:@"validation_grey"] forState:UIControlStateNormal];
    [identityImg setImage:[UIImage imageNamed:@"validation_green"] forState:UIControlStateSelected];
    [superView addSubview:identityImg];
    
    frontImg = [UIButton buttonWithType:UIButtonTypeCustom];
    frontImg.tag = 101;
    frontImg.frame = CGRectMake(10, line2.bottom+10, 266/2, 166/2);
    frontImg.contentMode = UIViewContentModeScaleAspectFill;
    [frontImg setImage:[UIImage imageNamed:@"id_before"] forState:UIControlStateNormal];
    [frontImg addTarget:self action:@selector(picImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:frontImg];
    
    reverseImg = [UIButton buttonWithType:UIButtonTypeCustom];
    reverseImg.tag = 102;

    reverseImg.frame = CGRectMake(superView.width-10-266/2, line2.bottom+10, 266/2, 166/2);
    [reverseImg setImage:[UIImage imageNamed:@"id_after"] forState:UIControlStateNormal];
    [reverseImg addTarget:self action:@selector(picImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:reverseImg];
    
    superView.height = reverseImg.bottom+10;
    _baseView.height = superView.bottom+12;
    
    _cellArr1 = @[@"姓名",@"工号",@"手机",@"性别",@"出生日期",@"地址",@"单元",@"职位"];
    
    // 表视图
    self.approveTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:UITableViewStylePlain];
    self.approveTable.tableHeaderView = _baseView;
    self.approveTable.tableFooterView = [UIView new];
    self.approveTable.delegate = self;
    self.approveTable.dataSource = self;
    self.approveTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.approveTable];
    
    //导航栏的下一步按钮
    [self initRightBtn];
    
}



- (void)initData {
    _workerVC = [[XYNewWorkerPermissionViewController alloc]init];
    _cellArr2 = [NSMutableArray arrayWithObjects:@"输入真实姓名",@"输入员工号",@"输入号码",@"选择性别",@"选择日期",@"输入地址",@"选择单元",@"选择职位", nil];
    _cellArr3 = [NSMutableArray arrayWithObjects:@"$",@"$",@"$",@"$",@"$",@"$",@"$",@"$", nil];
    _arrayInfo = [NSMutableArray array];
}

//导航栏的下一步按钮
- (void)initRightBtn {
    NSNumber *role = [UserInfo getUserRole];
    if ([role isEqual:@96] || [role isEqual:@128]) {
        //此账户有权限管理的权限，可以下一步，设置权限后保存
        UIBarButtonItem *rightBarButtonItem1 = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem1;
    }
    else {
        //没有权限管理的权限直接保存
        UIBarButtonItem *rightBarButtonItem2 = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(KeepURLAction)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem2;
    }

    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)rightBtnAction:(UIButton *)btn {
    if (_birthday == nil) {
        _birthday = @"";
    }
    _workerVC.joinId = _JoinID;
    _workerVC.licenseNumber = _textfield.text;
    _workerVC.licenseCarFrontUrl = _frontStr;
    _workerVC.licenseCarBackUrl = _backStr;
    _workerVC.faceUrl = _iconStr;
    _workerVC.name = _name;
    _workerVC.gender = _gender;
    _workerVC.mobile = _mobile;
    _workerVC.birthday = _birthday;
    _workerVC.address =  _readyAddress;
// 这几个参数  目前没有数据
//    _workerVC.status =
    _workerVC.memo = _Str;
    _workerVC.employeeNo = _employeeNo;
    _workerVC.departmentId = _DepartmentId;
    _workerVC.companyJobId = _companyJobId;

    [self whetherThroughAction:nil];
}

//添加成员信息
- (void)KeepURLAction {
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setValue:_JoinID forKey:@"joinId"];
    [paraDic setValue:_textfield.text forKey:@"licenseNumber"];
    [paraDic setValue:_frontStr forKey:@"licenseCarFrontUrl"];
    [paraDic setValue:_backStr forKey:@"licenseCarBackUrl"];
    [paraDic setValue:_iconStr forKey:@"faceUrl"];
    [paraDic setValue:_name forKey:@"name"];
    [paraDic setValue:_gender forKey:@"gender"];
    [paraDic setValue:_mobile forKey:@"mobile"];
    [paraDic setValue:_birthday forKey:@"birthday"];
    [paraDic setValue:_readyAddress forKey:@"address"];
    [paraDic setValue:_Str forKey:@"memo"];
    [paraDic setValue:_employeeNo forKey:@"employeeNo"];
    [paraDic setValue:_DepartmentId forKey:@"departmentId"];
    [paraDic setValue:_companyJobId forKey:@"companyJobId"];
    
    [self whetherThroughAction:paraDic];
}


- (void)whetherThroughAction:(NSMutableDictionary *)paraDic {
    if (_iconStr == nil) {
        [MBProgressHUD showMessage:@"头像不能为空" toView:self.view];
    }else
        if (_textfield.text.length > 0 && ![RegexTool validateIdentityCard:_textfield.text]) {
            [MBProgressHUD showMessage:@"身份证输入不正确！" toView:self.view];
        }else
            if (_name == nil || [_name isEqualToString:@""]) {
                [MBProgressHUD showMessage:@"姓名不能为空" toView:self.view];
            }else
                if (_mobile.length > 0 && ![RegexTool validateUserPhone:_mobile]){
                    [MBProgressHUD showError:@"手机号不正确！" toView:self.view];
                }else
                    if (_gender == nil ) {
                        [MBProgressHUD showMessage:@"性别不能为空" toView:self.view];
                    }else
                        if (_DepartmentId == nil ) {
                            [MBProgressHUD showMessage:@"单元不能为空" toView:self.view];
                        }else
                            if (_companyJobId == nil ) {
                                [MBProgressHUD showMessage:@"职位不能为空" toView:self.view];
                            }else
                            {
                                //有权限管理的权限，可以下一步
                                if (paraDic == nil) {
    
                                    [self getManagerProfileId];
                                    [self.navigationController pushViewController:_workerVC animated:YES];
                                    
                                }else {
                                    
                                    //无权限管理的权限，直接保存
                                    [AFNetClient POST_Path:KeepURL params:paraDic completed:^(NSData *stringData, id JSONDict) {
                                        NSNumber *code = JSONDict[@"Code"];
                                        if ([code isEqual:@0]) {
                                            [self getAllEmployeeMessage];
                                     
                                        }else {
                                            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
                                        }
                                    } failed:^(NSError *error) {
                                        NSLog(@"---------------------->>>>>>%@",error);
                                    }];
                                }

                            }
}

- (void)getManagerProfileId {
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    for (NSMutableDictionary *dic in arr) {
        if ([dic[@"DepartmentId"] isEqualToString:_DepartmentId]) {
            _workerVC.ManagerProfileId = dic[@"ManagerProfileId"];
        }
    }
}

- (void)getAllEmployeeMessage {
    [self getManagerProfileId];
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
                if ([_DepartmentId isEqualToString:@""]) {
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
                    if ([dic[@"DepartmentId"] isEqualToString:_DepartmentId] || [_workerVC.ManagerProfileId isEqualToString:dic[@"ProfileId"]]) {
                        EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
                        [arrM1 addObject:model];
                        
                        if ([dic[@"DepartmentId"] isEqualToString:_DepartmentId] && [_workerVC.ManagerProfileId isEqualToString:dic[@"ProfileId"]]) {
                            model.isMastLeader = YES;
                        } else if ([_workerVC.ManagerProfileId isEqualToString:dic[@"ProfileId"]])
                        {
                            model.isConcurrentLeader = YES;
                        }
                    }
                }
            }
            self.blockKeepYON(@"YES");
            [self popViewController:@"NewcolleaguesVC"];
        }
    } failed:^(NSError *error) {
    }];
}




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return [_cellArr2 count];

    } else {
        
        return 1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && _tempheight > 17) {
        return _tempheight + 32;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
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

    } else {
        if (_Str.length > 0) {
            NSDictionary *attrs = @{NSFontAttributeName:cell.textLabel.font};
            CGFloat labelWidth = kScreen_Width - 24;
            CGSize maxSize = CGSizeMake(labelWidth, 0);
            CGSize size = [_Str boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
            _tempheight = size.height;
            cell.height = size.height + 32;
            cell.textLabel.frame = CGRectMake(12, 12, size.width, size.height);
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = _Str;
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        }else {
            _tempheight = 0;
            cell.textLabel.text = @"输入备注内容";
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ((indexPath.section == 0 && indexPath.row < 3) || indexPath.section == 1 || (indexPath.section == 0 && indexPath.row == 5)) {

        InputMemberInfoVC *inputMemberInfoVC =[[InputMemberInfoVC alloc] init];
        inputMemberInfoVC.valueBlock = ^(NSString *tempStr) {
            if (indexPath.section == 1) {
                if ([tempStr isEqualToString:@"$"]) {
                    _Str = @"";
                }else {
                    _Str = tempStr;
                }
            }else {
                switch (indexPath.row) {
                    case 0:
                        if ([tempStr isEqualToString:@"$"]) {
                            _name = @"";
                            _cellArr2[0] = @"输入真实姓名";
                            _cellArr3[0] = @"$";
                        }else {
                            _name = tempStr;
                            _cellArr2[0] = tempStr;
                            _cellArr3[0] = tempStr;
                        }
                        
                        break;
                    case 1:
                        if ([tempStr isEqualToString:@"$"]) {
                            _employeeNo = @"";
                            _cellArr2[1] = @"输入员工号";
                            _cellArr3[1] = @"$";
                        }else {
                            _employeeNo = tempStr;
                            _cellArr2[1] = tempStr;
                            _cellArr3[1] = tempStr;
                        }
                        
                        break;
                    case 2:
                        if ([tempStr isEqualToString:@"$"]) {
                            _mobile = @"";
                            _cellArr2[2] = @"输入手机号";
                            _cellArr3[2] = @"$";
                        }else {
                            _mobile = tempStr;
                            _cellArr2[2] = tempStr;
                            _cellArr3[2] = tempStr;
                        }
                        
                        break;
                    case 5:
                        if ([tempStr isEqualToString:@"$"]) {
                            _readyAddress = @"";
                            _cellArr2[5] = @"输入地址";
                            _cellArr3[5] = @"$";
                        }else {
                            _readyAddress = tempStr;
                            _cellArr2[5] = tempStr;
                            _cellArr3[5] = tempStr;
                        }
                        break;
                    default:
                        break;
            }
            }
            [tableView reloadData];
        };
        
        if (indexPath.section == 1) {
            inputMemberInfoVC.DetailOfCell = _Str;
        }else {
            if (![_cellArr3[indexPath.row] isEqualToString:@"$"]) {
                inputMemberInfoVC.DetailOfCell = _cellArr2[indexPath.row];
            }
        }
   
        inputMemberInfoVC.indexPath = indexPath;
        [self.navigationController pushViewController:inputMemberInfoVC animated:YES];
    }
    
    if (indexPath.row == 3) {
        PopViewVC *popViewVC  = [[PopViewVC alloc] init];
        popViewVC.titleArr = @[@"男",@"女"];
        popViewVC.clickBlock = ^(NSInteger indexRow) {
            if (indexRow == 0) {
                _gender = @"1";
                _cellArr2[3] = @"男";
                _cellArr3[3] = @"男";
            } else {
                _gender = @"2";
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
    if (indexPath.row == 4) {
        
        //日期选择视图
        ZWLDatePickerView *datepickerView = [[ZWLDatePickerView alloc] initWithFrame:CGRectMake(0,kScreen_Height - 270, kScreen_Width, 270)];
        if (![_cellArr3[4] isEqualToString:@"$"]) {
            datepickerView.dateStr = _cellArr3[4];
        }
        datepickerView.dataBlock = ^(NSString *dateStr){
            _cellArr2[4] = dateStr;
            _cellArr3[4] = dateStr;
            NSString *str = @" 00:00:00";
            _birthday = [NSString stringWithFormat:@"%@%@",dateStr, str];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        BirthdayController *birthdayCtrl = [[BirthdayController alloc] init];
        birthdayCtrl.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//      self.definesPresentationContext = YES; //不盖住整个屏幕
        birthdayCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        birthdayCtrl.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [birthdayCtrl.view addSubview:datepickerView];
      
        [self presentViewController:birthdayCtrl animated:YES completion:nil];
    }
    
    if (indexPath.row == 6) {
        SelectUnitVC *selectUnitVC = [[SelectUnitVC alloc]init];
        selectUnitVC.superRanks = _superRanks;
        selectUnitVC.superTitle = _UnitTitle;
        selectUnitVC.ParentID = _DepartmentId;
        selectUnitVC.superRanks = @0;
        selectUnitVC.comanyName = [UserInfo getcompanyName];
        selectUnitVC.title = @"选择单元";
        [self.navigationController pushViewController:selectUnitVC animated:YES];
        selectUnitVC.sendUnitBlock = ^(DepartmentModel *model) {
            _DepartmentId = model.ParentID;
            _superRanks = model.superRanks;

            _UnitTitle = model.superTitle;
            _cellArr2[6] = model.superTitle;
            _cellArr3[6] = model.superTitle;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        };

    }
    if (indexPath.row == 7) {
        
        XYPositionViewController *positionVc = [[XYPositionViewController alloc] init];
        [positionVc getJobMessageWithOldJobName:nil successBlock:^(XYJobModel *jobModel) {
            _companyJobId = jobModel.jobId;
            _cellArr2[7] = jobModel.jobName;
            _cellArr3[7] = jobModel.jobName;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }];
        
        [self.navigationController pushViewController:positionVc animated:YES];
    }
}


//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 35)];
        view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        
        //组标题
        UILabel *sectionLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, 150, 20)];
        sectionLab.font = [UIFont systemFontOfSize:14];
        sectionLab.textColor = [UIColor colorWithHexString:@"#848484"];
        sectionLab.text = @"备注";
        [view addSubview:sectionLab];
        
        return view;
    }
}


- (void)checkAction
{
    CheckPersonInfo *checkPersonInfo = [[CheckPersonInfo alloc] init];
    checkPersonInfo.Nick = _Nick;
    checkPersonInfo.XiaoYinCode = _XiaoYinCode;
    checkPersonInfo.Singer = _Singer;
    checkPersonInfo.region = _region;
     checkPersonInfo.FaceUrl = _FaceUrl;
    checkPersonInfo.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    checkPersonInfo.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //self.definesPresentationContext = YES; //不盖住整个屏幕
    checkPersonInfo.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:checkPersonInfo animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate

//选取后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
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
        NSLog(@"---------------------->>>>>>%@",JSONDict);
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0]) {

            if (self.tempBtn.tag == 100) {
                
                _iconStr = JSONDict[@"Data"][@"FormatUrl"];
                [userImg setImage:img forState:UIControlStateNormal];
            }else if (self.tempBtn.tag == 101) {
                
                _frontStr = JSONDict[@"Data"][@"FormatUrl"];
                [frontImg setImage:img forState:UIControlStateNormal];
            }else {
                
                _backStr = JSONDict[@"Data"][@"FormatUrl"];
                [reverseImg setImage:img forState:UIControlStateNormal];

            }
            [_hud setHidden:YES];
        }else {
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
        }
    } failed:^(NSError *error) {
        [_hud setHidden:YES];
        NSLog(@"---------------------->>>>>>%@",error);
    }];

    //    [app.tabvc showCustomTabbar];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//取消后调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)picImageAction:(UIButton *)btn
{
    self.tempBtn = btn;
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

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _textfield) {
        if (textField.text.length > 18) {
            textField.text = [textField.text substringToIndex:18];
        }
    }
}

@end
