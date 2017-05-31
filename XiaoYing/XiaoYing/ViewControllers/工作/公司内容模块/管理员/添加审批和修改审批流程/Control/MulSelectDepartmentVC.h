//
//  AllowApplyDepartmentVC.h
//  XiaoYing
//
//  Created by ZWL on 16/4/28.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^SendBlock)(NSMutableArray *);


@interface MulSelectDepartmentVC : BaseSettingViewController

@property (nonatomic, copy)NSString *CompanyName;
@property (nonatomic, strong)NSNumber *CompanyRanks;
@property (nonatomic,strong) NSArray *departments;

@property (nonatomic,strong) NSArray *subUnitArray;

@property (nonatomic, strong)NSMutableArray *selectedArr;

@property (nonatomic,copy) SendBlock sendBlock;



@end
