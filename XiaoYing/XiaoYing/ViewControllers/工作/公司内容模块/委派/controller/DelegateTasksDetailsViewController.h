//
//  DelegateTasksDetailsViewController.h
//  XiaoYing
//
//  Created by Li_Xun on 16/5/12.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"

@interface DelegateTasksDetailsViewController : BaseSettingViewController

@property (nonatomic,strong) UICollectionView *CV;                          //集合视图
@property(nonatomic, strong) UITableView *tabView;                          //表格视图
@property (nonatomic,strong) UILabel *tasksTitle;                           //任务标题
@property (nonatomic,strong) UILabel *proportionTitle;                      //任务比
@property (nonatomic,strong) UILabel *completePeopleCollection;             //完成人集合
@property (nonatomic,strong) UILabel *stateTitle;                           //任务状态
@property (nonatomic,strong) UILabel *progressTitle;                        //进度标题
@property (nonatomic,strong) UIButton *scalingBtn;                          //展开收起按钮
@property (nonatomic,strong) UILabel *taskDetailsTitle;                     //任务详情
@property (nonatomic,strong) UIImageView *line;                             //线
@property (nonatomic,strong) UILabel *taskContent;                          //任务内容
@property (nonatomic,strong) UIView *tailView;                              //尾视图
@end
