//
//  MaintainCompanyinfoVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/21.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "MulSelectPeopleVC.h"
#import "DepartmentTableViewCell.h"
#import "EmployeeCell.h"
#import "XYSearchBar.h"
#import "DepartmentModel.h"
#import "EmployeeModel.h"
#import "HXTagsView.h"
#import "SelectedPeopleVC.h"
#import "SearchEmployeeView.h"



@interface MulSelectPeopleVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    MBProgressHUD *hud;
    DepartmentModel *_model;
    //    NSDictionary *_companyDic;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *baseView;

@property (nonatomic, strong)XYSearchBar *searchBar;

@property (nonatomic, strong)UILabel *companyLabel;
@property (nonatomic, strong)UILabel *unitLabel;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *okBtn;


@property (nonatomic, assign)BOOL isCompany;

@property (nonatomic, strong)NSMutableArray *navArr;

@property (strong, nonatomic) SearchEmployeeView *searchView;


@end

@implementation MulSelectPeopleVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //公司信息
    self.CompanyName = [UserInfo getcompanyName];
    self.CompanyRanks = @1;
    
    // 所有部门
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    self.departments = arr;
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dic in self.departments) {
        if ([dic[@"ParentID"] isEqualToString:@""]) {
            DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
            [arrM addObject:model];
        }
    }
    self.subUnitArray = arrM;
    
    // 所有员工
    NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
    self.employees = employeesArr;
    NSMutableArray *arrM1 = [NSMutableArray array];

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
                // 领导人置顶
                [arrM1 removeObject:model];
                [arrM1 insertObject:model atIndex:0];
                model.isConcurrentLeader = YES;
                
            }
        }
    }

    self.employeeArray = arrM1;
    
    // 先加入公司名
    _navArr = [NSMutableArray arrayWithObject:self.CompanyName];
    
    [self initBasic];
    
    [self initBottomView];
    
    [self initRightBtn];
    
    if (!self.selectedDepArr) {
        self.selectedDepArr = [NSMutableArray array];
    }
    
    if (!self.selectedEmpArr) {
        self.selectedEmpArr = [NSMutableArray array];
    }
    [self buttonStateChange];
    
    
}

- (void)initRightBtn
{
    UIButton *newCreate = [UIButton buttonWithType:UIButtonTypeCustom];
    newCreate.frame = CGRectMake(0, 0, 40, 30);
    [newCreate setTitle:@"已选" forState:UIControlStateNormal];
    [newCreate addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newCreate];
}

// 已选
-(void)btnAction:(UIButton *)btn {
    
    if (self.selectedEmpArr.count == 0) {
        [MBProgressHUD showMessage:@"未选择任何人"];
    }
    else {
        
        SelectedPeopleVC *selectedPeopleVC = [[SelectedPeopleVC alloc] init];
        selectedPeopleVC.employees = self.employees;
        selectedPeopleVC.selectedEmpArr = self.selectedEmpArr;
        selectedPeopleVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //淡出淡入
        selectedPeopleVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        self.definesPresentationContext = YES; //不盖住整个屏幕
        selectedPeopleVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [self presentViewController:selectedPeopleVC animated:YES completion:nil];
        
        selectedPeopleVC.sendBlock = ^(NSMutableArray *arrM) {
            
            [_tableView reloadData];
            [self buttonStateChange];
        };
    }
    
}


