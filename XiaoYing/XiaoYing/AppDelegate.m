//
//  AppDelegate.m
//  XiaoYing
//
//  Created by ZWL on 15/10/12.
//  Copyright (c) 2015年 ZWL. All rights reserved.
// 

#import "AppDelegate.h"
#import "GuideViewController.h"
#import "HomeViewController.h"
#import "CustomTabVC.h"

#import "NetWorkMonitor.h"
#import <RongIMKit/RongIMKit.h>
#import <AsyncSocket.h>

#import "taskModel.h"
#import "StringChangeDate.h"
#import "PushSoundEffect.h"
//第一次启动APP的数据的初始化
#import "FirstStartData.h"
#import "ConnectViewController.h"
#import <UMSocialCore/UMSocialCore.h>


#define Host @"192.168.10.69"
//#define Host @"124.160.57.54"
#define Port 60001


@interface AppDelegate()<RCIMReceiveMessageDelegate, AsyncSocketDelegate>
{
    Reachability *hostReach;
    NetworkStatus netstatus;
    BOOL isConnected;
    NSString *FirstNet;
}

@property(nonatomic,strong) AsyncSocket * socket;


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //设置启动页的时间
//    [NSThread sleepForTimeInterval:1.0];
    self.window.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    // 为了解决push有UITextView时的卡顿效果
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
    [self.window addSubview:textView];

    //判断是不是第一次启动APP
    [self isFirstLuachtheApp];
    
    //在整个过程中监听网络的变化
  //  [self MonitorNet];
    
    //获取系统的唯一标示码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *uuid=[self uuid];
        if (uuid!=nil) {
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            [userDefaultes setObject:uuid forKey:@"UUID"];
            //设备唯一识别符
        }
    });
    
    //初始化融云SDK
    [self initialRongYunSDK];
    
    //初始化友盟分享SDK
    [self initUmengSocial];
    

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        
    }
    
    [application registerForRemoteNotifications];

    //创建本地通知的方法
//    [self creatLocalNotificationWay];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatTaskONLocal:) name:@"CreatLocalNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitWay) name:@"StartExit" object:nil];
  
    
//--------------------------socket--------------------------------------
    NSString *token = [UserInfo getToken];
    if (token.length > 0) {
        
        [self connectSocket];
    }

    // 间隔发送消息表示在线
    [NSTimer scheduledTimerWithTimeInterval:25 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    
    // 连接socket通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSocket) name:@"KSocketConnectNotification" object:nil];

    
    return YES;
}


#pragma mark 注册推送通知之后
//在此接收设备令牌
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString *key=@"DeviceToken";
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:key];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);


}

#pragma mark 获取device token失败后
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error.localizedDescription);
}

#pragma mark 接收到推送通知之后
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"receiveRemoteNotification,userInfo is %@",userInfo);
}



//-(void)creatTaskONLocal:(NSNotification *)obj{
//    taskModel *model = obj.object;
//    NSDate *date = [StringChangeDate StringChangeDateWay:model.TaskTime];
//    NSTimeInterval second=[DateTool intervalFromLastDate:date toTheDate:[StringChangeDate getNowDateFromatAnDate:[NSDate date]]];
//    NSInteger sec =round(second);
//    if (sec>0||sec==0) {
//        [NSTimer scheduledTimerWithTimeInterval:sec target:self selector:@selector(creatLocalNotification) userInfo:nil repeats:NO];
//    }
//}
//初次加载的时候，将数据库里面的任务添加为本地通知
//-(void)creatLocalNotificationWay{
//    //开辟一个分线程执行本地通知
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSArray *arr = [taskDatabase queryData:@"所有任务"];
//        for (NSInteger i = 0; i < [taskDatabase queryData:@"所有任务"].count; i ++) {
//            taskModel *model =arr[i];
//            NSDate *date = [StringChangeDate StringChangeDateWay:model.TaskTime];
//            NSTimeInterval second=[DateTool intervalFromLastDate:date toTheDate:[StringChangeDate getNowDateFromatAnDate:[NSDate date]]];
//            NSInteger sec =round(second);
//            
//            NSLog(@"%ld",(long)sec);
//            if (sec>0||sec==0) {
//                 [NSTimer scheduledTimerWithTimeInterval:sec target:self selector:@selector(creatLocalNotification) userInfo:nil repeats:NO];
//            }
//           
//        }
//
//    });
//}
/**
 *  创建一个本地通知
 */
