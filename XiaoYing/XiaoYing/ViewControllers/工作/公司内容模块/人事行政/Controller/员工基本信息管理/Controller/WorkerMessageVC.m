//
//  MaintainCompanyinfoVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/21.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "WorkerMessageVC.h"
#import "MulSelectPeopleVC.h"
#import "DepartmentTableViewCell.h"
#import "EmployeeCell.h"
#import "XYSearchBar.h"
#import "DepartmentModel.h"
#import "EmployeeModel.h"
#import "HXTagsView.h"
#import "XYWorkSetLeaderVc.h"
#import "EditDetailOfMemberVC.h"
#import "ManagerListVC.h"
#import "DepartManagerAuthorityCell.h"
#import "AuthoritySettingVC.h"
#import "SearchEmployeeView.h"


@interface WorkerMessageVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    DepartmentModel *_model;
}

@property (nonatomic,strong) UIView *baseView;
@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong)XYSearchBar *searchBar;

@property (nonatomic, strong)UILabel *companyLabel;
@property (nonatomic, strong)UILabel *unitLabel;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *okBtn;

@property (nonatomic, assign)BOOL isCompany;
@property (nonatomic, strong)NSMutableArray *navArr;
@property (nonatomic, strong)NSMutableArray *navArrSingle;
@property (nonatomic,copy) NSString *CompanyId;

@property (nonatomic,strong) NSArray *departments;
@property (nonatomic,strong) NSArray *employees;
@property (nonatomic,strong) NSArray *subUnitArray;
@property (nonatomic,strong) NSArray *employeeArray;
@property (nonatomic, copy)NSString *CompanyName;
@property (nonatomic, strong) NSNumber *superRanks;
@property (nonatomic, strong) NSMutableArray *ManagerProfileIdArray;


@property (strong, nonatomic) SearchEmployeeView *searchView;


@end

@implementation WorkerMessageVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ManagerProfileIdArray = [NSMutableArray array];
    
    
    // 初始化数据
    [self initData];
    
    [self initBasic];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:@"refershWorkerMessageVC" object:nil];
}




- (void)initData
{
    self.CompanyName = [UserInfo getcompanyName];

    // 先加入公司名
    _navArr = [NSMutableArray arrayWithObject:[UserInfo getcompanyName]];
    
    // 所有部门
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    self.departments = arr;
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        if ([dic[@"ParentID"] isEqualToString:@""]) {
            DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
            [arrM addObject:model];
        }
        if (![dic[@"ManagerProfileId"] isEqualToString:@""]) {
            [_ManagerProfileIdArray addObject:dic[@"ManagerProfileId"]];
        }
    }
    self.subUnitArray = arrM;
    
    // 所有员工
    NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
    self.employees = employeesArr;
    NSMutableArray *arrM1 = [NSMutableArray array];
    for (NSDictionary *dic in employeesArr) {
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
    self.employeeArray = arrM1;
    _model = [[DepartmentModel alloc] init];
    _model.DepartmentId = @"";
    _model.Title = @"";
    [_tableView reloadData];
}


- (void)initBasic {
    
    UIView *baseView = [self firstHeaderView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = baseView;
    
    if (![self.title isEqual: @"权限管理"]) {
        //设置领导人
        _tableView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-44);
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.frame = CGRectMake(0, kScreen_Height-44-64, kScreen_Width, 44);
        [okBtn setTitle:@"设置领导人" forState:UIControlStateNormal];
        okBtn.backgroundColor = [UIColor whiteColor];
        [okBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [okBtn addTarget:self action:@selector(setLeader) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:okBtn];
        //间隔线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [okBtn addSubview:lineView];
    }else {
        _tableView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height-64);
        UIButton *newCreate = [UIButton buttonWithType:UIButtonTypeCustom];
        newCreate.frame = CGRectMake(0, 0, 30, 30);
        [newCreate setImage:[UIImage imageNamed:@"administrator_white"] forState:UIControlStateNormal];
        [newCreate addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newCreate];
    }
}

-(void)setLeader{
    if (!_model) {
        _model = [[DepartmentModel alloc] init];
        _model.DepartmentId = @"";
        _model.Title = @"";
    }
    //设置领导人
    XYWorkSetLeaderVc * setLeaderVc = [[XYWorkSetLeaderVc alloc]init];
    setLeaderVc.model = _model;
    setLeaderVc.departments = self.departments;
    setLeaderVc.employees = self.employees;
    setLeaderVc.comanyName = self.CompanyName;
    [self.navigationController pushViewController:setLeaderVc animated:YES];
    setLeaderVc.refershDataBlock = ^(NSMutableArray *array, NSMutableArray *array1, NSArray *array2) {
        _employeeArray = array;
        _departments = array1;
        _employees = array2;
        [_tableView reloadData];
    };
}

