//
//  ApplicationMessageModel.m
//  XiaoYing
//
//  Created by chenchanghua on 16/10/22.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ApplicationMessageModel.h"
#import "XYExtend.h"

@implementation ApplicationMessageModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.requestSerialNumber = dict[@"RequestSerialNumber"];
        self.typeName = dict[@"TypeName"];
        self.typeId = dict[@"TypeId"];
        self.tagType = [dict[@"TagType"] integerValue];
        self.approvalTag = dict[@"ApprovalTag"];
        self.passDateTime = [NSStringAndNSDate passTimeFromCreateWithDate:[NSStringAndNSDate dateFromString:dict[@"SendDateTime"]]];
        self.remark = dict[@"Remark"];
        self.imagesArray = [ApplicationMessageModel replaceImageUrlFromImageArray:dict[@"Images"]];
        
        self.originImagesUrlArray = [self getOriginImagesUrlWithImages:dict[@"Images"]];
        self.originImagesIdArray = [self getOriginImagesIdWithImages:dict[@"Images"]];
        
    }
    return self;
}

// 从字典中得到model
+ (ApplicationMessageModel*)modelFromDict:(NSDictionary*)dict{
    
    ApplicationMessageModel *model = [[ApplicationMessageModel alloc] initWithDict:dict];
    return model;
}

+ (NSMutableArray *)replaceImageUrlFromImageArray:(NSArray *)images
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *urlDic in images) {
        NSString *url = urlDic[@"URL"];
        NSString *imageStr = [NSString replaceString:url Withstr1:@"1000" str2:@"1000" str3:@"c"];
        [tempArray addObject:imageStr];
        
    }
    return tempArray;
}

- (NSArray *)getOriginImagesUrlWithImages:(NSArray *)images
{
    NSMutableArray *tempMutableArray = [NSMutableArray array];
    for (NSDictionary *dict in images) {
        [tempMutableArray addObject:dict[@"URL"]];
    }
    return [tempMutableArray copy];
}

- (NSArray *)getOriginImagesIdWithImages:(NSArray *)images
{
    NSMutableArray *tempMutableArray = [NSMutableArray array];
    for (NSDictionary *dict in images) {
        [tempMutableArray addObject:dict[@"Id"]];
    }
    return [tempMutableArray copy];
}

@end
