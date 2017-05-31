//
//  NewApproveFlowVC.h
//  XiaoYing
//
//  Created by ZWL on 16/4/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^RefreshBlock)(void);


@interface NewApproveFlowVC : BaseSettingViewController

@property (nonatomic,copy) NSString *categoryID;

@property (nonatomic,copy) RefreshBlock refreshBlock;


@end
