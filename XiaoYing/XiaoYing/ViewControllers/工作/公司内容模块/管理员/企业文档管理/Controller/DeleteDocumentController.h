//
//  DeleteDocumentController.h
//  XiaoYing
//
//  Created by ZWL on 16/1/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"

@interface DeleteDocumentController : BaseSettingViewController

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) NSArray *folderIdsArray;
@property (nonatomic, strong) NSArray *fileIdsArray;

@end
