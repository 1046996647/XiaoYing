//
//  MaintainCompanyView.m
//  XiaoYing
//
//  Created by GZH on 16/7/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "MaintainCompanyView.h"
#import "XYSearchBar.h"
#import "DepartmentTableViewCell.h"
#import "CompanyTableViewCell.h"
#import "StepsVC.h"
#import "StepsView.h"


@implementation MaintainCompanyView


- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
   
        
        self.delegate = self;
        self.dataSource = self;

        [self initBasic];
        [self initData];
        
        // 请求数据
        [self requestData];
        
    }
    return self;
}

// 请求数据
- (void)requestData
{
    
}



- (void)initBasic {
   
    //搜索框
    _m_searchBar = [[XYSearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
//    _m_searchBar.showsCancelButton = NO;
//    _m_searchBar.barStyle = UIBarStyleDefault;
    _m_searchBar.placeholder = @"找单元";
    _m_searchBar.delegate = self;
    [_m_searchBar.searchButton addTarget:self action:@selector(searcgBarClearAction) forControlEvents:UIControlEventTouchUpInside];
    self.tableHeaderView = _m_searchBar;
}

- (void)initData {
    _subUnitArray = [[NSMutableArray alloc]initWithObjects:@"人事部",@"行政部",@"财务部",nil];
}


#pragma mark --tableViewDelegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 12;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return _subUnitArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        StepsVC *stepVC = [[StepsVC alloc]init];
        [self.viewController.navigationController pushViewController:stepVC animated:YES];
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[CompanyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        return cell;
    }
    
    DepartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[DepartmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.companyLabel.text = _subUnitArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.upLineLabel.hidden = YES;
    }
    if (indexPath.row == _subUnitArray.count - 1) {
        cell.downLineLabel.hidden = YES;
    }

    return cell;
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



@end
