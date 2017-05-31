//
//  XYJobModel.m
//  XiaoYing
//
//  Created by chenchanghua on 16/10/8.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYJobModel.h"

@implementation XYJobModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        
        self.jobId = dict[@"ID"];
        self.jobName = dict[@"JobName"];
        self.jobDescription = [dict[@"JobDescription"] isEqual:[NSNull null]]? @"": dict[@"JobDescription"];
    }
    return self;
}

// 得到model数组
+ (NSMutableArray*)getModelArrayFromOriginArray:(NSArray*)array{
    
    NSMutableArray *mutableArray = [array mutableCopy];
    for (NSInteger i = 0; i<mutableArray.count; i++) {
        NSDictionary *dic = mutableArray[i];
        XYJobModel *model = [XYJobModel modelFromDict:dic];
        [mutableArray replaceObjectAtIndex:i withObject:model];
    }
    return [mutableArray copy];
}

// 从字典中得到model
+ (XYJobModel*)modelFromDict:(NSDictionary*)dict{
    
    XYJobModel *model = [[XYJobModel alloc] initWithDict:dict];
    return model;
}


- (NSString *)description
{
    NSString *str = [NSString stringWithFormat:@"\njobId:%@,\njobName:%@,\njobDescription:%@", self.jobId, self.jobName, self.jobDescription];
    return str;
}

@end
