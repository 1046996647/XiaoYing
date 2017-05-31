//
//  XYNewWorkerPermissionViewController.h
//  XiaoYing
//
//  Created by qj－shanwen on 16/7/23.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"

@interface XYNewWorkerPermissionViewController : BaseSettingViewController

@property (nonatomic, strong)NSString *licenseNumber;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *gender;
@property (nonatomic, strong)NSString *mobile;
@property (nonatomic, strong)NSString *birthday;
@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong)NSString *status;
@property (nonatomic, strong)NSString *memo;
@property (nonatomic, strong)NSString *employeeNo;
@property (nonatomic, strong)NSString *faceUrl;
@property (nonatomic, strong)NSString *licenseCarFrontUrl;
@property (nonatomic, strong)NSString *licenseCarBackUrl;
@property (nonatomic, strong)NSString *joinId;
@property (nonatomic, strong)NSString *departmentId;
@property (nonatomic, strong)NSString *companyJobId;

@property (nonatomic, strong)NSMutableArray *idOfAlreadyArray;


 @property (nonatomic, strong) NSString *ManagerProfileId;

@end
