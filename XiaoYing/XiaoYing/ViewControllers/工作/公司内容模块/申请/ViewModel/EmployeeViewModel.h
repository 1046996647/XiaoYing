//
//  EmployeeViewModel.h
//  XiaoYing
//
//  Created by chenchanghua on 16/10/17.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmployeeViewModel : NSObject

// 获取 我的岗位列表中的“部门-职位”名称数组\部门Id数组\部门Name数组
+ (void)getEmployeeMessageSuccess:(void(^)(NSArray *identityNameArray, NSArray *departmentIdArray, NSArray *departmentNameArray))success failed:(void(^)(NSError *error))failed;

@end
