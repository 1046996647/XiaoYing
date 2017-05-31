//
//  TransportDropMethod.h
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/16.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DocumentUploadFileModel.h"


@interface TransportDropMethod : NSObject

+ (void)uploadDataWithProgressControl;

/** 上传完成的模型数组*/
//@property (nonatomic, strong) NSMutableArray *uploadedArray;

/**
 * 归档
 */
+ (void)save:(NSArray *)arr;

// 上传完成的数组
+ (NSMutableArray *)getUploadedArray;

/**
 *  删除该资源
 *
 */
+ (void)deleteFile:(DocumentUploadFileModel *)model;


// 是否有文件在上传
+ (BOOL)isUploading;


@end
