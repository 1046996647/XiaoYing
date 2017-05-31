//
//  ApplicationModel.h
//  XiaoYing
//
//  Created by chenchanghua on 16/10/12.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationModel : NSObject

@property (nonatomic, copy) NSString *createrProfileId; //
@property (nonatomic, copy) NSString *createrName;      //创建者的姓名
@property (nonatomic, copy) NSString *createrFaceUrl;   //创建者的头像URl

@property (nonatomic, copy) NSString *applyID;          //申请ID
@property (nonatomic, copy) NSString *applyTypeName;    //申请种类的名称
@property (nonatomic, copy) NSString *context;          //申请的描述内容
@property (nonatomic, strong) NSString *createTime;     //申请创建的时间
@property (nonatomic, assign) NSInteger status;         //申请的当前状态
@property (nonatomic, copy) NSString *statusDesc;       //状态描述说明
@property (nonatomic, strong)UIColor *statusDescColor;  //状态描述说明的颜色
@property (nonatomic, copy) NSString *progress;         //总进度

- (instancetype)initWithDict:(NSDictionary*)dict;

+ (NSMutableArray*)getModelArrayFromModelArray:(NSArray*)array;
+ (ApplicationModel*)modelFromDict:(NSDictionary*)dict;

@end