- (void)btnAction:(UIButton *)btn {
    ManagerListVC *managerListVC = [[ManagerListVC alloc] init];
    managerListVC.departments = self.departments;
    managerListVC.ManagerProfileIdArray = _ManagerProfileIdArray;
    [self.navigationController pushViewController:managerListVC animated:YES];
}

#pragma mark --tableViewDelegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return _subUnitArray.count;
        
    }
    else {
        return _employeeArray.count;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 所有部门
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    self.departments = arr;
    
    // 所有员工
    NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
    self.employees = employeesArr;
    
    DepartmentModel *lastModel = nil;
    if (indexPath.section == 0) {
        
        lastModel = self.subUnitArray[indexPath.row];
        _model = lastModel;
        
        NSString *tagTitle = [NSString stringWithFormat:@" > %@",lastModel.Title];
        [_navArr addObject:tagTitle];
        UIView *baseView = [self secondHeaderView:_navArr];
        _tableView.tableHeaderView = baseView;
        
        // 下一层数据(部门)
        NSMutableArray *arrM1 = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            
            if ([lastModel.DepartmentId isEqualToString:dic[@"ParentID"]]) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                
                [arrM1 addObject:model];
            }
        }
        _subUnitArray = arrM1;
        
        // 下一层数据(员工)
        NSMutableArray *arrM2 = [NSMutableArray array];
        for (NSDictionary *dic in employeesArr) {
            
            if ([dic[@"DepartmentId"] isEqualToString:lastModel.DepartmentId] || [lastModel.ManagerProfileId isEqualToString:dic[@"ProfileId"]]) {
                EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
                [arrM2 addObject:model];
                
                if ([dic[@"DepartmentId"] isEqualToString:lastModel.DepartmentId] && [lastModel.ManagerProfileId isEqualToString:dic[@"ProfileId"]]) {
                    // 领导人置顶
                    [arrM2 removeObject:model];
                    [arrM2 insertObject:model atIndex:0];
                    model.isMastLeader = YES;
                } else if ([lastModel.ManagerProfileId isEqualToString:dic[@"ProfileId"]])
                {
                    // 领导人置顶
                    [arrM2 removeObject:model];
                    [arrM2 insertObject:model atIndex:0];
                    model.isConcurrentLeader = YES;

                }
            }
        }
        _employeeArray = arrM2;
        [_tableView reloadData];
    }
    else {
        if ([self.title isEqualToString:@"权限管理"]) {
            EmployeeModel *model = self.employeeArray[indexPath.row];
            AuthoritySettingVC *auhVC = [[AuthoritySettingVC alloc] init];
            NSNumber *userRole = [UserInfo getUserRole];
            NSLog(@"---11------------------%@（当前用户用户）-----%@",userRole,model.RoleType);
            //参数RoleType 128为创建者  64为管理员    2普通员工
            if ([userRole isEqual:@128]) {
                //用户是创建者时
                if ([model.RoleType isEqual:@128]) {
                    
                    if ([model.ProfileId isEqualToString:[UserInfo userID]]) {
                        [MBProgressHUD showMessage:@"您已拥有所有权限 !" toView:self.view];
                    }
                }else {
                    auhVC.model = model;
                    auhVC.departmentName = _model.Title;
                    auhVC.tempDepartmentId = _model.DepartmentId;
                    auhVC.ManagerProfileId = _model.ManagerProfileId;
                    if ([_ManagerProfileIdArray containsObject:model.ProfileId]) {
                        auhVC.isManagerYesOrNo = @"YES";
                    }
                    [self.navigationController pushViewController:auhVC animated:YES];
                }
            }
            else
                if ([userRole isEqual:@96]) {
                //用户是超级管理员时
                    if ([model.RoleType isEqual:@2] || [model.RoleType isEqual:@64] ) {
                        auhVC.model = model;
                        auhVC.departmentName = _model.Title;
                        auhVC.tempDepartmentId = _model.DepartmentId;
                        auhVC.ManagerProfileId = _model.ManagerProfileId;
                        if ([_ManagerProfileIdArray containsObject:model.ProfileId]) {
                            auhVC.isManagerYesOrNo = @"YES";
                        }
                        [self.navigationController pushViewController:auhVC animated:YES];
                    }else
                    {
                    if ([model.ProfileId isEqualToString:[UserInfo userID]]) {
                        [MBProgressHUD showMessage:@"您不能设置自己的权限 !" toView:self.view];
                    }else {
                        [MBProgressHUD showMessage:@"您无权管理其权限 !" toView:self.view];
                    }
                }
            }
        } else {
            NSNumber *number = [NSNumber numberWithInteger:_navArr.count];
            EmployeeModel *model = self.employeeArray[indexPath.row];
            EditDetailOfMemberVC *editVC = [[EditDetailOfMemberVC alloc] init];
            editVC.employeeModel = model;
            editVC.superRanks = number;
            editVC.tempDepartmentId = _model.DepartmentId;
            editVC.ManagerProfileId = _model.ManagerProfileId;
            editVC.referMember = ^(NSMutableArray *array, NSMutableArray *array1) {
                _employees = array1;
                _employeeArray = array;
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            };
            
            [self.navigationController pushViewController:editVC animated:YES];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    __weak typeof(self) weakSelf = self;
    
    DepartmentTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"DepartmentTableViewCell"];
    EmployeeCell *cell2 =[tableView dequeueReusableCellWithIdentifier:@"EmployeeCell"];
    if (indexPath.section == 0) {
        if (cell1 == nil) {
            cell1 = [[DepartmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DepartmentTableViewCell"];
        }
        
        DepartmentModel *model = _subUnitArray[indexPath.row];
        cell1.model = model;
        cell1.companyLabel.text = model.Title;
        cell1.unitLabel.text = [NSString stringWithFormat:@"%@级单元",model.Ranks];
        cell1.type = 2;
        
        
        //    cell.departments = self.departments;
        if (indexPath.row == 0) {
            cell1.upLineLabel.hidden = YES;
        }
        else {
            cell1.upLineLabel.hidden = NO;

        }
        if (indexPath.row == _subUnitArray.count - 1) {
            cell1.downLineLabel.hidden = YES;
        }
        else {
            cell1.downLineLabel.hidden = NO;
        }
        
        return cell1;
    } else {
        if (cell2 == nil) {
            cell2 = [[EmployeeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmployeeCell"];
        }
        EmployeeModel *model = _employeeArray[indexPath.row];
        cell2.currentDepartmentId = _model.DepartmentId;
        
        if ([self.title isEqualToString:@"权限管理"]) {
            cell2.type = 2;

        } else {
            cell2.type = 1;

        }
        cell2.model = model;

        
        return cell2;
    }
}

//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else {
        return 12;
    }
}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 12)];
        view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        return view;
    }
    
}



