//
//  SingleSelectPeopleVC.h
//  XiaoYing
//
//  Created by ZWL on 16/10/4.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "DepartmentModel.h"
#import "EmployeeModel.h"

typedef void(^SendEmployeeBlock)(EmployeeModel *);


@interface SingleSelectPeopleVC : BaseSettingViewController

@property (nonatomic,strong) DepartmentModel *model;
@property (nonatomic,strong) EmployeeModel *empModel;

@property (nonatomic,copy) NSString *comanyName;
@property (nonatomic,strong) NSArray *departments;
@property (nonatomic,strong) NSArray *employees;

@property (nonatomic,copy) SendEmployeeBlock sendEmployeeBlock;


@end
