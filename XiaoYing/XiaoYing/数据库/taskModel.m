//
//  taskModel.m
//  SQLiteDemo
//
//  Created by ZWL on 15/10/14.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#import "taskModel.h"

@implementation taskModel


+(NSString *)cutTimeString:(NSString *)str{
    
    NSArray *array = [str componentsSeparatedByString:@":"];
    NSString *time = [NSString stringWithFormat:@"%@:%@",array[0],array[1]];
    return time;
}

@end
