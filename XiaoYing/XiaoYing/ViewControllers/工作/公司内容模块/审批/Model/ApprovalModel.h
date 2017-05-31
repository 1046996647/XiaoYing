//
//  ApprovalModel.h
//  XiaoYing
//
//  Created by YL20071 on 16/10/19.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApprovalModel : NSObject

@property (nonatomic, copy) NSString *createrProfileId; //申请人ID
@property (nonatomic, copy) NSString *createrName;      //申请人名字
@property (nonatomic, copy) NSString *createFaceUrl;    //申请人头像URL
@property (nonatomic, copy) NSString *applyID;          //申请ID
@property (nonatomic, copy) NSString *applyTypeName;    //申请种类的名称
@property (nonatomic, copy) NSString *context;          //申请的描述内容
@property (nonatomic, strong) NSDate *createTime;       //申请创建的时间
@property (nonatomic, assign) NSInteger status;         //申请的当前状态
@property (nonatomic, copy) NSString *statusDesc;       //状态描述说明
@property (nonatomic, copy) NSString *progress;         //总进度
@property(nonatomic,copy)NSString *timeSpan;            //用时
@property(nonatomic,assign)NSInteger applySysType;      //是否是公告

- (instancetype)initWithDict:(NSDictionary*)dict;

+ (NSArray*)getModelArrayFromModelArray:(NSArray*)array;
+ (ApprovalModel*)modelFromDic:(NSDictionary*)dic;
@end
