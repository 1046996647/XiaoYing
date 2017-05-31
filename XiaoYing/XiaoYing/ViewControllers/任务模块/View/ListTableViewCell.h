//
//  ListTableViewCell.h
//  XiaoYing
//
//  Created by ZWL on 15/10/12.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class taskModel;
@interface ListTableViewCell : UITableViewCell
@property (nonatomic,copy)UIButton *ListBt;
@property (nonatomic,copy)UIButton *StateBt;
@property (nonatomic,copy)UIButton *StateBt1;
@property (nonatomic,copy)UIButton *StateBt2;
@property (nonatomic,copy)UILabel *TitleLab_;
@property (nonatomic,copy)UILabel *TimeLab_;
@property (nonatomic,copy)UIButton *FinishBt;


@property (nonatomic,retain)taskModel *model;
@end
