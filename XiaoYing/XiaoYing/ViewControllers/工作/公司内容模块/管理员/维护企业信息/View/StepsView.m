//
//  StepsView.m
//  XiaoYing
//
//  Created by GZH on 16/7/21.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "StepsView.h"
#import "XYSearchBar.h"
#import "DepartmentTableViewCell.h"
@implementation StepsView


- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        
        
        
        
        self.delegate = self;
        self.dataSource = self;
        
        [self initData];
        [self initBasic];
        
    }
    return self;
}




- (void)initBasic {
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
    backView.backgroundColor = [UIColor clearColor];
    
    //搜索框
    _m_searchBar = [[XYSearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    _m_searchBar.placeholder = @"找单元";
    _m_searchBar.delegate = self;
    [_m_searchBar.searchButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_m_searchBar]; 
    
    
    NSString *content = @"杭州赢莱金融信息服务有限公司";
    CGSize size =[content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    UILabel *companyLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 44, size.width, 36)];
    companyLab.tag = 1;
    companyLab.text = content;
    companyLab.font = [UIFont systemFontOfSize:12];
    companyLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBackUpUnit:)];
    [companyLab addGestureRecognizer:tap];
    companyLab.textColor = [UIColor colorWithHexString:@"#f99740"];
    [backView addSubview:companyLab];
    
    NSString *content1 = @"  >  人事部";
    CGSize size1 =[content1 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    UILabel *departmentLab = [[UILabel alloc] initWithFrame:CGRectMake(companyLab.right + 6, 44, size1.width, 36)];
    departmentLab.tag = 2;
    departmentLab.text = content1;
    departmentLab.font = [UIFont systemFontOfSize:12];
    departmentLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBackUpUnit:)];
    [departmentLab addGestureRecognizer:tap1];
    departmentLab.textColor = [UIColor colorWithHexString:@"#848484"];
    [backView addSubview:departmentLab];
    
    backView.frame = CGRectMake(0, 0, kScreen_Width, 44 + companyLab.height );
    self.tableHeaderView = backView;
}

- (void)initData {
    _sunUnitArray = [[NSMutableArray alloc]initWithObjects:@"研发组",@"设计组",@"产品组",@"XX组", nil];
    _unitButtonArray = [[NSMutableArray alloc]initWithObjects:@"杭州赢莱金融信息服务有限公司",@"认识部", nil];
}


#pragma mark --tableViewDelegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sunUnitArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    DepartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[DepartmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.unitLabel.text = @"2级单元";
    cell.companyLabel.text = _sunUnitArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.upLineLabel.hidden = YES;
    }
    if (indexPath.row == _sunUnitArray.count - 1) {
        cell.downLineLabel.hidden = YES;
    }
    
    return cell;
}

// 搜索框上的X按钮事件
- (void)clearAction {
    _m_searchBar.text = @"";
    [_m_searchBar resignFirstResponder];
    _m_searchBar.searchButton.hidden = YES;
}
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    _m_searchBar.searchButton.hidden = NO;
    return YES;
}


- (void)goBackUpUnit:(UILabel *)sender {
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

@end
