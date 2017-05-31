//
//  ApplyViewModel.h
//  XiaoYing
//
//  Created by chenchanghua on 16/10/15.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyViewModel : NSObject

// 分页获取进行中的申请
+ (void)getOngingApplicationDataWithBeginPage:(NSInteger)beginPage pageSize:(NSInteger)pageSize success:(void(^)(NSArray *applicationDataList))success failed:(void(^)(NSError *error))failed;

// 分页获取已结束的申请
+ (void)getCompletedApplicationDataWithBeginPage:(NSInteger)beginPage pageSize:(NSInteger)pageSize success:(void(^)(NSArray *applicationDataList))success failed:(void(^)(NSError *error))failed;

// 存储该用户下的身份、类型、种类这三层树形数据，返回数据的plist存储文件的沙盒路径
+ (void)memoryUserApplicationMessageWithDepartmentIds:(NSArray *)departmentIds success:(void(^)(NSString *memoryPath))success failed:(void(^)(NSError *error))failed;

// 获取该身份可使用的申请类型
+ (void)getUserApplicationCategoryWithDepartmentId:(NSString *)departmentId success:(void(^)(NSArray *categoryNameArray, NSArray *cateoryIdArray))success failed:(void(^)(NSError *error))failed;

// 获取指定审批类型下的审批种类
+ (void)getUserApplicationTypeWithDepartmentId:(NSString *)departmentId categoryId:(NSString *)categoryId success:(void(^)(NSArray *typeNameArray, NSArray *typeIdArray, NSArray *typeTagArray))success failed:(void(^)(NSError *error))failed;

// 获取指定审批种类关联的范文
+ (void)getContentTempWithTypeId:(NSString *)typeId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 创建审批申请
+ (void)createApplicationWithDepartmentId:(NSString *)departmentId TypeId:(NSString *)typeId Tag:(NSString *)tag Content:(NSString *)content PhotoIds:(NSString *)photoIds voiceIds:(NSString *)voiceIds success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 获取申请详情
+ (void)getApplicationDetailWithApplicationId:(NSString *)applicationId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 根据申请的种类名称，搜索符合条件的记录，并分页返回记录
+ (void)getSearchResultApplicationDataWithSearchText:(NSString *)searchText beginPage:(NSInteger)beginPage pageSize:(NSInteger)pageSize success:(void(^)(NSArray *applicationDataList))success failed:(void(^)(NSError *error))failed;

// 撤销申请
+ (void)revokeApplicationWithApplicationId:(NSString *)applicationId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 越级申请
+ (void)skipApplicationWithApplicationId:(NSString *)applicationId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

@end
