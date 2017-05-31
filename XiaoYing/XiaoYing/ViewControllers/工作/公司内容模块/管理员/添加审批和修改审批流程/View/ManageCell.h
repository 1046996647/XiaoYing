//
//  ManageCell.h
//  XiaoYing
//
//  Created by ZWL on 16/4/26.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewApprovalModel.h"

typedef void(^DeleteBlock)(NewApprovalModel *);


@interface ManageCell : UITableViewCell

@property (nonatomic,strong) UIButton *selectedControl;
@property (nonatomic,strong) UIButton *editControl;
@property (nonatomic,assign) CheckType checkType;

@property (nonatomic,strong) NewApprovalModel *model;
@property (nonatomic, copy) DeleteBlock deleteBlock;


@end
