//
//  SecurityManageMent.h
//  XiaoYing
//
//  Created by GZH on 16/8/10.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "BaseSettingViewController.h"
//typedef void(^BlockCreateCompany)(NSString *str);


@interface SecurityManageMent : BaseSettingViewController

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *stockholders;
@property (nonatomic, strong)NSString *mastPhones;
@property (nonatomic, strong)NSString *reservePhones;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSString *address;

@property (nonatomic, strong)NSString *string;

@property (nonatomic, strong)NSString *logoURL;
@property (nonatomic, strong)NSMutableArray *cardIDArray;
@property (nonatomic, strong)NSMutableArray *arrayDescriptionID;

//@property (nonatomic, copy)BlockCreateCompany blockCreateCompany;
@end
