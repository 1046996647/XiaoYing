//
//  CompanyFileManageController.h
//  XiaoYing
//
//  Created by ZWL on 16/1/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"

@interface CompanyFileManageController : BaseSettingViewController

@property (nonatomic, copy) NSString *parentFolderId;

- (void)beginOrRestoreUpload;

- (void)refreshDocumentTableView;

@end
