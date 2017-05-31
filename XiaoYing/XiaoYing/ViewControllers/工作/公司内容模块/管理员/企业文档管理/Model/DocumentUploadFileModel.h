//
//  DocumentUploadFileModel.h
//  XiaoYing
//
//  Created by chenchanghua on 16/12/7.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFSessionModel.h"

@class ALAssetRepresentation;

@interface DocumentUploadFileModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *filePath; //文件在手机的资源库中的路径
@property (nonatomic, copy) NSString *fileHomePath; //文件在app沙盒中的路径
@property (nonatomic, copy) NSString *fileWebPath; //文件在服务器上的路径

@property (nonatomic, copy) NSString *destributeFloderId; //文件将要放置到的文件夹的id

@property (nonatomic, copy) NSString *destributeDepartmentId; //文件将要放置到的部门id

@property (nonatomic, copy) NSString *fileToken; //文件在服务器上的token
@property (nonatomic, copy) NSString *fileName; //文件的名称
@property (nonatomic, assign) NSInteger fileType; //文件的类型(枚举)
@property (nonatomic, assign) NSInteger fileSize; //文件的总共的大小

@property (nonatomic, copy) NSString *fileRatioThumWebUrl; //文件的缩略图的webUrl

@property (nonatomic, assign) NSInteger fileOffSize; //每片段的大小
@property (nonatomic, assign) NSInteger fileChunks; //文件一共分成多少个片段
@property (nonatomic, strong) NSMutableArray *fileDropStateArray; //文件每个片段的上传状态
//@property (nonatomic, assign) NSTimeInterval fileDropUploadTime; //刚刚上传的文件片段的时间
@property (nonatomic, strong) NSDate *fileDropUploadTime; //上传的文件片段的时间

@property (nonatomic, assign) NSInteger fileCompleteUploadNum; //文件已经上传的大小
@property (nonatomic, assign) BOOL uploadPause; //文件现在暂停上传
@property (nonatomic, assign) NSInteger fileUploadSpeed; //文件上传的速度

@property (nonatomic, copy) NSString *place; //文件上传的位置
@property (nonatomic, assign) BOOL isUploadFinish; //整个文件是否上传完成
@property (nonatomic, assign) BOOL isDelete; //文件是否删除

@property (nonatomic, assign) BOOL isLocal; //是否是已下载又上传的



- (instancetype)initWithRepresentation:(ALAssetRepresentation *)representation;
- (instancetype)initWithModel:(ZFSessionModel *)model;

@end
