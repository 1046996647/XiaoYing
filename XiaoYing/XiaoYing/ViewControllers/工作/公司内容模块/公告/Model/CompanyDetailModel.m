//
//  CompanyDetailModel.m
//  XiaoYing
//
//  Created by GZH on 16/10/5.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "CompanyDetailModel.h"

@implementation CompanyDetailModel

-(instancetype)initWithDic:(NSDictionary*)dic{
    if (self = [super init]) {
        self.Content = dic[@"Content"];
        self.CreateTime = dic[@"CreateTime"];
        self.Creator = dic[@"Creator"];
        self.Id = dic[@"Id"];
        self.Rangs = dic[@"Rangs"];
        self.Title = dic[@"Title"];
    }
    return self;
}

+ (NSArray*)getModelArrayFromModelArray:(NSArray*)array{
    NSMutableArray *mutableArray = [array mutableCopy];
    for (NSInteger i = 0; i<mutableArray.count; i++) {
        NSDictionary *dic = mutableArray[i];
        CompanyDetailModel *model = [CompanyDetailModel modelFromDic:dic];
        [mutableArray replaceObjectAtIndex:i withObject:model];
    }
    return [mutableArray copy];
}

+ (CompanyDetailModel*)modelFromDic:(NSDictionary*)dic{
    CompanyDetailModel *model = [CompanyDetailModel new];
    model.Content = dic[@"Content"];
    model.CreateTime = dic[@"CreateTime"];
    model.Creator = dic[@"Creator"];
    model.Id = dic[@"Id"];
    model.Rangs = dic[@"Rangs"];
    model.Title = dic[@"Title"];
    return model;
}

@end
