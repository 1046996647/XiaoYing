//
//  UpTableViewCell.m
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "UpTableViewCell.h"
#import "InfoModel.h"

@implementation UpTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 设置cell之间的间隔线
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        
        //给cell赋值;
        self.detailLabel.text = @"(空)";
        self.messageLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        self.detailLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
 
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.detailLabel];
    }
    return self;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 6, 58, 32)];
        _messageLabel.text = @"备用电话";
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.textAlignment = NSTextAlignmentRight;
    }
    return _messageLabel;
}

- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 6, kScreen_Width - 85 - 20, 32)];
        _detailLabel.text = @"科技产业部";
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        
        
    }
    return _detailLabel;
}


- (void)getModel:(InfoModel *)model {

    if (self.tag == 0) {
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        CGFloat tempHeight = [model.Name boundingRectWithSize:CGSizeMake(kScreen_Width - 85 - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
        _detailLabel.numberOfLines = 0;
        if ([model.Name isEqual:@""] || model.Name == NULL) {
            _detailLabel.text = @"(空)";
            _detailLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        }else {
            _detailLabel.text = model.Name;
            _detailLabel.frame = CGRectMake(85, 6, kScreen_Width - 85 - 20, tempHeight + 12);
            _detailLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        }
    }else
        if (self.tag == 1) {
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        CGFloat tempHeight = [model.Stockholders boundingRectWithSize:CGSizeMake(kScreen_Width - 85 - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
        _detailLabel.numberOfLines = 0;
        if ([model.Stockholders isEqual:@""] || model.Stockholders == NULL) {
            _detailLabel.text = @"(空)";
            _detailLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        }else {
            _detailLabel.text = model.Stockholders;
            _detailLabel.frame = CGRectMake(85, 6, kScreen_Width - 85 - 20, tempHeight + 12);
            _detailLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        }
        }else
            if (self.tag == 4) {
            NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
            CGFloat tempHeight = [model.Url boundingRectWithSize:CGSizeMake(kScreen_Width - 85 - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            _detailLabel.numberOfLines = 0;
            if ([model.Url isEqual:@""] || model.Url == NULL) {
                _detailLabel.text = @"(空)";
                _detailLabel.textColor = [UIColor colorWithHexString:@"#848484"];
            }else {
                _detailLabel.text = model.Url;
                _detailLabel.frame = CGRectMake(85, 6, kScreen_Width - 85 - 20, tempHeight + 12);
                _detailLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            }
        }else
            if (self.tag == 5) {
                NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
                CGFloat tempHeight = [model.Address boundingRectWithSize:CGSizeMake(kScreen_Width - 85 - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
                _detailLabel.numberOfLines = 0;
                if ([model.Address isEqual:@""] || model.Address == NULL) {
                    _detailLabel.text = @"(空)";
                    _detailLabel.textColor = [UIColor colorWithHexString:@"#848484"];
                }else {
                    _detailLabel.text = model.Address;
                    _detailLabel.frame = CGRectMake(85, 6, kScreen_Width - 85 - 20, tempHeight + 12);
                    _detailLabel.textColor = [UIColor colorWithHexString:@"#333333"];
                }
            }

       switch (self.tag) {
            case 2:
            if ([model.MastPhones isEqual:@""] || model.MastPhones == NULL) {
                
                _detailLabel.text = @"(空)";
                _detailLabel.textColor = [UIColor colorWithHexString:@"#848484"];
            }else {
                _detailLabel.text = model.MastPhones;
                _detailLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            }
               _detailLabel.height = 32;

            break;
       
        case 3:
            
            if ([model.ReservePhones isEqual:@""] || model.ReservePhones == NULL) {
                _detailLabel.text = @"(空)";
                _detailLabel.textColor = [UIColor colorWithHexString:@"#848484"];
            }else {
                _detailLabel.text = model.ReservePhones;
                _detailLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            }
               _detailLabel.height = 32;

            break;
            default:
            break;
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
