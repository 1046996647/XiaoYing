//
//  HSMathod.m
//  XiaoYing
//
//  Created by chenchanghua on 16/12/28.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "HSMathod.h"

@implementation HSMathod

//获取当前屏幕显示的viewController对象，不需要任何参数
+ (UIViewController *)getCurrentViewController
{
    // 定义一个变量存放当前屏幕显示的viewcontroller
    UIViewController *result = nil;
    
    // 得到当前应用程序的关键窗口（正在活跃的窗口）
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    // windowLevel是在 Z轴 方向上的窗口位置，默认值为UIWindowLevelNormal
    if (window.windowLevel != UIWindowLevelNormal)
    {
        // 获取应用程序所有的窗口
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            // 找到程序的默认窗口（正在显示的窗口）
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                // 将关键窗口赋值为默认窗口
                window = tmpWin;
                break;
            }
        }
    }
    // 获取窗口的当前显示视图
    UIView *frontView = [[window subviews] objectAtIndex:0];
    
    // 获取视图的下一个响应者，UIView视图调用这个方法的返回值为UIViewController或它的父视图
    id nextResponder = [frontView nextResponder];
    
    // 判断显示视图的下一个响应者是否为一个UIViewController的类对象
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
}

//通过字符串、限定的文本宽，得到文本高
+ (CGFloat)getHightForText:(NSString *)textStr limitWidth:(CGFloat)limitWidth fontSize:(CGFloat)fontSize
{
    CGRect textRect = [textStr boundingRectWithSize:CGSizeMake(limitWidth, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil];
    return textRect.size.height;
}

//通过字符串、限定的文本高，得到文本宽
+ (CGFloat)getWidthForText:(NSString *)textStr limitHight:(CGFloat)limitHight fontSize:(CGFloat)fontSize
{
    CGRect textRect = [textStr boundingRectWithSize:CGSizeMake(0, limitHight) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil];
    return textRect.size.width;
}

@end
