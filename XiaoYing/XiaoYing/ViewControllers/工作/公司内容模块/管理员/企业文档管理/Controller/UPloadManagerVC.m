//
//  UPloadManagerVC.m
//  XiaoYing
//
//  Created by GZH on 16/7/4.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "UPloadManagerVC.h"
#import "UpLoadView.h"
#import "DocumentUploadFileModel.h"

// 存储上传文件信息的路径（caches）
#define UploadCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"UploadCache.data"]

@interface UPloadManagerVC ()

@property (nonatomic, strong) UpLoadView *uploadView;

@end

@implementation UPloadManagerVC

- (UpLoadView *)uploadView
{
    if (!_uploadView) {
        _uploadView = [[UpLoadView alloc] initWithFrame:self.view.frame];
    }
    return _uploadView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.navigationItem.title = @"上传管理";
    
    self.view = self.uploadView;
    
    //接受广播,代号@"CompanyFileUploadProgressNotification"
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(companyFileUploadProgressAction) name:@"CompanyFileUploadProgressNotification" object:nil];
}

- (void)companyFileUploadProgressAction
{
    DocumentUploadFileModel *tempModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
    self.uploadView.completeProgressNum = tempModel.fileCompleteUploadNum;
    self.uploadView.uploadPreogressSpeed = tempModel.fileUploadSpeed;
}

@end
