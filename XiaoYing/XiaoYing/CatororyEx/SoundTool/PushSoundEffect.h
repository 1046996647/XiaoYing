//
//  PushSoundEffect.h
//  XiaoYing
//
//  Created by ZWL on 15/12/8.
//  Copyright © 2015年 ZWL. All rights reserved.
//
/**
 *  1:使用本类的时候需要加入一个系统库 AudioToolbox
 *  2:之后加方法调用
 *  3:震动需要真机才可以
 */
/**
 *  1.NSString *path = [[NSBundle mainBundle] pathForResource:@"CAT2" ofType:@"WAV"];
 *  2.[PushSoundEffect playSoundEffectPath:path];
 */
#import <Foundation/Foundation.h>

@interface PushSoundEffect : NSObject


+(void)playSoundEffectPath:(NSString *)path;

+(void)playSystemSoundEffect;

+(void)playSoundWithName:(NSString *)name type:(NSString *)type;

@end
