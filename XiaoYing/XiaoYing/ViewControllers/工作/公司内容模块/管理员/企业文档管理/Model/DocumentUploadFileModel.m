//
//  DocumentUploadFileModel.m
//  XiaoYing
//
//  Created by chenchanghua on 16/12/7.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "DocumentUploadFileModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

// 缓存主目录
#define ZFCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"ZFCache"]

// 保存文件名
#define ZFFileName(url)  [[url componentsSeparatedByString:@"/"] lastObject]

// 文件的存放路径（caches）
#define ZFFileFullpath(url) [ZFCachesDirectory stringByAppendingPathComponent:ZFFileName(url)]

// 缓存主目录
#define DocumentCachesDirectory ([[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"documenttempData"])

@implementation DocumentUploadFileModel


- (instancetype)initWithRepresentation:(ALAssetRepresentation *)representation
{
    if (self = [super init]) {
        
        //文件在app资源库的路径
        self.filePath = [representation.url absoluteString];
        
        //文件在服务器上的地址
        self.fileWebPath = @""; //默认值为空
        
        //文件在服务器上的token
        self.destributeFloderId = @"";
        
        //文件的token
        self.fileToken = @""; //默认值为空
        
        //文件的名称
        self.fileName = [representation filename];
        
        //文件的大小
        //媒体文件转二进制大小不变的方式
        Byte *buffer = (Byte*)malloc((unsigned long)representation.size);
        NSUInteger buffered = [representation getBytes:buffer fromOffset:0.0 length:((unsigned long)representation.size) error:nil];
        NSData *tempData = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        self.fileSize = (unsigned long)tempData.length;
        
        //文件的缩略图的webUrl
        self.fileRatioThumWebUrl = @"";
        
        //文件在沙盒的路径
        BOOL writeBool = [tempData writeToFile:DocumentCachesDirectory atomically:YES];
        NSLog(@"将文件写入沙盒~~%d", writeBool);
        self.fileHomePath = DocumentCachesDirectory;
        
        //文件的类型
#warning 要改
        self.fileType = 2;//默认为图片
        
        //文件读取时每次偏移量的大小
        self.fileOffSize = 1024 * 100; //每片段的大小时100KB
        
        //文件总片段数offSize
        NSInteger chunks = (self.fileSize%1024==0)?((int)(self.fileSize/self.fileOffSize)):((int)(self.fileSize/self.fileOffSize + 1));
        self.fileChunks = chunks;
        
        //文件每个片段的上传状态数组  0－未上传  1-已上传
        self.fileDropStateArray = [NSMutableArray array];
        for (int i = 0; i < self.fileChunks; i ++) {
            [self.fileDropStateArray addObject:@0];
        }
        
        //刚刚上传的文件片段的时间
//        self.fileDropUploadTime = [NSDate date].timeIntervalSince1970;
        self.fileDropUploadTime = [NSDate date];
        
        //文件已经上传的size
        self.fileCompleteUploadNum = 0; //默认为0
        
        //文件现在暂停上传
        self.uploadPause = NO;
        
        //文件上传的速度
        self.fileUploadSpeed = 0;// 默认为0
    }
    return self;
}

// 已下载又上传的
- (instancetype)initWithModel:(ZFSessionModel *)model
{
    if (self = [super init]) {
        
        //文件在app资源库的路径
//        self.filePath = [representation.url absoluteString];
        
        //文件在服务器上的地址
        self.fileWebPath = @""; //默认值为空
        
        //文件在服务器上的token
        self.destributeFloderId = @"";
        
        //文件的token
        self.fileToken = @""; //默认值为空
        
        //文件的名称
        self.fileName = model.fileName;
        
        self.fileSize = model.totalLength;
        
        //文件的缩略图的webUrl
        self.fileRatioThumWebUrl = @"";
        
        self.fileHomePath = ZFFileFullpath(model.url);
        
        //文件的类型
#warning 要改
        self.fileType = 2;//默认为图片
        
        //文件读取时每次偏移量的大小
        self.fileOffSize = 1024 * 100; //每片段的大小时100KB
        
        //文件总片段数offSize
        NSInteger chunks = (self.fileSize%1024==0)?((int)(self.fileSize/self.fileOffSize)):((int)(self.fileSize/self.fileOffSize + 1));
        self.fileChunks = chunks;
        
        //文件每个片段的上传状态数组  0－未上传  1-已上传
        self.fileDropStateArray = [NSMutableArray array];
        for (int i = 0; i < self.fileChunks; i ++) {
            [self.fileDropStateArray addObject:@0];
        }
        
        //刚刚上传的文件片段的时间
        //        self.fileDropUploadTime = [NSDate date].timeIntervalSince1970;
        self.fileDropUploadTime = [NSDate date];
        
        //文件已经上传的size
        self.fileCompleteUploadNum = 0; //默认为0
        
        //文件现在暂停上传
        self.uploadPause = NO;
        
        //文件上传的速度
        self.fileUploadSpeed = 0;// 默认为0
        
        self.isLocal = YES;// 是否是已下载又上传的

    }
    return self;
}

