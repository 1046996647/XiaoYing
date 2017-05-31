//
//  ProcessVC.h
//  XiaoYing
//
//  Created by ZWL on 15/11/15.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"
#import "ApplyProgressTableView.h"

@interface ApplyProcessVC : BaseSettingViewController

@property (nonatomic, copy)NSString *applyRequestId;   //申请ID
@property (nonatomic, assign)NSInteger status;         //状态
@property (nonatomic, copy)NSString *statusDesc;       //状态描述说明
@property (nonatomic, strong)UIColor *statusDescColor; //状态描述说明的颜色
@property (nonatomic, copy)NSString *progress;         //总进度

@property (nonatomic, assign)BOOL showRevokeView;      //是否显示“撤销”
@property (nonatomic, assign)BOOL showBottomView;      //是否显示“重新申请，越级审批”

- (void)reloadTableView;

@end
