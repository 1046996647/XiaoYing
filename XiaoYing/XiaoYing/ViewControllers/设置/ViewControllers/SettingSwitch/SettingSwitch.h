//
//  SettingSwitch.h
//  XiaoYing
//
//  Created by yinglaijinrong on 16/1/11.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingSwitch : NSObject


//----------------------新消息通知-------------------------------

//通知显示消息详情
+ (void)setShowMessageDetailYesOrNo:(NSString *)str;
+ (BOOL)getShowMessageDetailYesOrNo;

//声音
+ (void)setVoiceRemindYesOrNo:(NSString *)str;
+ (BOOL)getVoiceRemindYesOrNo;

//震动
+ (void)setShakeRemindYesOrNo:(NSString *)str;
+ (BOOL)getShakeRemindYesOrNo;

//----功能消息免打扰-----
+ (void)setDisturbingState:(NSString *)str;
+ (NSInteger)getDisturbingState;



@end
