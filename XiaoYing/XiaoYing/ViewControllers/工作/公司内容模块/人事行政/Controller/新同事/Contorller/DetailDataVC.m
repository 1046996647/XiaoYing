//
//  DetailDataVC.m
//  XiaoYing
//
//  Created by GZH on 16/9/28.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "DetailDataVC.h"
#import "InviteNewStuView.h"

@implementation DetailDataVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI {
    InviteNewStuView *inviteView = [[InviteNewStuView alloc]initWithFrame:CGRectMake(0, 25, kScreen_Width, kScreen_Height - 100)];
    [self.view addSubview:inviteView];

}

@end
