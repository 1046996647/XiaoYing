//
//  MaintainCompanyinfoVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/21.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "WorkmateView.h"
#import "DepartmentTableViewCell.h"
#import "EmployeeCell.h"
#import "XYSearchBar.h"
#import "DepartmentModel.h"
#import "EmployeeModel.h"
#import "HXTagsView.h"
#import "XYWorkSetLeaderVc.h"
#import "RCIM.h"
#import "ChatViewController.h"
#import "EmploeeyDetailMessageVC.h"
#import "SearchEmployeeView.h"


@interface WorkmateView ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    DepartmentModel *_model;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong)XYSearchBar *searchBar;

@property (nonatomic, strong)UILabel *companyLabel;
@property (nonatomic, strong)UILabel *unitLabel;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *okBtn;

@property (nonatomic, assign)BOOL isCompany;
@property (nonatomic, strong)NSMutableArray *navArr;
@property (nonatomic,copy) NSString *CompanyId;

@property (nonatomic,strong) NSArray *departments;
@property (nonatomic,strong) NSArray *employees;
@property (nonatomic,strong) NSArray *subUnitArray;
@property (nonatomic,strong) NSArray *employeeArray;
@property (nonatomic, copy)NSString *CompanyName;
@property (nonatomic,strong) UILabel *label;

@property (nonatomic, strong) NSMutableArray * myFriendArray; // 好友信息数组
@property (strong, nonatomic) SearchEmployeeView *searchView;


@end

@implementation WorkmateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 好友数据
        _myFriendArray = [ZWLCacheData unarchiveObjectWithFile:FriendPath];
        
        // 初始化数据
        [self initData];
        
        [self initBasic];

        // 刷新部门和员工信息！
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(initData)
                                                     name:kRefreshInfoNotification
                                                   object:nil];
        
        // 是否是好友数据刷新
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(RefreshIsFriend)
                                                     name:@"kRefreshIsFriendNotification"
                                                   object:nil];

        // 移除搜索视图
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeSearchView)
                                                     name:@"kRemoveSearchViewNotification"
                                                   object:nil];

    }
    return self;
}

- (void)removeSearchView
{
    [self searchBarCancelButtonClicked:self.searchBar];
}

- (void)RefreshIsFriend
{
    // 好友数据
    _myFriendArray = [ZWLCacheData unarchiveObjectWithFile:FriendPath];
    
    for (EmployeeModel *model in _employeeArray) {
        // 是否是好友关系
        for (ConnectWithMyFriend *friend in _myFriendArray) {
            if ([model.ProfileId isEqualToString:friend.ProfileId]) {
                model.isFriend = YES;
            }
        }
    }
    [_tableView reloadData];
}

- (void)initData
{
    self.CompanyName = [UserInfo getcompanyName];
    self.companyLabel.text = self.CompanyName;
    
    // 所有部门
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    self.departments = arr;
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
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
                // 领导人置顶
                [arrM1 removeObject:model];
                [arrM1 insertObject:model atIndex:0];
                model.isConcurrentLeader = YES;

            }
            
            // 是否是好友关系
            for (ConnectWithMyFriend *friend in _myFriendArray) {
                if ([model.ProfileId isEqualToString:friend.ProfileId]) {
                    model.isFriend = YES;
                }
            }
        }
        
        
    }
    self.employeeArray = arrM1;
    
    if (self.departments.count > 0) {
        
        [_navArr removeAllObjects];
        // 先加入公司名
        _navArr = [NSMutableArray arrayWithObject:[UserInfo getcompanyName]];
        
        UIView *baseView = [self firstHeaderView];
        _tableView.tableHeaderView = baseView;
        self.label.hidden = YES;
        
    } else {
        self.label.hidden = NO;
        
        _tableView.tableHeaderView = nil;

    }
    [_tableView reloadData];
    
    // 移除搜索视图
    [self searchBarCancelButtonClicked:self.searchBar];

}


- (void)initBasic {
    
    UIView *baseView = [self firstHeaderView];
//    self.baseView = baseView;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-49-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:_tableView];
    
    if (self.departments.count > 0) {
        _tableView.tableHeaderView = baseView;

    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, (self.height-20)/2, kScreen_Width - 24, 20)];
    label.text = @"你还没有公司哦~";
    label.font = [UIFont systemFontOfSize:18];
    label.hidden = YES;
    label.textColor = [UIColor colorWithHexString:@"#848484"];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;

    
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
                // 是否是好友关系
                for (ConnectWithMyFriend *friend in _myFriendArray) {
                    if ([model.ProfileId isEqualToString:friend.ProfileId]) {
                        model.isFriend = YES;
                    }
                }
            }
        }
        _employeeArray = arrM2;
        [_tableView reloadData];
    }
    else {
        
        //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
        EmployeeModel *model = self.employeeArray[indexPath.row];
        
        EmploeeyDetailMessageVC *emploeeyDetailMessageVC = [[EmploeeyDetailMessageVC alloc] init];
        emploeeyDetailMessageVC.employeeModel = model;
        [self.viewController.navigationController pushViewController:emploeeyDetailMessageVC animated:YES];
        

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
            cell2 = [[EmployeeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmployeeCell"];
        }
        EmployeeModel *model = _employeeArray[indexPath.row];
        cell2.currentDepartmentId = _model.DepartmentId;
        cell2.type = 1;
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
        _model.Ranks = @1;
        
        UIView *baseView = [self firstHeaderView];
        self.unitLabel.text = [NSString stringWithFormat:@"1级单元"];
        
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
                // 是否是好友关系
                for (ConnectWithMyFriend *friend in _myFriendArray) {
                    if ([model.ProfileId isEqualToString:friend.ProfileId]) {
                        model.isFriend = YES;
                    }
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
                
                // 切换上级单元
                _model.Ranks = dic[@"Ranks"];
                _model.Title = dic[@"Title"];
                _model.DepartmentId = dic[@"DepartmentId"];
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
                // 是否是好友关系
                for (ConnectWithMyFriend *friend in _myFriendArray) {
                    if ([model.ProfileId isEqualToString:friend.ProfileId]) {
                        model.isFriend = YES;
                    }
                }
            }
        }

        
    }
    
    _subUnitArray = arrM;
    _employeeArray = arrM1;
    
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
    self.baseView = baseView;
    
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
    HXTagsView *tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, self.frame.size.width, 0)];
    tagsView.type = 0;
    [tagsView setTagAry:arrM delegate:self];
    [baseView addSubview:tagsView];
    baseView.height = tagsView.bottom;
    return baseView;
    
}

- (SearchEmployeeView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchEmployeeView alloc] initWithFrame:CGRectMake(0, 44, kScreen_Width, self.height-44)];
        _searchView.clickAction = ClickActionTwo;
        _searchView.searchBar = self.searchBar;
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
    [self addSubview:self.searchView];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *tempResults = [NSMutableArray array];
    
    for (NSDictionary *dic in self.employees) {
        if ([dic[@"EmployeeName"] containsString:searchText]) {
            EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
            [tempResults addObject:model];
            
            // 是否是好友关系
            for (ConnectWithMyFriend *friend in _myFriendArray) {
                if ([model.ProfileId isEqualToString:friend.ProfileId]) {
                    model.isFriend = YES;
                }
            }
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


@end
