//
//  EmployeeViewModel.m
//  XiaoYing
//
//  Created by chenchanghua on 16/10/17.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "EmployeeViewModel.h"

@implementation EmployeeViewModel

+ (void)getEmployeeMessageSuccess:(void(^)(NSArray *identityNameArray, NSArray *departmentIdArray, NSArray *departmentNameArray))success failed:(void(^)(NSError *error))failed
{
    NSString * path = [NSString stringWithFormat:@"%@/api/Employee/myjobs?Token=%@", BaseUrl1, [UserInfo getToken]];
    
    NSLog(@"获取我的岗位列表URL:%@", path);
    
    [AFNetClient GET_Path:path completed:^(NSData *stringData, id JSONDict) {
        
        NSLog(@"获取我的岗位列表JSONDict:%@", JSONDict);
        
        if (success) {
            
            NSMutableArray *departmentNameArray = [NSMutableArray array];
            NSMutableArray *departmentIdArray = [NSMutableArray array];
            NSMutableArray *jobNameArray = [NSMutableArray array];

            for (NSDictionary *dict in JSONDict[@"Data"]) {
                
                [departmentNameArray addObject:[dict[@"DepartmentName"] isEqual:[NSNull null]]? @"" : dict[@"DepartmentName"]];
                [departmentIdArray addObject:dict[@"DepartmentId"]];
                [jobNameArray addObject:[dict[@"JobName"] isEqual:[NSNull null]]? @"" : dict[@"JobName"]];
            }
            
            NSMutableArray *identityNameArray = [NSMutableArray array];
            for (int i = 0; i < departmentNameArray.count; i ++) {
                
                NSString *departmentNameStr = [departmentNameArray objectAtIndex:i];
                NSString *jobNameStr = [jobNameArray objectAtIndex:i];
                
                if ([departmentNameStr isEqualToString:@""]) {
                    NSString *identityNameStr = [NSString stringWithFormat:@"%@", jobNameStr];
                    [identityNameArray addObject:identityNameStr];
                }else {
                    NSString *identityNameStr = [NSString stringWithFormat:@"%@-%@", departmentNameStr, jobNameStr];
                    [identityNameArray addObject:identityNameStr];
                }
            }
            
            success(identityNameArray, departmentIdArray, departmentNameArray);
            
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
        
        NSLog(@"获取我的岗位列表失败:%@", error);
    }];
}

@end
