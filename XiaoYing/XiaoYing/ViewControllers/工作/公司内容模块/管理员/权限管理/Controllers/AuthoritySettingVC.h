//
//  AuthoritySettingVC.h
//  XiaoYing
//
//  Created by ZWL on 16/6/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "EmployeeModel.h"


@interface AuthoritySettingVC : BaseSettingViewController

@property (nonatomic, strong)EmployeeModel *model;


@property (nonatomic, strong)NSString *isManagerYesOrNo; //判断是否有领导人标识


@property (nonatomic, strong) NSString *tempDepartmentId;
@property (nonatomic, strong) NSString *ManagerProfileId;
@property (nonatomic, strong) NSString *departmentName;  //用来判断该员工的部门和职位

@end





