//
//  ApprovalModel.m
//  XiaoYing
//
//  Created by YL20071 on 16/10/19.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ApprovalModel.h"

@implementation ApprovalModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.createrProfileId = dict[@"CreaterProfileId"];
        self.createrName = dict[@"CreaterName"];
        self.createFaceUrl = dict[@"CreateFaceUrl"];
        self.applyID = dict[@"ApplyID"];
        self.applyTypeName = dict[@"ApplyTypeName"];
        self.context = dict[@"Context"];
        NSString *dateStr = dict[@"CreateTime"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.createTime = [formatter dateFromString:dateStr];
        self.status = [dict[@"Status"] integerValue];
        self.statusDesc = dict[@"StatusDesc"];
        self.progress = dict[@"Progress"];
        self.timeSpan = dict[@"TimeSpan"];
        self.applySysType = [dict[@"ApplySysType"]integerValue];
    }
    return self;
}

// 得到model数组
+ (NSArray*)getModelArrayFromModelArray:(NSArray*)array{
    NSMutableArray *mutableArray = [array mutableCopy];
    for (NSInteger i = 0; i<mutableArray.count; i++) {
        NSDictionary *dic = mutableArray[i];
        ApprovalModel *model = [ApprovalModel modelFromDic:dic];
        [mutableArray replaceObjectAtIndex:i withObject:model];
    }
    return [mutableArray copy];
}

// 从字典中得到model
+ (ApprovalModel*)modelFromDic:(NSDictionary*)dic{
    ApprovalModel *model = [ApprovalModel new];
    model.createrProfileId = dic[@"CreaterProfileId"];
    model.createrName = dic[@"CreaterName"];
    model.createFaceUrl = dic[@"CreateFaceUrl"];
    model.applyID = dic[@"ApplyID"];
    model.applyTypeName = dic[@"ApplyTypeName"];
    model.context = dic[@"Context"];
    NSString *dateStr = dic[@"CreateTime"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    model.createTime = [formatter dateFromString:dateStr];
    model.status = [dic[@"Status"] integerValue];
    model.statusDesc = dic[@"StatusDesc"];
    model.progress = dic[@"Progress"];
    model.timeSpan = dic[@"TimeSpan"];
    model.applySysType = [dic[@"ApplySysType"]integerValue];
    return model;
}

@end