#pragma mark HXTagsViewDelegate

/**
 *  tagsView代理方法
 *
 *  @param tagsView tagsView
 *  @param sender   tag:sender.titleLabel.text index:sender.tag
 */
- (void)tagsViewButtonAction:(HXTagsView *)tagsView button:(UIButton *)sender {
    
    // 所有部门
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    self.departments = arr;
    
    // 所有员工
    NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
    self.employees = employeesArr;
    
    NSLog(@"tag:%@ index:%ld",sender.titleLabel.text,(long)sender.tag);
    NSInteger index = [_navArr indexOfObject:sender.titleLabel.text];
    NSInteger count = _navArr.count;
    
    NSString *text = nil;
    if (index > 0) {
        text = [sender.titleLabel.text substringFromIndex:3];

    }
    else {
        text = sender.titleLabel.text;
    }
    
    [_navArr removeObjectsInRange:NSMakeRange(index+1, count-(index+1))];

    NSMutableArray *arrM = [NSMutableArray array];
    NSMutableArray *arrM1 = [NSMutableArray array];
    if (index == 0) {
        
        // 切换上级单元
        _model.DepartmentId = @"";
        _model.Title = @"";
        _model.NodeLevel = @1;
        
        UIView *baseView = [self firstHeaderView];
        self.unitLabel.text = [NSString stringWithFormat:@"1级单元"];
        
        self.companyLabel.text = self.CompanyName;
        _tableView.tableHeaderView = baseView;
        
        // 部门
        for (NSDictionary *dic in arr) {
            if ([dic[@"ParentID"] isEqualToString:@""]) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                [arrM addObject:model];
            }
        }
        
        // 员工
        for (NSDictionary *dic in employeesArr) {
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
    }
    else {
        
        UIView *baseView = [self secondHeaderView:_navArr];
        _tableView.tableHeaderView = baseView;
        
        NSDictionary *superDic = nil;
        for (NSDictionary *dic in arr) {
            
            if ([text isEqualToString:dic[@"Title"]]) {
                superDic = dic;
                
                // 切换上级单元
                _model.DepartmentId = @"";
                _model.Title = dic[@"Title"];
                _model.DepartmentId = dic[@"DepartmentId"];
                _model.ManagerProfileId = dic[@"ManagerProfileId"];
                _model.NodeLevel = dic[@"NodeLevel"];
            }
        }
        // 部门
        for (NSDictionary *dic in arr) {
            
            if ([superDic[@"DepartmentId"] isEqualToString:dic[@"ParentID"]]) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                [arrM addObject:model];
            }
        }
        // 员工
        for (NSDictionary *dic in employeesArr) {
            
            if ([dic[@"DepartmentId"] isEqualToString:superDic[@"DepartmentId"]] || [superDic[@"ManagerProfileId"] isEqualToString:dic[@"ProfileId"]]) {
                EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
                [arrM1 addObject:model];
                
                if ([dic[@"DepartmentId"] isEqualToString:superDic[@"DepartmentId"]] && [superDic[@"ManagerProfileId"] isEqualToString:dic[@"ProfileId"]]) {
                    model.isMastLeader = YES;
                } else if ([superDic[@"ManagerProfileId"] isEqualToString:dic[@"ProfileId"]])
                {
                    model.isConcurrentLeader = YES;
                    
                }
            }
        }
        
    }
    _subUnitArray = arrM;
    _employeeArray = arrM1;
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (XYSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[XYSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"找人";
        
    }
    return _searchBar;
}


