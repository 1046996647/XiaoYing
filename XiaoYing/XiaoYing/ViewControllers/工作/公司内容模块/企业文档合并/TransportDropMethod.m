//
//  TransportDropMethod.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/16.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "TransportDropMethod.h"

// 存储上传文件信息的路径（caches）
#define UploadCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"UploadCache.data"]

// 已上传完成的数据模型
#define UploadedCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"UploadedCache.data"]


@implementation TransportDropMethod



// 上传完成的数组
+ (NSMutableArray *)getUploadedArray
{
    NSMutableArray *arrM = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadedCachesDirectory];
    if (arrM.count == 0) {
        arrM = @[].mutableCopy;
    }
    return arrM;
}

/**
 *  删除该资源
 *
 */
+ (void)deleteFile:(DocumentUploadFileModel *)model
{
    if (model.isUploadFinish) {// 完成的
        // 保存已完成的数据模型
        NSMutableArray *arrM = [self getUploadedArray];
        for (DocumentUploadFileModel *documentUploadFileModel in arrM.mutableCopy) {
            if ([documentUploadFileModel.fileToken isEqualToString:model.fileToken]) {
                [arrM removeObject:documentUploadFileModel];
            }
        }
        [self save:arrM];
    }
    else {// 进行中的
        
        if (model.uploadPause) {
            [self deletePath];

        }
        else {
            model.uploadPause = YES;
            model.isDelete = YES;
            [NSKeyedArchiver archiveRootObject:model toFile:UploadCachesDirectory];
        }

    }
}


/**
 * 归档
 */
+ (void)save:(NSArray *)arr
{
    [NSKeyedArchiver archiveRootObject:arr toFile:UploadedCachesDirectory];
}

+ (BOOL)isUploading
{
    BOOL uploading = NO;
    DocumentUploadFileModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
    if (model && !model.isUploadFinish) {
        uploading = YES;
    }
    return uploading;
}

// 删除进行中的路径
+ (void)deletePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:UploadCachesDirectory]) {
        
        // 删除沙盒中所有资源
        [fileManager removeItemAtPath:UploadCachesDirectory error:nil];
        
    }
}


