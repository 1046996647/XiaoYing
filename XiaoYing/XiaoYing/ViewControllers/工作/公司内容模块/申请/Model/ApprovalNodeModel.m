//
//  ApprovalNodeModel.m
//  XiaoYing
//
//  Created by chenchanghua on 16/10/22.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ApprovalNodeModel.h"
#import "XYExtend.h"

@implementation ApprovalNodeModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        self.commenterFaceFormatUrl = [NSString replaceString:dict[@"CommenterFaceFormatUrl"] Withstr1:@"1000" str2:@"1000" str3:@"c"];
        self.receiveTime = dict[@""];
        self.commneterName = dict[@""];
        self.commenterJobName = dict[@""];
        self.statusName = dict[@""];
        self.tookTime = dict[@""];
        self.comment = dict[@""];
        self.photosArray = dict[@""];
    }
    
    return self;
}

// 得到model数组
+ (NSArray*)getModelArrayFromDataDictionary:(NSDictionary*)dataDict applicationStatus:(NSInteger)status{
    
    NSMutableArray *flowsMutableArray = [NSMutableArray array];
    
    NSArray *flowsArray = dataDict[@"Flows"];
    for (int i = 0; i < flowsArray.count; i ++) {
        
        if (i == 0) {
            
            ApprovalNodeModel *nodeModel = [[ApprovalNodeModel alloc] init];
            
            NSDictionary *tempDict = flowsArray.firstObject;
            nodeModel.commenterFaceFormatUrl = [NSString replaceString:tempDict[@"CommenterFaceFormatUrl"] Withstr1:@"1000" str2:@"1000" str3:@"c"];
            nodeModel.receiveTime = dataDict[@"SendDateTime"];
            nodeModel.commneterName = tempDict[@"CommneterName"];
            nodeModel.commenterJobName = tempDict[@"CommenterJobName"];
            nodeModel.statusName = [self statusNameStrFromStatusNum:[tempDict[@"Status"] integerValue] applicationStatus:status];
            
            if ([ApprovalNodeModel judgeStatusWheatheGoing:[tempDict[@"Status"] integerValue]]) {
                
                nodeModel.tookTime = [NSStringAndNSDate passTimeFromCreateWithDate:[NSStringAndNSDate dateFromString:dataDict[@"SendDateTime"]]];
                
            }else {
                nodeModel.tookTime = [NSStringAndNSDate passTimeFromOldDate:[NSStringAndNSDate dateFromString:dataDict[@"SendDateTime"]] toNewDate:[NSStringAndNSDate dateFromString:tempDict[@"SubmitTime"]]];
            }
            
            nodeModel.comment = tempDict[@"Comment"];
            nodeModel.photosArray = [ApprovalNodeModel replaceImageUrlFromImageArray:tempDict[@"Photos"]];
            nodeModel.isExpand = NO;
            
            [flowsMutableArray addObject: nodeModel];
            
        }else if ((i > 0) && (i < flowsArray.count - 1)) {
        
            ApprovalNodeModel *nodeModel = [[ApprovalNodeModel alloc] init];
            
            NSDictionary *lastDict = [flowsArray objectAtIndex:(i-1)];
            NSDictionary *tempDict = [flowsArray objectAtIndex:i];
            nodeModel.commenterFaceFormatUrl = [NSString replaceString:tempDict[@"CommenterFaceFormatUrl"] Withstr1:@"1000" str2:@"1000" str3:@"c"];
            nodeModel.receiveTime = lastDict[@"SubmitTime"];
            nodeModel.commneterName = tempDict[@"CommneterName"];
            nodeModel.commenterJobName = tempDict[@"CommenterJobName"];
            nodeModel.statusName = [self statusNameStrFromStatusNum:[tempDict[@"Status"] integerValue] applicationStatus:status];
        
            if ([ApprovalNodeModel judgeStatusWheatheGoing:[tempDict[@"Status"] integerValue]]) {

                nodeModel.tookTime = [NSStringAndNSDate passTimeFromCreateWithDate:[NSStringAndNSDate dateFromString:lastDict[@"SubmitTime"]]];
                
            }else {
                nodeModel.tookTime = [NSStringAndNSDate passTimeFromOldDate:[NSStringAndNSDate dateFromString:lastDict[@"SubmitTime"]] toNewDate:[NSStringAndNSDate dateFromString:tempDict[@"SubmitTime"]]];
            }
            
            nodeModel.comment = tempDict[@"Comment"];
            nodeModel.photosArray = [ApprovalNodeModel replaceImageUrlFromImageArray:tempDict[@"Photos"]];
            nodeModel.isExpand = NO;
            
            [flowsMutableArray addObject: nodeModel];
        
        }else {
            
            ApprovalNodeModel *nodeModel = [[ApprovalNodeModel alloc] init];
            
            NSDictionary *lastDict = [flowsArray objectAtIndex:(i-1)];
            NSDictionary *tempDict = [flowsArray objectAtIndex:i];
            nodeModel.commenterFaceFormatUrl = [NSString replaceString:tempDict[@"CommenterFaceFormatUrl"] Withstr1:@"1000" str2:@"1000" str3:@"c"];
            nodeModel.receiveTime = lastDict[@"SubmitTime"];
            nodeModel.commneterName = tempDict[@"CommneterName"];
            nodeModel.commenterJobName = tempDict[@"CommenterJobName"];
            nodeModel.statusName = [self statusNameStrFromStatusNum:[tempDict[@"Status"] integerValue] applicationStatus:status];
            
            if ([ApprovalNodeModel judgeStatusWheatheGoing:[tempDict[@"Status"] integerValue]]) {
                
                nodeModel.tookTime = [NSStringAndNSDate passTimeFromCreateWithDate:[NSStringAndNSDate dateFromString:lastDict[@"SubmitTime"]]];
                
            }else {
                nodeModel.tookTime = [NSStringAndNSDate passTimeFromOldDate:[NSStringAndNSDate dateFromString:lastDict[@"SubmitTime"]] toNewDate:[NSStringAndNSDate dateFromString:tempDict[@"SubmitTime"]]];
            }
            
            nodeModel.comment = tempDict[@"Comment"];
            nodeModel.photosArray = [ApprovalNodeModel replaceImageUrlFromImageArray:tempDict[@"Photos"]];
            nodeModel.isExpand = NO;
            
            [flowsMutableArray addObject: nodeModel];
        
        }

    }
    
    
    
    return flowsMutableArray;
}

// 从字典中得到model
+ (ApprovalNodeModel*)modelFromDict:(NSDictionary*)dict{
    
    ApprovalNodeModel *model = [[ApprovalNodeModel alloc] initWithDict:dict];
    return model;
}

+ (BOOL)judgeStatusWheatheGoing:(NSInteger)statusNum
{
    if (statusNum == 2 || statusNum == 4) {
        return NO;
    }
    return YES;
}


+ (NSString *)statusNameStrFromStatusNum:(NSInteger)statusNum applicationStatus:(NSInteger)status
{
    NSString *statusStr = [[NSString alloc] init];
    switch (statusNum) {
            
        case 0:
            
            statusStr = (status == 2 || status == 4)? @"": @"待审批";
            break;
            
        case 1:
            
            statusStr = @"审批中";
            break;
            
        case 2:
            
            statusStr = @"已拒绝";
            break;
            
        case 3:
            
            statusStr = @"越级审批中";
            break;
            
        case 4:
            
            statusStr = @"审批通过";
            break;
   
    }
    
    return statusStr;
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

@end