- (UIView *)firstHeaderView
{
    UIView *baseView = nil;
    if (![self.title isEqual: @"权限管理"]) {
        // 头视图
        baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 56+44)];
        //搜索框
        [baseView addSubview:self.searchBar];
    }
    else {
        // 头视图
        baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 56)];
        self.searchBar.bottom = 0;
    }

//    self.baseView = baseView;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, kScreen_Width, 44)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:whiteView];
    
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 6, kScreen_Width - 56, 16)];
    //    companyLabel.text = @"杭州赢莱金融服务有限公司";
    companyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    companyLabel.font = [UIFont systemFontOfSize:14];
    companyLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:companyLabel];
    self.companyLabel = companyLabel;
    self.companyLabel.text = self.CompanyName;
    
    
    UILabel *unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 26, kScreen_Width / 2, 12)];
    //    unitLabel.text = @"4级单元";
    unitLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    unitLabel.font = [UIFont systemFontOfSize:12];
    unitLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:unitLabel];
    self.unitLabel = unitLabel;
    self.unitLabel.text = [NSString stringWithFormat:@"1级单元"];
    
    return baseView;
}


- (UIView *)secondHeaderView:(NSMutableArray *)arrM
{
    // 更换头视图
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
    
    //搜索框
    [baseView addSubview:self.searchBar];
//    self.baseView = baseView;

    
    //多行不滚动,则计算出全部展示的高度,让maxHeight等于计算出的高度即可,初始化不需要设置高度
    HXTagsView *tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, self.view.frame.size.width, 0)];
    tagsView.type = 0;
    [tagsView setTagAry:arrM delegate:self];
    [baseView addSubview:tagsView];
    baseView.height = tagsView.bottom;
    return baseView;
    
}

- (SearchEmployeeView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchEmployeeView alloc] initWithFrame:CGRectMake(0, 44, kScreen_Width, kScreen_Height-64-44)];
        _searchView.model = _model;
        _searchView.superRanks = @(_navArr.count);
        __weak typeof(self) weakSelf = self;
        _searchView.searchBlock = ^(void) {
            [weakSelf searchBarCancelButtonClicked:weakSelf.searchBar];
        };
        _searchView.referMember = ^(NSMutableArray *array, NSMutableArray *array1) {
            
//            [weakSelf searchBarCancelButtonClicked:weakSelf.searchBar];

            //                _employees = array1;
            _employeeArray = array;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        };
        if ([self.title isEqualToString:@"权限管理"]) {
//            _searchView.clickAction = ClickActionFour;
//            _searchView.ManagerProfileIdArray = self.ManagerProfileIdArray;
//            _searchView.departments = self.departments;
            
        } else {
            _searchView.clickAction = ClickActionOne;
            
        }
    };
    return _searchView;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchBar.showsCancelButton = YES;
    [self.searchView.approveTable reloadData];
    [self.view addSubview:self.searchView];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *tempResults = [NSMutableArray array];

    for (NSDictionary *dic in self.employees) {
        if ([dic[@"EmployeeName"] containsString:searchText]) {
            
            EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
            [tempResults addObject:model];
 
        }
    }
    self.searchView.approveArr = tempResults;
    [self.searchView.approveTable reloadData];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
//    [self.searchView.approveArr removeAllObjects];
//    self.searchView.approveArr = nil;
    [self.searchView removeFromSuperview];
    self.searchView = nil;
    //    _searchBar.frame = CGRectMake(0, 64, kScreen_Width, 44);
    
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self searchBarCancelButtonClicked:_searchBar];
}





@end
