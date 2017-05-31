//
//  SettingSwitch.m
//  XiaoYing
//
//  Created by yinglaijinrong on 16/1/11.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "SettingSwitch.h"


@implementation SettingSwitch



//-----------------------------新消息通知-------------------------------

//通知显示消息详情
+ (void)setShowMessageDetailYesOrNo:(NSString *)str
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:str  forKey:@"YesOrNOTShowMessageDetail"];
    [userDefaultes synchronize];
}

+ (BOOL)getShowMessageDetailYesOrNo
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *dict=[userDefaultes  objectForKey:@"YesOrNOTShowMessageDetail"];
    if ([dict isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}

//声音
+ (void)setVoiceRemindYesOrNo:(NSString *)str
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:str  forKey:@"YesOrNOTVoiceRemind"];
    [userDefaultes synchronize];
}

+ (BOOL)getVoiceRemindYesOrNo
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *dict=[userDefaultes  objectForKey:@"YesOrNOTVoiceRemind"];
    if ([dict isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}

//震动
+ (void)setShakeRemindYesOrNo:(NSString *)str
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:str  forKey:@"YesOrNOTShakeRemind"];
    [userDefaultes synchronize];
}

+ (BOOL)getShakeRemindYesOrNo
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *dict=[userDefaultes  objectForKey:@"YesOrNOTShakeRemind"];
    if ([dict isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}

//----功能消息免打扰-----
+ (void)setDisturbingState:(NSString *)str
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:str  forKey:@"DisturbingState"];
    [userDefaultes synchronize];
}

+ (NSInteger)getDisturbingState
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString  *dict=[userDefaultes  objectForKey:@"DisturbingState"];
    if ([dict isEqualToString:@"0"]) {
        //开启
        return 0;
    }
    else if ([dict isEqualToString:@"1"]) {
        //只在夜间开启（只在22：00到8：00生效）
        return 1;
    }
    else {
        //关闭
        return 2;
    }

}

@end
