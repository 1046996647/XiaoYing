//
//  ApproveManageVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "ManagerListVC.h"
#import "DepartManagerAuthorityCell.h"
#import "AuthorityPullDownView.h"
#import "AuthoritySettingVC.h"
#import "EmployeeModel.h"
#import "ContactDataHelper.h"
@interface ManagerListVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) UITableView *approveTable;
@property (nonatomic,strong) NSMutableArray *arrayOfName;
@property (nonatomic,strong) NSMutableArray *approveArr;
@property (nonatomic,strong) AuthorityPullDownView *authorityPullDownView;//下拉视图
@end

@implementation ManagerListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    self.title = @"管理员列表";

    _approveArr = [[NSMutableArray alloc] init];
    _arrayOfName = [NSMutableArray array];

    
    //    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    [self initUI];
    
    //导航栏的排序按钮
//    [self initRightBtn];
    
    [self initData];
    
}


- (void)initData {
    NSArray *array = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
    for (NSDictionary *dic in array) {
        if (![dic[@"RoleType"] isEqual:@2]) {
            EmployeeModel *model = [[EmployeeModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_approveArr addObject:model];
            [_arrayOfName addObject:model.EmployeeName];
        }
    }

    _approveArr = [NSMutableArray SortOfNameWithArray:_arrayOfName AndTargetArray:_approveArr];
    
    [_approveTable reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.authorityPullDownView removeFromSuperview];

}

//导航栏的排序按钮
- (void)initRightBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 35, 35);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"排序" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightBar];
    
}

- (void)rightBtnAction:(UIButton *)btn
{
    if (btn.tag == 0) {
        
        if (self.authorityPullDownView == nil) {
            AuthorityPullDownView *authorityPullDownView = [[AuthorityPullDownView alloc] initWithFrame:self.view.bounds];
            self.authorityPullDownView = authorityPullDownView;
        }
        
        self.authorityPullDownView.btn = btn;
        [self.view addSubview:self.authorityPullDownView];
        btn.tag = 1;
    }
    else {
        [self.authorityPullDownView removeFromSuperview];
        btn.tag = 0;
    }

}

//初始化UI控件
- (void)initUI{

    // 表视图
    self.approveTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:UITableViewStylePlain];
    self.approveTable.tableFooterView = [UIView new];
    self.approveTable.delegate = self;
    self.approveTable.dataSource = self;
    self.approveTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.approveTable];
    if ([self.approveTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.approveTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.approveTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.approveTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EmployeeModel *model = _approveArr[indexPath.row];
    AuthoritySettingVC *auhVC = [[AuthoritySettingVC alloc] init];
    
    NSNumber *userRole = [UserInfo getUserRole];
    
    //参数RoleType 128为创建者  64为管理员    2普通员工
    if ([userRole isEqual:@128]) {
        //用户是创建者时
        if ([model.RoleType isEqual:@128]) {
            
                [MBProgressHUD showMessage:@"您已拥有所有权限 !" toView:self.view];
        }else {
            auhVC.model = model;
            auhVC.departmentName = model.DepartmentName;
            if ([_ManagerProfileIdArray containsObject:model.ProfileId]) {
                auhVC.isManagerYesOrNo = @"YES";
            }
            [self.navigationController pushViewController:auhVC animated:YES];
        }
    }else
        if ([userRole isEqual:@96]) {
        //用户是超级管理员时
        if ([model.RoleType isEqual:@2] || [model.RoleType isEqual:@64]) {
            
            auhVC.model = model;
            auhVC.departmentName = model.DepartmentName;
            if ([_ManagerProfileIdArray containsObject:model.ProfileId]) {
                auhVC.isManagerYesOrNo = @"YES";
            }
            [self.navigationController pushViewController:auhVC animated:YES];
        }else {
            
            if ([model.ProfileId isEqualToString:[UserInfo userID]]) {
                [MBProgressHUD showMessage:@"您不能设置自己的权限 !" toView:self.view];
            }else {
                [MBProgressHUD showMessage:@"您无权管理其权限 !" toView:self.view];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 0;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DepartManagerAuthorityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    
    if (cell == nil) {
        
        cell = [[DepartManagerAuthorityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        
    }
    EmployeeModel *model = _approveArr[indexPath.row];
    cell.model = model;
    
    return cell;
}

//单元格将要出现
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _approveArr.count;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
