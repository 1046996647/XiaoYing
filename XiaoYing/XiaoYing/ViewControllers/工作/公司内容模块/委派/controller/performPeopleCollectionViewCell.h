//
//  performPeopleCollectionViewCell.h
//  XiaoYing
//
//  Created by Li_Xun on 16/5/11.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface performPeopleCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *performPeopleImage;          //执行人头像
@property (strong, nonatomic) UILabel *performPeopleName;               //执行人名称
@property (strong, nonatomic) UILabel *statePrompt;                     //完成人的完成状态

-(instancetype)initWithFrame:(CGRect)frame;

@end
