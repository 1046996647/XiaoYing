//
//  FlowModel.m
//  XiaoYing
//
//  Created by YL20071 on 16/10/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "FlowModel.h"

@implementation FlowModel

//得到model数组
+(NSArray*)getModelArrayFromModelArray:(NSArray*)array{
    NSMutableArray *mutableArray = [array mutableCopy];
    for (NSInteger i = 0; i<mutableArray.count; i++) {
        NSDictionary *dic = mutableArray[i];
        FlowModel *model = [FlowModel modelFromDic:dic];
        [mutableArray replaceObjectAtIndex:i withObject:model];
    }
    return [mutableArray copy];
}

//从字典中得到model
+(FlowModel*)modelFromDic:(NSDictionary*)dic{
    FlowModel *model = [FlowModel new];
    model.level = [dic[@"Level"] integerValue];
    model.normal = [dic[@"Normal"]boolValue];
    model.commneterName = dic[@"CommneterName"];
    model.commenterJobName = dic[@"CommenterJobName"];
    model.commenterFaceFormatUrl = dic[@"CommenterFaceFormatUrl"];
    model.status = [dic[@"Status"] integerValue];
    NSString *dateStr = dic[@"SubmitTime"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    model.submitTime = [formatter dateFromString:dateStr];
    model.comment = dic[@"Comment"];
    model.photos = dic[@"Photos"];
    model.voices = dic[@"Voices"];
    model.commenterProfileId = dic[@"CommenterProfileId"];
    return model;
}

@end
