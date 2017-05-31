//
//  SortedDownLoadFileVC.h
//  XiaoYing
//
//  Created by 王思齐 on 16/12/15.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadFinishCell.h"
#import "DeleteViewController.h"
@interface SortedDownLoadFileVC : BaseSettingViewController
@property(nonatomic,strong)NSMutableArray *modelsArray;
@property (nonatomic,assign) CheckType checkType;

// 刷新表视图
- (void)refreshTableview;

// 删除文件
- (void)deleteFile:(ZFSessionModel *)model;

// 重命名
- (void)renameFile:(NSString *)url name:(NSString *)name;
@end
