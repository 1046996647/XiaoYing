//
//  CompanyInfoCell.h
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChilderCompanyModel;
@class IconModel;


@interface CompanyInfoCell : UITableViewCell
@property (nonatomic, strong)UIImageView *image;
@property (nonatomic, strong)UILabel *label;

- (void)getModel:(ChilderCompanyModel *)model;

@end
