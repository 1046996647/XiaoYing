//
//  FriendDetailMessageVC.h
//  XiaoYing
//
//  Created by ZWL on 16/8/17.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "ConnectModel.h"

@interface NOFriendDetailMessageVC : BaseSettingViewController

@property (nonatomic,strong) ConnectWithMyFriend *model;
@property (nonatomic,strong) NSString *strValue;
@property (nonatomic,assign) NSInteger backNum;


@end
