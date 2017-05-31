//
//  SettingCell.h
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/14.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "ProfileMyModel"

@interface SettingCell : UITableViewCell
{
    
    UILabel *_nameLab;
    UILabel *_personalLab;  //个性签名
    UIImageView *_markImg;
    UIButton *_codeBtn;
}

@property (nonatomic,strong) UIImageView *userImg;
@property (nonatomic,strong) UILabel *personal;
@property (nonatomic,strong) ProfileMyModel *profileModel;

@end
