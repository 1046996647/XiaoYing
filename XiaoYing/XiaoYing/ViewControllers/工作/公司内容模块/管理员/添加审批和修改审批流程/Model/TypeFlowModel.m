//
//  TypeFlowModel.m
//  XiaoYing
//
//  Created by ZWL on 16/9/19.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "TypeFlowModel.h"

@implementation TypeFlowModel

- (instancetype)initWithContentsOfDic:(NSDictionary *)dic
{
    self = [super initWithContentsOfDic:dic];
    if (self) {
        self.Used = dic[@"Used"];
        self.level = [dic[@"Level"] integerValue];
        self.maxPower = [dic[@"MaxPower"] integerValue];
//        self.Normal = dic[@"Normal"];

    }
    return self;
}

@end
