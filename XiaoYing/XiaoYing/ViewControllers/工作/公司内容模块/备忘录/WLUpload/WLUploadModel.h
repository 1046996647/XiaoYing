//
//  UploadModel.h
//  XiaoYing
//
//  Created by ZWL on 16/7/29.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WLUploadManager;

typedef NS_ENUM(NSInteger, UploadState){
    UploadStateStart = 0,     /** 上传中 */
    UploadStateSuspended,     /** 上传暂停 */
    UploadStateCompleted,     /** 上传完成 */
    UploadStateFailed         /** 上传失败 */
};

typedef void(^WLUploadStateBlock)(UploadState state);


@interface WLUploadModel : NSObject


/** 文件路径 */
@property (nonatomic, copy) NSString *path;
/** 开始下载时间 */
@property (nonatomic, strong) NSDate *startTime;
/** 文件名 */
@property (nonatomic, copy) NSString *fileName;
/** 文件大小 */
@property (nonatomic, assign) NSInteger totalSize;

// 上传速度
@property (nonatomic, copy) NSString *speedStr;


/** 获得服务器这次请求 返回数据的总长度 */
@property (nonatomic, assign) NSInteger startLength;

@property (nonatomic, copy) NSString *token;

// 是否暂停
//@property (nonatomic,assign) BOOL isPause;

// 是否正在下载
//@property (nonatomic,assign) BOOL isDownloading;

// 是否展开
@property (nonatomic,assign) BOOL isExpand;

// 上传状态
@property (nonatomic,assign) UploadState uploadState;

/** 上传状态 */
@property (atomic, copy) WLUploadStateBlock stateBlock;

@property (nonatomic, strong) WLUploadManager *uploadManager;



- (float)calculateFileSizeInUnit:(unsigned long long)contentLength;

- (NSString *)calculateUnit:(unsigned long long)contentLength;

@end
