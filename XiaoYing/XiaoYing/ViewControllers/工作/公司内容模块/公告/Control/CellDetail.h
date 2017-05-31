//
//  CellDetail.h
//  XiaoYing
//
//  Created by MengFanBiao on 16/6/21.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"
#import "CompanyDetailModel.h"
@interface CellDetail : BaseSettingViewController
@property(nonatomic,copy)NSString *afficheid;
@property(nonatomic,assign)BOOL isSearch;//是从搜索界面跳过来的
@end
