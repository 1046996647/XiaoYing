//
//  DelegateDetailsViewController.h
//  XiaoYing
//
//  Created by Li_Xun on 16/5/10.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"
#import "DelegateDetailsTableView.h"

@interface DelegateDetailsViewController : BaseSettingViewController

@property(nonatomic, strong) DelegateDetailsTableView *tabView;     //表格视图
@property(nonatomic, strong) UIButton *rightBtn;                    //自定义右导航栏
@property(nonatomic, assign) NSInteger markInt;                    //标记



@end
