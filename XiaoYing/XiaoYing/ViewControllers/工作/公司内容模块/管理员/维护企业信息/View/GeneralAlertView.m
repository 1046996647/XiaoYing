//
//  GeneralAlertView.m
//  XiaoYing
//
//  Created by GZH on 16/8/28.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "GeneralAlertView.h"

@interface GeneralAlertView ()

@property (nonatomic, strong)UIView *coverView;
@property (nonatomic, strong)UIView *littleView;

@end

@implementation GeneralAlertView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
    }
    return self;
}


- (void)initView {
    _coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.4;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_coverView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverBackAction)];
    [_coverView addGestureRecognizer:tap];
    
    _littleView = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width - 270) / 2, (kScreen_Height - 300) / 2, 270 , 100)];
    _littleView.backgroundColor = [UIColor whiteColor];
    _littleView.layer.cornerRadius = 5;
    _littleView.clipsToBounds = YES;
    [window addSubview:_littleView];
    
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.frame = CGRectMake(16, 15, _littleView.width-16*2, _littleView.height - 15 - 44 - .5);
    lab.text = @"是否确定重新添加子公司?";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_littleView addSubview:lab];

    NSArray *titleArr = @[@"确定", @"取消"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(_littleView.width/2.0), _littleView.height-44, _littleView.width/2.0, 44);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_littleView addSubview:btn];
    }
    
    //竖分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(_littleView.width/2 - 0.5, _littleView.height - 44, .5, 44)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_littleView addSubview:lineView2];
    
    //横分割线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _littleView.frame.size.height - 44, _littleView.width, .5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_littleView addSubview:lineView1];
    
    
    
}




- (void)btnAction:(UIButton *)sender {
    if (sender.tag == 0) {
        [self coverBackAction];
        [self.viewController.navigationController popViewControllerAnimated:YES];
        
    }else {
        [self coverBackAction];
    }
}


- (void)coverBackAction {
    [_coverView removeFromSuperview];
    [_littleView removeFromSuperview];
}



@end
