//
//  FrameManagerVC.h
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/23.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"
//#import "DepartmentModel.h"

typedef void(^SendBlock)(NSMutableArray *);


@interface FrameManagerVC : BaseSettingViewController
@property (nonatomic, copy)NSString *type;

@property (nonatomic, copy)NSString *ParentID;
@property (nonatomic, copy)NSString *DepartmentId;
@property (nonatomic, copy)NSString *superTitle;
@property (nonatomic, copy)NSString *subTitle;
@property (nonatomic, strong)NSNumber *superRanks;
@property (nonatomic, strong)NSNumber *ranks;

//@property (nonatomic,strong) DepartmentModel *model;

@property (nonatomic,copy) SendBlock sendBlock;
@property (nonatomic,strong) NSArray *departments;

@property (nonatomic,copy) NSString *comanyName;


@end
