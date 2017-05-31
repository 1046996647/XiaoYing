//
//  DocumentVM.h
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/12.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentVM : NSObject

/*==========================企业级别的文档==============================*/

// 查看该文件夹包含的文件夹Folder以及文件File，根据文件夹id（空字符串代表根目录）、部门id（公司级别传空字符串，多个部门级别传拼接字符串）、查询关键字（为空代表查询所有）、开始页码、每页大小、排序类型(1-时间2-文件名3-类型)、升序降序(1-升序2-降序)
+ (void)getDocumentListDataWithFolderId:(NSString *)FolderId departmentIds:(NSString *)departmentIds textKey:(NSString *)key pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize orderType:(NSInteger)orderType isasc:(NSInteger)isasc success:(void(^)(NSArray *documentListArray))success failed:(void(^)(NSError *error))failed;

// 重命名文件夹名称，根据文件夹id、新的名称
+ (void)renameFolderWithOldFolderId:(NSString *)oldFolderId newFolderName:(NSString *)newFolderName success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 重命名文件，根据文件id、新的名称
+ (void)renameFileWithOldFileId:(NSString *)oldFileId newFileName:(NSString *)newFileName success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 删除文件夹（以及该文件夹下的所有文件），删除文件。根据文件夹id（若都为空，不删除任何数据），根据文件id
+ (void)deleteDocumentWithFolderIds:(NSArray *)folderIds fileIds:(NSArray *)fileIds success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 创建一个空的文件夹，根据部门id、父文件夹（空字符串代表根目录）、文件夹名称
+ (void)createFolderWithParentFolderId:(NSString *)parentFolderId newFolderName:(NSString *)newFolderName departmentId:(NSString *)departmentId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 移动文件至目标文件夹，根据文件id，目标文件夹id，文件所属的部门id
+ (void)removeFileToDestributeFolderId:(NSString *)folderId fileId:(NSString *)fileId departmentId:(NSString *)departmentId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

/*==========================个人级别的文档==============================*/

// 查看该文件夹包含的文件夹Folder以及文件File，根据文件夹id（空字符串代表根目录）、查询关键字（为空代表查询所有）、开始页码、每页大小、排序类型(1-时间2-文件名3-类型)、升序降序(1-升序2-降序)
+ (void)personGetDocumentListDataWithFolderId:(NSString *)FolderId textKey:(NSString *)key pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize orderType:(NSInteger)orderType isasc:(NSInteger)isasc success:(void(^)(NSArray *documentListArray))success failed:(void(^)(NSError *error))failed;

// 重命名文件夹名称，根据文件夹id、新的名称
+ (void)personRenameFolderWithOldFolderId:(NSString *)oldFolderId newFolderName:(NSString *)newFolderName success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 重命名文件，根据文件id、新的名称
+ (void)personRenameFileWithOldFileId:(NSString *)oldFileId newFileName:(NSString *)newFileName success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 删除文件夹（以及该文件夹下的所有文件），删除文件。根据文件夹id（若都为空，不删除任何数据），根据文件id
+ (void)personDeleteDocumentWithFolderIds:(NSArray *)folderIds fileIds:(NSArray *)fileIds success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 创建一个空的文件夹，根据部门id、父文件夹（空字符串代表根目录）、文件夹名称
+ (void)personCreateFolderWithParentFolderId:(NSString *)parentFolderId newFolderName:(NSString *)newFolderName departmentId:(NSString *)departmentId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 移动文件至目标文件夹，根据文件id，目标文件夹id，文件所属的部门id
+ (void)personRemoveFileToDestributeFolderId:(NSString *)folderId fileId:(NSString *)fileId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 查找文档
+ (void)searchFile:(NSString *)key pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize orderType:(NSInteger)orderType isasc:(NSInteger)isasc success:(void(^)(NSArray *documentListArray))success failed:(void(^)(NSError *error))failed;

@end
