//
//  DetailTableViewCell.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/10/22.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "GroupListCell.h"

@implementation GroupListCell

/**
 *  初始化
 *
 *  @param style
 *  @param reuseIdentifier
 *
 *  @return
 */
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        用户头像
        _headerImage =[[UIImageView alloc]init];
        _headerImage.frame =CGRectMake(10, 7, 44, 44);
        _headerImage.layer.cornerRadius =4;
        _headerImage.clipsToBounds =YES;
        [self.contentView addSubview:_headerImage];
        //        用户名
        _nameLab =[[UILabel alloc]initWithFrame:CGRectMake(66, 0, 250, 58)];
        _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLab.font =[UIFont systemFontOfSize:18];
        [self.contentView addSubview:_nameLab];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.nameLab.text = self.model.Name;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"group-chat"]];
}

@end
