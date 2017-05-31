//
//  RemarkVC.h
//  XiaoYing
//
//  Created by ZWL on 16/12/20.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "ConnectModel.h"

typedef void(^ClickBlock)(NSString *);

@interface RemarkVC : BaseSettingViewController

@property (nonatomic,strong) NSString *text;

@property (nonatomic,strong) NSString *profileId;

@property (nonatomic,copy) ClickBlock clickBlock;


@end
