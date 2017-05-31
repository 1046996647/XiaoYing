//
//  NSMutableArray+SortOfName.h
//  XiaoYing
//
//  Created by GZH on 2016/11/15.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (SortOfName)

//按姓名排序
+ (NSMutableArray *)SortOfNameWithArray:(NSMutableArray *)array1
                         AndTargetArray:(NSMutableArray *)array2;


//按时间排序
+ (NSMutableArray *)SortOfTimeWithArray:(NSMutableArray *)array1
                         AndTargetArray:(NSMutableArray *)array2;

@end
