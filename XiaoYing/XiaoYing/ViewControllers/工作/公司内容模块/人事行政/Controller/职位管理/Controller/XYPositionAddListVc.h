//
//  XYPositionAddListVc.h
//  XiaoYing
//
//  Created by qj－shanwen on 16/8/10.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"

@protocol XYPositionAddListDelegate <NSObject>
@required
//让委托对象监测是否已经有相同的名称存在
- (BOOL)contrastToData:(NSString *)categaryName;

@optional
//让委托对象刷新自己的数据和UI界面
- (void)refreshDelegationView;
@end

@interface XYPositionAddListVc : BaseSettingViewController

@property(nonatomic, weak) id<XYPositionAddListDelegate> delegate;

@end
