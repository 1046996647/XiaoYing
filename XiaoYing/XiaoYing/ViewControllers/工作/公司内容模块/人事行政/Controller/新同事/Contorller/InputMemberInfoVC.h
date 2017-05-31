//
//  InputMemberIinfo.h
//  XiaoYing
//
//  Created by MengFanBiao on 16/6/28.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^ValueBlock)(NSString *str);

@interface InputMemberInfoVC : BaseSettingViewController

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) ValueBlock valueBlock;

@property (nonatomic, strong) NSString *DetailOfCell;


@end
