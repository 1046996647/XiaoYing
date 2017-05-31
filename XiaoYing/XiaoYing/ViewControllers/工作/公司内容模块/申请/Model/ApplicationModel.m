//
//  ApplicationModel.m
//  XiaoYing
//
//  Created by chenchanghua on 16/10/12.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ApplicationModel.h"

@implementation ApplicationModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        
        self.createrProfileId = dict[@"CreaterProfileId"];
        self.createrName = [dict[@"CreaterName"] isEqual:[NSNull null]]? [UserInfo GetnameOfCard] : dict[@"CreaterName"];
        self.createrFaceUrl = [dict[@"CreateFaceUrl"] isEqual:[NSNull null]]? [UserInfo GetfaceURLofCard] : dict[@"CreateFaceUrl"];
        
        self.applyID = dict[@"ApplyID"];
        self.applyTypeName = [dict[@"ApplyTypeName"] isEqual:[NSNull null]]? @"" : dict[@"ApplyTypeName"];
        self.context = dict[@"Context"];
        self.createTime = dict[@"CreateTime"];
        self.status = [dict[@"Status"] integerValue];
        self.statusDesc = dict[@"StatusDesc"];
        self.statusDescColor = [self getColorAccodingToStatus:self.status];
        self.progress = dict[@"Progress"];
        
    }
    return self;
}

// 得到model数组
+ (NSMutableArray*)getModelArrayFromModelArray:(NSArray*)array{
    
    NSMutableArray *mutableArray = [array mutableCopy];
    for (NSInteger i = 0; i<mutableArray.count; i++) {
        NSDictionary *dic = mutableArray[i];
        ApplicationModel *model = [ApplicationModel modelFromDict:dic];
        [mutableArray replaceObjectAtIndex:i withObject:model];
    }
    return mutableArray;
}

// 从字典中得到model
+ (ApplicationModel*)modelFromDict:(NSDictionary*)dict{
    
    ApplicationModel *model = [[ApplicationModel alloc] initWithDict:dict];
    return model;
}

- (UIColor *)getColorAccodingToStatus:(NSInteger)status
{
    UIColor *statusColor = [[UIColor alloc] init];
    
    switch (status) {
        case 0: //新建
            
            statusColor = [UIColor colorWithHexString:@"#848484"];
            break;
            
        case 1: //审核中
            
            statusColor = [UIColor colorWithHexString:@"#848484"];
            break;
            
        case 2: //已拒绝
            
            statusColor = [UIColor colorWithHexString:@"#f94040"];
            break;
            
        case 3: //越级审核中
            
            statusColor = [UIColor colorWithHexString:@"#f94040"];
            break;
            
        case 4: //已取消
            
            statusColor = [UIColor colorWithHexString:@"#848484"];
            break;
            
        case 5: //审核通过
            
            statusColor = [UIColor colorWithHexString:@"#02bb00"];
            break;
            
        case 6: //审核未通过
            
            statusColor = [UIColor colorWithHexString:@"#f94040"];
            break;
    }
    
    return statusColor;
}

@end
