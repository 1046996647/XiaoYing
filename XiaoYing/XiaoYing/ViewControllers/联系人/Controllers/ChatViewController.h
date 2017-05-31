//
//  ChatViewController.h
//  XiaoYing
//
//  Created by yinglaijinrong on 15/11/18.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "ConnectModel.h"
#import "GroupListModel.h"

@interface ChatViewController : RCConversationViewController
@property (nonatomic,copy) NSString * friendProfileIdStr;
@property (nonatomic,strong) ConnectWithMyFriend * friendModel;
@property (nonatomic,assign) NSInteger unreadMessageCount;

@property (nonatomic,strong) GroupListModel *model;

@property (nonatomic,strong) NSMutableArray *memberListArr;
// 群组成员id
@property (nonatomic, strong)NSMutableArray *iDArr;

@end
