//
//  NSString+StrAndDicChanged.m
//  XiaoYing
//
//  Created by GZH on 2016/12/28.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "NSString+StrAndDicChanged.h"

@implementation NSString (StrAndDicChanged)


+(NSString *)getStringWithDic:(NSDictionary *)dic {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}



@end




@implementation NSDictionary (StrAndDicChanged)


+ (NSDictionary *)getDicWithString:(NSString *)string {
    if (string == nil) {
        return nil;
    }
    
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    return dic;
}

@end
