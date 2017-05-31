//
//  UIView+redPoint.h
//  XiaoYing
//
//  Created by chenchanghua on 16/11/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (redPoint)

/*
 1.若角标显示为红点
 [myView showRedAtOffSetX:0 AndOffSetY:0 OrValue:nil];
 
 2.若角标显示为数字
 [myView showRedAtOffSetX:0 AndOffSetY:0 OrValue:@"2"];
 
 3.隐藏角标
 [myView hideRedPoint];
 
 */
- (void)showRedAtOffSetX:(float)offsetX AndOffSetY:(float)offsetY OrValue:(NSString *)value;
- (void)hideRedPoint;

/*
 1.若角标显示为红点
  [self.tabBarController.tabBar showBadgeOnItemIndex:1];
 
 2.隐藏角标
 [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
 
 3.若角标显示数字，则使用系统的badgeValue赋值即可
 
 */
- (void)showBadgeOnItemIndex:(int)index; //显示小红点
- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
