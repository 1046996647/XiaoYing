//
//  FileOperateVC.h
//  XiaoYing
//
//  Created by ZWL on 17/1/10.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^FileOperateBlock)(NSInteger, NSInteger);

@interface FileOperateVC : BaseSettingViewController

@property (nonatomic, assign) NSInteger fileType;
@property (nonatomic, copy) FileOperateBlock fileOperateBlock;
@property (nonatomic, strong) NSArray *authForButtnArr; //权限数组

@end
