//
//  NSObject+CalculateUnit.m
//  XiaoYing
//
//  Created by ZWL on 17/1/22.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "NSObject+CalculateUnit.h"

@implementation NSObject (CalculateUnit)

+ (float)calculateFileSizeInUnit:(unsigned long long)contentLength
{
    if(contentLength >= pow(1024, 3)) { return (float) (contentLength / (float)pow(1024, 3)); }
    else if (contentLength >= pow(1024, 2)) { return (float) (contentLength / (float)pow(1024, 2)); }
    else if (contentLength >= 1024) { return (float) (contentLength / (float)1024); }
    else { return (float) (contentLength); }
}

+ (NSString *)calculateUnit:(unsigned long long)contentLength
{
    if(contentLength >= pow(1024, 3)) { return @"G";}
    else if(contentLength >= pow(1024, 2)) { return @"M"; }
    else if(contentLength >= 1024) { return @"K"; }
    else { return @"B"; }
}

@end
