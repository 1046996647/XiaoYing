//
//  CreateDocumentFolderViewController.h
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/6.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"

@interface CreateDocumentFolderViewController : BaseSettingViewController

@property (nonatomic, copy) NSString *departmentPlaceId; //部门id
@property (nonatomic, copy) NSString *folderPlaceId; //文件夹id
@property (nonatomic, copy) NSString *originFolderPath; //创建文件的默认路径

@end
