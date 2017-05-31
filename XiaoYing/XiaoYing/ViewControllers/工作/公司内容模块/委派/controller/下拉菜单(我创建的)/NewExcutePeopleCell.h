//
//  NewExcutePeopleCell.h
//  XiaoYing
//
//  Created by ZWL on 16/5/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectPeopleModel.h"


@interface NewExcutePeopleCell : UITableViewCell
{
    
    UILabel *_nameLab;
    UILabel *_personalLab;  //个性签名
    UIImageView *_markImg;
    UIImageView *_remindImg;
}

@property (nonatomic,strong) NSString *identifier;

@property (nonatomic,strong) UIImageView *userImg;
@property (nonatomic,strong) UILabel *personal;
@property (nonatomic,strong) SelectPeopleModel *model;
@property (nonatomic,strong) UIButton *selectedControl;

// 假数据
//@property (nonatomic,strong) NSString *title;

@end
