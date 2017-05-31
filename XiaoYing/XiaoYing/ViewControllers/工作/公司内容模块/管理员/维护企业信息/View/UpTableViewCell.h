//
//  UpTableViewCell.h
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InfoModel;

@interface UpTableViewCell : UITableViewCell


@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *detailLabel;

- (void)getModel:(InfoModel *)model;

@end
