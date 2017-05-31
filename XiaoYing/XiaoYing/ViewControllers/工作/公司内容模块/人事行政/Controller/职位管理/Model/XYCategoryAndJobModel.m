//
//  XYCategoryAndJobModel.m
//  XiaoYing
//
//  Created by chenchanghua on 16/11/16.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYCategoryAndJobModel.h"

@implementation XYCategoryAndJobModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        
        self.categoryModel = [XYCategoryModel modelFromDict:dict];
        self.jobModelArray = [XYJobModel getModelArrayFromOriginArray:dict[@"Jobs"]];
    }
    return self;
}

+ (NSMutableArray *)getModelArrayFromOriginArray:(NSArray *)array
{
    NSMutableArray *mutableArray = [array mutableCopy];
    for (NSInteger i = 0; i<mutableArray.count; i++) {
        NSDictionary *dic = mutableArray[i];
        XYCategoryAndJobModel *model = [XYCategoryAndJobModel modelFromDict:dic];
        [mutableArray replaceObjectAtIndex:i withObject:model];
    }
    return [mutableArray copy];
}

+ (XYCategoryAndJobModel *)modelFromDict:(NSDictionary *)dict
{
    XYCategoryAndJobModel *model = [[XYCategoryAndJobModel alloc] initWithDict:dict];
    return model;
}

@end
