//
//  DocModel.m
//  XiaoYing
//
//  Created by 王思齐 on 16/12/13.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "DocModel.h"

@implementation DocModel
// 得到model数组
+ (NSArray*)getModelArrayFromModelArray:(NSArray*)array{
    NSMutableArray *mutableArray = [array mutableCopy];
    for (NSInteger i = 0; i<mutableArray.count; i++) {
        NSDictionary *dic = mutableArray[i];
        DocModel *model = [DocModel modelFromDic:dic];
        [mutableArray replaceObjectAtIndex:i withObject:model];
    }
    return [mutableArray copy];
}

// 从字典中得到model
+ (DocModel*)modelFromDic:(NSDictionary*)dic{
    DocModel *model = [DocModel new];
    model.CatID = dic[@"Id"];
    model.name = dic[@"Name"];
    model.creatTime = dic[@"CreateTime"];
    model.size = [dic[@"Size"] integerValue];
    model.type = [dic[@"Type"] integerValue];
    if (model.type == 0) {//如果是文件夹的话
        model.url = @"";
    }else{
        model.url = dic[@"Url"];
    }
    return model;
}
@end
