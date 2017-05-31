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
#import "SingleSelectPeopleVC.h"


@interface SingleSelectPeopleVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    MBProgressHUD *hud;
    DepartmentModel *_currentModel;
    //    NSDictionary *_companyDic;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *baseView;

@property (nonatomic, strong)XYSearchBar *m_searchBar;

@property (nonatomic, strong)UILabel *companyLabel;
@property (nonatomic, strong)UILabel *unitLabel;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *okBtn;

@property (nonatomic, strong)NSMutableArray *navArr;
@property (nonatomic,copy) NSString *CompanyId;

@property (nonatomic,strong) NSArray *subUnitArray;
@property (nonatomic,strong) NSArray *employeeArray;

@property (nonatomic, assign)BOOL firstResponde;

// 作为判断的数组
@property (nonatomic, strong)NSMutableArray *titleArr;


@end

@implementation SingleSelectPeopleVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _navArr = [NSMutableArray array];
        
        // 作为判断的数组
        _titleArr = [NSMutableArray array];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBasic];
    
    [self initBottomView];
}

- (void)initBasic {
    // 所有部门
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    self.departments = arr;
    
    // 所有员工
    NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
    self.employees = employeesArr;
    
    UIView *baseView = nil;
    NSMutableArray *arrM = [NSMutableArray array];
    NSMutableArray *arrM1 = [NSMutableArray array];
    
    NSDictionary *superDic = nil;
    for (NSDictionary *dic in self.departments) {
        
        if ([self.model.DepartmentId isEqualToString:dic[@"DepartmentId"]]) {
            superDic = dic;
            
        }
    }
    
    
    // 公司的
    if ([self.model.DepartmentId isEqualToString:@""]) {
        //    if (_navArr.count == 1) {
        
        
        for (NSDictionary *dic in self.departments) {
            if ([dic[@"ParentID"] isEqualToString:@""]) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                [arrM addObject:model];
            }
        }
        [_navArr addObject:self.comanyName];
        _titleArr = _navArr.mutableCopy;
        
        baseView = [self firstHeaderView];
        self.unitLabel.text = [NSString stringWithFormat:@"%@级单元",@1];
        self.companyLabel.text = self.comanyName;
        
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
    else {// 部门的
        
        
        for (NSDictionary *dic in self.departments) {
            
            if ([superDic[@"DepartmentId"] isEqualToString:dic[@"ParentID"]]) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                //            model.superTitle = lastModel.Title;
                //            model.superRanks = lastModel.Ranks;
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
        
        [_titleArr addObject:superDic[@"Title"]];
        NSString *tagTitle = [NSString stringWithFormat:@" > %@",superDic[@"Title"]];
        [_navArr addObject:tagTitle];
        
        // 查找父单元
        while (superDic) {
            
            superDic = [self search:superDic];
            
            if (superDic) {
                [_titleArr addObject:superDic[@"Title"]];
                NSString *tagTitle = [NSString stringWithFormat:@" > %@",superDic[@"Title"]];
                [_navArr addObject:tagTitle];
                
            }
            //            NSLog(@"!!!!!%@",superDic[@"Title"]);
            
        }
        
        [_navArr addObject:self.comanyName];
        _navArr = [[_navArr reverseObjectEnumerator] allObjects].mutableCopy;
        
        baseView = [self secondHeaderView:_navArr];
        
    }
    
    self.employeeArray = arrM1;
    self.subUnitArray = arrM;

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = baseView;
    
}

// 递归遍历
- (NSDictionary *)search:(NSDictionary *)nextDic
{
    //    NSDictionary *superDic = nil;
    for (NSDictionary *dic in self.departments) {
        
        if ([nextDic[@"ParentID"] isEqualToString:dic[@"DepartmentId"]]) {
            nextDic = dic;
            
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
    if (_sendEmployeeBlock) {
        _sendEmployeeBlock(self.empModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
        _currentModel = lastModel;
        
        if ([_titleArr containsObject:lastModel.Title] || lastModel.NodeLevel.integerValue == _model.NodeLevel.integerValue) {
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
                        model.isMastLeader = YES;
                    } else if ([lastModel.ManagerProfileId isEqualToString:dic[@"ProfileId"]])
                    {
                        model.isConcurrentLeader = YES;
                        
                    }
                }
            }
            _employeeArray = arrM2;
            [_tableView reloadData];
        }
        else {
            [MBProgressHUD showMessage:@"只能选择父级或当前级或同等级的员工"];

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
        if (indexPath.row == _subUnitArray.count - 1) {
            cell1.downLineLabel.hidden = YES;
        }
        else {
            cell1.downLineLabel.hidden = NO;
        }
        
        return cell1;
    } else {
        
        if (cell2 == nil) {
            cell2 = [[EmployeeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmployeeCell"];
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell2.sendEmployeeBlock = ^(EmployeeModel *model) {
                
                if (_currentModel.NodeLevel.integerValue == _model.NodeLevel.integerValue) {
                    if (!model.isMastLeader && !model.isConcurrentLeader && ![_model.DepartmentId isEqualToString:@""]) {
                        [MBProgressHUD showMessage:@"只能选择领导人"];
                        return ;
                    }

                }
                _firstResponde = YES;

                if (_empModel != model) {
                    _empModel.isSelected = NO
                    ;
                    _empModel = model;
                    
                }
                [_tableView reloadData];
            };
        }
        
        EmployeeModel *model = _employeeArray[indexPath.row];
        cell2.type = 0;
        
        if (!_firstResponde) {
            if ([self.empModel.EmployeeID isEqualToString:model.EmployeeID]) {
                model.isSelected = YES;
                _empModel = model;

            }
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



// 搜索框上的X按钮事件
- (void)searcgBarClearAction {
    _m_searchBar.text = @"";
    [_m_searchBar resignFirstResponder];
    _m_searchBar.searchButton.hidden = YES;
}
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.m_searchBar.searchButton.hidden = NO;
    return YES;
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
//        self.unitLabel.text = [NSString stringWithFormat:@"%@级单元",@1];
//        
        self.companyLabel.text = self.comanyName;
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


- (UIView *)firstHeaderView
{
    // 头视图
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 56)];
    //搜索框
//    _m_searchBar = [[XYSearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
//    //    _m_searchBar.showsCancelButton = NO;
//    //    _m_searchBar.barStyle = UIBarStyleDefault;
//    _m_searchBar.placeholder = @"找单元";
//    _m_searchBar.delegate = self;
//    [_m_searchBar.searchButton addTarget:self action:@selector(searcgBarClearAction) forControlEvents:UIControlEventTouchUpInside];
//    [baseView addSubview:_m_searchBar];
    
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:whiteView];
    
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 6, kScreen_Width - 56, 16)];
    //    companyLabel.text = @"杭州赢莱金融服务有限公司";
    companyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    companyLabel.font = [UIFont systemFontOfSize:14];
    companyLabel.textAlignment = NSTextAlignmentLeft;
//    companyLabel.backgroundColor = [UIColor redColor];
    [whiteView addSubview:companyLabel];
    self.companyLabel = companyLabel;
    self.companyLabel.text = self.comanyName;
    
    
    UILabel *unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 26, kScreen_Width / 2, 12)];
    //    unitLabel.text = @"4级单元";
    unitLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    unitLabel.font = [UIFont systemFontOfSize:12];
    unitLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:unitLabel];
    self.unitLabel = unitLabel;
    self.unitLabel.text = [NSString stringWithFormat:@"%@级单元",@1];
    
    
    return baseView;
}


- (UIView *)secondHeaderView:(NSMutableArray *)arrM
{
    // 更换头视图
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
    
    //搜索框
//    _m_searchBar = [[XYSearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
//    //    _m_searchBar.showsCancelButton = NO;
//    //    _m_searchBar.barStyle = UIBarStyleDefault;
//    _m_searchBar.placeholder = @"找单元";
//    _m_searchBar.delegate = self;
//    [_m_searchBar.searchButton addTarget:self action:@selector(searcgBarClearAction) forControlEvents:UIControlEventTouchUpInside];
//    [baseView addSubview:_m_searchBar];
    
    //多行不滚动,则计算出全部展示的高度,让maxHeight等于计算出的高度即可,初始化不需要设置高度
    HXTagsView *tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    tagsView.type = 0;
    [tagsView setTagAry:arrM delegate:self];
    [baseView addSubview:tagsView];
    baseView.height = tagsView.bottom;
    return baseView;
    
}

#pragma mark - 重写返回按钮事件
//- (void)backAction:(UIButton *)button
//{
//    [self confirmAction];
//}

@end
