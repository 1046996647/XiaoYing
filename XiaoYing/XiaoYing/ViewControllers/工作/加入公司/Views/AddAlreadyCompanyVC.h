//
//  AddAlreadyCompanyVC.h
//  XiaoYing
//
//  Created by GZH on 16/8/11.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "BaseSettingViewController.h"


typedef void(^RequestSuccess)(NSString *requestSuccess);
@interface AddAlreadyCompanyVC : BaseSettingViewController

@property (nonatomic, strong)RequestSuccess requestSuccess;

@property (nonatomic, strong)NSString *refershOrNo;

@end
