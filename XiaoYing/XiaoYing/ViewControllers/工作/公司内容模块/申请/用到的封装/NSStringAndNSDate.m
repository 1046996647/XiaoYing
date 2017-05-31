//
//  NSStringAndNSDate.m
//  XiaoYing
//
//  Created by chenchanghua on 16/10/20.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "NSStringAndNSDate.h"

@implementation NSStringAndNSDate

//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date
{
    //获取系统当前时间
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    //输出currentDateString
    NSLog(@"%@",currentDateString);
    return currentDateString;
}

//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)string
{
    //需要转换的字符串
    NSString *dateString = @"2015-06-26 08:08:08";
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:string];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    
    return [date dateByAddingTimeInterval:interval];
}

+ (NSString *)stringFromDateYMD:(NSDate *)date
{
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *dateString = [dateFormatter stringFromDate:date];
    //输出currentDateString
    return dateString;
}

//与当前时间进行对比
+ (NSString *)passTimeFromCreateWithDate:(NSDate *)createDate
{
    NSDate *currentDate=[NSStringAndNSDate getChineseCurrentDate];//获取当前时间
    NSDate *applyData = createDate;//申请发出的时间
    // 当前时间与申请发出的时间之间的时间差（秒）
    double intervalTime = currentDate.timeIntervalSince1970 - applyData.timeIntervalSince1970;
    NSInteger time = (NSInteger)intervalTime;
    NSInteger minutes = (time / 60) % 60;
    NSInteger hours = (time / 3600);
    return [NSString stringWithFormat:@"%ld时%ld分",hours,minutes];
}

//计算 (oldDate - newDate) 的间隔时间
+ (NSString *)passTimeFromOldDate:(NSDate *)oldDate toNewDate:(NSDate *)newDate
{
    NSLog(@"newDate.timeIntervalSince1970~~%f", newDate.timeIntervalSinceReferenceDate);
    double newIntervalTime = newDate.timeIntervalSince1970;
    double oldIntervalTime = oldDate.timeIntervalSince1970;
    double intervalTime = newIntervalTime - oldIntervalTime;
    NSInteger time = (NSInteger)intervalTime;
    NSInteger minutes = (time / 60) % 60;
    NSInteger hours = (time / 3600);
    return [NSString stringWithFormat:@"%ld时%ld分",hours,minutes];
}

+ (NSDate *)getChineseCurrentDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    return localDate;
}

@end
