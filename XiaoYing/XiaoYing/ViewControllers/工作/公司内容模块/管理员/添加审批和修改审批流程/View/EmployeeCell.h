//
//  EmployeeCell.h
//  XiaoYing
//
//  Created by ZWL on 16/9/23.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeModel.h"


typedef void(^SendEmployeeBlock)(EmployeeModel *);


@interface EmployeeCell : UITableViewCell

@property (nonatomic,strong) UIImageView *userImg;
@property (nonatomic,strong) UIImageView *labelView;
@property (nonatomic,strong) UILabel *mastJobNameLab;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UIButton *selectedControl;
@property (nonatomic,strong) UIButton *managerMark;
@property (nonatomic,copy) SendEmployeeBlock sendEmployeeBlock;
@property (nonatomic,strong) EmployeeModel *model;

@property (nonatomic, strong) NSString *currentDepartmentId;


// 单元格类型
@property (nonatomic,assign) NSInteger type;
@end
