//
//  ApproalPocessCell.h
//  XiaoYing
//
//  Created by YL20071 on 16/10/19.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApprovalPeopleModel;
#import "FlowModel.h"

@interface ApproalPocessCell : UITableViewCell

//@property (nonatomic, strong) ApprovalPeopleModel *approvalPeople;
@property(nonatomic,strong)FlowModel *flowModel;//流程模型
@property (nonatomic,strong) UIButton *voiceBtn;
@property (nonatomic,strong) UIButton *imageBtn;
@property(nonatomic,strong)NSArray *flowModels;//流程模型数组
@property(nonatomic,assign)NSInteger index;//当前属于流程中的第几层
@property(nonatomic,strong)NSDate *applyTime;//申请发出的时间
@property(nonatomic,assign)BOOL showComment;//是否显示审批意见
@end
