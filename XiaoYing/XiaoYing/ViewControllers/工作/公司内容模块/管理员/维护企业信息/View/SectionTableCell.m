//
//  SectionTableCell.m
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "SectionTableCell.h"
#import "DescriptionsModel.h"
#import "CompanyDetailVC.h"
#import "MakeDeleteAction.h"


@implementation SectionTableCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([reuseIdentifier isEqualToString:@"cell3"]) {
            [self.contentView addSubview:self.SectionLabel];
        }else
        {
            [self.contentView addSubview:self.backgroundLabel];
            [self.contentView addSubview:self.label];
            [self.contentView addSubview:self.cellLabel];
            [self.contentView addSubview:self.deleteBtn];
            [self.contentView addSubview:self.labelOnCell];
        }
        
    }
    return self;
}


#pragma mark  --2-4分区cell(创建公司，企业名片)--
- (UILabel *)SectionLabel {
    if (_SectionLabel == nil) {
        self.SectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 14, kScreen_Width - 24, 17)];
        _SectionLabel.font = [UIFont systemFontOfSize:14];
        _SectionLabel.textAlignment = NSTextAlignmentLeft;
        _SectionLabel.numberOfLines = 0;
        self.SectionLabel.text = @"(空)";
        self.SectionLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    }
    return _SectionLabel;
}


//参数2：str  标记是否是企业信息的cell （因为企业信息和企业名片共用相同的cell，(空）颜色设置不一样） 之后可能会改
- (void)getModel:(DescriptionsModel *)model andType:(NSString *)str{
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGFloat tempHeight = [model.DescContent boundingRectWithSize:CGSizeMake(kScreen_Width - 24, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    
    if (tempHeight > 17) {
        _SectionLabel.frame = CGRectMake(12, 14, kScreen_Width - 24, tempHeight);
    }else {
        _SectionLabel.frame = CGRectMake(12, 14, kScreen_Width - 24, 17);
    }
    
    if ([model.DescContent isEqual:@""] || model.DescContent == NULL) {
        _SectionLabel.text = @"(空)";
        
        if ([str isEqualToString:@"CompanyInfo"]) {
             _SectionLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        }else {
            _SectionLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        }
        
    }else {
        _SectionLabel.text = model.DescContent;
        _SectionLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }

}




#pragma mark --5分区cell上边的控件（创建公司的cell）--

- (UILabel *)backgroundLabel {
    if (_backgroundLabel == nil) {
        self.backgroundLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
        _backgroundLabel.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    }
    return _backgroundLabel;
}

- (UILabel *)label {
    if (_label == nil) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, kScreen_Width - 24, 30)];
        
        _label.font = [UIFont systemFontOfSize:14];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.numberOfLines = 0;
        _label.textColor = [UIColor colorWithHexString:@"#848484"];
        _label.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        
    }
    return _label;
}

- (UILabel *)cellLabel {
    if (_cellLabel == nil) {
        
        self.cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, kScreen_Width, 44)];
        _cellLabel.backgroundColor = [UIColor whiteColor];
    }
    return _cellLabel;
}


- (UILabel *)labelOnCell {
    
    if (_labelOnCell == nil) {
        self.labelOnCell = [[UILabel alloc]initWithFrame:CGRectMake(12, 44, kScreen_Width-24, 17)];
        _labelOnCell.backgroundColor = [UIColor redColor];
        _labelOnCell.font = [UIFont systemFontOfSize:14];
        _labelOnCell.textAlignment = NSTextAlignmentLeft;
        _labelOnCell.numberOfLines = 0;
        _labelOnCell.text = @"(空)";
        _labelOnCell.textColor = [UIColor colorWithHexString:@"#848484"];
        _labelOnCell.backgroundColor = [UIColor whiteColor];
    }
    
    return _labelOnCell;
}


- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"deletepicyure"] forState:UIControlStateNormal];
        
    }
    return _deleteBtn;
}


- (void)getModelOfSection:(NSString *)sectionTitle
          AndDetailOfCell:(NSString *)detaelText {
    NSLog(@"---------------%@-----------%@", sectionTitle, detaelText);
    CGFloat labelTextWidth = [sectionTitle boundingRectWithSize:CGSizeMake(kScreen_Width - 24, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |
                              NSStringDrawingUsesLineFragmentOrigin |
                              NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    _deleteBtn.frame = CGRectMake(labelTextWidth + 12, 2, 26, 26);
    _deleteBtn.titleLabel.text = sectionTitle;
    [_deleteBtn addTarget:self action:@selector(deleteSectionAlert:) forControlEvents:UIControlEventTouchUpInside];
    
    _label.text = sectionTitle;
    
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGFloat tempHeight = [detaelText boundingRectWithSize:CGSizeMake(kScreen_Width - 24, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    
    //针对企业信息模块 5分区有可能穿的是空值
    if ([detaelText isEqualToString:@""]) {
        detaelText = @"(空)";
    }
    
    _cellLabel.height = tempHeight + 27;
    _labelOnCell.frame = CGRectMake(12, 44, kScreen_Width - 24, tempHeight);
    _labelOnCell.text = detaelText;
    _labelOnCell.textColor = [UIColor colorWithHexString:@"#333333"];
    if ([detaelText isEqualToString:@"(空)"]) {
        _labelOnCell.textColor = [UIColor colorWithHexString:@"#848484"];
    }
}


- (void)deleteSectionAlert:(UIButton *)sender {
    //Alert推出框删除cell
    MakeDeleteAction *deleteVC = [[MakeDeleteAction alloc]init];
    deleteVC.labelTitle = sender.titleLabel.text;
    deleteVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    deleteVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    deleteVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController.navigationController presentViewController:deleteVC animated:YES completion:nil];
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
