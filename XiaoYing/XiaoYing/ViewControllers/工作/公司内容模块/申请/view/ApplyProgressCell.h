//
//  ApprovalProgressTableViewCell.h
//  XiaoYing
//
//  Created by ZWL on 15/12/25.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApprovalNodeModel.h"

@interface ApplyProgressCell : UITableViewCell

@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *imageBtn;

@property (nonatomic, strong) ApprovalNodeModel *approvalNodeModel;

@end
