//
//  UIImage+GenerateCodeOfQr.h
//  XiaoYing
//
//  Created by GZH on 2016/12/27.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GenerateCodeOfQr)

//获取二维码    参数：标识的数据(嵌入二维码的数据)，获取的二维码的尺寸(二维码的宽度)
+ (UIImage *)getCodeOfQrWithMark:(NSString *)strID withSize:(CGFloat)size;

@end
