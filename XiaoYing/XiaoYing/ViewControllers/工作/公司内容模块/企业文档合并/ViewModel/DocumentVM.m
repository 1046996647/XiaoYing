//
//  DocumentVM.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/12.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "DocumentVM.h"

@implementation DocumentVM

/*==========================企业级别的文档==============================*/

// 查看该文件夹包含的文件夹Folder以及文件File，根据文件夹id（空字符串代表根目录）、部门id（公司级别传空字符串，多个部门级别传拼接字符串）、查询关键字（为空代表查询所有）、开始页码、每页大小、排序类型(1-时间2-文件名3-类型)、升序降序(1-升序2-降序)
+ (void)getDocumentListDataWithFolderId:(NSString *)FolderId departmentIds:(NSString *)departmentIds textKey:(NSString *)key pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize orderType:(NSInteger)orderType isasc:(NSInteger)isasc success:(void(^)(NSArray *documentListArray))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@/api/doc/get?Token=%@&_catalogId=%@&depid=%@&key=%@&pageIndex=%d&pageSize=%d&ordertype=%d&isasc=%d", BaseUrl1, [UserInfo getToken], FolderId, departmentIds, key, pageIndex, pageSize, orderType, isasc];
    
    NSLog(@"查看该文件夹包含的文件夹以及文件URl:%@", url);
    
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

// 重命名文件夹名称，根据文件夹id、新的名称
+ (void)renameFolderWithOldFolderId:(NSString *)oldFolderId newFolderName:(NSString *)newFolderName success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@/api/doc/renamefolder?Token=%@&name=%@&_folderid=%@", BaseUrl1, [UserInfo getToken], newFolderName, oldFolderId];
    
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

// 重命名文件，根据文件id、新的名称
+ (void)renameFileWithOldFileId:(NSString *)oldFileId newFileName:(NSString *)newFileName success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@/api/doc/renamefile?Token=%@&name=%@&_fileid=%@", BaseUrl1, [UserInfo getToken], newFileName, oldFileId];
    
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

// 删除文件夹（以及该文件夹下的所有文件），删除文件。根据文件夹id（若都为空，不删除任何数据），根据文件id
+ (void)deleteDocumentWithFolderIds:(NSArray *)folderIds fileIds:(NSArray *)fileIds success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@/api/doc/delete?Token=%@", BaseUrl1, [UserInfo getToken]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"folderIds"] = folderIds;
    params[@"fileIds"] = fileIds;
    
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

// 创建一个空的文件夹，根据部门id、父文件夹（空字符串代表根目录）、文件夹名称
+ (void)createFolderWithParentFolderId:(NSString *)parentFolderId newFolderName:(NSString *)newFolderName departmentId:(NSString *)departmentId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@/api/doc/addcatalog?Token=%@", BaseUrl1, [UserInfo getToken]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Name"] = newFolderName;
    params[@"ParentId"] = parentFolderId;
    params[@"DepartmentId"] = departmentId;
    
    [AFNetClient POST_Path:url params:params completed:^(NSData *stringData, id JSONDict) {
        
        NSLog(@"创建文件夹成功：URL-%@-PARAMS-%@", url, params);
        
        if (success) {
            success(JSONDict);
        }
        
    } failed:^(NSError *error) {
        
        NSLog(@"创建文件夹成功：URL-%@-PARAMS-%@", url, params);
        
        if (failed) {
            failed(error);
        }
        
    }];
}

// 移动文件至目标文件夹，根据文件id，目标文件夹id，文件所属的部门id
+ (void)removeFileToDestributeFolderId:(NSString *)folderId fileId:(NSString *)fileId departmentId:(NSString *)departmentId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@/api/doc/remove?Token=%@&ids=%@&_folderId=%@&depid=%@&isfolder=false", BaseUrl1, [UserInfo getToken], fileId, folderId, departmentId];
    
    NSLog(@"移动文件URL:%@", url);
    
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

/*==========================个人级别的文档==============================*/

