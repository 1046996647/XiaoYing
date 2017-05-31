//
//  CompanyOfApplyCell.m
//  XiaoYing
//
//  Created by GZH on 16/8/12.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "CompanyOfApplyCell.h"
#import "OtherCompanyInfoModel.h"
#import "OtherCompanyDescriptionModel.h"
@interface CompanyOfApplyCell ()


@end

@implementation CompanyOfApplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if ([reuseIdentifier isEqualToString:@"cell1"]) {
            [self.contentView addSubview:self.beforeLabel];
            [self.contentView addSubview:self.behindLabel];
            
            // 设置cell之间的间隔线
            if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
                [self setSeparatorInset:UIEdgeInsetsZero];
            }
            if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
                [self setLayoutMargins:UIEdgeInsetsZero];
            }
            
         
        }else {
            
            [self.contentView addSubview:self.label];
        }
            self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


/**
 *0分区的cell
 */
- (UILabel *)beforeLabel {
    if (_beforeLabel == nil) {
        self.beforeLabel = [self Z_createLabelWithTitle:nil buttonFrame:CGRectMake(12, 0, 60, 44) textFont:14 colorStr:@"#848484" aligment:NSTextAlignmentRight];
    }
    return _beforeLabel;
}

- (UILabel *)behindLabel {
    if (_behindLabel == nil) {
        self.behindLabel = [self Z_createLabelWithTitle:@"(空)" buttonFrame:CGRectMake(_beforeLabel.right + 12, 10, kScreen_Width - 94 - 12, 24) textFont:14 colorStr:@"#cccccc" aligment:NSTextAlignmentLeft];
        _behindLabel.numberOfLines = 0;
    }
    return _behindLabel;
}

/**
 *其他分区的cell
 */

- (UILabel *)label {
    if (_label == nil) {
        self.label = [self Z_createLabelWithTitle:@"(空)" buttonFrame:CGRectMake(12, 10, kScreen_Width - 24, 24) textFont:14 colorStr:@"#cccccc" aligment:NSTextAlignmentLeft];
        _label.numberOfLines = 0;
    }
    return _label;
}



- (void)getModel:(OtherCompanyInfoModel *)model {
    switch (self.tag) {
        case 0:
            
            if ([model.Name isEqual:@""] || model.Name == NULL) {
                 _behindLabel.text = @"(空)";
//                _behindLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
            }else {
                _behindLabel.text = model.Name;
                _behindLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            }
            
            break;
        case 1:
            if ([model.Url isEqual:@""] || model.Url == NULL) {
                _behindLabel.text = @"(空)";
//                _behindLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
            }else {
                 _behindLabel.text = model.Url;
                _behindLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            }
           
            break;
        case 2:
            if ([model.Address isEqual:@""] || model.Address == NULL) {
                _behindLabel.text = @"(空)";
//                _behindLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
            }else {
                NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
                CGFloat height = [model.Address boundingRectWithSize:CGSizeMake(kScreen_Width - 24, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
                if (height > 17) {
                    _behindLabel.frame = CGRectMake(_beforeLabel.right + 12, 10, kScreen_Width - 94 - 12, height);
                }else {
                    _behindLabel.frame = CGRectMake(_beforeLabel.right + 12, 10, kScreen_Width - 94 - 12, 24);
                }
                
                _behindLabel.textColor = [UIColor colorWithHexString:@"#333333"];
                _behindLabel.text = model.Address;
            }

            break;
            
        default:
            break;
    }
}


- (void)getModelOfSectionOne:(OtherCompanyDescriptionModel *)model {
    if (model.DescContent == NULL || [model.DescContent isEqual:@""]) {
        _label.text = @"(空)";
    }else {
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        CGFloat height = [model.DescContent boundingRectWithSize:CGSizeMake(kScreen_Width - 24, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
        _label.frame = CGRectMake(12, 10, kScreen_Width - 24, height);
        _label.text = model.DescContent;
        _label.textColor = [UIColor colorWithHexString:@"#333333"];
    }
}







- (UILabel *)Z_createLabelWithTitle:(NSString *)title
                        buttonFrame:(CGRect)frame
                           textFont:(CGFloat)font
                           colorStr:(NSString *)colorStr
                           aligment:(NSTextAlignment)aligment {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = [UIColor colorWithHexString:colorStr];
    label.textAlignment = aligment;
    return label;
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
