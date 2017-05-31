//
//  EditDetailOfMemberVC.h
//  XiaoYing
//
//  Created by ZWL on 16/10/6.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"
@class EmployeeModel;

typedef void(^ReferMember)(NSMutableArray *array, NSMutableArray *array1);


@interface EditDetailOfMemberVC : BaseSettingViewController

@property (nonatomic, strong) EmployeeModel *employeeModel;
@property (nonatomic, strong) NSString *Singer;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *FaceUrl;

@property (nonatomic, strong) NSString *JoinID;;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) NSString *tempDepartmentId;
@property (nonatomic, strong) NSString *ManagerProfileId;
@property (nonatomic, strong) NSString *RoleType;
@property (nonatomic, copy) ReferMember referMember;


@property (nonatomic, strong) NSNumber *superRanks;
@end
