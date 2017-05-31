//
//  ApproalCell.h
//  XiaoYing
//
//  Created by YL20071 on 16/10/19.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApprovalModel.h"

@interface ApproalCell : UITableViewCell

@property (nonatomic, strong) ApprovalModel *approvalModel;
@property(nonatomic,assign)BOOL overed;//是否是从已审批那边过来的

@end
