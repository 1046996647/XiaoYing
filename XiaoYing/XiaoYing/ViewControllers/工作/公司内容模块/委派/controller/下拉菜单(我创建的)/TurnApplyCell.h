//
//  TurnApplyCell.h
//  XiaoYing
//
//  Created by ZWL on 16/5/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TurnApplyCell : UITableViewCell
{
    
    UILabel *_nameLab;
    UILabel *_personalLab;  //个性签名
    UIImageView *_markImg;
    UIImageView *_remindImg;
}

@property (nonatomic,strong) UIImageView *userImg;
@property (nonatomic,strong) UILabel *personalLab;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) ProfileMyModel *profileModel;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *applyTypeLab;

// 假数据
@property (nonatomic,copy) NSString *applyTypeStr;

@end
