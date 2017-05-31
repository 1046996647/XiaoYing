//
//  ApproalHeaderView.h
//  XiaoYing
//
//  Created by YL20071 on 16/10/19.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApproalDetailModel.h"
@interface ApproalHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame IsFinicial:(BOOL)isFinicial;

@property (nonatomic,strong) UIButton *voiceBtn;
@property (nonatomic,strong) UIButton *imageBtn;
@property(nonatomic,strong)ApproalDetailModel *detailModel;
@property(nonatomic,copy)NSString *progress;//进度
@property(nonatomic,copy)NSString *statusDesc;//状态说明
@property(nonatomic,assign)BOOL overed;//审批是否已完成
@property(nonatomic,assign)NSInteger useTime;//用时
@property(nonatomic,assign)BOOL isAffiche;//是否是公告
@end
