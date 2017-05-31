//
//  UserInfo.h
//  XiaoYing
//
//  Created by ZWL on 15/10/27.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

//
+(NSString  *)userCount;
+(void)saveUserCount:(NSString  *)userCount;


/*登录账号密码的保存*/
+(void)saveLoginAccount:(NSString *)str WithLastAcount:(NSString*)str1;
+(NSString *)getLoginAccountStr;
+(NSString *)getLastAccountStr;
+(BOOL)getLoginAccount;

/*用户信息*/
+(void)saveUserInfo:(NSMutableDictionary *)dict;
+(NSMutableDictionary *)getUserInfo;
+(void)saveUserID:(NSString  *)userID;

/*用户Token*/
+(void)saveToken:(NSString*)tokenString;
+(NSString  *)getToken;
+(NSString  *)userID;
+(void)delegataKey:(NSString *)dict;

/*公司信息*/
+(void)saveJoinCompany_YesOrNo:(NSString *)str;
+(BOOL)getJoinCompany_YesOrNo;

+(void)saveCompanyId:(NSString *)companyId;
+(void)savecompanyName:(NSString*)companyName;
+(void)saveUserRole:(NSNumber*)userRole;
+(NSNumber *)getUserRole;
+(NSString *)getCompanyId;
+(NSString *)getcompanyName;


/*非登录状态的任务的TaskID*/
+(void)saveOverALLTaskId:(NSInteger) overALLTaskId;
+(NSInteger)getOverALLTaskId;

/**
 *  判断是否是处于登录状态
 */
+(void)saveLoginOrNotLogin:(NSString *)str;
+(BOOL)getLoginOrNotLogin;

/**
 * 上次获取任务的时间
 */
+(void)saveTaskLastTime:(NSString *) str;
+(NSString *)getTaskLastTime;

/**
 * -----保存名片上边的信息-----
 */
+(void)saveFaceURLOfCard:(NSString *)faceURl;
+(NSString *)GetfaceURLofCard;

+(void)saveNameOfCard:(NSString *)name;
+(NSString *)GetnameOfCard;

+(void)saveDepartmentOfCard:(NSString *)name;
+(NSString *)GetDepartmentOfCard;

+(void)savePositionOfCard:(NSString *)name;
+(NSString *)GetPositionOfCard;


/**
 * -----最高领导人账户编号-----
 */
+(void)saveTopLeaderOfCompany:(NSString *)toplLader;
+(NSString *)GetTopLeaderOfCompany;

// 二维码生成的字符串
+(void)saveCode:(NSString *)codeStr;
+(NSString *)getCode;


@end
