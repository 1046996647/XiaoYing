//
//  SettingCell.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/14.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "FriendDetailCell.h"

@implementation FriendDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.identifier = reuseIdentifier;
        
        if ([reuseIdentifier isEqualToString:@"cell1"]) {
            
            //初始化子视图
            [self initSubViews];
        }
        else {
            
            _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
            _titleLab.textColor = [UIColor colorWithHexString:@"#848484"];
            _titleLab.font = [UIFont systemFontOfSize:16];
            [self.contentView addSubview:_titleLab];
            
            _dataLab = [[UILabel alloc] initWithFrame:CGRectZero];
            _dataLab.textColor = [UIColor colorWithHexString:@"#333333"];
            _dataLab.font = [UIFont systemFontOfSize:16];
            _dataLab.textAlignment = NSTextAlignmentRight;
            _dataLab.numberOfLines = 2;
            [self.contentView addSubview:_dataLab];
            
        }
        

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
    
    _remindImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_remindImg];
    
    //    _markImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    //    _markImg.image = [UIImage imageNamed:@"sign"];
    //    [self.contentView addSubview:_markImg];
    
    
    _personalLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _personalLab.font = [UIFont systemFontOfSize:12];
    _personalLab.numberOfLines = 2;
    _personalLab.textColor = [UIColor colorWithHexString:@"#848484"];
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_personalLab];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.identifier isEqualToString:@"cell1"]) {
        _userImg.frame = CGRectMake(12, 10, 60, 60);
        
        NSString *iconURL = nil;
        NSString *nick = nil;
        if (_model.isEmployee) {
            iconURL = [NSString replaceString:self.model.FaceUrl2 Withstr1:@"100" str2:@"100" str3:@"c"];
            nick = self.model.Name;

        }
        else {
            iconURL = [NSString replaceString:self.model.FaceUrl Withstr1:@"100" str2:@"100" str3:@"c"];

//            if (self.model.MemberName.length > 0) {
//                nick = self.model.MemberName;
//                
//            }
//            else {
//                nick = self.model.Nick;
//                
//            }
            if (self.model.RemarkName.length > 0) {
                nick = self.model.RemarkName;
                
            }
            else {
                nick = self.model.Nick;
                
            }

        }
        
        [_userImg sd_setImageWithURL:[NSURL URLWithString:iconURL]];
        
        CGSize size =[nick sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        _nameLab.frame = CGRectMake(_userImg.right + 12, 22, size.width, size.height);
        _nameLab.text = nick;
        
        _remindImg.frame = CGRectMake(_nameLab.right+12, _nameLab.top, 15, 20);
        
        //    _markImg.frame = CGRectMake(_nameLab.left, _nameLab.bottom + 7, 12, 12);
        
        _personalLab.frame = CGRectMake(_nameLab.left, _nameLab.bottom, self.width - _userImg.right - 12 - 24, 30);
        _personalLab.text = self.model.XiaoYingCode;
        
        if (self.model.Gender.integerValue == 0) {
        }
        else if (self.model.Gender.integerValue == 1) {
            _remindImg.image = [UIImage imageNamed:@"man"];
        }
        else {
            _remindImg.image = [UIImage imageNamed:@"woman"];
        }
    }
    else {
        
        //计算字符串高度
        NSString *str = self.data;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        CGSize textSize = [str boundingRectWithSize:CGSizeMake(200, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        _titleLab.frame = CGRectMake(24, self.height / 2 - textSize.height / 2, 100, textSize.height);
        _titleLab.text = self.title;
        
        _dataLab.frame = CGRectMake(kScreen_Width - 200 - 12, self.height / 2 - textSize.height / 2, 200, textSize.height);
        //    _dataLab.backgroundColor = [UIColor redColor];
        _dataLab.text = str;
    }
    
    
    
    
}


@end
