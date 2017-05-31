//
//  XYPositionViewController.h
//  XiaoYing
//
//  Created by qj－shanwen on 16/7/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"
@class XYJobModel;

@interface XYPositionViewController : BaseSettingViewController

- (void)getJobMessageWithOldJobName:(NSString *)oldJobName successBlock: (void(^)(XYJobModel *jobModel))block;

@end
