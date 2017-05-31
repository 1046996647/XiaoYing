//
//  PushSoundEffect.m
//  XiaoYing
//
//  Created by ZWL on 15/12/8.
//  Copyright © 2015年 ZWL. All rights reserved.
//
#import "PushSoundEffect.h"
#import <AudioToolbox/AudioToolbox.h>
@implementation PushSoundEffect

+(void)playSoundEffectPath:(NSString *)path{
    SystemSoundID soundID;
    
    //注册声音到系统
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound(soundID);//背景音  播放注册的声音
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//加短暂震动效果
    
    //声音停止
    AudioServicesDisposeSystemSoundID(soundID);

}
+(void)playSystemSoundEffect{
    //系统声音
    AudioServicesPlaySystemSound(1007);
    
    //调用震动代码：
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
+(void)playSoundWithName:(NSString *)name type:(NSString *)type{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &sound);
        AudioServicesPlaySystemSound(sound);
    }
    else {
        NSLog(@"Error: audio file not found at path: %@", path);
    }

}
+ (void)playMessageReceivedSound
{
    [PushSoundEffect playSoundWithName:@"messageReceived" type:@"aiff"];
}

+ (void)playMessageSentSound
{
    [PushSoundEffect playSoundWithName:@"messageSent" type:@"aiff"];
}
@end
