//
//  AddFriendCell.h
//  XiaoYing
//
//  Created by ZWL on 16/8/17.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectModel.h"

@interface AddFriendCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImgView;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *emailLab;
@property (nonatomic,strong) UIButton *sexBtn;

@property (nonatomic,strong) ConnectWithMyFriend *model;


@end
