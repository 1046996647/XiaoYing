//
//  NewMemoryTableView.h
//  XiaoYing
//
//  Created by GZH on 16/10/4.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"



typedef void(^RefreshBlock)(void);

@interface NewMemoryTableView : UIView

@property (nonatomic,copy) RefreshBlock refreshBlock;

@property (nonatomic, strong) NSMutableArray *modelArr;

@property(nonatomic,strong)UITableView *tableView;

// 刷新表视图
- (void)refreshTableview;


@end










