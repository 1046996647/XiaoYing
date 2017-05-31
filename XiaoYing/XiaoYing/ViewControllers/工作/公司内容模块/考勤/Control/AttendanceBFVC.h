//
//  AttendanceBFVC.h
//  XiaoYing
//
//  Created by ZWL on 16/1/28.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"

@interface AttendanceBFVC : BaseSettingViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSString *sssStr;

@end
