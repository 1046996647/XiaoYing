//
//  XYWorkSetLeaderVc.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/7/29.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "XYWorkSetLeaderVc.h"
#import "SingleSelectPeopleVC.h"
#import "HaveLeaderdoubtVC.h"
#import "XYPositionViewController.h"
#import "XYJobModel.h"
#import "DeleteViewController.h"


@interface XYWorkSetLeaderVc ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

{
    UIView * _header;
    NSArray* _titleArray;
    NSArray * _detailArray;
    NSArray * _nameArray;
    NSArray * _miniNameArray;
}
//@property(nonatomic,strong)XYWorkerSearch * search;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSString * concurrentJobName;
@property(nonatomic,strong)NSString * jobId;
@property(nonatomic,assign)BOOL isModifyJob;


@property (nonatomic,strong) MBProgressHUD *hud;


@end

@implementation XYWorkSetLeaderVc


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_model.Title);
    
//    _titleArray = @[@"领导人",@"职位"];
//    _detailArray = @[@"邹建",@"产品经理"];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.title = @"设置领导人";
    
    // 员工
    for (NSDictionary *dic in self.employees) {
        
        if ([_model.DepartmentId isEqualToString:@""]) {

            if ([[UserInfo GetTopLeaderOfCompany] isEqualToString:dic[@"ProfileId"]]) {// 公司领导人
                
                EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
//                model.isLeader = YES;
                model.isBelongToCurrentDepartment = YES;
                _empModel = model;
            }
        }
        else {
            
            if ([_model.ManagerProfileId isEqualToString:dic[@"ProfileId"]]) {// 当前部门是否有领导人
                
                EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
                model.isLeader = YES;
                
                if ([_model.DepartmentId isEqualToString:dic[@"DepartmentId"]]) {// 该领导人是否属于当前部门
                    model.isBelongToCurrentDepartment = YES;
                }
                
            }

        }
        
        
    }
    
    [self setNav];
    [self initUI];
    
}

-(void)setNav{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

-(void)initUI{
    
    NSString *str = @"该单元无领导人？";
    CGSize size1 =[str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width - 12 - size1.width, 12, size1.width, 30)];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    //    btn.backgroundColor = [UIColor cyanColor];
    btn.hidden = YES;
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#848484"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(haveLeader) forControlEvents:UIControlEventTouchUpInside];
    UIView *tablefooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
    [tablefooterView addSubview:btn];
    
    NSString * content = nil;
    if (![_model.DepartmentId isEqualToString:@""]) {
        content = _model.Title;

        if (_empModel.isLeader) {
            btn.hidden = NO;

        }
    }
    else {
        content = self.comanyName;
    }
    CGSize size = [content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    UILabel * companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, size.width, 14)];
    companyLabel.font = [UIFont systemFontOfSize:12];
    companyLabel.text = content;
    companyLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    companyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:companyLabel];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, companyLabel.bottom + 12, kScreen_Width, kScreen_Height - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = tablefooterView;
    
}

#pragma mark SEL
- (void)haveLeader {
    DeleteViewController *deleteViewController = [[DeleteViewController alloc] init];
    deleteViewController.titleStr = [NSString stringWithFormat:@"是否确定删除该单元领导人?"];
    deleteViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    deleteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    deleteViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:deleteViewController animated:YES completion:nil];
    deleteViewController.fileDeleteBlock = ^(void)
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        _hud.labelText = @"正在加载...";
        
        NSString *strUrl = [NSString stringWithFormat:@"%@&DepartmentId=%@",ClearLeaderURL, self.model.DepartmentId];
        [AFNetClient  POST_Path:strUrl completed:^(NSData *stringData, id JSONDict) {
            
            [_hud hide:YES];
            
            _empModel = nil;
            _model.ManagerProfileId = @"";

            [self GetDepartmentURlAction];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failed:^(NSError *error) {
            [_hud hide:YES];
            NSLog(@"请求失败Error--%@",error);
        }];
        
    };
    
}


-(void)saveButton {
    
    if (!_empModel) {
        [MBProgressHUD showMessage:@"未选择领导人"];
        return;
    }
    if (!self.empModel.isBelongToCurrentDepartment && !_concurrentJobName) {
        [MBProgressHUD showMessage:@"未选择兼任职位"];
        return;

    }
    
    [self SetLeaderURLAction];
    
}

//设置领导人
- (void)SetLeaderURLAction {
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"保存中...";
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.model.DepartmentId forKey:@"DepartmentId"];

    [paraDic setObject:self.empModel.ProfileId forKey:@"ProfileId"];
    [paraDic setObject:_jobId forKey:@"CompanyJobId"];
    
    [AFNetClient POST_Path:SetLeaderURL params:paraDic completed:^(NSData *stringData, id JSONDict) {
        
        NSNumber *code = JSONDict[@"Code"];
        if ([code isEqual:@1]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
        }else {

            if ([_model.DepartmentId isEqualToString:@""]) {
                
                [UserInfo saveTopLeaderOfCompany:_empModel.ProfileId];
                
                [self getAllEmployeeMessage];
            }
            else {
                
                _model.ManagerProfileId = _empModel.ProfileId;
                [self GetDepartmentURlAction];

            }
        }
        NSLog(@"%@", JSONDict);
    } failed:^(NSError *error) {
        NSLog(@"_______________________%@", error);
    }];
}

// 所有部门
- (void)GetDepartmentURlAction {
    
    [AFNetClient GET_Path:GetDepartmentURl completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            self.departments = JSONDict[@"Data"];
            [ZWLCacheData archiveObject:self.departments toFile:DepartmentsPath];
            
            [self getAllEmployeeMessage];

        }
    } failed:^(NSError *error) {
        [_hud hide:YES];
    }];
}

