//
//  UploadView.m
//  XiaoYing
//
//  Created by ZWL on 16/1/22.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AuthorityPullDownView.h"

@implementation AuthorityPullDownView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
        
        [self initSubview];
        
    }
    return self;
}

- (void)initSubview
{
    UIView *nextView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width-130,0, 120, 0)];
    nextView.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [self addSubview:nextView];
    
    UIButton *shareQR = [UIButton buttonWithType:UIButtonTypeCustom];
    shareQR.frame = CGRectMake(0, 0, 120, 40);
    [shareQR setTitle:@"按时间" forState:UIControlStateNormal];
    [shareQR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareQR.titleLabel.font = [UIFont systemFontOfSize:14];
    shareQR.tag = 1;
    [shareQR addTarget:self action:@selector(jumpConnect:) forControlEvents:UIControlEventTouchUpInside];
    [nextView addSubview:shareQR];
    
    UIView *firstline = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 100, 0.5)];
    firstline.backgroundColor = [UIColor whiteColor];
    [nextView addSubview:firstline];
    
    UIButton *keepQR = [UIButton buttonWithType:UIButtonTypeCustom];
    keepQR.frame = CGRectMake(0, 40.5 , 120, 40);
    [keepQR setTitle:@"按部门" forState:UIControlStateNormal];
    [keepQR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    keepQR.titleLabel.font = [UIFont systemFontOfSize:14];
    keepQR.tag = 2;
    [keepQR addTarget:self action:@selector(jumpConnect:) forControlEvents:UIControlEventTouchUpInside];
    [nextView addSubview:keepQR];
    
    UIView *secondline = [[UIView alloc] initWithFrame:CGRectMake(10, 80.5, 100, 0.5)];
    secondline.backgroundColor = [UIColor whiteColor];
    [nextView addSubview:secondline];
    
    
    UIButton *sweepQR = [UIButton buttonWithType:UIButtonTypeCustom];
    sweepQR.frame = CGRectMake(0, 81 , 120, 40);
    [sweepQR setTitle:@"按姓名" forState:UIControlStateNormal];
    [sweepQR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sweepQR.titleLabel.font = [UIFont systemFontOfSize:14];
    sweepQR.tag = 3;
    [sweepQR addTarget:self action:@selector(jumpConnect:) forControlEvents:UIControlEventTouchUpInside];
    [nextView addSubview:sweepQR];
    
    UIView *thirdline = [[UIView alloc] initWithFrame:CGRectMake(10, sweepQR.bottom, 100, 0.5)];
    thirdline.backgroundColor = [UIColor whiteColor];
    [nextView addSubview:thirdline];
    
    nextView.height = sweepQR.bottom;
    
}

- (void)jumpConnect:(UIButton *)btn
{
    if (btn.tag == 1) {

        NSLog(@"--------00" );
    }
    else if (btn.tag == 2) {

        NSLog(@"--------22" );
    }
    else if (btn.tag == 3) {

        NSLog(@"--------33" );
        
    }
    
}

//手势事件
- (void)tapAction
{
    self.btn.tag = 0;
    [self removeFromSuperview];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
