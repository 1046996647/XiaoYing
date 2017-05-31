//
//  XYPositionEditCell.h
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/21.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYCategoryModel;

@interface XYPositionEditCell : UITableViewCell

@property(nonatomic,strong)XYCategoryModel * model;

//按钮
@property(nonatomic,strong)UIButton * selectButton;

@end
