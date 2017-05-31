//
//  AttendanceVC.h
//  XiaoYing
//
//  Created by ZWL on 16/1/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"

@interface AttendanceVC : BaseSettingViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSString *havePermission;

@end
