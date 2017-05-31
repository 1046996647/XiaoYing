//
//  CreateCompanyVC.h
//  XiaoYing
//
//  Created by GZH on 16/8/22.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "BaseSettingViewController.h"


//回调请求回来数据中的ID
typedef void(^BlockValue)(NSString *strID);


@interface CreateCompanyVC : BaseSettingViewController

@property (nonatomic, strong)NSString *nameTemp;
@property (nonatomic, strong)NSString *stockholders;
@property (nonatomic, strong)NSString *mastPhones;
@property (nonatomic, strong)NSString *reservePhones;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong)NSMutableArray *arrayDescriptionID;
@property (nonatomic, strong)NSMutableArray *arrayDescriptionTitle;



@end
