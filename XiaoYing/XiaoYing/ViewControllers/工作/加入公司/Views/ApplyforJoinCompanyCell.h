//
//  ApplyforJoinCompanyCell.h
//  XiaoYing
//
//  Created by GZH on 16/8/18.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApplyForJoinTheCompanyModel;

@interface ApplyforJoinCompanyCell : UITableViewCell

@property (nonatomic, strong)UILabel *statusLabel;

@property (nonatomic, strong)UIButton *deleteButton;
@property (nonatomic, strong)UIButton *drawButton;

@property (nonatomic, strong)UIButton *agreeButton;
@property (nonatomic, strong)UIButton *refuseButton;


- (void)getModel:(ApplyForJoinTheCompanyModel *)model;

@end
