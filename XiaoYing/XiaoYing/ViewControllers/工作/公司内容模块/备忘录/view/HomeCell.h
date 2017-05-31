//
//  HomeCell.h
//  XiaoYing
//
//  Created by 王思齐 on 16/12/6.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendMemoryModel.h"

typedef void(^DeleteBlock)(SendMemoryModel *);


@interface HomeCell : UITableViewCell

@property (nonatomic,strong) UIView *baseView;


@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *contenLab;
@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,strong) SendMemoryModel *model;

@property (nonatomic,copy) DeleteBlock deleteBlock;

@end
