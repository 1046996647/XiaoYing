//
//  ApproalProcessVC.h
//  XiaoYing
//
//  Created by ZWL on 16/6/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "BaseSettingViewController.h"
typedef void(^ApproalBlock) (void);
@interface ApproalProcessVC : BaseSettingViewController
- (void)reloadTableView;
@property(nonatomic,strong)NSString *applyRequestID;
@property(nonatomic,copy)ApproalBlock approalBlock;
@property(nonatomic,copy)NSString *progress;//审批进度
@property(nonatomic,copy)NSString *statusDesc;//审批状态说明
@property(nonatomic,assign)NSInteger state;//审批状态
@property(nonatomic,assign)BOOL isOver;//我的审批状态已经结束
@property(nonatomic,assign)BOOL overed;
@property(nonatomic,assign)NSInteger useTime;//使用时间
@property(nonatomic,assign)BOOL isSearching;//是否是从搜索界面跳转
@property(nonatomic,strong)NSArray *applyRevokes;//申请撤销数组
@property(nonatomic,assign)BOOL isAffiche;//是否是公告
@end
