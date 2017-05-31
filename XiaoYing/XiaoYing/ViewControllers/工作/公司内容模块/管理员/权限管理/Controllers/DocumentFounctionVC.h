//
//  DocumentFounctionVC.h
//  XiaoYing
//
//  Created by GZH on 2017/1/6.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^BlockArray)(NSMutableArray *array, NSMutableArray *array1);

@interface DocumentFounctionVC : BaseSettingViewController

@property (nonatomic, strong)NSMutableArray *tempDataSource;
@property (nonatomic, strong)NSMutableArray *selectedDataSource;

@property (nonatomic, copy)BlockArray blockArray;

@end
