//
//  DepartmentTableViewCell.h
//  XiaoYing
//
//  Created by GZH on 16/7/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartmentModel.h"

typedef void(^SendBlock)(NSMutableArray *);

typedef void(^SendUnitBlock)(DepartmentModel *);

@interface DepartmentTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) UILabel *upLineLabel;
@property (nonatomic, strong) UILabel *downLineLabel;
@property (nonatomic, strong) UILabel *crossLineLabel;

@property (nonatomic, strong) DepartmentModel *model;

@property (nonatomic,copy) SendBlock sendBlock;
@property (nonatomic,copy) SendUnitBlock sendUnitBlock;


@property (nonatomic,strong) NSArray *departments;

// 单元格类型
@property (nonatomic,assign) NSInteger type;

@property(nonatomic,assign)BOOL allowChoose;//允许点击
@property(nonatomic,assign)BOOL singleChoose;//只能单选
@end
