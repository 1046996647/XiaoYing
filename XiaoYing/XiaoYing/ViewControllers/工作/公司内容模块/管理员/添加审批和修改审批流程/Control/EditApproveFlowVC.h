//
//  EditApproveFlowVC.h
//  XiaoYing
//
//  Created by ZWL on 16/10/12.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^RefreshBlock)(void);

@interface EditApproveFlowVC : BaseSettingViewController

@property (nonatomic,copy) NSString *categoryID;
@property (nonatomic,copy) NSString *TypeId;

@property (nonatomic,copy) RefreshBlock refreshBlock;

@end
