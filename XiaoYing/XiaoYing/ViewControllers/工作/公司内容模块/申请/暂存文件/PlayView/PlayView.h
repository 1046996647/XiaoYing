//
//  PlayView.h
//  XiaoYing
//
//  Created by ZWL on 16/4/13.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayView : UIView

// 录音文件URL
@property (strong, nonatomic) NSURL *contentURL;

// 录音时间
@property (strong, nonatomic) NSString *timeStr;

// 删除时设置player为空
- (void)cancel;


@end
