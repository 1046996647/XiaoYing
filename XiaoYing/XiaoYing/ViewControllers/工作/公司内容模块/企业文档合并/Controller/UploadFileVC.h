//
//  UploadFileVC.h
//  XiaoYing
//
//  Created by ZWL on 17/1/9.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZFSessionModel.h"

@interface UploadFileVC : UIViewController

@property (nonatomic, strong) UIImage *ratioThum;
@property (nonatomic, strong) NSDictionary *fileInfo;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) NSInteger fileSize;
@property (nonatomic, strong) ZFSessionModel * localFileModel;

@property (nonatomic, copy) NSString *departmentPlaceId;
@property (nonatomic, copy) NSString *folderPlaceId;
@property (nonatomic, copy) NSString *originFolderPath; //创建文件的默认路径

@end
