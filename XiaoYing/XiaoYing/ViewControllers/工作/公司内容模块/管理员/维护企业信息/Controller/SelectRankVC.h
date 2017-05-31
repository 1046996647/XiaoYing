//
//  SelectRankVC.h
//  XiaoYing
//
//  Created by ZWL on 16/9/11.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^ClickBlock)(NSInteger);


@interface SelectRankVC : BaseSettingViewController

@property (nonatomic,copy) ClickBlock clickBlock;

@property (nonatomic,assign) NSInteger minRank;
@property (nonatomic,assign) NSInteger maxRank;

@end
