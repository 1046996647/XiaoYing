//
//  MSDepartmentViewController.h
//  XiaoYing
//
//  Created by 王思齐 on 16/11/24.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"
@interface MSDepartmentViewController : BaseSettingViewController
@property (nonatomic, copy)NSString *CompanyName;
@property (nonatomic, strong)NSNumber *CompanyRanks;
@property (nonatomic,strong) NSArray *departments;
@property (nonatomic,strong) NSArray *subUnitArray;
@property (nonatomic, strong)NSMutableArray *selectedArr;

@end