-(void)creatLocalNotification{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:1];
    //chuagjian一个本地推送
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    if (noti) {
        //设置推送时间
        noti.fireDate = date;
        //设置时区
        noti.timeZone = [NSTimeZone defaultTimeZone];
        //设置重复间隔
        noti.repeatInterval = 1;
        //noti.repeatCalendar = NSCalendarUnitWeekday;
        //推送声音
        noti.soundName = UILocalNotificationDefaultSoundName;

        //内容
        noti.alertBody = @"您有任务要做呦";
        //显示在icon上的红色圈中的数子
        noti.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];
        noti.userInfo = infoDic;
        //添加推送到uiapplication
//        UIApplication *app = [UIApplication sharedApplication];
//        [app scheduleLocalNotification:noti];
//        
//        [app presentLocalNotificationNow:noti];
    }
    
}
/**
 *  初始化融云
 */
-(void)initialRongYunSDK{
    NSString * appKeyStr =@"cpj2xarljde9n";
    //初始化融云SDK。
    [[RCIM sharedRCIM] initWithAppKey:appKeyStr];
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    [RCIM sharedRCIM].showUnkownMessage = YES;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *flag=[user objectForKey:@"YESORNOTLOGIN"];
    if ([flag isEqualToString:@"1"]) {
        [self connectRongyunServie];
    }
}
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    
//    _mesCount ++ ;
    
    // 消息个数变化
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MESSAGECOUNT" object:nil];
    
    if ([message.content isKindOfClass:[RCDiscussionNotificationMessage class]]) {
        
        // 融云推送比自己服务器快
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新讨论组列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDiscussionListNotification" object:nil];
        });

    };
    
}
-(void)connectRongyunServie{
    
    // 获取融云token
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *rongCloudToken = [userDefaults objectForKey:@"RongCloud"];
    // 连接融云服务器
    [[RCIM sharedRCIM] connectWithToken:rongCloudToken success:^(NSString *userId) {
        
        NSLog(@" IMToken chenggong ********************* ");
        ProfileMyModel * model1 = [[FirstStartData shareFirstStartData] getPersonCentrePlist];
        
        // 当前登录的用户的用户信息
        RCUserInfo * user =[[RCUserInfo alloc]init];
        user.userId = model1.ProfileId;
        user.name = model1.Nick;
        NSString *iconURL = [NSString replaceString:model1.FaceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
        user.portraitUri = iconURL;
        [RCIM sharedRCIM].currentUserInfo = user;
    }
                                  error:^(RCConnectErrorCode status) {  }
                         tokenIncorrect:^(){}];
    
}

// 退出登录
-(void)exitWay{
    
    //判断是否处于登录状态
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:@"0" forKey:@"YESORNOTLOGIN"];
    
    //断开RCIM连接
    [[RCIM sharedRCIM] disconnect];
    
    //断开socket连接
    [self.socket disconnect];
    
    // 清空token
    [UserInfo saveToken:@""];
    
    // 清空员工和组织架构数据
//    [ZWLCacheData archiveObject:@[] toFile:EmployeesPath];
//    [ZWLCacheData archiveObject:@[] toFile:DepartmentsPath];
    [ZWLCacheData archiveObject:@[] toFile:PermissionsPath];
    [ZWLCacheData archiveObject:@[] toFile:PermissionsPath];
    
    [self.tabvc removeFromParentViewController];
    self.tabvc = nil;
    
    CustomTabVC *customTabVC = [[CustomTabVC alloc] init];
    customTabVC.selectedIndex = 1;
    self.window.rootViewController = customTabVC;

    customTabVC.lastItem.imageBtn.selected = NO;
    customTabVC.lastItem.title.textColor = [UIColor lightGrayColor];
    
    TabBarItem *tabBarItem = [customTabVC.tabBarView viewWithTag:1];
    tabBarItem.imageBtn.selected = YES;
    tabBarItem.title.textColor = [UIColor colorWithHexString:@"#f99740"];
    
    customTabVC.lastItem = tabBarItem;
}