//编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.filePath forKey:@"filePath"];
    [aCoder encodeObject:self.fileHomePath forKey:@"fileHomePath"];
    [aCoder encodeObject:self.fileWebPath forKey:@"fileWebPath"];
    [aCoder encodeObject:self.destributeFloderId forKey:@"destributeFloderId"];
    [aCoder encodeObject:self.destributeDepartmentId forKey:@"destributeDepartmentId"];
    [aCoder encodeObject:self.fileToken forKey:@"fileToken"];
    [aCoder encodeObject:self.fileName forKey:@"fileName"];
    [aCoder encodeInteger:self.fileType forKey:@"fileType"];
    [aCoder encodeInteger:self.fileSize forKey:@"fileSize"];
    [aCoder encodeObject:self.fileRatioThumWebUrl forKey:@"fileRatioThumWebUrl"];
    [aCoder encodeInteger:self.fileOffSize forKey:@"fileOffSize"];
    [aCoder encodeInteger:self.fileChunks forKey:@"fileChunks"];
    [aCoder encodeObject:self.fileDropStateArray forKey:@"fileDropStateArray"];
//    [aCoder encodeInteger:self.fileDropUploadTime forKey:@"fileDropUploadTime"];
    [aCoder encodeObject:self.fileDropUploadTime forKey:@"fileDropUploadTime"];
    [aCoder encodeInteger:self.fileCompleteUploadNum forKey:@"fileCompleteUploadNum"];
    [aCoder encodeBool:self.uploadPause forKey:@"uploadPause"];
    [aCoder encodeInteger:self.fileUploadSpeed forKey:@"fileUploadSpeed"];
    
    [aCoder encodeObject:self.place forKey:@"place"];
    [aCoder encodeBool:self.isUploadFinish forKey:@"isUploadFinish"];
    [aCoder encodeBool:self.isDelete forKey:@"isDelete"];
    [aCoder encodeBool:self.isLocal forKey:@"isLocal"];

}

//解码
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.filePath = [aDecoder decodeObjectForKey:@"filePath"];
        self.fileHomePath = [aDecoder decodeObjectForKey:@"fileHomePath"];
        self.fileWebPath = [aDecoder decodeObjectForKey:@"fileWebPath"];
        self.destributeFloderId = [aDecoder decodeObjectForKey:@"destributeFloderId"];
        self.destributeDepartmentId = [aDecoder decodeObjectForKey:@"destributeDepartmentId"];
        self.fileToken = [aDecoder decodeObjectForKey:@"fileToken"];
        self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
        self.fileType = [aDecoder decodeIntegerForKey:@"fileType"];
        self.fileSize = [aDecoder decodeIntegerForKey:@"fileSize"];
        self.fileRatioThumWebUrl = [aDecoder decodeObjectForKey:@"fileRatioThumWebUrl"];
        self.fileOffSize = [aDecoder decodeIntegerForKey:@"fileOffSize"];
        self.fileChunks = [aDecoder decodeIntegerForKey:@"fileChunks"];
        self.fileDropStateArray = [aDecoder decodeObjectForKey:@"fileDropStateArray"];
//        self.fileDropUploadTime = [aDecoder decodeIntegerForKey:@"fileDropUploadTime"];
        self.fileDropUploadTime = [aDecoder decodeObjectForKey:@"fileDropUploadTime"];
        self.fileCompleteUploadNum = [aDecoder decodeIntegerForKey:@"fileCompleteUploadNum"];
        self.uploadPause = [aDecoder decodeBoolForKey:@"uploadPause"];
        self.fileUploadSpeed = [aDecoder decodeIntegerForKey:@"fileUploadSpeed"];
        
        self.place = [aDecoder decodeObjectForKey:@"place"];
        self.isUploadFinish = [aDecoder decodeBoolForKey:@"isUploadFinish"];
        self.isDelete = [aDecoder decodeBoolForKey:@"isDelete"];
        self.isLocal = [aDecoder decodeBoolForKey:@"isLocal"];

    }
    return self;
}

@end
