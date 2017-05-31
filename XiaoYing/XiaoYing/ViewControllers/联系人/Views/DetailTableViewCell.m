//
//  DetailTableViewCell.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/10/22.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

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
        _headerImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_headerImage];
        
        UILabel *countLab = [[UILabel alloc] initWithFrame:CGRectMake(_headerImage.right-8, 0, 15, 15)];
        countLab.backgroundColor = [UIColor redColor];
        countLab.layer.cornerRadius = countLab.width/2.0;
        countLab.clipsToBounds = YES;
        countLab.hidden = YES;
        countLab.textColor = [UIColor whiteColor];
        countLab.font = [UIFont systemFontOfSize:11];
        countLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:countLab];
        self.countLab = countLab;
        
//        用户名
        _nameLab =[[UILabel alloc]initWithFrame:CGRectMake(66, 0, 250, 58)];
        _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLab.font =[UIFont systemFontOfSize:18];
        [self.contentView addSubview:_nameLab];
        
        _relationImage =[[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width-80, (58-25)/2, 80, 25)];
        //    imageBoth.hidden =YES;
        _relationImage.image =[UIImage imageNamed:@"both"];
        [self.contentView addSubview:_nameLab];
        
        _selectedControl = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - 58, 0, 58, 58)];
//        _selectedControl.backgroundColor = [UIColor cyanColor];
        [_selectedControl addTarget:self action:@selector(selected_action:) forControlEvents:UIControlEventTouchUpInside];
        [_selectedControl setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
        [_selectedControl setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
        [self.contentView addSubview:_selectedControl];

        
    }
    
    return self;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//
//
//}

- (void)setMyfriend:(ConnectWithMyFriend *)myfriend
{
    _myfriend = myfriend;
    if (self.section == 0) {
        self.nameLab.text = @"好友请求";
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"newfriends"]];
        
        _selectedControl.hidden = YES;
        
    }
    else {
        
        if (_myfriend.RemarkName.length > 0) {
            self.nameLab.text = _myfriend.RemarkName;

        }
        else {
            self.nameLab.text = _myfriend.Nick;

        }
        
        NSString *iconURL = [NSString replaceString:_myfriend.FaceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:iconURL]];
        
        //        if (_myfriend.RelationType.integerValue == 2) {
        //            _relationImage.image =[UIImage imageNamed:@"friend"];
        //
        //        }
        //        else if (_myfriend.RelationType.integerValue == 3) {
        //            _relationImage.image =[UIImage imageNamed:@"both"];
        //
        //        }
        if (self.type == 0) {
            _selectedControl.hidden = YES;
        }
        else {
            
            if (self.myfriend.isSelected) {
                _selectedControl.selected = YES;
            }
            else {
                _selectedControl.selected = NO;
                
            }
        }
        
    }
}

- (void)selected_action:(UIButton *)btn
{
    _myfriend.isSelected = !_myfriend.isSelected;
    if (_sendFriendBlock) {
        _sendFriendBlock(_myfriend);
    }
}

@end