#pragma mark ----判断是否处于登录状态
-(void)YESORNOTLOGIN{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    
    NSString *str = [user objectForKey:@"YESORNOTLOGIN"];
    
    if ([str isEqualToString:@"1"]) {
        [user setObject:@"1" forKey:@"YESORNOTLOGIN"];
        self.tabvc=[[LoginTabVC alloc]init];
        
     
        self.window.rootViewController=self.tabvc;
        
    }else if ([str isEqualToString:@"0"]){
    
        
//        [self.tabvc removeFromParentViewController];
//        self.tabvc = nil;
        CustomTabVC *customTabVC = [[CustomTabVC alloc] init];

        self.window.rootViewController = customTabVC;
        
        [user setObject:@"0" forKey:@"YESORNOTLOGIN"];
        
    }else{
        
        [user setObject:@"0" forKey:@"YESORNOTLOGIN"];
        CustomTabVC *customTabVC = [[CustomTabVC alloc] init];

        self.window.rootViewController = customTabVC;

        
    }

}
#pragma mark ----监听网络的变化
-(void)MonitorNet{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [hostReach startNotifier];
}

//启用网络监视
-(void)reachabilityChanged:(NSNotification *)note{
    NSString * connectionKind = nil;
    
    Reachability * curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    netstatus = [curReach currentReachabilityStatus];
    switch (netstatus) {
        case NotReachable:
            connectionKind = @"当前没有网络链接\n请检查你的网络设置";
            isConnected =NO;
            break;
            
        case ReachableViaWiFi:
            connectionKind = @"当前使用的网络类型是WIFI";
            isConnected =YES;
            break;
            
        case ReachableViaWWAN:
            connectionKind = @"您现在使用的是2G/3G网络\n可能会产生流量费用";
            isConnected =YES;
            break;
            
        default:
            break;
    }
    //为了避免出现两次的网络监控
    if ([FirstNet isEqualToString:connectionKind]==0) {
        FirstNet=[NSString stringWithFormat:@"%@",connectionKind];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络状态" message:connectionKind delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        [UIView animateWithDuration:8.0 animations:^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        } completion:^(BOOL finished) {
            [alert removeFromSuperview];
            
        }];

    }
}
#pragma mark ----判断是不是第一次启动APP
-(void)isFirstLuachtheApp{
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        GuideViewController *guide=[[GuideViewController alloc]init];
        self.window.rootViewController=guide;
        NSLog(@"第一次启动");
        //如果是第一次启动APP，做相应的数据的初始化,创建Plist文件
//        [self CreatPlist];
        
    }else{
        //判定是否处于登录状态
        [self YESORNOTLOGIN];
        
    }
   
}
#pragma mark --创建Plist文件
//-(void)CreatPlist{
//    //创建一个static变量来实现任务ID的唯一
//    
//    [UserInfo saveOverALLTaskId:0];
// 
//    NSArray *arr;
//    
//    //创建用户名的Plist文件
//    [[FirstStartData shareFirstStartData] UserPersonCenterModelPlist:arr];
//    //创建让任务信息的Plist文件
//    [[FirstStartData shareFirstStartData] InfoTaskWayPlist:arr];
//    //创建个人中心的Plist文件
//    [[FirstStartData shareFirstStartData] PersonCentrePlist:nil];
//    //创建公司详情
//    [[FirstStartData shareFirstStartData] ProfileCompanyModelPlist:nil];
//    //创建数据库文件
//    [[FirstStartData shareFirstStartData] creatSQL];
//    
//}

