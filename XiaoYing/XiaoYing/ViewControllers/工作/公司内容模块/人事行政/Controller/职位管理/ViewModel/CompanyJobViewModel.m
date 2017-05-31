//
//  CompanyJobViewModel.m
//  XiaoYing
//
//  Created by chenchanghua on 16/10/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "CompanyJobViewModel.h"

@implementation CompanyJobViewModel

// 职位类别 的获取
+ (void)getCategoryListWithKeyText:(NSString *)key success:(void(^)(NSArray *categoryList))success failed:(void(^)(NSError *error))failed
{
    //发送网络请求,获取类别列表
    NSString * path = [NSString stringWithFormat:@"%@?Token=%@&Key=%@", POSITION_GET_CATEGORY, [UserInfo getToken], key];
    
    NSLog(@"获取类别列表URL:%@", path);
    
    [AFNetClient GET_Path:path completed:^(NSData *stringData, id JSONDict) {

        if (success) {
            success(JSONDict[@"Data"]);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
        
    }];
}

// 职位类别 的添加，返回类别ID
+ (void)addCategoryWithCategoryName:(NSString *)categoryName success:(void(^)(NSString *newCategoryId))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@?Token=%@", POSITION_ADD_CATEGORY, [UserInfo getToken]];
    
    NSString*com = [NSString stringWithFormat:@"%@",[UserInfo getCompanyId]];
    
    NSDictionary * params = @{@"CompanyId":com,@"CategroyName":categoryName,@"CreatorId":[UserInfo userID]};
    
    [AFNetClient POST_Path:url params:params completed:^(NSData *stringData, id JSONDict) {

        if (success) {
            
            success(JSONDict[@"Data"]);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
        
    }];

}

// 职位类别 的重命名
+ (void)renameCategoryWithCategoryId:(NSString *)categoryId categoryNewName:(NSString *)categoryNewName success:(void(^)(NSDictionary *responseData))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@?Token=%@&_id=%@&name=%@", POSITION_RENAME_CATEGORY, [UserInfo getToken], categoryId, categoryNewName];
    
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

// 职位类别 的删除
+ (void)deleteCategoryWithCategoryId:(NSString *)categoryId success:(void(^)(NSString *deletedCategoryId))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@?Token=%@&_id=%@", POSITION_DELETE_CATEGORY, [UserInfo getToken], categoryId];
    
    [AFNetClient POST_Path:url completed:^(NSData *stringData, id JSONDict) {
        
        if (success) {
            
            success(categoryId);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            
            failed(error);
        }
    }];
    
}

// 判断该职位类别下是否有员工，返回员工数量
+ (void)getEmpolyeeCountWithCategoryId:(NSString *)categoryId success:(void(^)(NSInteger empolyeeCount))success failed:(void(^)(NSError *error))failed
{
    //发送网络请求,返回职位下的员工数
    NSString * path = [NSString stringWithFormat:@"%@?Token=%@&_id=%@", POSITION_GET_COUNT_FROM_CATEGORY, [UserInfo getToken], categoryId];
    [AFNetClient GET_Path:path completed:^(NSData *stringData, id JSONDict) {
        
        if (success) {
            success([JSONDict[@"Data"] integerValue]);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
        
    }];
}

//_________________________________________________________________

// 职位 的获取
+ (void)getJobListWithCategoeyId:(NSString *)categoryId keyText:(NSString *)key success:(void(^)(NSArray *dataList))success failed:(void(^)(NSError *error))failed
{
    //发送网络请求,获取职位列表
    NSString * path = [NSString stringWithFormat:@"%@?Token=%@&_categoryID=%@&Key=%@", POSITION_GET_JOBNAME, [UserInfo getToken], categoryId, key];
    
    NSLog(@"职位的获取URL:%@", path);
    
    [AFNetClient GET_Path:path completed:^(NSData *stringData, id JSONDict) {
        
        if (success) {
            success(JSONDict[@"Data"]);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            
            failed(error);
        }
        
    }];
}

// 职位 的添加，返回职位ID
+ (void)addJobMessageWithCategoryId:(NSString *)categoryId jobName:(NSString *)jobName jobDescription:(NSString *)jobDescription success:(void(^)(NSString *newJobId))success failed:(void(^)(NSError *error))failed
{
    //发送网络请求
    NSString *url = [NSString stringWithFormat:@"%@?Token=%@", POSITION_ADD_JOBNAME, [UserInfo getToken]];

    NSDictionary *paramsDict = @{@"companyId":[UserInfo getCompanyId], @"categoryId":categoryId, @"jobName":jobName, @"creatorId":[UserInfo userID], @"jobDescription":jobDescription};
    
    [AFNetClient POST_Path:url params:paramsDict completed:^(NSData *stringData, id JSONDict) {

        if (success) {
            success(JSONDict[@"Data"]);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
        
    }];

}

// 职位 的编辑
+ (void)editJobMessageWithcategoryId:(NSString *)categoryId jobId:(NSString *)jobId newJobName:(NSString *)jobName newJobDescription:(NSString *)jobDescription success:(void(^)(id JSONDict))success failed:(void(^)(NSError *error))failed
{
    //发送网络请求
    NSString *url = [NSString stringWithFormat:@"%@?Token=%@", POSITION_EDIT_JOBNAME, [UserInfo getToken]];
    
    NSDictionary *paramsDict = @{@"iD":jobId, @"companyId":[UserInfo getCompanyId], @"categoryId":categoryId, @"jobName":jobName, @"creatorId":[UserInfo userID], @"jobDescription":jobDescription};
    
    [AFNetClient POST_Path:url params:paramsDict completed:^(NSData *stringData, id JSONDict) {
        
        if (success) {
            success(JSONDict);
        }
        
    } failed:^(NSError *error) {

        if (failed) {
            failed(error);
        }
        
    }];
}

// 职位 的删除
+ (void)deleteJobMessageWithJobId:(NSString *)jobId success:(void(^)(id JSONDict))success failed:(void(^)(NSError *error))failed
{
    //发送网络请求
    NSString *url = [NSString stringWithFormat:@"%@?Token=%@&_id=%@", POSITION_DELETE_JOBNAME, [UserInfo getToken], jobId];
    
    [AFNetClient POST_Path:url params:nil completed:^(NSData *stringData, id JSONDict) {

        if (success) {
            success(JSONDict);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
        
    }];
}

// 判断该职位下是否有员工，返回员工数量
+ (void)getEmpolyeeCountWithJobId:(NSString *)jobId success:(void(^)(NSInteger empolyeeCount))success failed:(void(^)(NSError *error))failed
{
    //发送网络请求,返回职位下的员工数
    NSString * path = [NSString stringWithFormat:@"%@?Token=%@&_id=%@", POSITION_GET_COUNT_FROM_JOBNAME, [UserInfo getToken], jobId];
    [AFNetClient GET_Path:path completed:^(NSData *stringData, id JSONDict) {
        
        
        if (success) {
            success([JSONDict[@"Data"] integerValue]);
        }
        
    } failed:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
        
    }];

}

@end
