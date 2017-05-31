
//
//  NotMovieFolderView.m
//  XiaoYing
//
//  Created by GZH on 16/7/28.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "NotMovieFolderView.h"

@implementation NotMovieFolderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self pushView];
    }
    return self;
}



- (void)pushView {
    _coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.4;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_coverView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverBackAction)];
    [_coverView addGestureRecognizer:tap];
    
    _littleView = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width - 270) / 2, (kScreen_Height - 100) / 2, 270 , 100)];
    _littleView.backgroundColor = [UIColor whiteColor];
    _littleView.layer.cornerRadius = 5;
    _littleView.clipsToBounds = YES;
    [window addSubview:_littleView];
    
    UILabel *upLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 270, 100 - 44 - 0.5)];
    upLabel.text = @"暂不支持文件夹移动";
    upLabel.font = [UIFont systemFontOfSize:16];
    upLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    upLabel.textAlignment = NSTextAlignmentCenter;
    [_littleView addSubview:upLabel];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100 - 44, 270, 0.5)];
    label.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_littleView addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 100 - 44 - .5, 270, 44);
    [btn setTitle:@"知道了" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 16];
    [btn addTarget:self action:@selector(coverBackAction) forControlEvents:UIControlEventTouchUpInside];
    [_littleView addSubview:btn];


}

- (void)coverBackAction {
    [_coverView removeFromSuperview];
    [_littleView removeFromSuperview];
}



@end
