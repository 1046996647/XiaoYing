//
//  PolicyVC.m
//  XiaoYing
//
//  Created by YL20071 on 16/11/2.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "PolicyVC.h"

@interface PolicyVC ()
{
    UIScrollView *_scrollview;
    UIImageView *_imageview;
}
@end

@implementation PolicyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航控制器
    [self setNavi];
    //界面布局
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置导航控制器 methods
-(void)setNavi{
    self.title = @"服务协议";
}

#pragma mark - 界面布局 methods
-(void)initUI{
    //1添加 UIScrollView
    //设置 UIScrollView的位置与屏幕大小相同
    _scrollview=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollview.bounces = NO;
    _scrollview.showsVerticalScrollIndicator = NO;
    //_scrollview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollview];
    
    //2添加图片
    UIImage *image = [UIImage imageNamed:@"小赢计划服务条款(1)"];
    _imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, image.size.height)];
    _imageview.image = image;
    _imageview.userInteractionEnabled = YES;
    _imageview.backgroundColor = [UIColor whiteColor];
    _imageview.contentMode = UIViewContentModeScaleToFill;
    //调用initWithImage:方法，它创建出来的imageview的宽高和图片的宽高一样
    [_scrollview addSubview:_imageview];
    
    //设置UIScrollView的滚动范围和图片的真实尺寸一致
    _scrollview.contentSize = CGSizeMake(kScreen_Width, _imageview.bottom + 50);
}



@end
