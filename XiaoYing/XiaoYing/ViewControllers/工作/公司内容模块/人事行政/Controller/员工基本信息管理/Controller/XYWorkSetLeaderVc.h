//
//  XYWorkSetLeaderVc.h
//  XiaoYing
//
//  Created by qj－shanwen on 16/7/29.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "DepartmentModel.h"
#import "EmployeeModel.h"

typedef void(^RefershDataBlock)(NSMutableArray *array, NSMutableArray *array1, NSArray *array2);


@interface XYWorkSetLeaderVc : BaseSettingViewController

@property (nonatomic,copy) NSString *comanyName;
@property (nonatomic,strong) DepartmentModel *model;
@property (nonatomic,strong) EmployeeModel *empModel;

@property (nonatomic,strong) NSArray *departments;
@property (nonatomic,strong) NSArray *employees;
@property (nonatomic, copy) RefershDataBlock refershDataBlock;


@end
