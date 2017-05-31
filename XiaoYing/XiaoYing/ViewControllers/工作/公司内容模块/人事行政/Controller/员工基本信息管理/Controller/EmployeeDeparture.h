//
//  EmployeeDeparture.h
//  XiaoYing
//
//  Created by GZH on 16/10/28.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"

@protocol EmployeeDepartureDelegate <NSObject>

- (void)employDepareture;

@end

@interface EmployeeDeparture : BaseSettingViewController

@property (nonatomic, assign)id<EmployeeDepartureDelegate>delegate;

@end
