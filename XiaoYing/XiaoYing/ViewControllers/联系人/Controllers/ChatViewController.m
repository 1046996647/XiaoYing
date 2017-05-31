//
//  ChatViewController.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/11/18.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "ChatViewController.h"
#import "AppDelegate.h"
//#import "FrindView.h"
#import "UserInfo.h"
#import "LocationVC.h"
#import "GroupListSettingVC.h"
#import "NOFriendDetailMessageVC.h"
#import "EmploeeyDetailMessageVC.h"

@interface ChatViewController () 
{
    AppDelegate *app;
    NSString *_text;
}
@property (nonatomic,strong) UIButton *setButton;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    
    app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabvc hideCustomTabbar];
    
//    if (app.mesCount >= 0) {
//        app.mesCount = app.mesCount - self.unreadMessageCount;
//        // 消息个数变化
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"MESSAGECOUNT" object:[NSString stringWithFormat:@"%ld",(long)app.mesCount]];
//    }
    
    // 消息个数变化
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MESSAGECOUNT" object:nil];
    
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 10, 18);
    [backButton setImage:[UIImage imageNamed:@"Arrow-white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //设置按钮
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(0, 0, 20, 18);
    [setButton setImage:[UIImage imageNamed:@"contacts_white"] forState:UIControlStateNormal];
//    setButton.hidden = YES;
    self.setButton = setButton;
    [setButton addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:setButton];
    
//    // 判断是否有讨论组
//    [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId success:^(RCDiscussion *discussion) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            if ([discussion.memberIdList containsObject:[UserInfo userID]]) {
//                //设置按钮
//                UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                setButton.frame = CGRectMake(0, 0, 20, 18);
//                [setButton setImage:[UIImage imageNamed:@"contacts_white"] forState:UIControlStateNormal];
//                [setButton addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
//                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:setButton];
//            }
//
//        });
//        
//
//    } error:^(RCErrorCode status) {
//        
//    }];
    
    if (self.conversationType == ConversationType_DISCUSSION) {
        
        // 是否还有讨论组
        [self isHasDiscussion];
        
        // 是否还有讨论组通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(isHasDiscussion)
                                                     name:@"kIsHasDiscussionNotification"
                                                   object:nil];

    }
    else {
        self.setButton.hidden = YES;

    }
    
    self.memberListArr = [NSMutableArray array];
    
    self.iDArr = [NSMutableArray array];
    

    
}

- (void)isHasDiscussion
{
    NSMutableArray *arrM = [NSMutableArray array];
    //            从本地读取数据
    NSArray *groupListArr = [ZWLCacheData unarchiveObjectWithFile:GroupPath];
    for (GroupListModel *model in groupListArr) {
        
        [arrM addObject:model.RongCloudChatRoomId];

    }
    if (![arrM containsObject:self.targetId]) {
        self.setButton.hidden = YES;
    }
    else {
        self.setButton.hidden = NO;

    }
}

- (void)setAction
{
    GroupListSettingVC *groupListSettingVC =[[GroupListSettingVC alloc]init];
    groupListSettingVC.targetId = self.targetId;
    groupListSettingVC.memberListArr = self.memberListArr;
    groupListSettingVC.iDArr = self.iDArr;
    [self.navigationController pushViewController:groupListSettingVC animated:YES];
}


#pragma mark - override


///**
// *  点击头像事件
// *
// *  @param userId 用户的ID
// */
//- (void)didTapCellPortrait:(NSString *)userId{
//    
//    // 当前用户
//    if ([userId isEqualToString:[UserInfo userID]]) {
//        //个人信息取出
//        ProfileMyModel *model = [[FirstStartData shareFirstStartData] getPersonCentrePlist];
//        ConnectWithMyFriend *friend = [[ConnectWithMyFriend alloc] init];
//        friend.FaceUrl = model.FaceUrl;
//        friend.Nick = model.Nick;
//        friend.XiaoYingCode = model.XiaoYingCode;
//        friend.Birthday = model.Birthday;
//        friend.RegionName = model.RegionName;
//        friend.Signature = model.Signature;
//        friend.ProfileId = model.ProfileId;
//        NOFriendDetailMessageVC *vc = [[NOFriendDetailMessageVC alloc] init];
//        vc.model = friend;
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
//    
//    if (self.conversationType == ConversationType_DISCUSSION) {
//        
//        //            从本地读取数据
//        NSArray *groupListArr = [ZWLCacheData unarchiveObjectWithFile:GroupPath];
//        GroupListModel *aModel = nil;
//        for (GroupListModel *model in groupListArr) {
//            
//            if ([model.RongCloudChatRoomId isEqualToString:self.targetId]) {
//
//                aModel = model;
//            }
//        }
//        
//        for (NSDictionary *dic in aModel.Members) {
//            ConnectWithMyFriend *model = [[ConnectWithMyFriend alloc] initWithContentsOfDic:dic];
//            
//            if ([model.ProfileId isEqualToString:userId]) {
//                
//                NOFriendDetailMessageVC *vc = [[NOFriendDetailMessageVC alloc] init];
//                vc.model = model;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//
//        }
//        
//    } else {
//        // 所有好友
//        NSArray *friendArr = [ZWLCacheData unarchiveObjectWithFile:FriendPath];
//        
//        // 所有员工
//        NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
//        
//        // 好友的
//        for (ConnectWithMyFriend *friend in friendArr) {
//            
//            if ([userId isEqualToString:friend.ProfileId]) {
//                NOFriendDetailMessageVC *vc = [[NOFriendDetailMessageVC alloc] init];
//                vc.model = friend;
//                [self.navigationController pushViewController:vc animated:YES];
//                return;
//            }
//        }
//        
//        // 员工的
//        for (NSDictionary *dic in employeesArr) {
//            
//            if ([userId isEqualToString:dic[@"ProfileId"]]) {
//                
//                EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
//                EmploeeyDetailMessageVC *vc = [[EmploeeyDetailMessageVC alloc] init];
//                vc.employeeModel = model;
//                [self.navigationController pushViewController:vc animated:YES];
//                return;
//                
//            }
//        }
//    }
//    
//
//}


// 点开位置cell触发的方法
- (void)presentLocationViewController:(RCLocationMessage *)locationMessageContent
{
    LocationVC *locationVC = [[LocationVC alloc] init];
    locationVC.location = locationMessageContent.location;
    [self.navigationController pushViewController:locationVC animated:YES];
}

- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent
{
    if (_text.length > 500) {
        [self.navigationController.view makeToast:@"最大字数为500"
                                         duration:1.0
         
                                         position:CSToastPositionCenter];
//        inputTextView.text = [inputTextView.text substringToIndex:500];
        return nil;
    }
    else {
        return messageCotent;
    }
}

- (void)inputTextView:(UITextView *)inputTextView
shouldChangeTextInRange:(NSRange)range
      replacementText:(NSString *)text
{
    _text = inputTextView.text;
//    if (_text.length > 500) {
//        [self.navigationController.view makeToast:@"最大字数为500"
//                                         duration:1.0
//         
//                                         position:CSToastPositionCenter];
//        inputTextView.text = [inputTextView.text substringToIndex:500];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 返回按钮事件
- (void)backAction:(UIButton *)button
{
    [self.view endEditing:YES];
    // 消息个数变化
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MESSAGECOUNT" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
