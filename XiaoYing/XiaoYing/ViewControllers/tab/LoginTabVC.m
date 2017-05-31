//
//  LoginTabVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "LoginTabVC.h"
#import "HomeViewController.h"
#import "ConnectViewController.h"
#import "AppliedViewController.h"
#import "SetViewController.h"
#import "XYNoteViewController.h"
#import "RCIM.h"

@interface LoginTabVC ()<UITabBarControllerDelegate>
{
    //控制器
    XYNoteViewController*main_VC;
    AppliedViewController *match_VC;
    SetViewController *love_VC;
    ConnectViewController *kind_VC;
    
    UINavigationController *nav1;
    UINavigationController *nav2;
    UINavigationController *nav3;
    UINavigationController *nav4;
    
    UITabBarItem *item1;
    UITabBarItem *item2;
    UITabBarItem *item3;
    UITabBarItem *item4;
}
@end

@implementation LoginTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.tabBar.backgroundColor = [UIColor whiteColor];
    // 背景色设置
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;

    
    main_VC = [[XYNoteViewController alloc] init];
    match_VC = [[AppliedViewController alloc] init];
    kind_VC = [[ConnectViewController alloc] init];
    love_VC = [[SetViewController alloc] init];
    
    nav1 = [[UINavigationController alloc] initWithRootViewController:main_VC];
    nav2 = [[UINavigationController alloc] initWithRootViewController:match_VC];
    nav3 = [[UINavigationController alloc] initWithRootViewController:kind_VC];
    nav4 = [[UINavigationController alloc] initWithRootViewController:love_VC];
    
    
    item1 = [[UITabBarItem alloc] initWithTitle:@"便签" image:[[UIImage imageNamed:@"task_grey"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    item2 = [[UITabBarItem alloc] initWithTitle:@"工作" image:[[UIImage imageNamed:@"work_grey"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]tag:1];
    item3 = [[UITabBarItem alloc] initWithTitle:@"联系人" image:[[UIImage imageNamed:@"contact_grey"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:2];
    item4 = [[UITabBarItem alloc] initWithTitle:@"设置" image:[[UIImage imageNamed:@"set_grey"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:3];
    item1.selectedImage = [[UIImage imageNamed:@"task_orange"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"work_orange"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"contact_orange"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.selectedImage = [[UIImage imageNamed:@"set_orange"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [item1 setTitleTextAttributes:[NSDictionary
                                   dictionaryWithObjectsAndKeys: [UIColor lightGrayColor],
                                   NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [item2 setTitleTextAttributes:[NSDictionary
                                   dictionaryWithObjectsAndKeys: [UIColor lightGrayColor],
                                   NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [item3 setTitleTextAttributes:[NSDictionary
                                   dictionaryWithObjectsAndKeys: [UIColor lightGrayColor],
                                   NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [item4 setTitleTextAttributes:[NSDictionary
                                   dictionaryWithObjectsAndKeys: [UIColor lightGrayColor],
                                   NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [item1 setTitleTextAttributes:[NSDictionary
                                   dictionaryWithObjectsAndKeys: [UIColor colorWithHexString:@"#f99740"],
                                   NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [item2 setTitleTextAttributes:[NSDictionary
                                   dictionaryWithObjectsAndKeys: [UIColor colorWithHexString:@"#f99740"],
                                   NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [item3 setTitleTextAttributes:[NSDictionary
                                   dictionaryWithObjectsAndKeys: [UIColor colorWithHexString:@"#f99740"],
                                   NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [item4 setTitleTextAttributes:[NSDictionary
                                   dictionaryWithObjectsAndKeys: [UIColor colorWithHexString:@"#f99740"],
                                   NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    nav1.tabBarItem = item1;
    nav2.tabBarItem = item2;
    nav3.tabBarItem = item3;
    nav4.tabBarItem = item4;
    self.viewControllers = @[nav1,nav2,nav3,nav4];
    
    self.delegate = self;

    [self checkMessage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkMessage) name:@"MESSAGECOUNT" object:nil];
    
}

-(void)checkMessage {
    
    NSInteger messageCount = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
    NSString *countStr = nil;
    
    //检测消息的个数
    if (messageCount <= 0) {
        countStr = nil;
    }else if (messageCount>99){
        countStr = @"...";
    }else{
        
        countStr = [NSString stringWithFormat:@"%ld",(long)messageCount];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        item3.badgeValue = countStr;

    });
    
    
}


//显示tabbar
- (void)showCustomTabbar
{
    self.tabBar.hidden = NO;
}
//隐藏tabbar
- (void)hideCustomTabbar
{
    self.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kConversionListShow" object:nil];
}





@end
