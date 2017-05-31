//
//  XYEditPositionVc.h
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/20.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "XYJobModel.h"
#import "XYCategoryModel.h"

@interface XYEditPositionVc : BaseSettingViewController

@property (nonatomic, strong) XYCategoryModel *categoryModel;
@property (nonatomic, strong) XYJobModel *jobModel;

@end
