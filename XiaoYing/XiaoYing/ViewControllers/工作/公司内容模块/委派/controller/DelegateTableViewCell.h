//
//  DelegateTableViewCell.h
//  XiaoYing
//
//  Created by Li_Xun on 16/5/9.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DelegateTableViewCell : UITableViewCell

@property(strong,nonatomic) UILabel *delegateTitle;                     //委派标题
@property(strong,nonatomic) UILabel *delegatePeopleTitle;               //委派人标题
@property(strong,nonatomic) UILabel *delegatePeopleName;                //委派人姓名
@property(strong,nonatomic) UILabel *performPeopleTitle;                //执行人标题
@property(strong,nonatomic) UILabel *performPeopleName;                 //执行人姓名
@property(strong,nonatomic) UILabel *timeTitle;                         //时间标题
@property(strong,nonatomic) UILabel *timeDetails;                       //时间详情
@property(strong,nonatomic) UILabel *progressTitle;                     //进度标题
@property(strong,nonatomic) UIImageView *progressImage;                 //进度条
@property(strong,nonatomic) UIButton *discussionGroups;                 //讨论组
@property(strong,nonatomic) UIButton *unreadMessages;                   //未读消息提示


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
