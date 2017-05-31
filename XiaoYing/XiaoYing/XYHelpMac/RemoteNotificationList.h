//
//  RemoteNotificationList.h
//  XiaoYing
//
//  Created by ZWL on 16/11/1.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#ifndef RemoteNotificationList_h
#define RemoteNotificationList_h

// ----------------------------推送通知--------------------------

//1.1.2                   获取推送通知
#define GetPushMessage        [NSString stringWithFormat:@"%@/api/push/my?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.1.2                   移除推送通知
#define RemovePushMessage        [NSString stringWithFormat:@"%@/api/push/remove?Token=%@",BaseUrl1,[UserInfo getToken]]

// ----------------------------聊天通知--------------------------

// 检测好友请求
#define ApiFriendRequest @"api/friend/request"

#define kCheckFriendRequestNotification @"kCheckFriendRequestNotification"

// 接受了您的添加请求并添加您为好友
#define NoApiFriendAgree @"noapi-friend-agree"

#define kAgreeFriendSuccessNotification @"kAgreeFriendSuccessNotification"

// 拒绝了您的添加请求
#define NoApiFriendRefuse @"noapi-friend-refuse"

#define kRefuseFriendNotification @"kRefuseFriendNotification"

// 删除好友通知
#define NoApiFriendDelete @"noapi-friend-delete"

// ----------------------------有关公司的通知--------------------------
// 企业架构更新了！
#define ApiDepartmentRefresh @"api/department/allDepartment"

#define kDepartmentRefreshNotification @"kDepartmentRefreshNotification"

// 企业员工变化了！
#define ApiEmployeeRefresh @"api/company/department"

#define kEmployeeRefreshNotification @"kEmployeeRefreshNotification"


#endif /* RemoteNotificationList_h */