- (void)getAllEmployeeMessage {
    
    NSInteger pageIndex = 1;
    NSInteger pageSize = 1000;
    NSString *strURL = [GetAllEmployee stringByAppendingFormat:@"&pageIndex=%ld&PageSize=%ld",pageIndex, pageSize];
    //获取公司所有职员信息
    [AFNetClient GET_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        [_hud hide:YES];
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            self.employees = JSONDict[@"Data"];
            [ZWLCacheData archiveObject:self.employees toFile:EmployeesPath];
            
            NSMutableArray *arrM1 = [NSMutableArray array];
            
            if ([_model.DepartmentId isEqualToString:@""]) {
                
                for (NSDictionary *dic in self.employees) {
                    if ([dic[@"DepartmentId"] isEqualToString:@""] || [[UserInfo GetTopLeaderOfCompany] isEqualToString:dic[@"ProfileId"]]) {
                        EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
                        [arrM1 addObject:model];
                        
                        if ([dic[@"DepartmentId"] isEqualToString:@""] && [[UserInfo GetTopLeaderOfCompany] isEqualToString:dic[@"ProfileId"]]) {
                            // 领导人置顶
                            [arrM1 removeObject:model];
                            [arrM1 insertObject:model atIndex:0];
                            model.isMastLeader = YES;
                        } else if ([[UserInfo GetTopLeaderOfCompany] isEqualToString:dic[@"ProfileId"]])
                        {
                            model.isConcurrentLeader = YES;
                            
                        }
                    }
                }
            }
            else {
                for (NSDictionary *dic in self.employees) {
                    
                    if ([dic[@"DepartmentId"] isEqualToString:_model.DepartmentId] || [_empModel.ProfileId isEqualToString:dic[@"ProfileId"]]) {
                        EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
                        [arrM1 addObject:model];
                        
                        if ([dic[@"DepartmentId"] isEqualToString:_model.DepartmentId] && [_empModel.ProfileId isEqualToString:dic[@"ProfileId"]]) {
                            // 领导人置顶
                            [arrM1 removeObject:model];
                            [arrM1 insertObject:model atIndex:0];
                            model.isMastLeader = YES;
                        } else if ([_empModel.ProfileId isEqualToString:dic[@"ProfileId"]])
                        {
                            // 领导人置顶
                            [arrM1 removeObject:model];
                            [arrM1 insertObject:model atIndex:0];
                            model.isConcurrentLeader = YES;
                            
                        }
                    }
                }
                
            }
            
            if (self.refershDataBlock) {
                self.refershDataBlock(arrM1, self.departments.mutableCopy, self.employees);
                
            }
            [self popViewController:@"WorkerMessageVC"];
            
        }
    } failed:^(NSError *error) {
        
        [_hud hide:YES];
//        [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
        
    }];
}
#pragma mark tableView

//一个tableView里面有多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//一组tableView里面有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

//每行cell展示哪些数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#848484"];

    }
    
    if (indexPath.row == 0) {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        cell.textLabel.text = @"领导人";
        cell.detailTextLabel.text = self.empModel.EmployeeName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        
        if (_empModel.isBelongToCurrentDepartment) {
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
            cell.textLabel.text = @"职位";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
            
            // 主职
            for (NSDictionary *dic in _empModel.Jobs) {
                if ([dic[@"IsMastJob"] boolValue]) {
                    cell.detailTextLabel.text = dic[@"JobName"];
                    _jobId = dic[@"CompanyJobId"];
                }
            }


        }
        else {
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            cell.textLabel.text = @"兼任职位";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.userInteractionEnabled = YES;

            if (!_isModifyJob) {
                // 匹配兼职
                for (NSDictionary *dic in _empModel.Jobs) {
                    if ([_model.DepartmentId isEqualToString:dic[@"DepartmentId"]]) {
                        _concurrentJobName = dic[@"JobName"];
                        _jobId = dic[@"CompanyJobId"];
                        
                    }
                }
            }
            cell.detailTextLabel.text = _concurrentJobName;
            

        }
        
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        SingleSelectPeopleVC *singleSelectPeopleVC = [[SingleSelectPeopleVC alloc] init];
        singleSelectPeopleVC.title = @"选择领导人";
        singleSelectPeopleVC.comanyName = self.comanyName;
        singleSelectPeopleVC.model = self.model;
        singleSelectPeopleVC.empModel = self.empModel;
        singleSelectPeopleVC.departments = self.departments;
        singleSelectPeopleVC.employees = self.employees;
        [self.navigationController pushViewController:singleSelectPeopleVC animated:YES];
        singleSelectPeopleVC.sendEmployeeBlock  = ^(EmployeeModel *model) {
            NSLog(@"%@",model.EmployeeName);
            if ([_model.DepartmentId isEqualToString:model.DepartmentId]) {// 公司领导人或该领导人是否属于当前部门
                model.isBelongToCurrentDepartment = YES;
            }
            else {
                model.isBelongToCurrentDepartment = NO;

            }
            self.empModel = model;
            
            [tableView reloadData];
        };
    }
    
    else {
        
        XYPositionViewController *positionVc = [[XYPositionViewController alloc] init];
        [self.navigationController pushViewController:positionVc animated:YES];

        [positionVc getJobMessageWithOldJobName:_concurrentJobName successBlock:^(XYJobModel *jobModel) {
            NSLog(@"jobModel~~~!!!~~~%@", jobModel);
            
            _isModifyJob = YES;
            _concurrentJobName = jobModel.jobName;
            _jobId = jobModel.jobId;
            
            [tableView reloadData];

        }];
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

