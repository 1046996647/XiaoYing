//
//  ApplyViewModel.m
//  XiaoYing
//
//  Created by chenchanghua on 16/10/15.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ApplyViewModel.h"

@implementation ApplyViewModel

// 分页获取进行中的申请
+ (void)getOngingApplicationDataWithBeginPage:(NSInteger)beginPage pageSize:(NSInteger)pageSize success:(void(^)(NSArray *applicationDataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@?Token=%@&PageIndex=%ld&PageSize=%ld", APPLY_GET_ONGING_APPLICATION, [UserInfo getToken], beginPage, pageSize];
    
    NSLog(@"分页获取进行中的申请URl:%@", url);
    
    [AFNetClient GET_Path:url completed:^(NSData *stringData, id JSONDict) {
        
        if (success) {
            
            success(JSONDict[@"Data"][@"Records"]);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
        
    }];
}

// 分页获取已结束的申请
+ (void)getCompletedApplicationDataWithBeginPage:(NSInteger)beginPage pageSize:(NSInteger)pageSize success:(void(^)(NSArray *applicationDataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@?Token=%@&PageIndex=%ld&PageSize=%ld", APPLY_GET_COMPLETED_APPLICATION, [UserInfo getToken], beginPage, pageSize];
    
    [AFNetClient GET_Path:url completed:^(NSData *stringData, id JSONDict) {
        
        if (success) {
            
            success(JSONDict[@"Data"][@"Records"]);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
        
    }];
}

// 存储该用户下的身份、类型、种类这三层树形数据，返回数据的plist存储文件的沙盒路径
+ (void)memoryUserApplicationMessageWithDepartmentIds:(NSArray *)departmentIds success:(void(^)(NSString *memoryPath))success failed:(void(^)(NSError *error))failed
{
    __block NSInteger count = 0;
    __block NSMutableArray *tempTotalMutableArray = [NSMutableArray array];
    __block NSMutableArray *totalMutableArray = [NSMutableArray array];
    
    for (NSString *departmentId in departmentIds) {
        
        [self memoryUserApplicationMessageWithDepartmentId:departmentId success:^(NSDictionary *dataWithDepartmentId) {
            
            [tempTotalMutableArray addObject:dataWithDepartmentId];
            
            if (++count == departmentIds.count) {
                
                //1.首先得获得沙盒的Documents目录的路径：
                NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                
                //2.然后拼接目标路径字符串：
                NSString *filePath = [documentsPath stringByAppendingPathComponent:@"userApplication.plist"];
                
                //3.整理数据
                for (NSString *departmentStr in departmentIds) {
                    for (NSDictionary *dataDict in tempTotalMutableArray) {
                        if ([dataDict[@"idName"] isEqualToString:departmentStr]) {
                            [totalMutableArray addObject:dataDict[@"data"]];
                        }
                    }
                }
                
                //4.最后存入：
                [totalMutableArray writeToFile:filePath atomically:YES];
                
                //5.返回数据的plist存储文件的沙盒路径
                if (success) {
                    success(filePath);
                }
            }
            
        }];
        
    }
}

// 辅助方法
+ (void)memoryUserApplicationMessageWithDepartmentId:(NSString *)departmentId success:(void(^)(NSDictionary *dataWithDepartmentId))success
{
    NSString * path = [NSString stringWithFormat:@"%@?Token=%@&DepartmentId=%@", APPLY_GET_APPLICATION_CATEGORY, [UserInfo getToken], departmentId];
    
    [AFNetClient GET_Path:path completed:^(NSData *stringData, id JSONDict) {
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:JSONDict[@"Data"], @"data", departmentId, @"idName", nil];
        
        if (success) {
            success(dict);
        }

    } failed:^(NSError *error) {

    }];
}

// 获取该身份可使用的申请类型
+ (void)getUserApplicationCategoryWithDepartmentId:(NSString *)departmentId success:(void(^)(NSArray *categoryNameArray, NSArray *cateoryIdArray))success failed:(void(^)(NSError *error))failed
{
    NSString * path = [NSString stringWithFormat:@"%@?Token=%@&DepartmentId=%@", APPLY_GET_APPLICATION_CATEGORY, [UserInfo getToken], departmentId];
    
    [AFNetClient GET_Path:path completed:^(NSData *stringData, id JSONDict) {
        
        NSLog(@"获取该身份可使用的申请类型:%@", JSONDict);
        
        if (success) {
            
            NSMutableArray *categoryNameArray = [NSMutableArray array];
            NSMutableArray *cateoryIdArray = [NSMutableArray array];
            
            for (NSDictionary *dict in JSONDict[@"Data"]) {

                NSString *categoryNameStr = [dict[@"Name"] isEqual:[NSNull null]]? @"" : dict[@"Name"];
                [categoryNameArray addObject:categoryNameStr];
                [cateoryIdArray addObject:dict[@"ID"]];
            }
            
            success(categoryNameArray, cateoryIdArray);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
        
    }];
}

// 获取指定审批类型下的审批种类
+ (void)getUserApplicationTypeWithDepartmentId:(NSString *)departmentId categoryId:(NSString *)categoryId success:(void(^)(NSArray *typeNameArray, NSArray *typeIdArray, NSArray *typeTagArray))success failed:(void(^)(NSError *error))failed
{
    NSString * path = [NSString stringWithFormat:@"%@?Token=%@&DepartmentId=%@&CategoryId=%@", APPLY_GET_APPLICATION_TYPE, [UserInfo getToken], departmentId, categoryId];
    
    [AFNetClient GET_Path:path completed:^(NSData *stringData, id JSONDict) {
        
        NSLog(@"获取指定审批类型下的审批种类:%@", JSONDict);
        
        if (success) {
            
            NSMutableArray *typeNameArray = [NSMutableArray array];
            NSMutableArray *typeIdArray = [NSMutableArray array];
            NSMutableArray *typeTagArray = [NSMutableArray array];
            
            for (NSDictionary *dict in JSONDict[@"Data"]) {
                
                NSString *typeNameStr = [dict[@"Name"] isEqual:[NSNull null]]? @"" : dict[@"Name"];
                [typeNameArray addObject:typeNameStr];
                [typeIdArray addObject:dict[@"Id"]];
                [typeTagArray addObject:dict[@"tagType"]];
            }
            
            success(typeNameArray, typeIdArray, typeTagArray);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
        
    }];
}

// 获取指定审批种类关联的范文
+ (void)getContentTempWithTypeId:(NSString *)typeId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    NSString * path = [NSString stringWithFormat:@"%@?Token=%@&TypeID=%@", APPLY_GET_APPLICATION_CONTENT_TEMP, [UserInfo getToken], typeId];
    
    [AFNetClient GET_Path:path completed:^(NSData *stringData, id JSONDict) {
        
        if (success) {
            success(JSONDict);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
        
    }];
}

// 创建审批申请
+ (void)createApplicationWithDepartmentId:(NSString *)departmentId TypeId:(NSString *)typeId Tag:(NSString *)tag Content:(NSString *)content PhotoIds:(NSString *)photoIds voiceIds:(NSString *)voiceIds success:(void(^)(NSDictionary *))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@?Token=%@", APPLY_CREATE_APPLICATION, [UserInfo getToken]];
    NSDictionary *params = @{@"DepartmentId":departmentId, @"TypeID":typeId, @"Tag":tag, @"ApprovalContent":content, @"VoiceIDs":voiceIds, @"PhotoIDs":photoIds};
    
    [AFNetClient POST_Path:url params:params completed:^(NSData *stringData, id JSONDict) {
        
        if (success) {
            success(JSONDict);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
        
    }];
}

// 获取申请详情
+ (void)getApplicationDetailWithApplicationId:(NSString *)applicationId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@?Token=%@&ApplyRequestID=%@", APPLY_GET_APPLICATION_DETAIL, [UserInfo getToken], applicationId];
    
    NSLog(@"获取申请详情的url~~%@", url);
    
    [AFNetClient GET_Path:url completed:^(NSData *stringData, id JSONDict) {
        
        if (success) {
            success(JSONDict[@"Data"]);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
        
    }];
    
}

// 根据申请的种类名称，搜索符合条件的记录，并分页返回记录
+ (void)getSearchResultApplicationDataWithSearchText:(NSString *)searchText beginPage:(NSInteger)beginPage pageSize:(NSInteger)pageSize success:(void(^)(NSArray *applicationDataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@?Token=%@&searchText=%@&PageIndex=%ld&PageSize=%ld", APPLY_SEARCH_APPLICATION, [UserInfo getToken], searchText, beginPage, pageSize];
    
    NSLog(@"根据申请的种类名称，搜索符合条件的记录，并分页返回记录:%@", url);
    
    [AFNetClient GET_Path:url completed:^(NSData *stringData, id JSONDict) {
        
        if (success) {
            
            success(JSONDict[@"Data"][@"Records"]);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
        
    }];
}

// 撤销申请
+ (void)revokeApplicationWithApplicationId:(NSString *)applicationId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@?Token=%@&applyRequestId=%@", APPLY_REVOKE_APPLICATION, [UserInfo getToken], applicationId];
    
    [AFNetClient POST_Path:url completed:^(NSData *stringData, id JSONDict) {
        
        if (success) {
            
            success(JSONDict);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            
            failed(error);
        }
    }];
    
}

// 越级申请
+ (void)skipApplicationWithApplicationId:(NSString *)applicationId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@?Token=%@&applyRequestId=%@", APPLY_SKIP_APPLICATION, [UserInfo getToken], applicationId];

    [AFNetClient POST_Path:url completed:^(NSData *stringData, id JSONDict) {
        
        if (success) {
            
            success(JSONDict);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            
            failed(error);
        }
    }];
    
}

@end
