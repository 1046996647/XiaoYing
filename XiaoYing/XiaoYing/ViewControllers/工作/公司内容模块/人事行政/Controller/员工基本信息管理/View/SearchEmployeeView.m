//
//  SearchView.m
//  XiaoYing
//
//  Created by ZWL on 16/10/14.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "SearchEmployeeView.h"
#import "EmployeeModel.h"
#import "EmployeeCell.h"
#import "EditDetailOfMemberVC.h"
#import "EmploeeyDetailMessageVC.h"
#import "AuthoritySettingVC.h"


@implementation SearchEmployeeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 表视图
        self.approveTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.approveTable.tableFooterView = [UIView new];
        self.approveTable.delegate = self;
        self.approveTable.dataSource = self;
        self.approveTable.backgroundColor = [UIColor clearColor];
        [self addSubview:self.approveTable];
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewController.view endEditing:YES];
    
    EmployeeModel *model = self.approveArr[indexPath.row];
    
    if (self.clickAction == ClickActionOne) {
        EditDetailOfMemberVC *editVC = [[EditDetailOfMemberVC alloc] init];
        editVC.employeeModel = model;
        editVC.superRanks = self.superRanks;
        editVC.memberID = model.ProfileId;
        editVC.RoleType = model.RoleType;
        editVC.ManagerProfileId = _model.ManagerProfileId;
        editVC.tempDepartmentId = _model.DepartmentId;
        [self.viewController.navigationController pushViewController:editVC animated:YES];
        editVC.referMember = self.referMember;
        if (self.searchBlock) {
            self.searchBlock();
        }
    } else if (self.clickAction == ClickActionTwo) {
        EmploeeyDetailMessageVC *emploeeyDetailMessageVC = [[EmploeeyDetailMessageVC alloc] init];
        emploeeyDetailMessageVC.employeeModel = model;
        [self.viewController.navigationController pushViewController:emploeeyDetailMessageVC animated:YES];
        if (self.searchBlock) {
            self.searchBlock();
        }
    } else if (self.clickAction == ClickActionFour) {
        AuthoritySettingVC *auhVC = [[AuthoritySettingVC alloc] init];
        NSNumber *userRole = [UserInfo getUserRole];
        //参数RoleType 128为创建者  64为管理员    2普通员工
        if (![userRole isEqual:@64]) {
            //用户是创建者时
            if ([model.RoleType isEqual:@128]) {
                
                if ([model.ProfileId isEqualToString:[UserInfo userID]]) {
                    [MBProgressHUD showMessage:@"您已拥有所有权限 !"];
                }
            } else {
                auhVC.model = model;
//                auhVC.departments = self.departments;
                if ([_ManagerProfileIdArray containsObject:model.ProfileId]) {
                    auhVC.isManagerYesOrNo = @"YES";
                }
                [self.viewController.navigationController pushViewController:auhVC animated:YES];
            }
        }
        else {
            //用户是管理员时
            if (![model.RoleType isEqual:@2]) {
                if ([model.ProfileId isEqualToString:[UserInfo userID]]) {
                    [MBProgressHUD showMessage:@"您不能设置自己的权限 !"];
                }else {
                    [MBProgressHUD showMessage:@"您无权管理其权限 !"];
                }
            }else {
                auhVC.model = model;
//                auhVC.departments = self.departments;
                if ([_ManagerProfileIdArray containsObject:model.ProfileId]) {
                    auhVC.isManagerYesOrNo = @"YES";
                }
                [self.viewController.navigationController pushViewController:auhVC animated:YES];
            }
        }
    }


    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EmployeeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[EmployeeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    EmployeeModel *model = _approveArr[indexPath.row];
    
    if (self.clickAction == ClickActionThree) {
        cell.sendEmployeeBlock = ^(EmployeeModel *model)
        {
            
            if (model.isSelected) {
                
                if (_selectedEmpArr) {
                    if (![_selectedEmpArr containsObject:model.ProfileId]) {
                        [_selectedEmpArr addObject:model.ProfileId];
                        
                    }
                }
                else {
                    if (![_selectedArr containsObject:model.ProfileId]) {
                        [_selectedArr addObject:model.ProfileId];
                        
                    }
                }


            }
            else {
                
                if (_selectedEmpArr) {
                    if ([_selectedEmpArr containsObject:model.ProfileId]) {
                        [_selectedEmpArr removeObject:model.ProfileId];
                        
                    }
                }
                else {
                    if ([_selectedArr containsObject:model.ProfileId]) {
                        [_selectedArr removeObject:model.ProfileId];
                        
                    }
                }

                
            }
//            [_approveTable reloadData];
            if (self.searchBlock) {
                self.searchBlock();
            }
            // 数据刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kDataRefreshNotification" object:nil];
            
        };
        
        if (_selectedEmpArr) {
            if ([_selectedEmpArr containsObject:model.ProfileId]) {
                model.isSelected = YES;
            }
            else {
                model.isSelected = NO;
            }
        }
        else {
            
            if ([_selectedArr containsObject:model.ProfileId]) {
                model.isSelected = YES;
            }
            else {
                model.isSelected = NO;
            }
        }
        
//        if ([_iDArr containsObject:model.ProfileId]) {
//            [cell.selectedControl setImage:[UIImage imageNamed:@"choice_gray"] forState:UIControlStateNormal];
//            cell.selectedControl.userInteractionEnabled = NO;
//        }

    }
    
    else {
        
        if (self.clickAction == ClickActionFour) {
            cell.type = 2;

        }
        else {
            cell.type = 1;

        }
    }
    cell.model = model;
    if ([_iDArr containsObject:model.ProfileId]) {
        [cell.selectedControl setImage:[UIImage imageNamed:@"choice_gray"] forState:UIControlStateNormal];
        cell.selectedControl.userInteractionEnabled = NO;
    }
    else {
        if ([_selectedArr containsObject:model.ProfileId]) {
            //                model.isSelected = YES;
            [cell.selectedControl setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
            cell.selectedControl.userInteractionEnabled = YES;
        }
        else {
            //                model.isSelected = NO;
            [cell.selectedControl setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
            cell.selectedControl.userInteractionEnabled = YES;
        }
    }
    

//    cell.currentDepartmentId = model.DepartmentId;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _approveArr.count;
}




- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
    
    UIButton *cancelBtn = [self.searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    cancelBtn.enabled = YES; //把enabled设置为yes
}


@end
