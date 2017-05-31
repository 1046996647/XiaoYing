//
//  GroupNameSetyingVC.h
//  XiaoYing
//
//  Created by ZWL on 16/8/17.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "GroupListModel.h"

typedef void(^ClickBlock)(NSString *);


@interface GroupNameSettingVC : BaseSettingViewController

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) GroupListModel *model;

@property (nonatomic,copy) ClickBlock clickBlock;

@end
