//
//  SortVC.h
//  XiaoYing
//
//  Created by ZWL on 16/7/4.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^BlockResult)(NSInteger str);

@interface SortVC : BaseSettingViewController

@property (nonatomic, copy)BlockResult blockResult;

@end
