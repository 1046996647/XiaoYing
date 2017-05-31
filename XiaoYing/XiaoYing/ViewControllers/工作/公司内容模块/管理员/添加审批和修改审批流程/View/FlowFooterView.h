//
//  FlowFooterView.h
//  XiaoYing
//
//  Created by ZWL on 16/4/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowFooterView : UIView

@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UIButton *circleView1;
@property (nonatomic,strong) UIView *rectView1;
@property (nonatomic,strong) UILabel *peopleLab;


@property (nonatomic, copy)NSString *CompanyName;
@property (nonatomic, strong)NSNumber *CompanyRanks;
@property (nonatomic,strong) NSArray *departments;
@property (nonatomic,strong) NSArray *employees;


@property (nonatomic,strong) NSMutableArray *selectedDepArr;
@property (nonatomic, strong)NSMutableArray *selectedEmpArr;


@property NSUInteger section;

@property (nonatomic, weak) UITableView *tableView;

@end
