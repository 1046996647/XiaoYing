//
//  PersonalmanagerCell.m
//  XiaoYing
//
//  Created by GZH on 16/8/3.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "PersonalmanagerCell.h"

@implementation PersonalmanagerCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.label];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (UILabel *)label {
    if (_label == nil) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, kScreen_Width, 44)];
        _label.text = @"(空)";
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor colorWithHexString:@"#cccccc"];
        
    }
    return _label;
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
