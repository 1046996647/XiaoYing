//
//  GroupListCell.h
//  XiaoYing
//
//  Created by ZWL on 16/11/25.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupListModel.h"

@interface GroupListCell : UITableViewCell

@property (nonatomic,strong) UIImageView * headerImage; // 头像
@property (nonatomic,strong) UILabel * nameLab; // 名字
@property (nonatomic,strong) GroupListModel * model;


@end
