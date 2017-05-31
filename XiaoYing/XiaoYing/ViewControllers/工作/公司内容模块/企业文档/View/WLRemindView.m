//
//  DownloadRemindView.m
//  XiaoYing
//
//  Created by ZWL on 16/7/13.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "WLRemindView.h"

@implementation WLRemindView

+ (void)showIcon:(NSString *)icon
{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;

    UIView *showview =  [[UIView alloc] initWithFrame:window.bounds];
    showview.alpha = 1.0f;
    [window addSubview:showview];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.image = [UIImage imageNamed:icon];
    imageView.center = showview.center;
    [showview addSubview:imageView];
    
    [UIView animateWithDuration:1.5f animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

@end
