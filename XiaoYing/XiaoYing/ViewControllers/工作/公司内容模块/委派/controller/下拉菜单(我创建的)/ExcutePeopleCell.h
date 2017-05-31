//
//  ExcutePeopleCell.h
//  XiaoYing
//
//  Created by ZWL on 16/5/18.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExcutePeopleCell : UITableViewCell
{
    
    UILabel *_nameLab;
    UILabel *_personalLab;  //个性签名
    UIImageView *_markImg;
    UIImageView *_remindImg;
}

@property (nonatomic,strong) UIImageView *userImg;
@property (nonatomic,strong) UILabel *personal;
@property (nonatomic,strong) ProfileMyModel *profileModel;
@property (nonatomic,strong) UIButton *selectedControl;


@end
