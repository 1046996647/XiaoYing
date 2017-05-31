//
//  NSString+StrAndDicChanged.h
//  XiaoYing
//
//  Created by GZH on 2016/12/28.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StrAndDicChanged)

//将字典转换成字符串
+ (NSString *)getStringWithDic:(NSDictionary *)dic;

@end



@interface NSDictionary (StrAndDicChanged)
//将字符串转换成字典
+ (NSDictionary *)getDicWithString:(NSString *)string;

@end
