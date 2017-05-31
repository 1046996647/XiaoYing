//
//  DelegateTableViewCell.m
//  XiaoYing
//
//  Created by Li_Xun on 16/5/9.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DelegateTableViewCell.h"

@implementation DelegateTableViewCell
@synthesize delegateTitle,delegatePeopleTitle,delegatePeopleName,performPeopleTitle,performPeopleName,timeTitle,timeDetails,progressTitle,progressImage,discussionGroups,unreadMessages;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initialization];
    return self;
    
}

#pragma  mark - 初始化
-(void)initialization
{
    delegateTitle = [[UILabel alloc]init];
    delegateTitle.font = [UIFont systemFontOfSize:14];
//    delegateTitle.backgroundColor = [UIColor redColor];
    [self addSubview:delegateTitle];
    [self adapter:delegateTitle left:12 top:10 width:120 heigth:14];
    
    
    progressImage = [[UIImageView alloc]init];
    [self addSubview:progressImage];
    [self adapter:progressImage left:12 top:31 width:296 heigth:4];
    
    delegatePeopleTitle = [[UILabel alloc]init];
    delegatePeopleTitle.text = @"委派人 :";
    delegatePeopleTitle.font = [UIFont systemFontOfSize:12];
    delegatePeopleTitle.textColor = [UIColor colorWithHexString:@"#848484"];
//    delegatePeopleTitle.backgroundColor = [UIColor redColor];
    [self addSubview:delegatePeopleTitle];
    [self adapter:delegatePeopleTitle left:12 top:42 width:43 heigth:12];
    
    delegatePeopleName = [[UILabel alloc]init];
    delegatePeopleName.font = [UIFont systemFontOfSize:12];
    delegatePeopleName.textColor = [UIColor colorWithHexString:@"#848484"];
//    delegatePeopleName.backgroundColor = [UIColor redColor];
    [self addSubview:delegatePeopleName];
    [self adapter:delegatePeopleName left:55 top:42 width:130 heigth:12];
    
    performPeopleTitle = [[UILabel alloc]init];
    performPeopleTitle.text = @"执行人 :";
    performPeopleTitle.font = [UIFont systemFontOfSize:12];
    performPeopleTitle.textColor = [UIColor colorWithHexString:@"#848484"];
//    performPeopleTitle.backgroundColor = [UIColor redColor];
    [self addSubview:performPeopleTitle];
    [self adapter:performPeopleTitle left:12 top:60 width:43 heigth:12];
    
    performPeopleName = [[UILabel alloc]init];
    performPeopleName.font = [UIFont systemFontOfSize:12];
    performPeopleName.textColor = [UIColor colorWithHexString:@"#848484"];
//    performPeopleName.backgroundColor = [UIColor redColor];
    [self addSubview:performPeopleName];
    [self adapter:performPeopleName left:55 top:60 width:150 heigth:12];
    
    timeTitle = [[UILabel alloc]init];
    timeTitle.text = @"时   间 :";
    timeTitle.font = [UIFont systemFontOfSize:12];
    timeTitle.textColor = [UIColor colorWithHexString:@"#848484"];
//    timeTitle.backgroundColor = [UIColor redColor];
    [self addSubview:timeTitle];
    [self adapter:timeTitle left:12 top:78 width:43 heigth:12];
    
    timeDetails = [[UILabel alloc]init];
    timeDetails.font = [UIFont systemFontOfSize:12];
    timeDetails.textColor = [UIColor colorWithHexString:@"#848484"];
//    timeDetails.backgroundColor = [UIColor redColor];
    [self addSubview:timeDetails];
    [self adapter:timeDetails left:55 top:78 width:150 heigth:12];
    
    progressTitle = [[UILabel alloc]init];
    progressTitle.font = [UIFont systemFontOfSize:12];
    progressTitle.textAlignment = NSTextAlignmentRight;
//    progressTitle.backgroundColor = [UIColor redColor];
    [self addSubview:progressTitle];
    [self adapter:progressTitle left:188 top:11 width:120 heigth:12];
    
    discussionGroups = [[UIButton alloc]init];
//    discussionGroups.backgroundColor = [UIColor redColor];
    [discussionGroups setTitle:@"讨论组" forState:UIControlStateNormal];
    discussionGroups.titleLabel.font = [UIFont systemFontOfSize:14];
    discussionGroups.layer.masksToBounds =YES;
    discussionGroups.layer.cornerRadius = 5;
    [self addSubview:discussionGroups];
    [self adapter:discussionGroups left:210 top:42 width:98 heigth:47];
    
    unreadMessages = [[UIButton alloc]initWithFrame:CGRectMake(62*scaleX, 7*scaleY, 13*scaleX, 13*scaleY)];
    unreadMessages.titleLabel.font = [UIFont systemFontOfSize:10];
    unreadMessages.layer.masksToBounds =YES;
    unreadMessages.layer.cornerRadius = 6.5;
    [discussionGroups addSubview:unreadMessages];
//    [self adapter:unreadMessages left:60 top:7 width:17 heigth:17];
    
}

#pragma mark - 适配器
-(void)adapter:(id)childview left:(CGFloat)lwidth top:(CGFloat)theight width:(CGFloat)width heigth:(CGFloat)heigth
{
    [childview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lwidth*scaleX);
        make.top.mas_equalTo(theight*scaleY);
        make.size.mas_equalTo(CGSizeMake(width*scaleX, heigth*scaleY));
    }];
}

@end
