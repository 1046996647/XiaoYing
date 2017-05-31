//
//  ApproalPocessTableView.h
//  XiaoYing
//
//  Created by YL20071 on 16/10/19.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowModel.h"
@protocol ApproalPocessTableViewDelegate <NSObject>

- (void)scroll;

@end

@interface ApproalPocessTableView : UITableView

@property (nonatomic,strong) id<ApproalPocessTableViewDelegate> ApproalPocessTableViewDelegate;
@property (nonatomic,strong) NSArray *dataList;
@property(nonatomic,strong)NSArray *flows;
@property(nonatomic,strong)NSDate *applyTime;//申请发出的时间

@end
