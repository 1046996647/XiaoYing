//
//  WLUploadManager.m
//  XiaoYing
//
//  Created by ZWL on 16/7/28.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "WLUploadManager.h"

// 缓存主目录
#define ZFCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"ZFCache"]

@interface WLUploadManager()<NSCopying>




@end

@implementation WLUploadManager

/**
 * 读取model
 */
- (NSArray *)getUploadModels
{
    // 文件信息
    NSArray *uploadModels = [NSKeyedUnarchiver unarchiveObjectWithFile:WLDownloadDetailPath];
    return uploadModels;
}

//- (NSMutableArray *)uploadModelsArray
//{
//    if (!_uploadModelsArray) {
//        _uploadModelsArray = @[].mutableCopy;
//        [_uploadModelsArray addObjectsFromArray:[self getUploadModels]];
//    }
//    return _uploadModelsArray;
//}

- (NSMutableArray *)uploadingArray
{
    if (!_uploadingArray) {
        _uploadingArray = @[].mutableCopy;
        [_uploadingArray addObjectsFromArray:[self getUploadModels]];

    }
    return _uploadingArray;
}

//- (NSMutableArray *)downloadedArray
//{
//    if (!_uploadingArray) {
//        _uploadingArray = @[].mutableCopy;
//    }
//    return _uploadingArray;
//}

static WLUploadManager *_uploadManager;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _uploadManager = [super allocWithZone:zone];
    });
    
    return _uploadManager;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
    return _uploadManager;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _uploadManager = [[self alloc] init];
    });
    
    return _uploadManager;
}

/**
 * 归档
 */
- (void)save:(NSArray *)uploadModels
{
    [NSKeyedArchiver archiveRootObject:uploadModels toFile:WLDownloadDetailPath];
}