- (void)initBasic {
    
    UIView *baseView = [self firstHeaderView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = baseView;
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
    
    if (indexPath.section == 0) {
        
        // 所有部门
        NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
        self.departments = arr;
        
        DepartmentModel *lastModel = self.subUnitArray[indexPath.row];
        _model = lastModel;

        
        NSString *tagTitle = [NSString stringWithFormat:@" > %@",lastModel.Title];
        [_navArr addObject:tagTitle];
        
        UIView *baseView = [self secondHeaderView:_navArr];
        _tableView.tableHeaderView = baseView;
        
        // 下一层数据(部门)
        NSMutableArray *arrM1 = [NSMutableArray array];
        for (NSDictionary *dic in self.departments) {
            
            if ([lastModel.DepartmentId isEqualToString:dic[@"ParentID"]]) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                [arrM1 addObject:model];
            }
        }
        _subUnitArray = arrM1;
        
    
        // 所有员工
        NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
        self.employees = employeesArr;
        
        // 下一层数据(员工)
        NSMutableArray *arrM2 = [NSMutableArray array];
        for (NSDictionary *dic in self.employees) {
            
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
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    __weak typeof(self) weakSelf = self;
    
    DepartmentTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"DepartmentTableViewCell"];
    EmployeeCell *cell2 =[tableView dequeueReusableCellWithIdentifier:@"EmployeeCell"];
    
    if (indexPath.section == 0) {
        if (cell1 == nil) {
            cell1 = [[DepartmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DepartmentTableViewCell"];
            cell1.sendUnitBlock = ^(DepartmentModel *model)
            {
                NSLog(@"%@",model.DepartmentId);
                
                NSDictionary *superDic = nil;
                for (NSDictionary *dic in self.departments) {
                    
                    if ([model.DepartmentId isEqualToString:dic[@"DepartmentId"]]) {
                        superDic = dic;
                        
                    }
                }
                
                NSMutableArray *arrM = [NSMutableArray array];
                for (NSDictionary *dic in self.departments) {
                    
                    if ([model.DepartmentId isEqualToString:dic[@"ParentID"]]) {
                        [arrM addObject:dic];
                    }
                }
  
                
                if (model.isSelected) {
                    
                    if (![_selectedDepArr containsObject:superDic[@"DepartmentId"]]) {
                        [_selectedDepArr addObject:superDic[@"DepartmentId"]];
                        
                    }
                    
                    // 员工
                    [self searchEmp:superDic type:0];
                    
                    // 选中子单元
                    while (arrM.count > 0) {
                        arrM = [self searchDep:arrM type:0];
                        
                    }
                    
                    // 查找父单元
                    while (superDic) {
                        
                        superDic = [self search:superDic type:0];
                        
                    }
                    
                    
                }
                else {
                    
                    if ([_selectedDepArr containsObject:superDic[@"DepartmentId"]]) {
                        [_selectedDepArr removeObject:superDic[@"DepartmentId"]];
                        
                    }
                    // 员工
                    [self searchEmp:superDic type:1];
                    
                    // 移除子单元
                    while (arrM.count > 0) {
                        arrM = [self searchDep:arrM type:1];
                    }
                    
                    // 查找父单元
                    while (superDic) {
                        
                        superDic = [self search:superDic type:1];
                        
                    }
                    
                }
                
                [self buttonStateChange];
                
                [_tableView reloadData];
                
                if (self.selectedEmpArr.count == self.employees.count && self.selectedDepArr.count == self.departments.count) {
                    _selectBtn.selected = YES;
                }
                else {
                    _selectBtn.selected = NO;
                    
                }
            };
        }
        
        DepartmentModel *model = _subUnitArray[indexPath.row];
        cell1.model = model;
        cell1.companyLabel.text = model.Title;
        cell1.unitLabel.text = [NSString stringWithFormat:@"%@级单元",model.Ranks];
        cell1.type = 1;
        
        if ([_selectedDepArr containsObject:model.DepartmentId]) {
            model.isSelected = YES;
        }
        else {
            model.isSelected = NO;
        }
        
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
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell2.sendEmployeeBlock = ^(EmployeeModel *model)
            {
                
                NSDictionary *superDic = nil;
                for (NSDictionary *dic in self.departments) {
                    
                    if ([model.DepartmentId isEqualToString:dic[@"DepartmentId"]]) {
                        superDic = dic;
                        
                    }
                }

                if (model.isSelected) {
                    if (![_selectedEmpArr containsObject:model.ProfileId]) {
                        [_selectedEmpArr addObject:model.ProfileId];
                        
                    }
                    
                    // 查找父单元
                    while (superDic) {
                        
                        superDic = [self search:superDic type:0];
                        
                    }
                }
                else {
                    if ([_selectedEmpArr containsObject:model.ProfileId]) {
                        [_selectedEmpArr removeObject:model.ProfileId];
                        
                    }
                    
                    // 查找父单元
                    while (superDic) {
                        
                        superDic = [self search:superDic type:0];
                        
                    }
                }
                [self buttonStateChange];
                [_tableView reloadData];
                
                if (self.selectedEmpArr.count == self.employees.count && self.selectedDepArr.count == self.departments.count) {
                    _selectBtn.selected = YES;
                }
                else {
                    _selectBtn.selected = NO;
                    
                }
            };
        }
        
        EmployeeModel *model = _employeeArray[indexPath.row];
        cell2.model = model;
        cell2.currentDepartmentId = _model.DepartmentId;

        if ([_selectedEmpArr containsObject:model.ProfileId]) {
            model.isSelected = YES;
        }
        else {
            model.isSelected = NO;
        }
        
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

// 查找子单元的
// 递归遍历(0:加，1:减)
- (NSMutableArray *)searchDep:(NSMutableArray *)nextArr type:(NSInteger)type
{
    // 部门
    //    NSDictionary *superDic = nil;
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dic1 in nextArr) {
        
        if (type == 0) {
            
            if (![_selectedDepArr containsObject:dic1[@"DepartmentId"]]) {
                [_selectedDepArr addObject:dic1[@"DepartmentId"]];
                
            }
            
            // 员工
            [self searchEmp:dic1 type:0];
            
            for (NSDictionary *dic2 in self.departments) {
                
                if ([dic1[@"DepartmentId"] isEqualToString:dic2[@"ParentID"]]) {
                    [arrM addObject:dic2];
                    
                    
                }
            }
            
        }
        else {
            if ([_selectedDepArr containsObject:dic1[@"DepartmentId"]]) {
                [_selectedDepArr removeObject:dic1[@"DepartmentId"]];
                
            }
            
            // 员工
            [self searchEmp:dic1 type:1];
            
            for (NSDictionary *dic2 in self.departments) {
                
                if ([dic1[@"DepartmentId"] isEqualToString:dic2[@"ParentID"]]) {
                    [arrM addObject:dic2];
                    

                }
            }
        
        }
        
        
    }
    
    return arrM;
}

// 员工
- (void)searchEmp:(NSDictionary *)dic1 type:(NSInteger)type
{
    if (type == 0) {
        for (NSDictionary *dic2 in self.employees) {
            
            if ([dic1[@"DepartmentId"] isEqualToString:dic2[@"DepartmentId"]]) {
                
                if (![_selectedEmpArr containsObject:dic2[@"ProfileId"]]) {
                    [_selectedEmpArr addObject:dic2[@"ProfileId"]];
                    
                }
                
                
            }
        }
    }
    else {
        for (NSDictionary *dic2 in self.employees) {
            
            if ([dic1[@"DepartmentId"] isEqualToString:dic2[@"DepartmentId"]]) {
                
                if ([_selectedEmpArr containsObject:dic2[@"ProfileId"]]) {
                    [_selectedEmpArr removeObject:dic2[@"ProfileId"]];
                    
                }
                
                
            }
        }
    }
}

// 查找父单元的
- (NSDictionary *)search:(NSDictionary *)nextDic type:(NSInteger)type
{
    //    NSDictionary *superDic = nil;
    for (NSDictionary *dic in self.departments) {
        
        if ([nextDic[@"ParentID"] isEqualToString:dic[@"DepartmentId"]]) {
            nextDic = dic;
            
            if (type == 0) {
                
                if (![_selectedDepArr containsObject:dic[@"DepartmentId"]]) {
                    [_selectedDepArr addObject:dic[@"DepartmentId"]];
                    
                }
            }
            else {
                if ([_selectedDepArr containsObject:dic[@"DepartmentId"]]) {
                    [_selectedDepArr removeObject:dic[@"DepartmentId"]];
                    
                }
                
                    
            }
            
            return nextDic;
        }
    }
    
    return nil;
}


- (void)initBottomView {
    // 确定视图
    UIView *currentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-44-64, kScreen_Width, 44)];
    [self.view addSubview:currentView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    button.frame = currentView.bounds;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [currentView addSubview:button];
    self.okBtn = button;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [currentView addSubview:lineView];
}

- (void)confirmAction
{
    if (self.selectedEmpArr.count > 0) {
        
        if (_sendAllBlock) {
            _sendAllBlock(_selectedDepArr, _selectedEmpArr);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 确定按钮的显示改变
- (void)buttonStateChange
{
    if (_selectedEmpArr.count > 0) {
        
        NSString *str = [NSString stringWithFormat:@"确定(%ld)",(unsigned long)_selectedEmpArr.count];
        [self.okBtn setTitle:str forState:UIControlStateNormal];
        
    }
    else {
        
        [self.okBtn setTitle:@"确定" forState:UIControlStateNormal];
        
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
        
        UIView *baseView = [self firstHeaderView];
        self.unitLabel.text = [NSString stringWithFormat:@"%@级单元",self.CompanyRanks];
        
        self.companyLabel.text = self.CompanyName;
        _tableView.tableHeaderView = baseView;
        
        // 部门
        for (NSDictionary *dic in self.departments) {
            if ([dic[@"ParentID"] isEqualToString:@""]) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                [arrM addObject:model];
            }
        }
        
        // 员工
        for (NSDictionary *dic in self.employees) {
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
        for (NSDictionary *dic in self.departments) {
            
            if ([text isEqualToString:dic[@"Title"]]) {
                superDic = dic;
                
            }
        }
        
        // 部门
        for (NSDictionary *dic in self.departments) {
            
            if ([superDic[@"DepartmentId"] isEqualToString:dic[@"ParentID"]]) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                [arrM addObject:model];
            }
        }
        
        // 员工
        for (NSDictionary *dic in self.employees) {

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


- (void)selectAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        for (NSDictionary *dic in self.departments) {
            
            if (![_selectedDepArr containsObject:dic[@"DepartmentId"]]) {
                [_selectedDepArr addObject:dic[@"DepartmentId"]];
                
            }
        }
        
        for (NSDictionary *dic in self.employees) {
            
            if (![_selectedEmpArr containsObject:dic[@"ProfileId"]]) {
                [_selectedEmpArr addObject:dic[@"ProfileId"]];
                
            }
        }
    }
    else {
        [_selectedDepArr removeAllObjects];
        [_selectedEmpArr removeAllObjects];
    }
    
    [self buttonStateChange];
    [_tableView reloadData];
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
    // 头视图
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 56+44)];
    //搜索框
    [baseView addSubview:self.searchBar];
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
    
//    _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width - 40, 0, 40, 40)];
//    [_selectBtn setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
//    [_selectBtn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
//    [_selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
//    [whiteView addSubview:_selectBtn];
    
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
        _searchView.clickAction = ClickActionThree;
        _searchView.selectedEmpArr = self.selectedEmpArr;
        __weak typeof(self) weakSelf = self;
        _searchView.searchBlock = ^(void) {
            [weakSelf searchBarCancelButtonClicked:weakSelf.searchBar];
        };
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
    
    [self.searchView removeFromSuperview];
    self.searchView = nil;
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    [_tableView reloadData];
    [self buttonStateChange];
}


@end
