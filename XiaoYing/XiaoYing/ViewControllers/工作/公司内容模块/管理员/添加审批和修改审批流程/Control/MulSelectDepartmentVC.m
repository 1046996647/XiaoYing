//
//  MaintainCompanyinfoVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/21.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "MulSelectDepartmentVC.h"
#import "DepartmentTableViewCell.h"
#import "XYSearchBar.h"
#import "DepartmentModel.h"
#import "HXTagsView.h"
#import "SelectedDepartmentsVC.h"



@interface MulSelectDepartmentVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    MBProgressHUD *hud;
//    DepartmentModel *_model;
//    NSDictionary *_companyDic;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *baseView;

@property (nonatomic, strong)XYSearchBar *m_searchBar;



@property (nonatomic, strong)UILabel *companyLabel;
@property (nonatomic, strong)UILabel *unitLabel;
//@property (nonatomic, copy)NSString *CompanyId;
//@property (nonatomic, copy)NSString *CompanyName;
//@property (nonatomic, strong)NSNumber *CompanyRanks;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *okBtn;


@property (nonatomic, assign)BOOL isCompany;

@property (nonatomic, strong)NSMutableArray *navArr;


@end

@implementation MulSelectDepartmentVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //公司信息
    self.CompanyName = [UserInfo getcompanyName];
    self.CompanyRanks = @1;
    
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
    
    // 先加入公司名
    _navArr = [NSMutableArray arrayWithObject:self.CompanyName];
    
    [self initBasic];
    
    [self initBottomView];
    
    [self initRightBtn];
    
    if (!self.selectedArr) {
        self.selectedArr = [NSMutableArray array];
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
    
    if (self.selectedArr.count == 0) {
        [MBProgressHUD showMessage:@"未选择任何部门"];
    }
    else {
        
        SelectedDepartmentsVC *selectedDepartmentsVC = [[SelectedDepartmentsVC alloc] init];
        selectedDepartmentsVC.selectedArr = self.selectedArr;
        selectedDepartmentsVC.departments = self.departments;
        selectedDepartmentsVC.CompanyName = self.CompanyName;
        selectedDepartmentsVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //淡出淡入
        selectedDepartmentsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //    self.definesPresentationContext = YES; //不盖住整个屏幕
        selectedDepartmentsVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [self presentViewController:selectedDepartmentsVC animated:YES completion:nil];
        
        selectedDepartmentsVC.sendBlock = ^(NSMutableArray *arrM) {
            
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _subUnitArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 所有部门
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    self.departments = arr;

    
    DepartmentModel *lastModel = self.subUnitArray[indexPath.row];
    
    if (_selectBtn.selected || lastModel.isSelected) {
        
        [MBProgressHUD showMessage:@"选子部门先取消父部门"];
        return;
    }
    
    NSString *tagTitle = [NSString stringWithFormat:@" > %@",lastModel.Title];
    [_navArr addObject:tagTitle];
    
    UIView *baseView = [self secondHeaderView:_navArr];
    _tableView.tableHeaderView = baseView;
    
    // 下一层数据
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        
        if ([lastModel.DepartmentId isEqualToString:dic[@"ParentID"]]) {
            DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
            [arrM addObject:model];
        }
    }
    _subUnitArray = arrM;
    [_tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    __weak typeof(self) weakSelf = self;
    
    DepartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[DepartmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.sendUnitBlock = ^(DepartmentModel *model)
        {
            NSLog(@"%@",model.DepartmentId);
            
            if (_selectBtn.selected) {
                
                [MBProgressHUD showMessage:@"选子部门先取消父部门"];
                return;
            }
            
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
                
                if (![_selectedArr containsObject:superDic[@"DepartmentId"]]) {
                    [_selectedArr addObject:superDic[@"DepartmentId"]];

                }
                
                // 查找子单元
                while (arrM.count > 0) {
                    arrM = [self search:arrM type:1];
                    
                }
                

            }
            else {
                
                if ([_selectedArr containsObject:superDic[@"DepartmentId"]]) {
                    [_selectedArr removeObject:superDic[@"DepartmentId"]];
                    
                }
                
//                // 查找子单元
//                while (arrM.count > 0) {
//                    arrM = [self search:arrM type:1];
//                }
                
            }
            
            [self buttonStateChange];

            [_tableView reloadData];
            
        };
    }
    
    DepartmentModel *model = _subUnitArray[indexPath.row];
    cell.model = model;
    cell.companyLabel.text = model.Title;
    cell.unitLabel.text = [NSString stringWithFormat:@"%@级单元",model.Ranks];
    cell.type = 1;
    
    if ([_selectedArr containsObject:model.DepartmentId]) {
        model.isSelected = YES;
    }
    else {
        model.isSelected = NO;
    }
    
//    cell.departments = self.departments;
    if (indexPath.row == 0) {
        cell.upLineLabel.hidden = YES;
    }
    if (indexPath.row == _subUnitArray.count - 1) {
        cell.downLineLabel.hidden = YES;
    }
    else {
        cell.downLineLabel.hidden = NO;
    }
    
    return cell;
}

// 递归遍历(0:加，1:减)
- (NSMutableArray *)search:(NSMutableArray *)nextArr type:(NSInteger)type
{
    //    NSDictionary *superDic = nil;
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dic1 in nextArr) {
        
        if (type == 0) {
            if (![_selectedArr containsObject:dic1[@"DepartmentId"]]) {
                [_selectedArr addObject:dic1[@"DepartmentId"]];
                
            }
            
            for (NSDictionary *dic2 in self.departments) {
                
                if ([dic1[@"DepartmentId"] isEqualToString:dic2[@"ParentID"]]) {
                    [arrM addObject:dic2];
                }
            }
        }
        else {
            if ([_selectedArr containsObject:dic1[@"DepartmentId"]]) {
                [_selectedArr removeObject:dic1[@"DepartmentId"]];
                
            }
            
            for (NSDictionary *dic2 in self.departments) {
                
                if ([dic1[@"DepartmentId"] isEqualToString:dic2[@"ParentID"]]) {
                    [arrM addObject:dic2];
                }
            }
        }
        

    }
    
    return arrM;
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
    if (self.selectedArr.count > 0) {
        
        if (_sendBlock) {
            _sendBlock(_selectedArr);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 确定按钮的显示改变
- (void)buttonStateChange
{
    if (_selectedArr.count > 0) {
        
        NSString *str = [NSString stringWithFormat:@"确定(%ld)",(unsigned long)_selectedArr.count];
        [self.okBtn setTitle:str forState:UIControlStateNormal];
        
    }
    else {
        
        [self.okBtn setTitle:@"确定" forState:UIControlStateNormal];
        
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
    
    // 所有部门
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    self.departments = arr;
    
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
    if (index == 0) {
        
        UIView *baseView = [self firstHeaderView];
        self.unitLabel.text = [NSString stringWithFormat:@"%@级单元",self.CompanyRanks];

        self.companyLabel.text = self.CompanyName;
        _tableView.tableHeaderView = baseView;
        
        for (NSDictionary *dic in arr) {
            if ([dic[@"ParentID"] isEqualToString:@""]) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                [arrM addObject:model];
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
                
            }
        }
        for (NSDictionary *dic in arr) {
            
            if ([superDic[@"DepartmentId"] isEqualToString:dic[@"ParentID"]]) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                [arrM addObject:model];
            }
        }
        
    }
    
    _subUnitArray = arrM;
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
    self.unitLabel.text = [NSString stringWithFormat:@"%@级单元",self.CompanyRanks];
    
    
    _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width - 40, 0, 40, 40)];
    [_selectBtn setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:_selectBtn];
    
    // 公司
    if (_selectedArr.count > 0 && [_selectedArr[0] isEqualToString:@""]) {
        _selectBtn.selected = YES;
    }
    
    return baseView;
}

- (void)selectAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        [_selectedArr removeAllObjects];

        if (![_selectedArr containsObject:@""]) {
            [_selectedArr addObject:@""];
            
        }
    }
    else {
        
        if ([_selectedArr containsObject:@""]) {
            [_selectedArr removeObject:@""];
            
        }
    }

    [self buttonStateChange];
    [_tableView reloadData];
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

//#pragma mark - 重写返回按钮事件
//- (void)backAction:(UIButton *)button
//{
//    [self confirmAction];
//}

@end
