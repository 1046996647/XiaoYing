//
//  BaseSettingViewController.m
//  XiaoYing
//
//  Created by ZWL on 15/12/16.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"

@interface BaseSettingViewController ()
{
    AppDelegate *app;
}

@end

@implementation BaseSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 使用UISearchController时，显示取消按钮那一栏
//    self.definesPresentationContext = YES;

//    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //返回按钮
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];// 加这个view为了限制点击的范围
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 30);
//    backButton.backgroundColor = [UIColor redColor];
    [backButton setImage:[UIImage imageNamed:@"Arrow-white"] forState:UIControlStateNormal];
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:backButton];
    self.backButton = backButton;
//    [self.navigationController.navigationBar addSubview:backButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
    
    //设置导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    
    //消除底部横线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //隐藏标签栏
    app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabvc hideCustomTabbar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.navigationController.viewControllers.count == 1) {
        
        [app.tabvc showCustomTabbar];
    }
    
}


#pragma mark - 返回按钮事件
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
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
