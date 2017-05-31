//
//  ApplicationCreatorModel.m
//  XiaoYing
//
//  Created by chenchanghua on 16/10/21.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ApplicationCreatorModel.h"

@implementation ApplicationCreatorModel

- (instancetype)initWithDict:(NSDictionary*)dict statusDesc:(NSString *)statusDesc progress:(NSString *)progress
{
    if (self = [super init]) {
        
        NSDictionary *creatorDict = dict[@"Creator"];
        
        self.faceURL = creatorDict[@"FaceURL"];
        self.employeeName = creatorDict[@"EmployeeName"];
        self.departmentName = dict[@"DepartmentName"];
        self.departmentId = creatorDict[@"DepartmentId"];
        self.mastJobName = creatorDict[@"MastJobName"];
        self.categoryName = dict[@"CategroyName"];
        self.statusDesc = statusDesc;
        self.sendDateTime = dict[@"SendDateTime"];
        self.progressNumber = [self percentageNumFromPercentageString:progress];
        self.progress = progress;
    }
    return self;
}

// 从字典中得到model
+ (ApplicationCreatorModel*)modelFromDict:(NSDictionary*)dict statusDesc:(NSString *)statusDesc progress:(NSString *)progress{
    
    ApplicationCreatorModel *model = [[ApplicationCreatorModel alloc] initWithDict:dict statusDesc:statusDesc progress:progress];
    return model;
}

- (NSString *)percentageNumFromPercentageString:(NSString *)str
{
    NSArray *strArray = [str componentsSeparatedByString:@"/"];
    float molecule = [strArray[0] floatValue];//分子
    float denominator = [strArray[1] floatValue];//分母
    float progress = molecule/denominator;
    
    return [NSString stringWithFormat:@"%f", progress];
}

@end
