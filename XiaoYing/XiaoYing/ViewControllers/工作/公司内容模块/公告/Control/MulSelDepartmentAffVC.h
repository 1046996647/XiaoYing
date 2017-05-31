//
//  MulSelDepartmentAffVC.h
//  XiaoYing
//
//  Created by 王思齐 on 16/11/17.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"
typedef void(^SendBlock)(NSMutableArray *);
@interface MulSelDepartmentAffVC : BaseSettingViewController
@property (nonatomic, copy)NSString *CompanyName;
@property (nonatomic, strong)NSNumber *CompanyRanks;
@property (nonatomic,strong) NSArray *departments;
@property (nonatomic,strong) NSArray *subUnitArray;
@property (nonatomic, strong)NSMutableArray *selectedArr;

@property(nonatomic,strong)NSArray *allowDepartments;//允许申请的部门
@property (nonatomic,copy) SendBlock sendBlock;

@end
