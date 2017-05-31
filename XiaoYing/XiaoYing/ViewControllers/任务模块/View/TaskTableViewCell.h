//
//  TaskTableViewCell.h
//  XiaoYing
//
//  Created by ZWL on 15/10/12.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TaskItem;

@interface TaskTableViewCell : UITableViewCell

@property (nonatomic,retain)TaskItem *item;
 
@end
