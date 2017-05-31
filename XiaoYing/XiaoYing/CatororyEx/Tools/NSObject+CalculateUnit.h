//
//  NSObject+CalculateUnit.h
//  XiaoYing
//
//  Created by ZWL on 17/1/22.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CalculateUnit)

+ (float)calculateFileSizeInUnit:(unsigned long long)contentLength;

+ (NSString *)calculateUnit:(unsigned long long)contentLength;

@end
