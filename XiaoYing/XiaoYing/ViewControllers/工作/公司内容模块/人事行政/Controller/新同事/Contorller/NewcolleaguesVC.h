//
//  NewcolleaguesVC.h
//  XiaoYing
//
//  Created by MengFanBiao on 16/6/12.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^BlockNotification)(NSString *str);

@interface NewcolleaguesVC : BaseSettingViewController

@property (nonatomic, copy)BlockNotification blockNotification; //返回刷新（通知小红点）

@property (nonatomic, assign)BOOL haveNotification; //判断有通知的时候，再block回调，刷新数据

@end
