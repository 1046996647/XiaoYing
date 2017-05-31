//
//  MoveFileViewController.h
//  XiaoYing
//
//  Created by chenchanghua on 16/12/8.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"

@interface MoveFileViewController : BaseSettingViewController

@property (nonatomic, copy) NSString *folderName;//文件夹的名称
@property (nonatomic, copy) NSString *folderId;//文件夹的id

@property (nonatomic, copy) NSString *fileId;//需要移动的文件的id

@end