#pragma mark --获取用户UUID
-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
//    NSArray *localArray=[[UIApplication sharedApplication] scheduledLocalNotifications];
   // NSLog(@"localarray=%@",localArray);
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"小赢温馨提示您" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    
//    
//    [alert show];
    //图标上德数字减1
    
    NSInteger i = (NSInteger)0;
    application.applicationIconBadgeNumber = i;
}



//屏蔽第三方键盘
-(BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier{
    return NO;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//--------------------------socket--------------------------------------

-(AsyncSocket *)socket{
    
    if (!_socket) {
        _socket=[[AsyncSocket alloc] initWithDelegate:self];
    }
    return _socket;
}

- (void)connectSocket

{
    // 连接socket
    NSError * error=nil;
    BOOL result = [self.socket connectToHost:Host onPort:Port error:&error];
    NSLog(@"%d连接结果%@",result,error);
    
    // 获取推送通知
    [self getPushMessage];
}

- (void)timeAction
{
    // 间隔发送消息表示在线
    NSDictionary * dic = @{@"Data":@{@"from":@"client"}};
    
    [self.socket writeData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] withTimeout:25 tag:1];
    [self.socket readDataWithTimeout:-1 tag:0];
    
}

#pragma mark * AsyncSocketDelegate
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"连接成功");
    
    NSString *token = [UserInfo getToken];
    
    if (token.length > 0) {
        // 发送认证消息
        NSDictionary * dic = @{@"Data":@{@"token":token}};
        [self.socket writeData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] withTimeout:3 tag:1];


    }
    [self.socket readDataWithTimeout:-1 tag:0];
    
    
}

//- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
//{
//    NSLog(@"即将失去连接%@",err);
//}
//
//- (void)onSocketDidDisconnect:(AsyncSocket *)sock
//{
//    NSLog(@"失去连接");
//}

