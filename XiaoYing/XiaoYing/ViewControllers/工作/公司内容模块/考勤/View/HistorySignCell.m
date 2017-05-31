//
//  HistorySignCell.m
//  XiaoYing
//
//  Created by ZWL on 16/1/31.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "HistorySignCell.h"
@interface HistorySignCell()
{
    
}
@property (nonatomic,strong)UILabel *dateLab;//日期
@property (nonatomic,strong)UILabel *daySignLab;//本日已签
@property (nonatomic,strong)UILabel *eailySignLab;//早签到
@property (nonatomic,strong)UILabel *leakSignLab;//漏签
@end

@implementation HistorySignCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.dateLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, 44)];
        self.dateLab.textColor = [UIColor colorWithHexString:@"#333333"];
        self.dateLab.text = @"2016-01-21";
        self.dateLab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.dateLab];
        
        self.daySignLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-100, 7, 88, 12)];
        self.daySignLab.textColor = [UIColor colorWithHexString:@"#848484"];
        self.daySignLab.text = @"本日已签 3";
        self.daySignLab.font = [UIFont systemFontOfSize:12];
        self.daySignLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.daySignLab];

        
        self.eailySignLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-200, 19+6, 140, 12)];
        self.eailySignLab.textColor = [UIColor colorWithHexString:@"#848484"];
        self.eailySignLab.text = @"早签 1";
        self.eailySignLab.font = [UIFont systemFontOfSize:12];
        self.eailySignLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.eailySignLab];

        
        self.leakSignLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-60, 19+6, 48, 12)];
        self.leakSignLab.textColor = [UIColor colorWithHexString:@"#848484"];
        self.leakSignLab.text = @"漏签 2";
        self.leakSignLab.font = [UIFont systemFontOfSize:12];
        self.leakSignLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.leakSignLab];
        
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
