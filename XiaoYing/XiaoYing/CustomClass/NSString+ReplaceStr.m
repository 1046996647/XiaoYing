//
//  NSString+ReplaceStr.m
//  XiaoYing
//
//  Created by GZH on 16/10/13.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "NSString+ReplaceStr.h"


@implementation NSString (ReplaceStr)

+ (NSString *)replaceString:(NSString *)strURL
                   Withstr1:(NSString *)str1
                       str2:(NSString *)str2
                       str3:(NSString *)str3 {
    NSString *URL = [strURL stringByReplacingOccurrencesOfString:@"{0}" withString:str1];
    NSString *URL1 = [URL stringByReplacingOccurrencesOfString:@"{1}" withString:str2];
    NSString *URL2 = [URL1 stringByReplacingOccurrencesOfString:@"{2}" withString:str3];
    
    if ([BaseUrl1 isEqualToString:@"http://api.yinglaijinrong.com"]) { //线上版本
        URL2 = [NSString stringWithFormat:@"http://img.yinglaijinrong.com/%@", URL2];
    } else { //线下版本
        URL2 = [NSString stringWithFormat:@"http://192.168.10.69:8081/%@", URL2];
    }
    
    return URL2;
}


@end
