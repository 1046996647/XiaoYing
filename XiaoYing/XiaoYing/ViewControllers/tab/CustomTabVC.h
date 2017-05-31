//
//  CustomTabVC.h
//  XiaoYing
//
//  Created by ZWL on 15/10/21.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarItem.h"

@interface CustomTabVC : UITabBarController

@property (nonatomic,retain)UIImageView *tabBarView;
@property (nonatomic,retain)TabBarItem *lastItem;          //上一个底部控件


@end
