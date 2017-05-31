//
//  AppDelegate.h
//  XiaoYing
//
//  Created by ZWL on 15/10/12.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTool.h"
#import "LoginTabVC.h"
#import "CustomTabVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginTabVC *tabvc;
@property (assign, nonatomic) NSInteger mesCount;
 
@end
