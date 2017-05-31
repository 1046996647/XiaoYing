//
//  NewMemorandumVC.h
//  XiaoYing
//
//  Created by 王思齐 on 16/12/6.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"

typedef void(^RefreshBlock)(void);


@interface NewMemorandumVC : BaseSettingViewController

@property (nonatomic,copy) RefreshBlock refreshBlock;


// 刷新表视图
- (void)refreshTableview;
@end
