    //
//  AFNetClient.h
//  AFNetClient
//
//  Created by l.h on 14-9-23.
//  Copyright (c) 2014年 sibu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
 

extern NSString *const kAPI_BASE_URL;


/**
 @ Copyright (c) 2014年 gzsibu. All rights reserved.
 @ AFNetClient 请求回调的块声明；
 @ 2014.9 基本的Get,Post 请求完成 Block回调；
 @
*/

typedef void (^HHSuccessBlock)(NSData *stringData,id JSONDict);
typedef void (^HHFailedBlock)(NSError *error);
typedef void (^HHSpeedBlock)(float  progress);

@interface AFNetClient : NSObject


/*请求客户端*/
+ (instancetype)client;


/**
  @       get  请求
  @param  path=nil  无参数
 */
+ (void)GET_Path:(NSString *)path completed:(HHSuccessBlock )successBlock failed:(HHFailedBlock )failed;


/**
 @       get  请求 
 @param  path  有参数
 */
+ (void)GET_Path:(NSString *)path  params:(NSDictionary *)params  completed:(HHSuccessBlock )successBlock failed:(HHFailedBlock )failed;


+ (void)POST_Path2:(NSString *)path completed:(HHSuccessBlock )successBlock failed:(HHFailedBlock )failed;


/**
 @          POST  请求 无参数
 @param     无参数
 */
+ (void)POST_Path:(NSString *)path completed:(HHSuccessBlock )successBlock failed:(HHFailedBlock )failed;


/**
 @          POST  请求  有参数
 @param     有参数
 */
+ (void)POST_Path:(NSString *)path params:(id)paramsDic completed:(HHSuccessBlock )successBlock failed:(HHFailedBlock )failed;


/**
 @          文件下载
 @param     HHSpeedBlock  下载进度
 @param     下载进度建议用SVProgressHUD显示
 */
+(void)downloadFile:(NSString *)UrlAddress  completed:(HHSuccessBlock)successBlock failed:(HHFailedBlock)failed  progress:(HHSpeedBlock)progressBlock;



/*  -------判断当前的网络类型----------
 1、NotReachable     - 没有网络连接
 2、ReachableViaWWAN - 移动网络(2G、3G)
 3、ReachableViaWiFi - WIFI网络
 */
//+ (NetworkStatus)networkStatus;
//+ (NetworkStatus)networkStatus
//{
//    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.apple.com"];
//    // NotReachable     - 没有网络连接
//    // ReachableViaWWAN - 移动网络(2G、3G)
//    // ReachableViaWiFi - WIFI网络
//    return [reachability currentReachabilityStatus];
//}


//================================================

//+(void)POST_Path:(NSString *)path arams:(NSDictionary *)paramsDi completed:(HHSuccessBlock)successBlock failed:(HHFailedBlock)failed;

/**
 官方文档:  http://cocoadocs.org/docsets/AFNetworking/2.4.0/
 Github:   https://github.com/AFNetworking/AFNetworking/
 
 */

@end
