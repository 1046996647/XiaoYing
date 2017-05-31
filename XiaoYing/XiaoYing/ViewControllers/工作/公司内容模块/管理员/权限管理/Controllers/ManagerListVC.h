//
//  ManagerListVC.h
//  XiaoYing
//
//  Created by ZWL on 16/1/18.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"

@interface ManagerListVC : BaseSettingViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSArray *departments;
@property (nonatomic, strong) NSMutableArray *ManagerProfileIdArray;

@end
