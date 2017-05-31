//
//  NSString+ReplaceStr.h
//  XiaoYing
//
//  Created by GZH on 16/10/13.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ReplaceStr)

+ (NSString *)replaceString:(NSString *)strURL
                   Withstr1:(NSString *)str1
                       str2:(NSString *)str2
                       str3:(NSString *)str3;

@end
