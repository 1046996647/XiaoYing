//
//  SelectedPeopleVc.h
//  XiaoYing
//
//  Created by ZWL on 16/5/23.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^SendBlock)(NSMutableArray *);

@interface SelectedPeopleVC : BaseSettingViewController

@property (nonatomic,copy) SendBlock sendBlock;

// 选中的员工
@property (nonatomic, strong)NSMutableArray *selectedEmpArr;
@property (nonatomic,strong) NSArray *employees;
@property (nonatomic,strong) NSArray *friends;

// 选中的人
@property (nonatomic, strong)NSMutableArray *selectedArr;
@end
