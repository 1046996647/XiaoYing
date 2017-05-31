//
//  ManageVC.h
//  XiaoYing
//
//  Created by ZWL on 16/1/13.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"

@interface ManageVC : BaseSettingViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)NSString *differentStr;

@end
