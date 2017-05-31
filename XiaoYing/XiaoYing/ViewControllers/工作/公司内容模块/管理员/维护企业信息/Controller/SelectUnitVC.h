//
//  SelectUnitVC.h
//  XiaoYing
//
//  Created by ZWL on 16/9/13.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "DepartmentModel.h"
typedef void(^SendUnitBlock)(DepartmentModel *);

@interface SelectUnitVC : BaseSettingViewController

@property (nonatomic,strong) NSArray *departments;
@property (nonatomic,strong) NSArray *subUnitArray;

@property (nonatomic, strong) DepartmentModel *currentModel;
@property (nonatomic, copy)NSString *ParentID;
@property (nonatomic, copy)NSString *DepartmentId;
@property (nonatomic, copy)NSString *superTitle;
@property (nonatomic, copy)NSString *subTitle;
@property (nonatomic, strong)NSNumber *superRanks;

@property (nonatomic, strong)NSMutableArray *navArr;

@property (nonatomic,copy) SendUnitBlock sendUnitBlock;

@property (nonatomic,copy) NSString *comanyName;


@end
