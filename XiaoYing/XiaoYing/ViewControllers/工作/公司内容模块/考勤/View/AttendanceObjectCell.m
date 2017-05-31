//
//  AttendanceObjectCell.m
//  XiaoYing
//
//  Created by ZWL on 16/1/28.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AttendanceObjectCell.h"

@interface AttendanceObjectCell()

@property (nonatomic,strong) UIImageView *selectImageview;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIView *viewline;


@end

@implementation AttendanceObjectCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectImageview = [[UIImageView alloc] initWithFrame:CGRectMake(12, 14.5, 15, 15)];
        self.selectImageview.image = [UIImage imageNamed:@"nochoose"];
        [self.contentView addSubview:self.selectImageview];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(24+15, 0, kScreen_Width-40-80, 44)];
        self.titleLab.text = @"科技产业部";
        self.titleLab.font = [UIFont systemFontOfSize:14];
        self.titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:self.titleLab];
        
        self.viewline = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width-35, 15, 0.5, 14)];
        self.viewline.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        [self.contentView addSubview:self.viewline];
    }
    
    return self;
}
- (void)setStr:(NSString *)str{
    
    self.titleLab.text = str;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected == YES) {
        self.selectImageview.image = [UIImage imageNamed:@"choose1"];
    }else{
        self.selectImageview.image = [UIImage imageNamed:@"nochoose1"];
    }
    // Configure the view for the selected state
}

@end
