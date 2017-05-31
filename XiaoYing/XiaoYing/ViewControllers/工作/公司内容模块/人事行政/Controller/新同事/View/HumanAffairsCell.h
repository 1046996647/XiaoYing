//
//  HumanAffairsCell.h
//  XiaoYing
//
//  Created by MengFanBiao on 16/6/12.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewWorkersModel;


@interface HumanAffairsCell : UITableViewCell
{
    
    UILabel *_nameLab;
    UILabel *_Remark;
    UILabel *_StatusCN;
    UILabel *_personalLab;  //个性签名
    UIImageView *_markImg;
    UIImageView *_remindImg;
}

@property (nonatomic,strong) NSString *identifier;

@property (nonatomic,strong) UIImageView *userImg;
@property (nonatomic,strong) UILabel *personal;
@property (nonatomic,strong) ProfileMyModel *profileModel;
@property (nonatomic,strong) UIButton *selectedControl;



- (void)getModel:(NewWorkersModel *)model;


@end
