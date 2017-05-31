//
//  DownloadManagerController.h
//  XiaoYing
//
//  Created by ZWL on 16/1/26.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"

@class ZFSessionModel;

@interface DownloadManagerController : BaseSettingViewController

@property (nonatomic,assign) CheckType checkType;


@property(nonatomic,strong)NSMutableArray *downingList;
@property(nonatomic,strong)NSMutableArray *finishedList;

// 更新数据源 
//- (void)initData;

// 刷新表视图
- (void)refreshTableview;

// 删除文件
- (void)deleteFile:(ZFSessionModel *)model;

// 重命名
- (void)renameFile:(NSString *)url name:(NSString *)name;


@end
