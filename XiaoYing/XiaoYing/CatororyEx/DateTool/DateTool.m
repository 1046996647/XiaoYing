//
//  DateTool.m
//  XiaoYing
//
//  Created by ZWL on 15/12/7.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "DateTool.h"

@implementation DateTool
+ (NSTimeInterval )intervalFromLastDate:(NSDate *)date1 toTheDate:(NSDate *)date2{
    NSLog(@"date1=%@   date2=%@",date1,date2);
    NSTimeInterval late1 = [date1 timeIntervalSince1970]*1;
    NSTimeInterval late2 = [date2 timeIntervalSince1970]*1;
    NSTimeInterval cha = late1 - late2;
    return cha;
}
@end
