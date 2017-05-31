//
//  XYSelectJobCell.m
//  XiaoYing
//
//  Created by chenchanghua on 16/10/25.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYSelectJobCell.h"

@interface XYSelectJobCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation XYSelectJobCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupCell];
    }
    
    return self;
}

-(void)setupCell{
    
    //titleLabel
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:self.titleLabel];
    
    //selectButton
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    self.selectButton.userInteractionEnabled = NO;
    [self.contentView addSubview:self.selectButton];
    
    
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
    
    //选中button
    self.selectButton.frame = CGRectMake(kScreen_Width -40, 0, 40, 40);
    
    
}


- (void)setJobNameStr:(NSString *)jobNameStr
{
    _jobNameStr = jobNameStr;
    self.titleLabel.text = jobNameStr;
}

- (void)setSelectJobNameStr:(NSString *)selectJobNameStr
{
    _selectJobNameStr = selectJobNameStr;
    self.selectButton.selected = NO;
    
    if ([self.jobNameStr isEqualToString:self.selectJobNameStr]) {
        
        self.selectButton.selected = YES;
    }
}

@end
