//
//  PersonCenteVC.h
//  XiaoYing
//
//  Created by ZWL on 15/11/23.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"
@class PersonCenterModel;
@class ProfileMyModel;
@class ProfileCompanyModel;

@interface PersonCenteVC : BaseSettingViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic,retain)ProfileMyModel * mymodel;
@property (nonatomic,retain)ProfileCompanyModel *companymodel;
@end
