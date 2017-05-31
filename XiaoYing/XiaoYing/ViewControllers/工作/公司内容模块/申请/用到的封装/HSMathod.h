//
//  HSMathod.h
//  XiaoYing
//
//  Created by chenchanghua on 16/12/28.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSMathod : NSObject

//获取当前屏幕显示的viewController对象，不需要任何参数
+ (UIViewController *)getCurrentViewController;

//通过字符串、限定的文本宽，得到文本高
+ (CGFloat)getHightForText:(NSString *)textStr limitWidth:(CGFloat)limitWidth fontSize:(CGFloat)fontSize;

//通过字符串、限定的文本高，得到文本宽
+ (CGFloat)getWidthForText:(NSString *)textStr limitHight:(CGFloat)limitHight fontSize:(CGFloat)fontSize;

@end
