//
//  PersonalpermissionVC.h
//  XiaoYing
//
//  Created by GZH on 16/9/22.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "BaseSettingViewController.h"
//人事管理里边获得的权限的model 数组, 人事管理里边未获得的权限的model 数组, 人事管理权限的ID
typedef void(^PassWord)(NSMutableArray *array, NSMutableArray *array1, NSMutableArray *array2);


@interface PersonalpermissionVC : BaseSettingViewController

@property (nonatomic, copy) PassWord passWord;


@property (nonatomic, strong)NSMutableArray *persissionNetArray;

@property (nonatomic, strong)NSMutableArray *modelOfAlreadyArray;  //上一个界面传过来的获得的权限
@property (nonatomic, strong)NSMutableArray *idOfAlreadyarray;  //上一个界面传过来获得的权限的ID



@end
