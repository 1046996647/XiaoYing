//
//  XYWorkPositionCell.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/8/9.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYWorkPositionCell.h"
@interface XYWorkPositionCell(){
    UILabel *_titleLabel;
    
    UIButton *_rightButton;
}

@end

@implementation XYWorkPositionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.identifier = reuseIdentifier;
        if ([reuseIdentifier isEqualToString:@"cellOne"]) {
            
            [self initCellOne];
        }
    }
    return self;
    
}

-(void)initCellOne{
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_titleLabel];
    
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"choose_orange"] forState:UIControlStateSelected];
    [self.contentView addSubview:_rightButton];
    
    
}
#pragma mark method
//button选择
-(void)click:(UIButton *)button{
    
    if (_rightButton.selected == 0) {
        
        _rightButton.selected = 1;
        
    }else
    {
        _rightButton.selected = 0;
    }
    
}

#pragma mark layoutsubViews
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    if ([self.identifier isEqualToString:@"cellOne"]) {
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).offset(12);
            make.centerY.equalTo(self.contentView.mas_centerY);
            
        }];
        
        
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView.mas_right).offset(-12);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
            
        }];
    }
  
    
}


#pragma mark 重写set方法
-(void)setTitle:(NSString *)title{
    
    _titleLabel.text = title;
}

-(void)setHighlighted:(BOOL)highlighted{
    
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
