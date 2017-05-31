//
//  MoveFolderViewController.h
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/14.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^movePlaceBlock)(NSString *departmentId, NSString *folderName, NSString *folderId);

@interface MoveFolderViewController : BaseSettingViewController

@property (nonatomic, copy) NSString *folderName;//父文件夹的名称
@property (nonatomic, copy) NSString *folderId;//父文件夹的id

@property (nonatomic, copy) NSString *departmentId;//部门id

@property (nonatomic, copy) movePlaceBlock movePlaceBlock;

@end
