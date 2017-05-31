//
//  ApplicationCreatorModel.h
//  XiaoYing
//
//  Created by chenchanghua on 16/10/21.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationCreatorModel : NSObject

@property (nonatomic, copy) NSString *faceURL; //头像地址－格式
@property (nonatomic, copy) NSString *employeeName; //职工名称
@property (nonatomic, copy) NSString *departmentName; //所在部门名称
@property (nonatomic, copy) NSString *departmentId; //所在部门ID
@property (nonatomic, copy) NSString *mastJobName; //主要职务名称
@property (nonatomic, copy) NSString *categoryName; //审批类别名称
@property (nonatomic, copy) NSString *statusDesc; //状态描述说明--从申请列表中传递过来
@property (nonatomic, copy) NSString *sendDateTime; //申请发出的时间
@property (nonatomic, copy) NSString *progressNumber; //总申请的百分比(0.8)
@property (nonatomic, copy) NSString *progress; //总进度--从申请列表中传递过来

- (instancetype)initWithDict:(NSDictionary*)dict statusDesc:(NSString *)statusDesc progress:(NSString *)progress;

+ (ApplicationCreatorModel*)modelFromDict:(NSDictionary*)dict statusDesc:(NSString *)statusDesc progress:(NSString *)progress;

@end
