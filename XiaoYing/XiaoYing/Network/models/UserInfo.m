//
//  UserInfo.m
//  XiaoYing
//
//  Created by ZWL on 15/10/27.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

#pragma mark ----账号信息
+(void)saveLoginAccount:(NSString *)str WithLastAcount:(NSString*)str1{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:str forKey:@"ACOUNT"];
    [userDefaultes setObject:str1 forKey:@"LASTACOUNT"];
    [userDefaultes synchronize];
}
+(NSString *)getLastAccountStr{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    return [userDefaultes objectForKey:@"LASTACOUNT"];
}
+(NSString *)getLoginAccountStr{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    return [userDefaultes objectForKey:@"ACOUNT"];
}
+(BOOL)getLoginAccount{
    if ([[self getLoginAccountStr] isEqualToString:[self getLastAccountStr]]) {
        return YES;
    }else{
        return NO;
    }
    
}


#pragma mark ----用户信息
+(void)saveUserInfo:(NSMutableDictionary *)dict
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:dict forKey:@"userInfo"];
    [userDefaultes synchronize];
}

+(NSMutableDictionary  *)getUserInfo
{
    NSUserDefaults   *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary  *dict=[NSMutableDictionary  dictionaryWithDictionary:[userDefaultes  objectForKey:@"userInfo"]];
    return dict;
}



+(void)delegataKey:(NSString *)dict
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dicts=[userDefaultes  objectForKey:@"userInfo"];
    [dicts removeObjectForKey:dict];
    [userDefaultes synchronize];
}

+(void)saveToken:(NSString *)tokenString
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:tokenString  forKey:@"token"];
    [userDefaultes synchronize];
}

//
+(NSString  *)userCount
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *userCount = [userDefaultes  objectForKey:@"UserCount"];
    return userCount;
}

+(void)saveUserCount:(NSString  *)userCount
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:userCount  forKey:@"UserCount"];
    [userDefaultes synchronize];
}


//
+(NSString  *)userID
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *uesrid=[userDefaultes  objectForKey:@"USER_ID"];
    return uesrid;
}

+(void)saveUserID:(NSString  *)userID
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:userID  forKey:@"USER_ID"];
    [userDefaultes synchronize];
}

//
+(NSString *)getToken
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *dict=[userDefaultes  objectForKey:@"token"];
    return dict;
}

#pragma mark ---公司信息
/*公司信息*/
+(void)saveJoinCompany_YesOrNo:(NSString *)str
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:str  forKey:@"YESORNOTJOINCOMPANY"];
    [userDefaultes synchronize];
}
+(BOOL)getJoinCompany_YesOrNo
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *dict=[userDefaultes  objectForKey:@"YESORNOTJOINCOMPANY"];
    if ([dict isEqualToString:@"0"]) {
        return YES;
    }else{
        return NO;
    }
}
+(void)saveCompanyId:(NSString *)companyId{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:companyId  forKey:@"CompanyId"];
    [userDefaultes synchronize];
}
+(void)savecompanyName:(NSString*)companyName{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:companyName  forKey:@"CompanyName"];
    [userDefaultes synchronize];
}
+(void)saveUserRole:(NSNumber*)userRole{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:userRole  forKey:@"UserRole"];
    [userDefaultes synchronize];
}
+(NSNumber *)getUserRole{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSNumber  *dict=[userDefaultes  objectForKey:@"UserRole"];
    return dict;
}
+(NSString *)getCompanyId{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *dict=[userDefaultes  objectForKey:@"CompanyId"];
    return dict;
}
+(NSString *)getcompanyName{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *dict=[userDefaultes  objectForKey:@"CompanyName"];
    return dict;
}
#pragma mark ---非登录状态下的任务ID
+(void)saveOverALLTaskId:(NSInteger)overALLTaskId{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setInteger:overALLTaskId forKey:@"overALLTaskId"];
    [userDefaultes synchronize];
}
+(NSInteger)getOverALLTaskId{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSInteger dic = [userDefaultes integerForKey:@"overALLTaskId"];
    return dic;
}
/**
 *  判断是否是处于登录状态
 */
+(void)saveLoginOrNotLogin:(NSString *)str{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:str forKey:@"YESORNOTLOGIN"];
    [userDefaultes synchronize];
}
+(BOOL)getLoginOrNotLogin{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *dic = [userDefaultes objectForKey:@"YESORNOTLOGIN"];
    if ([dic isEqualToString:@"1"]) {
        return YES;
    }else if ([dic isEqualToString:@"0"]){
        return NO;
    }
    return NO;
}
/**
 * 上次获取任务的时间
 */
+(void)saveTaskLastTime:(NSString *)str{
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    [userDefaultes setObject:str forKey:@"LastTime"];
    
    [userDefaultes synchronize];
}
+(NSString *)getTaskLastTime{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *dic = [userDefaults objectForKey:@"LastTime"];
    
    NSArray *arr = [dic componentsSeparatedByString:@" +"];
    return arr[0];
}



//名片上边的信息
+(void)saveFaceURLOfCard:(NSString *)faceURl {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:faceURl  forKey:@"FaceURLOfCard"];
    [userDefaultes synchronize];
}
+(NSString *)GetfaceURLofCard {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *dict=[userDefaultes  objectForKey:@"FaceURLOfCard"];
    return dict;
}

+(void)saveNameOfCard:(NSString *)name {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:name  forKey:@"NameOfCard"];
    [userDefaultes synchronize];
}
+(NSString *)GetnameOfCard {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *dict=[userDefaultes  objectForKey:@"NameOfCard"];
    return dict;
}

+(void)saveDepartmentOfCard:(NSString *)name {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:name  forKey:@"DepartmentOfCard"];
    [userDefaultes synchronize];
}
+(NSString *)GetDepartmentOfCard {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *dict=[userDefaultes  objectForKey:@"DepartmentOfCard"];
    return dict;
}

+(void)savePositionOfCard:(NSString *)name {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:name  forKey:@"PositionOfCard"];
    [userDefaultes synchronize];

}
+(NSString *)GetPositionOfCard {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *dict=[userDefaultes  objectForKey:@"PositionOfCard"];
    return dict;
}


//最高领导人账户编号
+(void)saveTopLeaderOfCompany:(NSString *)toplLader {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:toplLader forKey:@"TopLeaderOfCompany"];
    [userDefaults synchronize];
}
+(NSString *)GetTopLeaderOfCompany {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *dict = [userDefaultes  objectForKey:@"TopLeaderOfCompany"];
    return dict;
}


+(void)saveCode:(NSString *)codeStr
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:codeStr forKey:@"codeStr"];
    [userDefaults synchronize];
}
+(NSString *)getCode
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *dict = [userDefaultes  objectForKey:@"codeStr"];
    return dict;
}




@end