+ (void)uploadDataWithProgressControl
{

    __block DocumentUploadFileModel *documentUploadFileModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
    NSLog(@"uploadPause~~%d", documentUploadFileModel.uploadPause);

    
    __weak typeof(self)weakSelf = self;

    //确定该documentUploadFileModel已经上传的节点
    NSInteger currentDrop = 0;
    NSLog(@"documentUploadFileModel.fileDropStateArray~~%@", documentUploadFileModel.fileDropStateArray);
    for (int i = 0; i < documentUploadFileModel.fileDropStateArray.count; i ++) {
        if ([documentUploadFileModel.fileDropStateArray[i] isEqualToNumber:@0]) {
            currentDrop = i;
            NSLog(@"currentDrop~~%ld", (long)currentDrop);
            break;
        }
    }
    //文件在沙盒中的路径
    NSLog(@"documentUploadFileModel.fileHomePath~~%@", documentUploadFileModel.fileHomePath);
    
    //根据documentUploadFileModel的沙盒路径，让NSFileHandle持有控制该文件
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:documentUploadFileModel.fileHomePath];
    
    //确定好这一次读取文件的开始位置
    [readHandle seekToFileOffset:documentUploadFileModel.fileOffSize * currentDrop];
    
    //每一次都读取一个片段，最后一个片段的大小会自动以实际的大小为准
    NSData *currentData = [readHandle readDataOfLength:documentUploadFileModel.fileOffSize];
    
    //读完后，关闭该文件
    [readHandle closeFile];
    
    NSLog(@"documentUploadFileModel.filePath~~%@", documentUploadFileModel.filePath);
    NSLog(@"documentUploadFileModel.fileOffSize```%lu",(long)documentUploadFileModel.fileOffSize);
    NSLog(@"(unsigned long)currentData.length```%lu",(unsigned long)currentData.length);
    
    //将这次的文件片段数据按base64格式编码，并将此作为这次POST请求的body参数
    NSString *encodedFileData = [currentData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
    paramDic[@"Data"] = encodedFileData;
    
    //确定好POST请求的路径，此处需要用到documentUploadFileModel的文件Token
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/bigfile/upload?token=%@", BaseUrl1, documentUploadFileModel.fileToken];
    
    if (currentDrop < documentUploadFileModel.fileChunks) {
        
        [AFNetClient POST_Path:urlStr params:paramDic completed:^(NSData *stringData, id JSONDict) {
            
            NSLog(@"%@",JSONDict);
            
            //已经上传的大小，用比例显示
            NSInteger completeNum = [JSONDict[@"start"] integerValue];
//            documentUploadFileModel.fileCompleteUploadNum = completeNum;
            documentUploadFileModel.fileCompleteUploadNum = completeNum;
            NSLog(@"上传进度~~%ld/%ld", (long)completeNum, (long)documentUploadFileModel.fileSize);
            
//            //上传的速度，只有开始上传的时候才能计算
//            NSTimeInterval gapUploadTime = [NSDate date].timeIntervalSince1970 - documentUploadFileModel.fileDropUploadTime;
//            NSInteger uploadSpeed = (documentUploadFileModel.fileOffSize / 1024) / gapUploadTime;
            
            // 每秒下载速度
            NSTimeInterval uploadTime = -1 * [documentUploadFileModel.fileDropUploadTime timeIntervalSinceNow];
            NSUInteger speed = completeNum / uploadTime;
            if (speed == 0) { return; }
            documentUploadFileModel.fileUploadSpeed = speed;
            NSLog(@"%ldKB/S", (long)speed);
            
            //文件片段的状态的更改
            documentUploadFileModel.fileDropStateArray[currentDrop] = @1;
            
            //归档前，需要
            DocumentUploadFileModel *tempUploadFileModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
            documentUploadFileModel.uploadPause = tempUploadFileModel.uploadPause;
            documentUploadFileModel.isDelete = tempUploadFileModel.isDelete;
            documentUploadFileModel.isLocal = tempUploadFileModel.isLocal;

            
            //这个文件片段已经成功上传，为避免信息丢失，保存
            [NSKeyedArchiver archiveRootObject:documentUploadFileModel toFile:UploadCachesDirectory];
            
            //每完成一个片段的上传，就发出广播,代号@"CompanyFileUploadProgressNotification"
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:@"CompanyFileUploadProgressNotification" object:nil];
            
            documentUploadFileModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
            
            //如果不是最后一个文件片段，就继续循环
            if (!(currentDrop == documentUploadFileModel.fileChunks - 1)) {
                
                //每一次循环前，检测下是否按下暂停按钮
#warning 将这个判断的依据来源，放进模型中
                if (documentUploadFileModel.uploadPause == NO) {
                    [weakSelf uploadDataWithProgressControl];
                } else {

                    if (documentUploadFileModel.isDelete) {
                        [self deletePath];
                    }
                    return ;
                }
                
            } else {
                
                NSLog(@"文件已经上传完成");
//                documentUploadFileModel.fileCompleteUploadNum = documentUploadFileModel.fileSize / 1024;
//                documentUploadFileModel.fileUploadSpeed = 0;
                
                documentUploadFileModel.isUploadFinish = YES;
                //这个文件片段已经成功上传，为避免信息丢失，保存
                [NSKeyedArchiver archiveRootObject:documentUploadFileModel toFile:UploadCachesDirectory];
                
                // 保存已完成的数据模型
                NSMutableArray *arrM = [self getUploadedArray];
                [arrM addObject:documentUploadFileModel];
                [self save:arrM];
                
                //每完成一个片段的上传，就发出广播,代号@"CompanyFileUploadProgressNotification"
                NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                [notificationCenter postNotificationName:@"CompanyFileUploadProgressNotification" object:nil];
                
                //请求参数
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"Name"] = documentUploadFileModel.fileName;
                params[@"Type"] = [NSNumber numberWithInteger:2];
                params[@"Url"] = documentUploadFileModel.fileWebPath;
                params[@"CatalogId"] = documentUploadFileModel.destributeFloderId;
                params[@"DepartmentId2"] = documentUploadFileModel.destributeDepartmentId;
                params[@"Size"] = [NSNumber numberWithInteger:(documentUploadFileModel.fileSize)];
                params[@"Creator"] = [UserInfo userID];
                params[@"ThumbnailUrl"] = documentUploadFileModel.fileRatioThumWebUrl;//缩略图
                
                if ([documentUploadFileModel.destributeDepartmentId isEqualToString:@" "]) { //个人文档
                    
                    //将文件上传至个人文档管理，返回该文件的id
                    NSString *url = [NSString stringWithFormat:@"%@/api/psndoc/upload?Token=%@", BaseUrl1, [UserInfo getToken]];
                    
                    //请求参数--这个要调整过来
                    params[@"DepartmentId2"] = @"";
                    
                    [AFNetClient POST_Path:url params:params completed:^(NSData *stringData, id JSONDict) {
                        
                        NSLog(@"文件上传至个人文档管理成功:%@---%@", url, params);
                        
                        NSLog(@"文件上传至个人文档管理成功:%@", JSONDict);
                        
                        if (!documentUploadFileModel.isLocal) {
                            //文件上传完成后，将该文件在沙盒中删除
                            NSFileManager *fileManager = [NSFileManager defaultManager];
                            [fileManager removeItemAtPath:documentUploadFileModel.fileHomePath error:nil];
                        }

                        
                        
//                        documentUploadFileModel.fileSize = 0;
                        //这个文件片段已经成功上传，为避免信息丢失，保存
                        [NSKeyedArchiver archiveRootObject:documentUploadFileModel toFile:UploadCachesDirectory];
                        
//                        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//                        [notificationCenter postNotificationName:@"CompanyFileUploadProgressNotification" object:nil];
                        
                        // 文件上传成功后刷新主界面数据
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDocNotification" object:nil];

                        
                    } failed:^(NSError *error) {
                        
                        NSLog(@"文件上传至个人文档管理失败:%@---%@", url, params);
                        
                        NSLog(@"文件上传至个人文档管理失败:%@", error);
                        
                    }];
                    
                }else { //企业文档
                    
                    //将文件上传至企业文档管理，返回该文件的id
                    NSString *url = [NSString stringWithFormat:@"%@/api/doc/upload?Token=%@", BaseUrl1, [UserInfo getToken]];
                
                    [AFNetClient POST_Path:url params:params completed:^(NSData *stringData, id JSONDict) {
                        
                        NSLog(@"文件上传至企业文档管理成功:%@---%@", url, params);
                        
                        NSLog(@"文件上传至企业文档管理成功:%@", JSONDict);
                        if (!documentUploadFileModel.isLocal) {
                            //文件上传完成后，将该文件在沙盒中删除
                            NSFileManager *fileManager = [NSFileManager defaultManager];
                            [fileManager removeItemAtPath:documentUploadFileModel.fileHomePath error:nil];
                        }
                        
                        
//                        documentUploadFileModel.fileSize = 0;
                        //这个文件片段已经成功上传，为避免信息丢失，保存
                        [NSKeyedArchiver archiveRootObject:documentUploadFileModel toFile:UploadCachesDirectory];
                        
//                        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//                        [notificationCenter postNotificationName:@"CompanyFileUploadProgressNotification" object:nil];
                        
                        // 文件上传成功后刷新主界面数据
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDocNotification" object:nil];
                        
                    } failed:^(NSError *error) {
                        
                        NSLog(@"文件上传至企业文档管理失败:%@---%@", url, params);
                        
                        NSLog(@"文件上传至企业文档管理失败:%@", error);
                        
                    }];
                
                }
                
            }
            
        } failed:^(NSError *error) {
            
            NSLog(@"错了错啦%@", error);
            
        }];
    }
    
}

@end
