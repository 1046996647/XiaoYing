//
//  ZWLCacheData.m
//  XiaoYing
//
//  Created by ZWL on 16/11/11.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ZWLCacheData.h"

@implementation ZWLCacheData

+ (void)archiveObject:(id)obj toFile:(NSString *)path
{
    [NSKeyedArchiver archiveRootObject:@[] toFile:path];
    [NSKeyedArchiver archiveRootObject:obj toFile:path];

}

+ (id)unarchiveObjectWithFile:(NSString *)path
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

@end
