//
//  MSDepartmentViewController.m
//  XiaoYing
//
//  Created by 王思齐 on 16/11/24.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "MSDepartmentViewController.h"
#import "AdverPowerDetailVc.h"
//#import "DepartmentTableViewCell.h"
#import "ChooseDepartmentCell.h"
#import "DepartmentModel.h"
#import "HXTagsView.h"
#import "SelectedDepartmentsVC.h"
@interface MSDepartmentViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    MBProgressHUD *hud;
    //    DepartmentModel *_model;
    //    NSDictionary *_companyDic;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *baseView;

//@property (nonatomic, strong)XYSearchBar *m_searchBar;



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

@implementation MSDepartmentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dic in self.departments) {
        if ([dic[@"ParentID"] isEqualToString:@""]) {
            DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
            [arrM addObject:model];
        }
    }
    self.subUnitArray = arrM;
    
    // 先加入公司名
    _navArr = [NSMutableArray arrayWithObject:self.CompanyName];
    
    [self initBasic];
    
//    [self initBottomView];
    
//    [self initRightBtn];
    
    if (!self.selectedArr) {
        self.selectedArr = [NSMutableArray array];
    }
    [self buttonStateChange];
    
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
    for (NSDictionary *dic in self.departments) {
        
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
    ChooseDepartmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    DepartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ChooseDepartmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

    }
    
    DepartmentModel *model = _subUnitArray[indexPath.row];
    cell.model = model;    
    cell.companyLabel.text = model.Title;
    cell.unitLabel.text = [NSString stringWithFormat:@"%@级单元",model.Ranks];
    cell.type = 0;
    
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

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //    self.m_searchBar.searchButton.hidden = NO;
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
        
        for (NSDictionary *dic in self.departments) {
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
        for (NSDictionary *dic in self.departments) {
            
            if ([text isEqualToString:dic[@"Title"]]) {
                superDic = dic;
                
            }
        }
        for (NSDictionary *dic in self.departments) {
            
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
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:whiteView];
    
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 6, kScreen_Width - 56, 14)];
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
    [_selectBtn setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
//    [_selectBtn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
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
    AdverPowerDetailVc *vc = [[AdverPowerDetailVc alloc]init];
    vc.title = [UserInfo getcompanyName];
    vc.departmentID = @"Uzg9";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UIView *)secondHeaderView:(NSMutableArray *)arrM
{
    // 更换头视图
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
    
    //搜索框
    
    //多行不滚动,则计算出全部展示的高度,让maxHeight等于计算出的高度即可,初始化不需要设置高度
    HXTagsView *tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    tagsView.type = 0;
    [tagsView setTagAry:arrM delegate:self];
    [baseView addSubview:tagsView];
    baseView.height = tagsView.bottom;
    return baseView;
    
}


@end
