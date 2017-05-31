//
//  HeadView.h
//  XiaoYing
//
//  Created by yinglaijinrong on 16/6/6.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@interface HeadView : UITableViewHeaderFooterView

@property (strong,nonatomic) UIButton * clickBut; // 点击按钮
@property (strong,nonatomic) UILabel *headNameLab; // 头像
@property (strong,nonatomic) UIImageView *headImageview; // 头像按钮

-(void)openAnimate:(NSString *)flag;

@end
