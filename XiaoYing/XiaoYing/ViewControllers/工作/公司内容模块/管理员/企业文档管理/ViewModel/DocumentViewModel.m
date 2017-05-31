//
//  DocumentViewModel.m
//  XiaoYing
//
//  Created by chenchanghua on 16/11/28.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "DocumentViewModel.h"

@implementation DocumentViewModel

+ (void)getDocumentListDataWithFolderId:(NSString *)FolderId success:(void(^)(NSArray *documentListArray))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@/api/doc/get?Token=%@&_catalogId=%@&&depid=&key=&pageIndex=1&pageSize=1000&ordertype=1&isasc=1", BaseUrl1, [UserInfo getToken], FolderId];
    
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

+ (void)searchDocumentWithKeyText:(NSString *)keyText success:(void(^)(NSArray *documentListArray))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@/api/doc/query?Token=%@&key=%@", BaseUrl1, [UserInfo getToken], keyText];
    
    NSLog(@"搜索查看想相关的文件夹以及文件URl:%@", url);
    
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

+ (void)createFolderWithParentFolderId:(NSString *)parentFolderId newFolderName:(NSString *)newFolderName success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@/api/doc/addcatalog?Token=%@", BaseUrl1, [UserInfo getToken]];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Name"] = newFolderName;
    params[@"ParentId"] = parentFolderId;
    params[@"CompanyId"] = [UserInfo getCompanyId];
    
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

+ (void)uploadFileWithFileName:(NSString *)fileName fileType:(NSInteger)filetype fileData:(NSData *)fileData destributeFolderId:(NSString *)destributeFolderId creatorId:(NSString *)creatorId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    //1.先将文件的base64格式数据上传至服务器,获取该文件在服务器上的url
    NSString *url = [NSString stringWithFormat:@"%@/api/file/upload?Token=%@", BaseUrl1, [UserInfo getToken]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Data"] = [fileData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    params[@"FileName"] = fileName;
    params[@"Category"] = [UserInfo getCompanyId];
    
    [AFNetClient POST_Path:url params:params completed:^(NSData *stringData, id JSONDict) {
        
        if (success) {
            
            //2.后上传该文件在服务器上的url,返回该文档的id
            NSString *url = [NSString stringWithFormat:@"%@/api/doc/upload?Token=%@", BaseUrl1, [UserInfo getToken]];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"Name"] = fileName;
            params[@"Type"] = [NSNumber numberWithInteger:filetype];
            params[@"Url"] = JSONDict[@"Data"];
            params[@"CatalogId"] = destributeFolderId;
//            params[@"CompanyId"] = [UserInfo getCompanyId];
            params[@"DepartmentId"] = @"";
            params[@"Size"] = [NSNumber numberWithInteger:(fileData.length / 1024)];
            params[@"Creator"] = [UserInfo userID];
            params[@"ThumbnailUrl"] = @"";
            
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
        
    } failed:^(NSError *error) {
        
        if (failed) {
            failed(error);
        }
        
    }];

}

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

+ (void)removeFileToDestributeFolderId:(NSString *)folderId fileId:(NSString *)fileId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@/api/doc/remove?Token=%@&strDocumentIds=%@&_folderId=%@", BaseUrl1, [UserInfo getToken], fileId, folderId];
    
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

// 设置文档的可见范围，根据文件id、文件名、可见部门ids
+ (void)setVisibleForFileWithFileId:(NSString *)fileId fileName:(NSString *)fileName visibleDepartmentIds:(NSString *)visibleDepartmentIds success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed
{
    NSString *url = [NSString stringWithFormat:@"%@/api/doc/setvisible?Token=%@&_documnetId=%@&strDepartmentIds=%@&name=%@", BaseUrl1, [UserInfo getToken], fileId, visibleDepartmentIds, fileName];
    
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
