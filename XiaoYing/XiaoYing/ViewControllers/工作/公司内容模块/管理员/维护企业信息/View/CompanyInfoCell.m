//
//  CompanyInfoCell.m
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "CompanyInfoCell.h"
#import "ChilderCompanyModel.h"


@implementation CompanyInfoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        
        [self.contentView addSubview:self.image];
        [self.contentView addSubview:self.label];
        
        //cell之间的线
        //        self.layer.borderWidth = 0.5;
        //        self.layer.cornerRadius = 0.9;
        //        self.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}



- (UIImageView *)image {
    if (_image == nil) {
        self.image = [[UIImageView alloc]initWithFrame:CGRectMake(12, 6, 38, 38)];
    }
    _image.backgroundColor = [UIColor grayColor];
    _image.layer.cornerRadius = 5.0;
    _image.layer.masksToBounds = YES;
    return _image;
}

- (UILabel *)label {
    if (_label == nil) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(62, 6, kScreen_Width - 74, 38)];
        _label.text = @"杭州赢莱金融信息服务有限公司";
        _label.font = [UIFont systemFontOfSize:16];
        _label.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _label;
}


//- (void)getModel:(ChilderCompanyModel *)model {
//    _label.text = model.CompanyName;
//}

- (void)getModel:(ChilderCompanyModel *)model {
    _label.text = model.CompanyName;
    NSString *iconURL = [NSString replaceString:model.LOGFormatUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [_image sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"003"]];
    
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
