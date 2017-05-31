//
//  NSNumber+RegionName.m
//  XiaoYing
//
//  Created by ZWL on 16/10/28.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "NSNumber+RegionName.h"

@implementation NSNumber (RegionName)


- (NSString *)getRegionName
{
    //---------------------------地区-----------------------------
    //获取本地地区文件
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/region.plist"];
    NSArray *fullRegionArr = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *arrM = [NSMutableArray array];
    //    [arrM addObject:self.profileMyModel.RegionName];
    // 取出parentId
    NSNumber *parentId = nil;
    for (NSDictionary *dic in fullRegionArr) {
        if ([dic[@"Id"] integerValue] == self.integerValue) {
            [arrM addObject:dic[@"RegionName"]];
            parentId = dic[@"ParentId"];
        }
    }
    
    for (int i = 0; i < 2; i++) {
        for (NSDictionary *dic in fullRegionArr) {
            if ([dic[@"Id"] integerValue] == [parentId integerValue]) {
                [arrM addObject:dic[@"RegionName"]];
                parentId = dic[@"ParentId"];
            }
        }
    }
    
    //地区拼接
    NSMutableString *fullRegion = [NSMutableString string];
    for (NSInteger i = arrM.count - 1; i >= 0; i--) {
        [fullRegion appendFormat:@"%@",arrM[i]];
    }
    return fullRegion;
}

@end
