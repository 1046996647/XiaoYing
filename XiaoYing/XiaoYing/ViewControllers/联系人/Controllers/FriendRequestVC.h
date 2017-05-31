//
//  FriendRequestVC.h
//  XiaoYing
//
//  Created by ZWL on 16/8/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^RequestBlock)(void);


@interface FriendRequestVC : BaseSettingViewController

@property (nonatomic, strong) NSArray *requestArray; // 请求好友数组
@property (nonatomic, assign) int count; // 请求好友数组
@property (nonatomic,copy)  RequestBlock requestBlock;


@end
