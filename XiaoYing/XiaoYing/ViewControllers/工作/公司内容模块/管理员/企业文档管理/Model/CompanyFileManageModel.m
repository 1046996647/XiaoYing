//
//  CompanyFileManageModel.m
//  XiaoYing
//
//  Created by ZWL on 16/1/26.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "CompanyFileManageModel.h"

@implementation CompanyFileManageModel

- (instancetype)initWithContentsOfDic:(NSDictionary *)dic
{
    self = [super initWithContentsOfDic:dic];
    if (self) {
        _isSelected = NO;
    }
    return self;
}

@end
