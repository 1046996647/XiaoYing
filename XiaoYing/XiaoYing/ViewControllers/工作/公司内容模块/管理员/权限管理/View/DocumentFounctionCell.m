//
//  DocumentFounctionCell.m
//  XiaoYing
//
//  Created by GZH on 2017/1/6.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "DocumentFounctionCell.h"
#import "ModuleModel.h"
@implementation DocumentFounctionCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.imageMark];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    }
    return self;
}


- (UILabel *)label {
    if (_label == nil) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, kScreen_Width/2 - 12, 44)];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.font = [UIFont systemFontOfSize:16];
        _label.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _label;
}

- (UIButton *)imageMark {
    if (_imageMark == nil) {
        self.imageMark = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width - 35, 5, 35, 35)];
        [_imageMark setImage:[UIImage imageNamed:@"kong_gray"] forState:UIControlStateNormal];
        [_imageMark setImage:[UIImage imageNamed:@"xuanzhong_-orange"] forState:UIControlStateSelected];
        
    }
    return _imageMark;
}


- (void)getModel:(ModuleModel *)model andSelectedMark:(NSString *)str{
    
    _label.text = model.Name;
    
    if ([str isEqualToString:@"1"]) {
        _imageMark.selected = YES;
    }else {
        _imageMark.selected = NO;
    }
    
    if ([model.Name isEqualToString:@"查看"]) {
        _imageMark.userInteractionEnabled = NO;
    }
    
    
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
