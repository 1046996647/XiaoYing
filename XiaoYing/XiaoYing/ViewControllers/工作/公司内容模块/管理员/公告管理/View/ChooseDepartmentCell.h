//
//  ChooseDepartmentCell.h
//  XiaoYing
//
//  Created by 王思齐 on 16/11/24.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartmentModel.h"
@interface ChooseDepartmentCell : UITableViewCell

@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) UILabel *upLineLabel;
@property (nonatomic, strong) UILabel *downLineLabel;
@property (nonatomic, strong) UILabel *crossLineLabel;

@property (nonatomic, strong) DepartmentModel *model;

@property (nonatomic,strong) NSArray *departments;

// 单元格类型
@property (nonatomic,assign) NSInteger type;
@end
