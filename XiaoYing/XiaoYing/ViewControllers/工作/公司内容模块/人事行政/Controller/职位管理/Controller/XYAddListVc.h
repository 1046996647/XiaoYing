//
//  XYAddListVc.h
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/20.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "XYCategoryModel.h"
@class XYJobModel;

@interface XYAddListVc : BaseSettingViewController

@property (nonatomic, strong) XYCategoryModel *categoryMessageModel;

- (void)refreshTableViewDataAndUI;
- (void)getJobModelWithOldJobName:(NSString *)oldJobName successBlock: (void(^)(XYJobModel *jobModel))block;

@end
