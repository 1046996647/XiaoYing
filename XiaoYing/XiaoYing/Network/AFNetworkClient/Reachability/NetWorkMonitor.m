//
//  NetWorkMonitoring.m
//  UserLocationManager
//
//  Created by luo.h on 14-12-27.
//  Copyright (c) 2014年 sibu.cn. All rights reserved.
//

#import "NetWorkMonitor.h"

@implementation NetWorkMonitor

+(NetWorkMonitor *)sharedManager
{
    NSLog(@"netMonitor");
    static NetWorkMonitor *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[self alloc]init];
    });
    return client;
}

//初始化
- (instancetype)init
{
     NSLog(@"netMonitor=init");
    self = [super init];
    if (self)
    {
        //初始化
        self.NetReach = [Reachability reachabilityWithHostName:@"www.baidu.com"] ;
        //或者： self.NetReach = [Reachability reachabilityForInternetConnection];
       
        //开始监听,会启动一个run loop
        [self.NetReach startNotifier];
        
        
         self.NetReach.reachableOnWWAN = NO;
        
        /**
         *  用通知监测会调用2次（建议直接用Block）
         *
         *  @param NetReachabilityChanged:
         *
         */
        //接收网络环境变化的通知  消息名称（固定）为：kReachabilityChangedNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(NetReachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
      
    }
    return self;
}


/**
 *  网络是否畅通
 *
 *  @return yes(畅通)  No(不通)
 */
+(BOOL)isNetReachable;
{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
        return NO;
    } else {
        return YES;
    }
    //    BOOL   netReach=  [reach  isReachable];
    //    NSLog(@"网络是否畅通===%d",netReach);
}



/**
 *  检查当前网络状态
 *
 *  @return NetworkStatus  WIFI/3G
 */
-(NSUInteger)CurrentNetStatusType;
{
//    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    NetworkStatus status = [reach currentReachabilityStatus];
    NetworkStatus state = [self.NetReach currentReachabilityStatus];
    NSString *stateDesc;
    NSUInteger netType;
    switch (state) {
        case NotReachable :
            stateDesc = @"无可用连接";
            netType=NotReachable;
            break;
        case ReachableViaWiFi :
            stateDesc = @"WIFI";
            netType=ReachableViaWiFi;
            break;
        case ReachableViaWWAN :
            stateDesc = @"2G/3G";
            netType=ReachableViaWWAN;
            break;
    }
    NSLog(@"当前网络状态:%@",stateDesc);
    return netType;
}




-(void)netStateBlock:(netStateBlock)netChangeblock
{
    self.netTypeBlock=netChangeblock;
}


/**
 *  网络状态改变
 *
 *  @param note 通知（网络切换）
 */
- (void) NetReachabilityChanged: (NSNotification*)note {
    
    Reachability * reach = [note object];
    NSParameterAssert([reach isKindOfClass:[Reachability class]]);
    BOOL  reachable;
    
    reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus   CurrentNetStatus=[reach currentReachabilityStatus];
    
    switch (CurrentNetStatus) {
        case NotReachable:
                reachable=NO;
              NSLog(@"3G/4G网络不可用");
            break;
        case ReachableViaWiFi:
                reachable=YES;
              NSLog(@"ViaWIFI/3G/4G网络已经连接可用");
            break;
        case ReachableViaWWAN:
                reachable=YES;
              NSLog(@"WWANWIF/3G/4G网络已经连接可用");
            break;
        default:
            break;
    }
    
    self.netTypeBlock(CurrentNetStatus,reachable);
}


- (void)dealloc {
    // Stop Notifier
    if (_NetReach) {
        [_NetReach stopNotifier];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

#pragma mark-------支持网络类型   类方法------
/**
 *  调用方法
 *  [NetWorkMonitor  isEnableWIFI];
 *  [NetWorkMonitor  isEnable3G];
 *  [NetWorkMonitor  isConnect];
 */

// 是否wifi
+ (BOOL)isEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] ==ReachableViaWiFi);
}

// 是否3G
+ (BOOL)isEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] ==ReachableViaWWAN);
}

// 网络连接
+ (BOOL)isConnect {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] !=NotReachable);
}

//判断当前网络是否连接
+(BOOL)isServerConnect{
    return [[Reachability reachabilityWithHostname:@"www.baidu.com"] currentReachabilityStatus]!=NotReachable;
}


#pragma mark--------
+(BOOL)checkNetStatusOK{
    BOOL reachability;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            NSLog(@"没有网络");
            reachability = NO;
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            NSLog(@"正在使用3G网络");
            reachability = YES;
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            NSLog(@"正在使用wifi网络");
            reachability = YES;
            break;
    }
    return reachability;
}


@end
