//
//  ApprovalHeaderView.h
//  XiaoYing
//
//  Created by ZWL on 15/12/25.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationMessageModel.h"

@interface ApplyHeaderView : UIView

@property (nonatomic, strong)ApplicationMessageModel *applicationMessageModel;

- (instancetype)initWithFrame:(CGRect)frame IsFinicial:(BOOL)isFinicial;

- (void)setApplicationMessageModel:(ApplicationMessageModel *)applicationMessageModel headerHeight:(void(^)(NSInteger headerHeight))headerHeight;

@end
