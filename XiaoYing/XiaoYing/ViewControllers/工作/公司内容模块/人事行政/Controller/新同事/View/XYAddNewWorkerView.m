//
//  XYAddNewWorkerView.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/7/22.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "XYAddNewWorkerView.h"
#import "InviteNewStuVC.h"
#import "ScanOfNewStuVC.h"

@implementation XYAddNewWorkerView

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
    UIView *nextView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width-130,0.5, 120, 122)];
    nextView.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [self addSubview:nextView];
    
    UIButton *shareQR = [UIButton buttonWithType:UIButtonTypeCustom];
    shareQR.frame = CGRectMake(0, 0, 120, 40);
    [shareQR setTitle:@"小赢号添加" forState:UIControlStateNormal];
    [shareQR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareQR.titleLabel.font = [UIFont systemFontOfSize:14];
    shareQR.tag = 1;
    [shareQR addTarget:self action:@selector(jumpConnect:) forControlEvents:UIControlEventTouchUpInside];
    [nextView addSubview:shareQR];
    
    UIView *firstline = [[UIView alloc] initWithFrame:CGRectMake(0, 40, nextView.width, 0.5)];
    firstline.backgroundColor = [UIColor whiteColor];
    [nextView addSubview:firstline];
    
//    UIButton *keepQR = [UIButton buttonWithType:UIButtonTypeCustom];
//    keepQR.frame = CGRectMake(0, 40.5 , 120, 40);
//    [keepQR setTitle:@"扫一扫" forState:UIControlStateNormal];
//    [keepQR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    keepQR.titleLabel.font = [UIFont systemFontOfSize:14];
//    keepQR.tag = 2;
//    [keepQR addTarget:self action:@selector(jumpConnect:) forControlEvents:UIControlEventTouchUpInside];
//    [nextView addSubview:keepQR];
//    
    nextView.height = shareQR.bottom;
    
}

- (void)jumpConnect:(UIButton *)btn
{
    if (btn.tag == 1) {
        
        InviteNewStuVC *inviteVC = [[InviteNewStuVC alloc]init];
        [self.viewController.navigationController pushViewController:inviteVC animated:YES];
        
    }
    else if (btn.tag == 2) {
        ScanOfNewStuVC *scanVC = [[ScanOfNewStuVC alloc]init];
        [self.viewController.navigationController pushViewController:scanVC animated:YES];
    }
    
}

//手势事件
- (void)tapAction
{
    self.btn.tag = 0;
    [self removeFromSuperview];
}



@end
