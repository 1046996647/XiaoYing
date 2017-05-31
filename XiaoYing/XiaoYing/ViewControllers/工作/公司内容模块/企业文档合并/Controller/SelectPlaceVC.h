//
//  SelectPlaceVC.h
//  XiaoYing
//
//  Created by ZWL on 17/1/9.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"

typedef void(^getFilePlaceBlock)(NSString *departmentName, NSString *departmentId, NSString *folderName, NSString *folderId);

@interface SelectPlaceVC : BaseSettingViewController

@property (nonatomic, copy) getFilePlaceBlock getPlaceBlock;

@end
