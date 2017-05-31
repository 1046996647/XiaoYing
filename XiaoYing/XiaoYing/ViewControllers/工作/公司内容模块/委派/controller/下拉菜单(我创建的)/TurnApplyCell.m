//
//  SettingCell.m
//  XiaoYing
//
//  Created by ZWL on 15/12/14.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "TurnApplyCell.h"

@implementation TurnApplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        
        //初始化子视图
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    _userImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    //    _userImg.image = [UIImage imageNamed:@"ying"];
    _userImg.layer.cornerRadius = 5;
    _userImg.clipsToBounds = YES;
    [self.contentView addSubview:_userImg];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLab.font = [UIFont systemFontOfSize:16];
    _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_nameLab];
    
    
    _personalLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _personalLab.font = [UIFont systemFontOfSize:14];
    _personalLab.textColor = [UIColor colorWithHexString:@"#848484"];
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_personalLab];
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLab.font = [UIFont systemFontOfSize:12];
    _timeLab.textAlignment = NSTextAlignmentRight;
    _timeLab.textColor = [UIColor colorWithHexString:@"#848484"];
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_timeLab];
    
    _applyTypeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _applyTypeLab.textAlignment = NSTextAlignmentRight;
    _applyTypeLab.font = [UIFont systemFontOfSize:12];
    _applyTypeLab.textColor = [UIColor colorWithHexString:@"#848484"];
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_applyTypeLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _userImg.frame = CGRectMake(12, (self.height-76/2.0)/2.0, 76/2.0, 76/2.0);
    [_userImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.ZWL.com/%@",self.profileModel.FaceUrl]] placeholderImage:[UIImage imageNamed:@"newfriends"]];
    
    _nameLab.frame = CGRectMake(_userImg.right + 12, _userImg.top+2, 200, 16);
    //    _nameLab.text = self.profileModel.Nick;
    _nameLab.text = @"张伟良";
    
    
    _personalLab.frame = CGRectMake(_nameLab.left, _nameLab.bottom + 6, self.width - _userImg.right - 12 - 24, 12);
    //    _personalLab.text = self.profileModel.Signature;
    _personalLab.text = @"委派任务标题";
    
    _timeLab.frame = CGRectMake(self.width-12-150, 10, 150, 12);
    _timeLab.text = @"2016-02-23 11:03";
    
    _applyTypeLab.frame = CGRectMake(self.width-12-150, _timeLab.bottom+10, 150, 12);
    _applyTypeLab.text = self.applyTypeStr;
}









@end
