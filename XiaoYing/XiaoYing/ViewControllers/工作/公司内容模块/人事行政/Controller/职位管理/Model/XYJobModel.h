//
//  XYJobModel.h
//  XiaoYing
//
//  Created by chenchanghua on 16/10/8.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYJobModel : NSObject

@property (nonatomic, copy) NSString *jobId;//职位ID
@property (nonatomic, copy) NSString *jobName;//职位名称
@property (nonatomic, copy) NSString *jobDescription;//职位说明

-(instancetype)initWithDict:(NSDictionary*)dict;

+ (NSMutableArray *)getModelArrayFromOriginArray:(NSArray*)array;
+ (XYJobModel *)modelFromDict:(NSDictionary*)dict;
@end
