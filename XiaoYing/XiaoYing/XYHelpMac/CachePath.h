//
//  CachePath.h
//  XiaoYing
//
//  Created by ZWL on 16/11/11.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#ifndef CachePath_h
#define CachePath_h

// 好友缓存路径
#define FriendPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Friend.data"]

// 群组缓存路径
#define GroupPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Group.data"]

// 组织架构缓存路径
#define DepartmentsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Departments.data"]

// 员工缓存路径
#define EmployeesPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Employees.data"]

// 权限缓存路径
#define PermissionsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Permissions.data"]

#endif /* CachePath_h */
