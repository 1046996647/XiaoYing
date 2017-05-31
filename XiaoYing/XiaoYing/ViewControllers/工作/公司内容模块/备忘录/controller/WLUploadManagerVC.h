//
//  UploadManagerVC.h
//  XiaoYing
//
//  Created by ZWL on 16/8/1.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "UploadingCell.h"


@interface WLUploadManagerVC : BaseSettingViewController

// 刷新表视图
- (void)refreshTableview;

// 删除文件
- (void)deleteFile:(WLUploadModel *)model;

@end
