//
//  MulSelectPeopleVC.h
//  XiaoYing
//
//  Created by ZWL on 16/9/23.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"

@interface MulSelectPeopleVC : BaseSettingViewController

typedef void(^SendAllBlock)(NSMutableArray *, NSMutableArray *);

@property (nonatomic, copy)NSString *CompanyName;
@property (nonatomic, strong)NSNumber *CompanyRanks;

@property (nonatomic,strong) NSArray *departments;
@property (nonatomic,strong) NSArray *employees;

@property (nonatomic,strong) NSArray *subUnitArray;
@property (nonatomic,strong) NSArray *employeeArray;


@property (nonatomic, strong)NSMutableArray *selectedDepArr;
@property (nonatomic, strong)NSMutableArray *selectedEmpArr;

@property (nonatomic,copy) SendAllBlock sendAllBlock;

@end
