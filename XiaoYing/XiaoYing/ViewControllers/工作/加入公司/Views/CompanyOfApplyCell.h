//
//  CompanyOfApplyCell.h
//  XiaoYing
//
//  Created by GZH on 16/8/12.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OtherCompanyInfoModel;
@class OtherCompanyDescriptionModel;

@interface CompanyOfApplyCell : UITableViewCell

@property (nonatomic, strong)UILabel *beforeLabel;
@property (nonatomic, strong)UILabel *behindLabel;

@property (nonatomic, strong)UILabel *label;

- (void)getModel:(OtherCompanyInfoModel *)model;

- (void)getModelOfSectionOne:(OtherCompanyDescriptionModel *)model;
@end
