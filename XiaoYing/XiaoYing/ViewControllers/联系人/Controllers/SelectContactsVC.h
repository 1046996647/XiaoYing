//
//  SelectContactsVC.h
//  XiaoYing
//
//  Created by ZWL on 16/11/23.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^AddMember)(NSArray *array);


@interface SelectContactsVC : BaseSettingViewController

// 群组成员id
@property (nonatomic, strong)NSMutableArray *iDArr;
@property (nonatomic, copy) AddMember addMember;


@end
