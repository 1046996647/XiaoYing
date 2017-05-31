//
//  AttendanceSignCell.h
//  XiaoYing
//
//  Created by ZWL on 16/1/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AttendanceSignModel;

@interface AttendanceSignCell : UITableViewCell

@property (nonatomic,strong) AttendanceSignModel *model;
@property (nonatomic,strong) UIButton *signBt;//点击签到按钮

@end
