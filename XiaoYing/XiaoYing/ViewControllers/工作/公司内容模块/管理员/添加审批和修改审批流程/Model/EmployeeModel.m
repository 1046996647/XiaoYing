//
//  EmployeeModel.m
//  XiaoYing
//
//  Created by ZWL on 16/9/23.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "EmployeeModel.h"

@implementation EmployeeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (instancetype)initWithContentsOfDic:(NSDictionary *)dic
{
    self = [super initWithContentsOfDic:dic];
    if (self) {
        
        
//        if ([[dic objectForKey:@"RegionId"] isKindOfClass:[NSNull class]]) {
//            self.RegionId= @0;
//        }
        if ([[dic objectForKey:@"Birthday"] isKindOfClass:[NSNull class]]) {
            self.Birthday= @"";
        }
        else {
            NSArray *array = [self.Birthday componentsSeparatedByString:@" "];
            self.Birthday= array.firstObject;
        }
        if ([[dic objectForKey:@"Signer"] isKindOfClass:[NSNull class]]) {
            self.Signer= @"";
        }
//        if ([[dic objectForKey:@"Address"] isKindOfClass:[NSNull class]]) {
//            self.Address= @"";
//        }
        if ([[dic objectForKey:@"EmployeeNo"] isKindOfClass:[NSNull class]]) {
            self.EmployeeNo = @"";
        }
        if ([[dic objectForKey:@"Mobile"] isKindOfClass:[NSNull class]]) {
            self.Mobile= @"";
        }
    }
    return self;
}


@end
