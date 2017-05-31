//
//  CommemorationCell.m
//  XiaoYing
//
//  Created by ZWL on 16/2/1.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "CommemorationCell.h"
@interface CommemorationCell()
{
    
}
@property (nonatomic,strong) UIImageView *headImageview;//头像
@property (nonatomic,strong) UILabel *nameLab;//姓名
@property (nonatomic,strong) UILabel *birthdayLab;//生日
@property (nonatomic,strong) UILabel *dateLab;//日期
@end

@implementation CommemorationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.headImageview = [[UIImageView alloc] initWithFrame:CGRectMake(12, 7, 30, 30)];
        self.headImageview.image = [UIImage imageNamed:@"1.1"];
        self.headImageview.clipsToBounds = YES;
        self.headImageview.layer.cornerRadius = 5;
        [self.contentView addSubview:self.headImageview];
        
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(12+30+12, 7, 150, 30)];
        self.nameLab.text = @"钱老板";
        self.nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
        self.nameLab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.nameLab];
        
        self.birthdayLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-12-30, 7, 30, 12)];
        self.birthdayLab.text = @"生日";
        self.birthdayLab.textAlignment = NSTextAlignmentRight;
        self.birthdayLab.textColor = [UIColor colorWithHexString:@"#848484"];
        self.birthdayLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.birthdayLab];
        
        self.dateLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-12-80, 7+12+6, 80, 12)];
        self.dateLab.text = @"2016-01-27";
        self.dateLab.textAlignment = NSTextAlignmentRight;
        self.dateLab.textColor = [UIColor colorWithHexString:@"#848484"];
        self.dateLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.dateLab];
        
        
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
