//
//  ImageBrowseController.m
//  XiaoYing
//
//  Created by yinglaijinrong on 16/1/11.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "ImageBrowseController.h"

@interface ImageBrowseController ()


@end

@implementation ImageBrowseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    //让UIImageView位置不随导航栏的隐藏而变化
    self.navigationController.navigationBar.translucent = YES;
    
    //使用按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 20);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"使用" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(useAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    //图片
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = self.img;
//    imgView.image = [UIImage imageNamed:@"test"];
    [self.view addSubview:imgView];
}

- (void)useAction
{
    if ([self.delegate respondsToSelector:@selector(dismiss)]) {
        [self.delegate dismiss];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //隐藏状态栏
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
    
    //隐藏电池条（在plist文件中，加入View controller-based status bar appearance项，并设置为NO。）
    [[UIApplication sharedApplication] setStatusBarHidden:self.navigationController.navigationBarHidden withAnimation:UIStatusBarAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
