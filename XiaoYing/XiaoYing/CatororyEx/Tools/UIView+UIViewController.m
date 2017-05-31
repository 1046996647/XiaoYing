//
//  UIView+UIViewController.m

//
//  Created by imac on 15/9/2.
//  Copyright (c) 2015年 朱思明. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)

- (UIViewController *)viewController
{
    UIResponder *responder = self.nextResponder;
    while (![responder isKindOfClass:[UIViewController class]] && responder != nil) {
        responder = responder.nextResponder;
    }
    return (UIViewController *)responder;
}

// textview
- (void)computeWordCountWithTextView:(UITextView *)originTextView remindLab:(UILabel *)remindLab warningLabel:(UILabel *)warningLabel maxNumber:(NSUInteger)maxNum
{
    if (originTextView.text.length > 0) {
        remindLab.hidden = YES;
    } else {
        remindLab.hidden = NO;
        
    }
    
    NSString *toBeString = originTextView.text;
    
    NSString *lang = [originTextView.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        //获取高亮部分
        UITextRange *selectedRange = [originTextView markedTextRange];
        UITextPosition *position = [originTextView positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > maxNum)
            {
                originTextView.text = [toBeString substringToIndex:maxNum];
                warningLabel.text = @"0";
            }else {
                
                warningLabel.text = [NSString stringWithFormat:@"%ld", (maxNum - toBeString.length)];
                
            }
        }
        // 拼音输入时，拼音字母处于选中状态，此时不判断是否超长
        
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > maxNum)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxNum];
            if (rangeIndex.length == 1)
            {
                originTextView.text = [toBeString substringToIndex:maxNum];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxNum)];
                originTextView.text = [toBeString substringWithRange:rangeRange];
            }
            warningLabel.text = @"0";
        }else {
            
            warningLabel.text = [NSString stringWithFormat:@"%ld", (maxNum - toBeString.length)];
            
        }
    }
    
}


// textfield
- (void)computeWordCountWithTextField:(UITextField *)originTextField warningLabel:(UILabel *)warningLabel maxNumber:(NSUInteger)maxNum
{
    
    
    NSString *toBeString = originTextField.text;
    
    NSString *lang = [originTextField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        //获取高亮部分
        UITextRange *selectedRange = [originTextField markedTextRange];
        UITextPosition *position = [originTextField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > maxNum)
            {
                originTextField.text = [toBeString substringToIndex:maxNum];
                warningLabel.text = @"0";
            }else {
                
                warningLabel.text = [NSString stringWithFormat:@"%ld", (maxNum - toBeString.length)];
                
            }
        }
        // 拼音输入时，拼音字母处于选中状态，此时不判断是否超长
        
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > maxNum)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxNum];
            if (rangeIndex.length == 1)
            {
                originTextField.text = [toBeString substringToIndex:maxNum];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxNum)];
                originTextField.text = [toBeString substringWithRange:rangeRange];
            }
            warningLabel.text = @"0";
        }else {
            
            warningLabel.text = [NSString stringWithFormat:@"%ld", (maxNum - toBeString.length)];
            
        }
    }
    
}



@end
