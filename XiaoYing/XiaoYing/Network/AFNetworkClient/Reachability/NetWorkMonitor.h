//
//  NetWorkMonitoring.h
//  UserLocationManager
//
//  Created by luo.h on 14-12-27.
//  Copyright (c) 2014年 sibu.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

/**
 *  网络监控Block
 *  @param NetStateType 网路类型
 */
typedef void(^netStateBlock)(NSInteger  NetStateType,BOOL  isReachable);

@interface NetWorkMonitor : NSObject


@property(nonatomic,strong)   netStateBlock  netTypeBlock;
@property(nonatomic,strong)   Reachability   *NetReach;
@property (strong, nonatomic) Reachability   *HReachability;
+ (NetWorkMonitor*)sharedManager;


/**
 *  网络是否畅通
 *  @param BOOL 网络是否畅通
 *  @return  yes or No
 */
+(BOOL)isNetReachable;


/**
 *  当前网络状态类型
 *  @param  NSUInteger 网络类型
 *  @return NetstatusType
 */
-(NSUInteger)CurrentNetStatusType;


/**
 *  Block  网络切换通知回调
 *
 *  @param netChangeblock 网络类型  网络可达（是否）
 */
-(void)netStateBlock:(netStateBlock)netChangeblock;


+ (BOOL)isEnableWIFI;
+ (BOOL)isEnable3G;
+ (BOOL)isConnect;
+ (BOOL)isServerConnect;
+ (BOOL)checkNetStatusOK;


@end
