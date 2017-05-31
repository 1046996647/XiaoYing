//
//  DocumentViewModel.h
//  XiaoYing
//
//  Created by chenchanghua on 16/11/28.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentViewModel : NSObject

// 查看该文件夹包含的文件夹Folder以及文件File，根据文件夹id（空字符串代表根目录）
+ (void)getDocumentListDataWithFolderId:(NSString *)FolderId success:(void(^)(NSArray *documentListArray))success failed:(void(^)(NSError *error))failed;

// 搜索查看想相关的文件夹以及文件， 根据key关键字（为空时，返回所有）
+ (void)searchDocumentWithKeyText:(NSString *)keyText success:(void(^)(NSArray *documentListArray))success failed:(void(^)(NSError *error))failed;

// 创建一个空的文件夹，根据公司id、父文件夹（空字符串代表根目录）
+ (void)createFolderWithParentFolderId:(NSString *)parentFolderId newFolderName:(NSString *)newFolderName success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 上传文件，根据文件名、文件类型、文件数据、目标文件夹id、创建人id
+ (void)uploadFileWithFileName:(NSString *)fileName fileType:(NSInteger)filetype fileData:(NSData *)fileData destributeFolderId:(NSString *)destributeFolderId creatorId:(NSString *)creatorId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 重命名文件夹名称，根据文件夹id
+ (void)renameFolderWithOldFolderId:(NSString *)oldFolderId newFolderName:(NSString *)newFolderName success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 重命名文件，根据文件id
+ (void)renameFileWithOldFileId:(NSString *)oldFileId newFileName:(NSString *)newFileName success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 删除文件夹（以及该文件夹下的所有文件），删除文件。根据文件夹id（若都为空，不删除任何数据），根据文件id
+ (void)deleteDocumentWithFolderIds:(NSArray *)folderIds fileIds:(NSArray *)fileIds success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 移动文件至目标文件夹，根据文件id，目标文件夹id
+ (void)removeFileToDestributeFolderId:(NSString *)folderId fileId:(NSString *)fileId success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

// 设置文档的可见范围，根据文件id、文件名、可见部门ids
+ (void)setVisibleForFileWithFileId:(NSString *)fileId fileName:(NSString *)fileName visibleDepartmentIds:(NSString *)visibleDepartmentIds success:(void(^)(NSDictionary *dataList))success failed:(void(^)(NSError *error))failed;

@end
