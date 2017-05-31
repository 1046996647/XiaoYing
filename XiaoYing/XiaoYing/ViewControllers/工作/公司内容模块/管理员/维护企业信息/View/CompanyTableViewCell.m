//
//  CompanyTableViewCell.m
//  XiaoYing
//
//  Created by GZH on 16/7/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "CompanyTableViewCell.h"

@implementation CompanyTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.companyLabel];
        [self.contentView addSubview:self.unitLabel];
        self.selectionStyle = UIAccessibilityTraitNone;
    }
    return self;
}




- (UILabel *)companyLabel {
    if (_companyLabel == nil) {
        self.companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 6, kScreen_Width - 56, 14)];
        _companyLabel.text = @"杭州赢莱金融服务有限公司";
        _companyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _companyLabel.font = [UIFont systemFontOfSize:14];
        _companyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _companyLabel;
}

- (UILabel *)unitLabel {
    if (_unitLabel == nil) {
        self.unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 26, kScreen_Width / 2, 12)];
        _unitLabel.text = @"4级单元";
        _unitLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _unitLabel.font = [UIFont systemFontOfSize:12];
        _unitLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _unitLabel;
}








- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
