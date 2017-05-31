//
//  EmployeeDetailCell.h
//  XiaoYing
//
//  Created by ZWL on 16/10/28.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeModel.h"

@interface EmployeeDetailCell : UITableViewCell

@property (nonatomic,copy) NSString *identifier;

@property (nonatomic,strong) UIImageView *userImg;
@property (nonatomic,strong) UILabel *personalLab;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UIImageView *remindImg;
@property (nonatomic,strong) EmployeeModel *model;

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *dataLab;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *data;

@end
