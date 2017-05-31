//
//  WLUploadManager.h
//  XiaoYing
//
//  Created by ZWL on 16/7/28.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLUploadModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

// 缓存主目录
#define WLCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"WLCache"]

// 存储文件信息的路径（caches）
#define WLDownloadDetailPath [WLCachesDirectory stringByAppendingPathComponent:@"downloadDetail.data"]

@protocol WLUploadDelegate <NSObject>
/** 下载中的回调 */
- (void)uploadResponse:(WLUploadModel *)uploadModel;

@end

@interface WLUploadManager : NSObject

/** 所有本地存储的所有下载信息数据数组 */
@property (nonatomic, strong) NSMutableArray *uploadModelsArray;
/** 下载完成的模型数组*/
@property (nonatomic, strong) NSMutableArray *uploadedArray;
/** 下载中的模型数组*/
@property (nonatomic, strong) NSMutableArray *uploadingArray;
/** ZFDownloadDelegate */
@property (nonatomic, weak) id<WLUploadDelegate> delegate;

/**
 *  单例
 *
 *  @return 返回单例对象
 */
+ (instancetype)sharedInstance;

/**
 * 读取model
 */
- (NSArray *)getUploadModels;

// 上传入口
- (void)upload:(ALAsset *)asset;

// 读取文件上传
-(void)readDataWithUploadModel:(WLUploadModel *)uploadModel;

// 暂停、下载
- (void)pauseOrUpload:(WLUploadModel *)uploadModel;

/**
 *  删除该资源
 */
- (void)deleteFile:(WLUploadModel *)uploadModel;


















@end
