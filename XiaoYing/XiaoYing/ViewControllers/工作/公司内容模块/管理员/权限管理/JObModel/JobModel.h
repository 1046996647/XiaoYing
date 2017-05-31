//
//  JobModel.h
//  XiaoYing
//
//  Created by GZH on 2016/11/9.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobModel : NSObject

@property (nonatomic, strong)NSString *CompanyJobId;
@property (nonatomic, strong)NSString *JobName;
@property (nonatomic, strong)NSString *IsMastJob;
@property (nonatomic, strong)NSString *DepartmentName;
@property (nonatomic, strong)NSString *DepartmentId;

@property (nonatomic, strong)NSString *departmentStr;

@end
