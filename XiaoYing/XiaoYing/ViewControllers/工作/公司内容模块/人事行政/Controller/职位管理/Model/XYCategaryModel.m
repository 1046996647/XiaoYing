//
//  XYEditModel.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/23.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYCategoryModel.h"

@implementation XYCategoryModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        
        self.categoryName = dict[@"CategroyName"];
        self.positionCount = [dict[@"Count"] integerValue];
        self.categoryId = dict[@"ID"];
    }
    return self;
}

+ (XYCategoryModel *)modelFromDict:(NSDictionary*)dict
{
    XYCategoryModel *model = [[XYCategoryModel alloc] initWithDict:dict];
    return model;
}

@end