// 查看该文件夹包含的文件夹Folder以及文件File，根据文件夹id（空字符串代表根目录）、查询关键字（为空代表查询所有）、开始页码、每页大小、排序类型(1-时间2-文件名3-类型)、升序降序(1-升序2-降序)
+ (void)personGetDocumentListDataWithFolderId:(NSString *)FolderId textKey:(NSString *)key pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize orderType:(NSInteger)orderType isasc:(NSInteger)isasc success:(void(^)(NSArray *documentListArray))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@/api/psndoc/get?Token=%@&_catalogId=%@&key=%@&pageIndex=%d&pageSize=%d&ordertype=%d&isasc=%d", BaseUrl1, [UserInfo getToken], FolderId, key, pageIndex, pageSize, orderType, isasc];
    
    NSLog(@"person查看该文件夹包含的文件夹以及文件URl:%@", url);
    
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

// 重命名文件夹名称，根据文件夹id、新的名称
+ (void)personRenameFolderWithOldFolderId:(NSString *)oldFolderId newFolderName:(NSString *)newFolderName success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@/api/psndoc/renamefolder?Token=%@&name=%@&_folderid=%@", BaseUrl1, [UserInfo getToken], newFolderName, oldFolderId];
    
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

// 重命名文件，根据文件id、新的名称
+ (void)personRenameFileWithOldFileId:(NSString *)oldFileId newFileName:(NSString *)newFileName success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@/api/psndoc/renamefile?Token=%@&name=%@&_fileid=%@", BaseUrl1, [UserInfo getToken], newFileName, oldFileId];
    
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

// 删除文件夹（以及该文件夹下的所有文件），删除文件。根据文件夹id（若都为空，不删除任何数据），根据文件id
+ (void)personDeleteDocumentWithFolderIds:(NSArray *)folderIds fileIds:(NSArray *)fileIds success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    [self deleteDocumentWithFolderIds:folderIds fileIds:fileIds success:success failed:failed];
    return;
    
    NSString *url = [NSString stringWithFormat:@"%@/api/psndoc/delete?Token=%@", BaseUrl1, [UserInfo getToken]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"folderIds"] = folderIds;
    params[@"fileIds"] = fileIds;
    
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

// 创建一个空的文件夹，根据部门id、父文件夹（空字符串代表根目录）、文件夹名称
+ (void)personCreateFolderWithParentFolderId:(NSString *)parentFolderId newFolderName:(NSString *)newFolderName departmentId:(NSString *)departmentId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@/api/psndoc/addcatalog?Token=%@", BaseUrl1, [UserInfo getToken]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Name"] = newFolderName;
    params[@"ParentId"] = parentFolderId;
    params[@"DepartmentId"] = departmentId;
    
    [AFNetClient POST_Path:url params:params completed:^(NSData *stringData, id JSONDict) {
        
        NSLog(@"创建文件夹成功：URL-%@-PARAMS-%@", url, params);
        
        if (success) {
            success(JSONDict);
        }
        
    } failed:^(NSError *error) {
        
        NSLog(@"创建文件夹成功：URL-%@-PARAMS-%@", url, params);
        
        if (failed) {
            failed(error);
        }
        
    }];
}

// 移动文件至目标文件夹，根据文件id，目标文件夹id，文件所属的部门id
+ (void)personRemoveFileToDestributeFolderId:(NSString *)folderId fileId:(NSString *)fileId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@/api/psndoc/remove?Token=%@&ids=%@&_folderId=%@&isfolder=false", BaseUrl1, [UserInfo getToken], fileId, folderId];
    
    NSLog(@"person移动文件URL:%@", url);
    
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

// 查找文档
+ (void)searchFile:(NSString *)key pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize orderType:(NSInteger)orderType isasc:(NSInteger)isasc success:(void(^)(NSArray *documentListArray))success failed:(void(^)(NSError *error))failed
{
    
    NSString *url = [NSString stringWithFormat:@"%@/api/psndoc/searchall?Token=%@&key=%@&pageIndex=%ld&pageSize=%ld&ordertype=%ld&isdesc=%ld", BaseUrl1, [UserInfo getToken], key, (long)pageIndex, (long)pageSize, (long)orderType, (long)isasc];
        
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


@end