// 发送数据后调用
//-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
//{
//    [self.socket readDataWithTimeout:-1 tag:0];
//    NSLog(@"发送数据");
//}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
//    UIApplicationState  state = [UIApplication sharedApplication].applicationState;
//    if (state==UIApplicationStateBackground) {
//        NSInteger number = [UIApplication sharedApplication].applicationIconBadgeNumber;
//        NSLog(@"设置程序标示后台情况下%ld",(long)number);
//        number++;
//        NSLog(@"%ld",(long)number);
//        NSLog(@"%@",[NSThread currentThread]);
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number];
//        
//    }
    
    //将数据包转换为字符串
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"sokect消息：%@",aStr);
    
    NSDictionary *dic = [aStr objectFromJSONString];
    dic = [dic[@"Data"][@"MessageBody"] firstObject];
    
    NSString *MsgId = nil;
    if (dic) {
        MsgId = dic[@"MsgId"];
        NSString *Route = dic[@"Route"];
        NSString *Content = dic[@"Content"];
        NSString *CompanyId = dic[@"CompanyId"];
        

        // ----------------------------有关公司的通知--------------------------
        // 企业架构更新了！
        if ([Route isEqualToString:ApiDepartmentRefresh]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDepartmentRefreshNotification object:nil];
        }
        
        // 企业员工变化了！
        if ([Route isEqualToString:ApiEmployeeRefresh]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kEmployeeRefreshNotification object:nil];
        }
        
        // ----------------------------聊天通知--------------------------
        
        // 检测好友
        if ([Route isEqualToString:ApiFriendRequest]) {

            [[NSNotificationCenter defaultCenter] postNotificationName:kCheckFriendRequestNotification object:nil];
        }
        
        // 接受了您的添加请求并添加您为好友
        if ([Route isEqualToString:NoApiFriendAgree]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kAgreeFriendSuccessNotification object:nil];
            
        }
        
        // 拒绝了您的好友添加请求
        if ([Route isEqualToString:NoApiFriendRefuse]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefuseFriendNotification object:nil];
        }
        
        // 删除好友通知
        if ([Route isEqualToString:NoApiFriendDelete]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kAgreeFriendSuccessNotification object:nil];
        }
    
        // ----------------------------审批相关--------------------------
        //有新的流程待审核
        if ([Route isEqualToString:ApprovalAuditing]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kCheckApprovalAuditingNotification object:nil];
        }
        
        //撤销了申请
        if ([Route isEqualToString:ApplyRevoke]) {
            NSString *param = dic[@"Param"];
            NSDictionary *paramDic = [param objectFromJSONString];
            NSString *applyId = paramDic[@"applyId"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kCheckApplyRevokeNotification object:applyId];
        }
        
        
        
        /*----------------------------申请相关--------------------------*/
        
        // 申请被通过
        if ([Route isEqualToString:SocketNotification_ApplyAgree]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kApplyAgreeNotification object:nil];
        }
        
        // 申请未通过
        if ([Route isEqualToString:SocketNotification_ApplyRefuse]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kApplyRefuseNotification object:nil];
        }
        
        
        
        /*----------------------------加入公司--------------------------*/

        //老同事离开了部门
        if ([Route isEqualToString:NoApiStudentLeave]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kColleagueLeaveNotification object:@{@"Content":Content,@"CompanyId":CompanyId}];
        }
        

        //新同事加入了部门
        if ([Route isEqualToString:NoApiStudentJoin]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kColleagueJoinNotification object:@{@"Content":Content,@"CompanyId":CompanyId}];
        }
        
        
        // 公司拒绝了您的加入申请  (暂时不需要红点)
        if ([Route isEqualToString:NoApiRefuseJoin]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefuseJoinNotification object:nil];
        }
        
        // 拒绝了您的加入公司邀请   (暂时不需要红点)
        if ([Route isEqualToString:NoApiRefuseInvite]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefuseInviteNotification object:nil];
        }

        // 有新人申请加入公司请及时处理
        if ([Route isEqualToString:ApiJoinQueue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kJoinQueueNotification object:nil];
        }
        
        // 公司撤销了对您的加入申请
        if ([Route isEqualToString:NoApiCanaleJoin]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kCanaleJoinNotification object:nil];
        }

        // 撤销了对贵公司的加入申请
        if ([Route isEqualToString:NoApiCanaleJoinApply]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kCanaleJoinApplyNotification object:nil];
        }

        
        
        NSLog(@"Route:%@",Route);
        [self removePushMessage:@[MsgId]];

    }

    [self.socket readDataWithTimeout:-1 tag:0];
}

// 获取推送通知
-(void)getPushMessage {
    
    [AFNetClient GET_Path:GetPushMessage completed:^(NSData *stringData, id JSONDict) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dic in JSONDict[@"Data"][@"MessageBody"]) {
            [arrM addObject:dic[@"MsgId"]];
        }
        
        if (arrM.count > 0) {
            [self removePushMessage:arrM];
        }
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}
// 移除推送通知
- (void)removePushMessage:(NSArray *)arr {
    [AFNetClient  POST_Path:RemovePushMessage params:arr completed:^(NSData *stringData, id JSONDict) {
        NSLog(@"移除推送：%@",JSONDict);
    } failed:^(NSError *error) {
        NSLog(@"请求失败Error--%ld",(long)error.code);
    }];
}

// =======================友盟==========================
- (void)initUmengSocial
{
    //打开日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    // 获取友盟social版本号
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"585a1dd1f29d98750f00001b"];
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx2e6d72e447f21b72" appSecret:@"49d96dde9d92c18c6ab4dcd4693058e2" redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 添加某一平台会加入平台下所有分享渠道，如微信：好友、朋友圈、收藏，QQ：QQ和QQ空间
     * 以下接口可移除相应平台类型的分享，如微信收藏，对应类型可在枚举中查找
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    // 设置分享到QQ互联的appID
    // U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105919302"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1203685429"  appSecret:@"d53b5bd2e16b34396d37f617f2b00388" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}

//#define __IPHONE_10_0    100000
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


@end
