//
//  AuthoritySettingCell.m
//  XiaoYing
//
//  Created by ZWL on 16/6/12.
//  Copyright © 2016年 ZWL. All rights reserved.
//



#import "AuthoritySettingCell.h"



@interface AuthoritySettingCell ()
@property (nonatomic, strong)UILabel *label;
@property (nonatomic,strong) UIView *backView;




@end

@implementation AuthoritySettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
  
        
        self.identifier = reuseIdentifier;
        
        if ([reuseIdentifier isEqualToString:@"cell1"]) {
            
            _userImg = [[UIImageView alloc] initWithFrame:CGRectZero];
             [self.contentView addSubview:_userImg];
            
            _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
             [self.contentView addSubview:_nameLab];
            
            
            _personalLab = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.contentView addSubview:_personalLab];
            
        }
        else {
            _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
            
            [self.contentView addSubview:_backView];
        }
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([self.identifier isEqualToString:@"cell1"]) {
        // 第一种单元格
        _userImg.layer.cornerRadius = 5;
        _userImg.clipsToBounds = YES;
      
        _userImg.frame = CGRectMake(12, 12, 20, 20);
//        [_userImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.ZWL.com/"]] placeholderImage:[UIImage imageNamed:@"position"]];
        
        _nameLab.font = [UIFont systemFontOfSize:14];
        _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
       

 
        _nameLab.text = _tempString;
        
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        CGFloat height = [ _nameLab.text  boundingRectWithSize:CGSizeMake(kScreen_Width-(_userImg.right+12)-12, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
        
        _nameLab.numberOfLines = 0;
        _nameLab.frame = CGRectMake(_userImg.right + 12, _userImg.top, kScreen_Width-(_userImg.right+12)-12, height);
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:_nameLab.text];
        [attribute addAttributes:@{
                                   NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#f99740"],
                                   NSFontAttributeName : [UIFont systemFontOfSize:14]
                                   }range:NSMakeRange(_nameLab.text.length-6, 6)];
        
        _nameLab.attributedText = attribute;
        
        
        _personalLab.frame = CGRectMake(_userImg.right + 12, _nameLab.bottom + 5, kScreen_Width-(_userImg.right+12)-12, 14);
        _personalLab.font = [UIFont systemFontOfSize:14];
        _personalLab.text = _jobModel.JobName;
        
        if ([_jobModel.IsMastJob isEqual:@1]) {
            _userImg.image = [UIImage imageNamed:@"position"];
            _personalLab.textColor = [UIColor colorWithHexString:@"#1fc688"];
        }else {
            _userImg.image = [UIImage imageNamed:@"parttime"];
            _personalLab.textColor = [UIColor colorWithHexString:@"#40d7f9"];
        }
        
        
    }
     else{
        // 第二种单元格
         _backView.backgroundColor = [UIColor whiteColor];
         _label = [[UILabel alloc]initWithFrame:CGRectMake(12, 15, 80, 14)];
         _label.text = @"(空)";
         _label.font = [UIFont systemFontOfSize:14];
         _label.textColor = [UIColor colorWithHexString:@"#cccccc"];
         _label.textAlignment = NSTextAlignmentLeft;
         [_backView addSubview:_label];
         
     }
}




@end
