//
//  StringChangeDate.m
//  XiaoYing
//
//  Created by ZWL on 15/12/3.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "StringChangeDate.h"

@implementation StringChangeDate

/**
 *  字符串转换为时间
 *
 *  @param str 字符串
 *
 *  @return 时间
 */
+ (NSDate *)StringChangeDateWay:(NSString *)str{
    NSDateFormatter *inputFormatter =[[NSDateFormatter alloc]init];
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"]];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *inputDate = [inputFormatter dateFromString:str];
    
    return   [self getNowDateFromatAnDate:inputDate];
}
/**
 *  转变为当前的系统时间
 *
 *  @param anyDate
 *
 *  @return 系统当前时间
 */
+(NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate{
    
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    
    return destinationDateNow;
}
/**
 *  当前时间转换为字符串
 *
 *  @param date 当前时间
 *
 *  @return 字符串
 */
+ (NSString *)DateChangeStringWay:(NSDate *)date{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [df stringFromDate:date] ;
}
@end
