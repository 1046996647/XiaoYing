//
//  OverheadInfoVC.h
//  XiaoYing
//
//  Created by ZWL on 16/8/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^ClickBlock)(NSString *);

@interface OverheadInfoVC : BaseSettingViewController

@property (nonatomic,strong) NSString *friendProfileId;
@property (nonatomic,copy) ClickBlock clickBlock;


@end
