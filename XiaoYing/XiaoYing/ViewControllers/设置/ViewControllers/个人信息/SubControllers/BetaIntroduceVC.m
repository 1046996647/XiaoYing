//
//  BetaIntroduceVC.m
//  XiaoYing
//
//  Created by YL20071 on 16/11/2.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BetaIntroduceVC.h"

@interface BetaIntroduceVC ()

@end

@implementation BetaIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNavi];
    //界面布局
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置导航栏 methods
-(void)setNavi{
    self.title = @"新版本介绍";
}

#pragma mark - 界面布局 methods
-(void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"banben"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    [self.view addSubview:imageView];
}

@end
