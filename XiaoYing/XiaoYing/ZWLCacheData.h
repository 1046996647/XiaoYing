//
//  ZWLCacheData.h
//  XiaoYing
//
//  Created by ZWL on 16/11/11.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWLCacheData : NSObject

// 归档
+ (void)archiveObject:(id) obj toFile:(NSString *)path;

// 解档
+ (id)unarchiveObjectWithFile:(NSString *)path;


@end
