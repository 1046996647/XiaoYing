//
//  CustomTabVC.m
//  XiaoYing
//
//  Created by ZWL on 15/10/21.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "CustomTabVC.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ReLoginViewController.h"
#import "XYNoteViewController.h"


#define count_ 4;
@interface CustomTabVC ()<UINavigationControllerDelegate>
{
    XYNoteViewController *login_VC1;
    ReLoginViewController *login_VC2;

    UINavigationController *nav1;
    UINavigationController *nav2;
    
    

}
@end

@implementation CustomTabVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
 

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    login_VC1=[[XYNoteViewController alloc]init];
    login_VC2=[[ReLoginViewController alloc]init];
    
    nav1 = [[UINavigationController alloc] initWithRootViewController:login_VC1];
    nav1.delegate = self;
    
    nav2 = [[UINavigationController alloc] initWithRootViewController:login_VC2];
    nav2.delegate = self;

    
   
    self.viewControllers = @[nav1,nav2];
    
    // 自定义标签栏
    [self initTabBarView];
    
 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 自定义标签栏
- (void)initTabBarView
{
    self.tabBar.hidden = YES;
    
    
    // 标签栏按钮
    // 2.创建自定标签栏
    _tabBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 49, kScreen_Width, 49)];
    _tabBarView.backgroundColor = [UIColor whiteColor];
    //    _tabBarView.image = [UIImage imageNamed:@"bg_tabbar@2x"];
    // 开始事件
    _tabBarView.userInteractionEnabled = YES;
    [self.view addSubview:_tabBarView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_tabBarView addSubview:lineView];
    
    // 4.创建标签按钮
    NSArray *normalImages = @[@"task_grey",
                              @"work_grey",
                              @"contact_grey",
                              @"set_grey"];
    
    NSArray *selectedImages = @[@"task_orange",
                                @"work_orange",
                                @"contact_orange",
                                @"set_orange"];

    
    NSArray *titles = @[@"便签",@"工作",@"联系人",@"设置"];
    
    // 获取按钮的宽度
    float itemWidth = kScreen_Width / normalImages.count;
    for (int i = 0; i < normalImages.count; i++) {
        // 创建按钮
        TabBarItem *barItem = [[TabBarItem alloc] initWithFrame:CGRectMake(i * itemWidth, 0, itemWidth, 49)];
        barItem.selected = YES;// 需开启才有用
        // 设置图片
        [barItem.imageBtn setImage:[UIImage imageNamed:normalImages[i]] forState:UIControlStateNormal];
        [barItem.imageBtn setImage:[UIImage imageNamed:selectedImages[i]] forState:UIControlStateSelected];

        barItem.title.text = titles[i];
        // 添加事件
        barItem.tag = i;
        [barItem addTarget:self action:@selector(barItemAction:) forControlEvents:UIControlEventTouchUpInside];
        // 添加到标签栏上
        [_tabBarView addSubview:barItem];
        
        if (i == 0) {
            barItem.imageBtn.selected = YES;
            barItem.title.textColor = [UIColor colorWithHexString:@"#f99740"];
            _lastItem = barItem;
        }
        
    }
    
}

#pragma mark - 标签按钮的事件
- (void)barItemAction:(TabBarItem *)tabBarItem
{
   
    
    //以下顺序不可乱
    _lastItem.imageBtn.selected = NO;
    _lastItem.title.textColor = [UIColor lightGrayColor];
    
    tabBarItem.imageBtn.selected = YES;
    tabBarItem.title.textColor = [UIColor colorWithHexString:@"#f99740"];
    
    if (tabBarItem.tag == 1) {
        login_VC2.title = @"工作";
    }
    
    if (tabBarItem.tag == 2) {
        login_VC2.title = @"联系人";
    }
    
    if (tabBarItem.tag == 3) {
        login_VC2.title = @"设置";
    }
    
    // 1.切换标签控制器显示的子视图控制器
    if (tabBarItem.tag == 0) {
        self.selectedIndex = tabBarItem.tag;

    }
    else {
        self.selectedIndex = 1;

    }
    
    // 上一个选项
    _lastItem = tabBarItem;
    
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSInteger count = navigationController.viewControllers.count;
    if (count > 1) {
        _tabBarView.hidden = YES;
    } else {
        _tabBarView.hidden = NO;

    }
}


@end
