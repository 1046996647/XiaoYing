//
//  FriendRequestCell.h
//  XiaoYing
//
//  Created by ZWL on 16/10/26.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddFriendModel.h"

typedef void(^RequestBlock)(void);


@interface FriendRequestCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImgView;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *decLab;
@property (nonatomic,strong) UIButton *stateBtn;
@property (nonatomic,strong) UIView *baseView;

@property (nonatomic,strong) AddFriendModel *model;
@property (nonatomic,copy)  RequestBlock requestBlock;

@end
