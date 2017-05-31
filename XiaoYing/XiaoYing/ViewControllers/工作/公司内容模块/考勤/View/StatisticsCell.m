//
//  StatisticsCell.m
//  XiaoYing
//
//  Created by ZWL on 16/1/30.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "StatisticsCell.h"
@interface StatisticsCell()
{
   
}
@property (nonatomic,strong) UIImageView *headImageview;//头像
@property (nonatomic,strong) UILabel *nameLab;//姓名
@property (nonatomic,strong) UILabel *timeAfternoonLab;//时间
@property (nonatomic,strong) UILabel *dayLab;//日期

@property (nonatomic,strong) UILabel *signLab;//签到情况（漏签，早签。。。。。。）


@end

@implementation StatisticsCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
   
        //头像
        self.headImageview = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 40, 40)];
        self.headImageview.image = [UIImage imageNamed:@"1.1.png"];
        self.headImageview.clipsToBounds = YES;
        self.headImageview.layer.cornerRadius = 5;
        [self.contentView addSubview:self.headImageview];
        
        //姓名
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(52+12, 8, 100, 16)];
        self.nameLab.text = @"应俊俊";
        self.nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
        self.nameLab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.nameLab];
        
        //时间
        self.timeAfternoonLab = [[UILabel alloc] initWithFrame:CGRectMake(52+12, 8+16+6, 150, 12)];
        self.timeAfternoonLab.text = @"00:00-09:30 上午上班";
        self.timeAfternoonLab.textColor = [UIColor colorWithHexString:@"#848484"];
        self.timeAfternoonLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.timeAfternoonLab];
        
        //日期
        self.dayLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-120, 8, 110, 12)];
        self.dayLab.text = @"2016-01-21 09:30";
        self.dayLab.textColor = [UIColor colorWithHexString:@"#848484"];
        self.dayLab.font = [UIFont systemFontOfSize:12];
        self.dayLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.dayLab];

        //箭头
        self.arrowHeadImageview = [UIButton buttonWithType:UIButtonTypeCustom];
        self.arrowHeadImageview.frame = CGRectMake(kScreen_Width-12-30, 20, 30, 30);
        [self.arrowHeadImageview setImage:[UIImage imageNamed:@"opinion_read"] forState:UIControlStateNormal];
     
        [self.contentView addSubview:self.arrowHeadImageview];
        
        //漏签，改签
        
        self.signLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-12-30-70, 28, 70, 11)];
        self.signLab.text = @"漏签 补";
        self.signLab.textColor = [UIColor colorWithHexString:@"#848484"];
        self.signLab.font = [UIFont systemFontOfSize:12];
        self.signLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.signLab];
        
        
        
    }
    return self;
}






@end
