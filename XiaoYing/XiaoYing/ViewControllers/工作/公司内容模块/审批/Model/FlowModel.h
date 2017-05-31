//
//  FlowModel.h
//  XiaoYing
//
//  Created by YL20071 on 16/10/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlowModel : NSObject

@property(nonatomic,assign)NSInteger level;//层级
@property(nonatomic,assign)BOOL normal;//是否正常（与部门相关信息是否匹配）
@property(nonatomic,copy)NSString *commneterName;//批复人名称
@property(nonatomic,copy)NSString *commenterJobName;//批复人岗位
@property(nonatomic,copy)NSString *commenterFaceFormatUrl;//批复人的头像地址
@property(nonatomic,assign)NSInteger status;//批复状态
@property(nonatomic,strong)NSDate *submitTime;//提交时间，当状态为审批中时，改时间无效
@property(nonatomic,copy)NSString *comment;//批复意见
@property(nonatomic,strong)NSArray *photos;//图片数组
@property(nonatomic,strong)NSArray *voices;//语音数组
@property(nonatomic,copy)NSString *commenterProfileId;//审批人的ID
@property(nonatomic,assign )BOOL isExpand;

//得到model数组
+(NSArray*)getModelArrayFromModelArray:(NSArray*)array;
//从字典中得到model
+(FlowModel*)modelFromDic:(NSDictionary*)dic;
@end
