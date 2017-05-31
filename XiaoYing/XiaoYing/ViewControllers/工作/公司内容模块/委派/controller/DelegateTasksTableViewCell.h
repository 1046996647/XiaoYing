//
//  DelegateTasksTableViewCell.h
//  XiaoYing
//
//  Created by Li_Xun on 16/5/11.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DelegateTasksTableViewCell : UITableViewCell

@property(nonatomic, strong) UIView *backgroundview;                //背景视图
@property(nonatomic, strong) UILabel *stateLabel;                   //状态
@property(nonatomic, strong) UILabel *numberLabel;                  //任务数量
@property(nonatomic, strong) UILabel *titleLabel;                   //标题
@property(nonatomic, strong) UILabel *tasksDetailsLabel;            //任务详情
@property(nonatomic, strong) UILabel *proportionLabel;              //任务比
@property(nonatomic, strong) NSTimer *time;                         //无用
@property(nonatomic, strong) UIButton *performPeopleImage;       //任务人头像
@property(nonatomic, strong) UILabel *statePrompt;              //任务的完成状态

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
