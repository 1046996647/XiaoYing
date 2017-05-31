//
//  StringChangeDate.h
//  XiaoYing
//
//  Created by ZWL on 15/12/3.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringChangeDate : NSObject



+ (NSDate *)StringChangeDateWay:(NSString *)str;

+ (NSString *)DateChangeStringWay:(NSDate *)date;

+(NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
@end
