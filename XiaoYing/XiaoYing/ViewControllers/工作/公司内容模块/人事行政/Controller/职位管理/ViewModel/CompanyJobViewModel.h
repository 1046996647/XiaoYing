//
//  CompanyJobViewModel.h
//  XiaoYing
//
//  Created by chenchanghua on 16/10/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyJobViewModel : NSObject

// 职位类别 的获取
+ (void)getCategoryListWithKeyText:(NSString *)key success:(void(^)(NSArray *categoryList))success failed:(void(^)(NSError *error))failed;

// 职位类别 的添加，返回类别ID
+ (void)addCategoryWithCategoryName:(NSString *)categoryName success:(void(^)(NSString *newCategoryId))success failed:(void(^)(NSError *error))failed;

// 职位类别 的重命名
+ (void)renameCategoryWithCategoryId:(NSString *)categoryId categoryNewName:(NSString *)categoryNewName success:(void(^)(NSDictionary *responseData))success failed:(void(^)(NSError *error))failed;

// 职位类别 的删除
+ (void)deleteCategoryWithCategoryId:(NSString *)categoryId success:(void(^)(NSString *deletedCategoryId))success failed:(void(^)(NSError *error))failed;

// 判断是否存在该职位类别(该接口没有使用，用本地搜索确定)

// 判断该职位类别下是否有员工，返回员工数量
+ (void)getEmpolyeeCountWithCategoryId:(NSString *)categoryId success:(void(^)(NSInteger empolyeeCount))success failed:(void(^)(NSError *error))failed;

//_________________________________________________________________

// 职位 的获取
+ (void)getJobListWithCategoeyId:(NSString *)categoryId keyText:(NSString *)key success:(void(^)(NSArray *dataList))success failed:(void(^)(NSError *error))failed;

// 职位 的添加，返回职位ID
+ (void)addJobMessageWithCategoryId:(NSString *)categoryId jobName:(NSString *)jobName jobDescription:(NSString *)jobDescription success:(void(^)(NSString *newJobId))success failed:(void(^)(NSError *error))failed;

// 职位 的编辑
+ (void)editJobMessageWithcategoryId:(NSString *)categoryId jobId:(NSString *)jobId newJobName:(NSString *)jobName newJobDescription:(NSString *)jobDescription success:(void(^)(id JSONDict))success failed:(void(^)(NSError *error))failed;

// 职位 的删除
+ (void)deleteJobMessageWithJobId:(NSString *)jobId success:(void(^)(id JSONDict))success failed:(void(^)(NSError *error))failed;

// 判断是否存在该职位(该接口没有使用，用本地搜索确定)

// 判断该职位下是否有员工，返回员工数量
+ (void)getEmpolyeeCountWithJobId:(NSString *)jobId success:(void(^)(NSInteger empolyeeCount))success failed:(void(^)(NSError *error))failed;

@end
