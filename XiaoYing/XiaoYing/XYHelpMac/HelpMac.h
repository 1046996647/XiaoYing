//
//  HelpMac.h
//  XiaoYing
//
//  Created by ZWL on 15/10/12.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpMac : NSObject
 
#define Qsend_GlobalMacro_h


//判断是NSString 返回 该String 否则返回 @""
#define kIsString(str) [str isKindOfClass:[NSString class]] ? str : @""


//----------------------系统----------------------------
//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

#define  Divide_Scale_Iphone5   1136/960

#define iOS_Version_9  [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0

//是否是iOS 7 及 以上版本
#define iOS_Version_7  [[[UIDevice currentDevice] systemVersion] floatValue] > 7.0

//是否是iOS 8 及 以上版本
#define iOS_Version_8  [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

#define Is_iOS_Version_7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)?YES:NO
//是否是 iPhone5 屏幕尺寸
//#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


//判断iphone4
#define IS_IPHONE_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone5
#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone6
#define IS_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone6+
#define IS_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


//----------------------系统----------------------------

//-------------------获取设备大小尺寸-------------------------



//设备屏幕尺寸 屏幕Size
#define kScreen_Size      [UIScreen mainScreen] bounds].size
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
//获取 屏幕Frame
#define kScreen_Frame   [UIScreen mainScreen].applicationFrame
#define kScreen_CenterX  kScreen_Width/2
#define kScreen_CenterY  kScreen_Height/2

#define scaleX  kScreen_Width/320
#define scaleY  kScreen_Height/568

//获取状态栏Frame
#define kScreen_StatusBarFrame   [[UIApplication sharedApplication] statusBarFrame]


//获取中间内容高度（除去状态栏，UITabBar，UINavigationBar）
//#define kContent_Height [[UIScreen mainScreen] bounds].size.height-44-49-20


//应用尺寸(不包括状态栏,通话时状态栏高度不是20，所以需要知道具体尺寸)
#define kContent_Height   ([UIScreen mainScreen].applicationFrame.size.height)
#define kContent_Width    ([UIScreen mainScreen].applicationFrame.size.width)
#define kContent_Frame    (CGRectMake(0, 0 ,kContent_Width,kContent_Height))
#define kContent_CenterX  kContent_Width/2
#define kContent_CenterY  kContent_Height/2

//-------------------获取设备大小-------------------------


//--------------------打印日志---------------------------
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] "fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

// -------------------重写NSLog------------------------
#ifdef DEBUG
#define NSLog(format, ...) fprintf(stderr, "\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
#define NSLog(format, ...) nil
#endif

#define SYSTEM_VERSION [[[UIDevice CurrentDevice] systemVersion] floatValue]
@end
