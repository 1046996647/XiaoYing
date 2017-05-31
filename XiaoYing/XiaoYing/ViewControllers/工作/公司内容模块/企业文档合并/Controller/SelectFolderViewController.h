//
//  SelectFolderViewController.h
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/13.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^getFilePlaceBlock)(NSString *departmentName, NSString *departmentId, NSString *folderName, NSString *folderId);

@interface SelectFolderViewController : BaseSettingViewController

@property (nonatomic, copy) NSString *folderName;//父文件夹的名称
@property (nonatomic, copy) NSString *folderId;//父文件夹的id

@property (nonatomic, copy) NSString *departmentName;//部门名称
@property (nonatomic, copy) NSString *departmentId;//部门id

@property (nonatomic, strong) NSMutableArray *folderNameArr;//文件夹路径数组形式

@property (nonatomic, copy) getFilePlaceBlock getPlaceBlock;

@end
