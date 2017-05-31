//
//  DetailTableViewCell.h
//  XiaoYing
//
//  Created by yinglaijinrong on 15/10/22.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectModel.h"

typedef void(^SendFriendBlock)(ConnectWithMyFriend *);


@interface DetailTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView * headerImage; // 头像
@property (nonatomic,strong) UILabel *countLab;

@property (nonatomic,strong) UIImageView * relationImage;
@property (nonatomic,strong) UILabel * nameLab; // 名字
@property (nonatomic,strong) NSString * requestCount; // 消息
@property (nonatomic,strong) UILabel * timeLab; // 时间
@property (nonatomic,strong) UIImageView * phoneImage; // 手机用户还是电脑
@property (nonatomic,strong) UIButton *selectedControl;


@property (nonatomic,strong) ConnectWithMyFriend *myfriend;
@property (nonatomic) NSInteger section;
@property (nonatomic,copy) SendFriendBlock sendFriendBlock;
// 单元格类型
@property (nonatomic,assign) NSInteger type;


@end
