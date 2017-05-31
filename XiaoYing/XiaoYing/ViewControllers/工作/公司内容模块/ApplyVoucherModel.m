//
//  ApplyVoucherModel.m
//  XiaoYing
//
//  Created by YL20071 on 16/10/26.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ApplyVoucherModel.h"

@implementation ApplyVoucherModel

//从字典中获取模型数组
+(NSArray*)getApplyVoucherModelArrayFromArray:(NSArray*)array{
    NSMutableArray *mutableArray = [array mutableCopy];
    for (NSInteger i = 0; i<mutableArray.count; i++) {
        NSDictionary *dic = mutableArray[i];
        ApplyVoucherModel *model = [ApplyVoucherModel getApplyVoucherModelFromDic:dic];
        [mutableArray replaceObjectAtIndex:i withObject:model];
    }
    return [mutableArray copy];
}

//从字典中获取模型
+(ApplyVoucherModel*)getApplyVoucherModelFromDic:(NSDictionary*)dic{
    ApplyVoucherModel *model = [ApplyVoucherModel new];
    model.serialNumber = dic[@"SerialNumber"];
    model.createrName = dic[@"CreaterName"];
    model.approvalTypeName = dic[@"ApprovalTypeName"];
    model.approvalTag = dic[@"ApprovalTag"];
    model.tagtype = [dic[@"Tagtype"] integerValue];
    model.passingTime = dic[@"PassingTime"];
    model.faceUrl = dic[@"FaceUrl"];
    model.applyContent = dic[@"ApplyContent"];
    model.approvalCategoryName = dic[@"ApprovalCategoryName"];
    model.role = dic[@"Role"];
    return model;
}
@end
