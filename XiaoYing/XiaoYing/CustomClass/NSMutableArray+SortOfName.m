//
//  NSMutableArray+SortOfName.m
//  XiaoYing
//
//  Created by GZH on 2016/11/15.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "NSMutableArray+SortOfName.h"

@implementation NSMutableArray (SortOfName)

+ (NSMutableArray *)SortOfNameWithArray:(NSMutableArray *)array1
                         AndTargetArray:(NSMutableArray *)array2{
    
    NSArray *sortArray = [array1 sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *arrayOfResult = [NSMutableArray array];
    for (id objc in sortArray) {
        if (![arrayOfResult containsObject:objc]) {
            [arrayOfResult addObject:objc];
        }
    }

    NSMutableArray *targetArray = [NSMutableArray array];
    for (int i = 0; i < arrayOfResult.count; i++) {
        for (int j = 0; j < array1.count; j++) {
            if ([arrayOfResult[i] isEqualToString:array1[j]]) {
                [targetArray addObject:array2[j]];
            }
        }
    }
    
    return targetArray;
}



+ (NSMutableArray *)SortOfTimeWithArray:(NSMutableArray *)array1
                         AndTargetArray:(NSMutableArray *)array2 {
    NSMutableArray *resultArray = [NSMutableArray array];
    NSMutableArray *targetArray = [NSMutableArray array];
    
    resultArray = (NSMutableArray *)[array1 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd/"];
        if (obj1 == [NSNull null]) {
            obj1 = @"0000/00/00";
        }
        if (obj2 == [NSNull null]) {
            obj2 = @"0000/00/00";
        }
        NSDate *date1 = [formatter dateFromString:obj1];
        NSDate *date2 = [formatter dateFromString:obj2];
        NSComparisonResult result = [date1 compare:date2];
        return result == NSOrderedAscending;
    }];
    
    for (int i = 0; i < resultArray.count; i++) {
        for (int j = 0; j < array1.count; j++) {
            if ([resultArray[i] isEqualToString:array1[j]]) {
                [targetArray addObject:array2[j]];
            }
        }
    }
  
    return targetArray;
}



@end



