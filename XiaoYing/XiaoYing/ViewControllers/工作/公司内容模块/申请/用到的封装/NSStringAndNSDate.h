//
//  NSStringAndNSDate.h
//  XiaoYing
//
//  Created by chenchanghua on 16/10/20.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStringAndNSDate : NSObject

//NSString转NSDate
+ (NSString *)stringFromDate:(NSDate *)date;

//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)string;

//NSString转NSDate(2015-10-10)
+ (NSString *)stringFromDateYMD:(NSDate *)date;

//根据createDate计算出已经过去多少时分
+ (NSString *)passTimeFromCreateWithDate:(NSDate *)createDate;

//计算 (oldDate - newDate) 的间隔时间
+ (NSString *)passTimeFromOldDate:(NSDate *)oldDate toNewDate:(NSDate *)newDate;

@end