- (void)upload:(ALAsset *)asset
{
    
    // 创建缓存目录文件
    [self createCacheDirectory];
    
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    //         fileMB = ((float)[representation size]/(1024 * 1024));
    //         NSLog(@"size of asset in bytes: %0.2f", fileMB);
    //         NSLog(@"---%ld",(unsigned long)[representation size]);
    // 图片转二进制大小不变的方式
//    Byte *buffer = (Byte*)malloc((unsigned long)representation.size);
//    NSUInteger buffered = [representation getBytes:buffer fromOffset:0.0 length:((unsigned long)representation.size) error:nil];
//    NSData *tempData = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
//    
//    
//    NSString *path = [WLCachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"jpg"]];
//    if ([tempData writeToFile:path atomically:YES]) {
//        NSLog(@"写入成功");
//    }
    
//    NSString *fileName = [NSString stringWithFormat:@"%.0f.jpg",[NSDate timeIntervalSinceReferenceDate] * 1000.0];
    
    NSString *path = [ZFCachesDirectory stringByAppendingPathComponent:@"14525705791193.mp4"];
    NSData *tempData = [NSData dataWithContentsOfFile:path];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@name=%@&size=%ld",GetFileToken,@"14525705791193.mp4",(unsigned long)tempData.length];
    
    
    __block WLUploadModel *uploadModel = [[WLUploadModel alloc] init];
    uploadModel.startTime = [NSDate date];
    uploadModel.fileName = @"14525705791193.mp4";
    uploadModel.path = path;
    uploadModel.startLength = 0;
    uploadModel.uploadManager = [WLUploadManager sharedInstance];
    uploadModel.totalSize = tempData.length;
//    [self.uploadModelsArray addObject:uploadModel];
    [self.uploadingArray addObject:uploadModel];
    // 保存
    [self save:self.uploadingArray];
    
    [AFNetClient POST_Path:urlStr completed:^(NSData *stringData, id JSONDict) {
        
        NSLog(@"%@",JSONDict);
        uploadModel.token = JSONDict[@"token"];
        
//        // 保存
//        [self save:self.uploadingArray];
        
        [self readDataWithUploadModel:uploadModel];
        
        
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    

}


-(void)readDataWithUploadModel:(WLUploadModel *)uploadModel
{
    //    NSLog(@"---%ld",(unsigned long)file);
    
    //总片数的获取方法：
    int offset =1024*300;//（每一片的大小是1M）
    //    NSInteger chunks = (file%1024==0)?((int)(file/1024*1024)):((int)(file/(1024*1024) + 1));
    //    NSLog(@"chunks = %ld",(long)chunks);
    
    //将文件分片，读取每一片的数据：
    NSData* data;
    
    //    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:self.path];
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:uploadModel.path];
    
    //    NSLog(@"%@",readHandle);
    
    [readHandle seekToFileOffset:uploadModel.startLength];
    data = [readHandle readDataOfLength:offset];
    [readHandle closeFile];
    
    NSLog(@"---%lu",(unsigned long)data.length);
    
    // 转成Base64
    NSString *encodedVoiceStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    // 参数
    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
    [paramDic  setValue:encodedVoiceStr forKey:@"data"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@token=%@",UploadFile,uploadModel.token];
    
    if (uploadModel.startLength < uploadModel.totalSize) {
        [AFNetClient  POST_Path:urlStr params:paramDic completed:^(NSData *stringData, id JSONDict) {
            NSLog(@"%@",JSONDict);
            
            NSInteger startLength = [JSONDict[@"start"] integerValue];
            uploadModel.startLength = startLength;
            //            NSLog(@"总大小：%.2f",((float)_start)/(1024*1024));
            
            // 每秒下载速度
            NSTimeInterval downloadTime = -1 * [uploadModel.startTime timeIntervalSinceNow];
            NSUInteger speed = startLength / downloadTime;
            if (speed == 0) { return; }
            float speedSec = [uploadModel calculateFileSizeInUnit:(unsigned long long) speed];
            NSString *unit = [uploadModel calculateUnit:(unsigned long long) speed];
            NSString *speedStr = [NSString stringWithFormat:@"%.2f%@/s",speedSec,unit];
            
            uploadModel.speedStr = speedStr;

            
            // 保存
            [self save:self.uploadingArray];
            
            if (uploadModel.uploadState == UploadStateStart) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(uploadResponse:)]) {
                        [self.delegate uploadResponse:uploadModel];
                    }
                });
            }
            
            [self readDataWithUploadModel:uploadModel];
            
            
        } failed:^(NSError *error) {
            NSLog(@"请求失败Error--%@",error);
        }];
    }
    
    else {// 已上传完成
        
        [self.uploadingArray removeObject:uploadModel];
        
        // 保存
        [self save:self.uploadingArray];
        
    }
    
    
    
}

/**
 *  创建缓存目录文件
 */
- (void)createCacheDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:WLCachesDirectory]) {
        [fileManager createDirectoryAtPath:WLCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

// 暂停、下载
- (void)pauseOrUpload:(WLUploadModel *)uploadModel
{
    if (uploadModel.uploadState == UploadStateStart) {
        uploadModel.uploadState = UploadStateSuspended;
        if (uploadModel.stateBlock) {
            uploadModel.stateBlock(UploadStateSuspended);
        }
    }
    else if (uploadModel.uploadState == UploadStateSuspended) {
        uploadModel.uploadState = UploadStateStart;
        [self readDataWithUploadModel:uploadModel];

    }
}

#pragma mark - 删除
/**
 *  删除该资源
 */
- (void)deleteFile:(WLUploadModel *)uploadModel
{
    if (uploadModel.uploadState == UploadStateStart) {
        uploadModel.uploadState = UploadStateSuspended;

    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:uploadModel.path]) {
        // 删除沙盒中的资源
        [fileManager removeItemAtPath:uploadModel.path error:nil];
        // 从沙盒中移除该条模型的信息
        for (WLUploadModel *model in self.uploadingArray.mutableCopy) {
            [self.uploadingArray removeObject:model];

        }
        // 保存归档信息
        [self save:self.uploadingArray];
    }
}































@end
