//
//  UIView+UIViewController.h
//  WXMovie
//
//  Created by imac on 15/9/2.
//  Copyright (c) 2015年 朱思明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewController)

// 获取控制器
- (UIViewController *)viewController;

// 字数的控制
- (void)computeWordCountWithTextView:(UITextView *)originTextView remindLab:(UILabel *)remindLab warningLabel:(UILabel *)warningLabel maxNumber:(NSUInteger)maxNum;


- (void)computeWordCountWithTextField:(UITextField *)originTextField warningLabel:(UILabel *)warningLabel maxNumber:(NSUInteger)maxNum;

@end
