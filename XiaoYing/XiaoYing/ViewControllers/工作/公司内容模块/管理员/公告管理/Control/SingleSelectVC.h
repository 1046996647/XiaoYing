//
//  SingleSelectVC.h
//  XiaoYing
//
//  Created by 王思齐 on 16/11/25.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeModel.h"
#import "DepartmentModel.h"
typedef void(^SendEmployeeBlock)(EmployeeModel *);
@interface SingleSelectVC : BaseSettingViewController

@property (nonatomic,strong) DepartmentModel *model;
@property (nonatomic,strong) EmployeeModel *empModel;

@property (nonatomic,copy) NSString *comanyName;
@property (nonatomic,strong) NSArray *departments;
@property (nonatomic,strong) NSArray *employees;

@property (nonatomic,copy) SendEmployeeBlock sendEmployeeBlock;
@end
