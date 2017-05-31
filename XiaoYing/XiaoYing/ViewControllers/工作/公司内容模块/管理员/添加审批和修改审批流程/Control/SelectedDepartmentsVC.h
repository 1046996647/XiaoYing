//
//  SelectedDepartmentsVC.h
//  XiaoYing
//
//  Created by ZWL on 16/9/22.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^SendBlock)(NSMutableArray *);


@interface SelectedDepartmentsVC : BaseSettingViewController

@property (nonatomic, strong)NSMutableArray *selectedArr;
@property (nonatomic,strong) NSArray *departments;
@property (nonatomic, copy)NSString *CompanyName;


@property (nonatomic,copy) SendBlock sendBlock;

@end
