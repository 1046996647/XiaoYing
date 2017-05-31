//
//  XYWorkChooseCell.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/8/16.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYWorkChooseCell.h"
@interface XYWorkChooseCell()
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * miniTitleLabel;

@property(nonatomic,strong)UIImageView * iconImage;
@property(nonatomic,strong)UIImageView * miniIconImage;

@property(nonatomic,strong)UIButton * rightButton;

@property(nonatomic,strong)UIButton * clickButton;
@property(nonatomic,strong)UIButton * titleButton;

@end

@implementation XYWorkChooseCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _identifier = reuseIdentifier;
        if ([reuseIdentifier isEqualToString:@"cellJob"]) {
            
            [self initCellJob];
            
        }

    }
    
    return self;
    
}

-(void)initCellJob{
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:self.titleLabel];
    
    self.miniTitleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.miniTitleLabel];
    self.miniTitleLabel.font = [UIFont systemFontOfSize:12];
    self.miniTitleLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    
    
    self.iconImage = [[UIImageView alloc]init];
    self.iconImage.image = [UIImage imageNamed:@"arrow_to"];
    
    [self.contentView addSubview:self.iconImage];
    
//    self.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    if ([self.identifier isEqualToString:@"cellJob"]) {
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(12);
        }];
        
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView.mas_right).offset(-12);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@7);
            make.height.equalTo(@10);
        }];
        
        [self.miniTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.iconImage.mas_left).offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            
        }];
    }
    
}


#pragma mark 重写set方法
-(void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

-(void)setDetail:(NSString *)detail
{
    self.miniTitleLabel.text = detail;
}

-(NSString *)title{
    return _titleLabel.text;
}

-(NSString *)detail{
    return _miniTitleLabel.text;
}
@end
