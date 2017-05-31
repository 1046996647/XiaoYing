//
//  PushViewOfSecretManageView.m
//  XiaoYing
//
//  Created by GZH on 16/8/11.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "PushViewOfSecretManageView.h"
#import "ManageVC.h"
#import "AppliedViewController.h"

@interface PushViewOfSecretManageView ()

@property (nonatomic, strong)UIView *coverView;
@property (nonatomic, strong)UIView *littleView;

@end

@implementation PushViewOfSecretManageView

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
    
    _littleView = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width - 270) / 2, (kScreen_Height - 300) / 2, 270 , 100 + 32)];
    _littleView.backgroundColor = [UIColor whiteColor];
    _littleView.layer.cornerRadius = 5;
    _littleView.clipsToBounds = YES;
    [window addSubview:_littleView];
    
    _upLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, _littleView.width - 12 * 2, _littleView.height - 12 - 44 - .5)];
    _upLabel.numberOfLines = 3;
    _upLabel.font = [UIFont systemFontOfSize:16];
    _upLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _upLabel.textAlignment = NSTextAlignmentCenter;
    [_littleView addSubview:_upLabel];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100  + 32 - 44, 270, 0.5)];
    label.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_littleView addSubview:label];
    
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
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(_littleView.width/2 - 0.25, _littleView.height - 44, .5, 44)];
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
        ManageVC *manageVC = [[ManageVC alloc] init];
        manageVC.differentStr = @"qwert";
        [self.viewController.navigationController pushViewController:manageVC animated:YES];
        
    }else {
        [self coverBackAction];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GoBackOfCreateCompany" object:nil];
        AppliedViewController *applyVC = [[AppliedViewController alloc]init];
        for (UIViewController *viewController in self.viewController.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[applyVC class]]) {
                 [self.viewController.navigationController popToViewController:viewController animated:YES];
            }
        }
    }
}








- (void)coverBackAction {
    [_coverView removeFromSuperview];
    [_littleView removeFromSuperview];
}





@end
