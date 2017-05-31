//
//  GroupListSettingVC.h
//  XiaoYing
//
//  Created by ZWL on 16/8/16.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "GroupListModel.h"


@interface GroupListSettingVC : BaseSettingViewController

@property (nonatomic,copy) NSString *targetId;


@property (nonatomic,strong) GroupListModel *model;
@property (nonatomic,strong) NSMutableArray *memberListArr;
// 群组成员id
@property (nonatomic, strong)NSMutableArray *iDArr;



@end
