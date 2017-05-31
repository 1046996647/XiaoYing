//
//  SettingCell.m
//  XiaoYing
//
//  Created by ZWL on 15/12/14.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "NewExcutePeopleCell.h"
#import "UIColor+Expend.h"
#import "UIViewExt.h"

@implementation NewExcutePeopleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.identifier = reuseIdentifier;

        
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if ([reuseIdentifier isEqualToString:@"cell1"]) {
            //初始化子视图
            [self initSubViews];
        } else {
            
            _selectedControl = [[UIButton alloc] initWithFrame:CGRectZero];
            [_selectedControl addTarget:self action:@selector(selected_action:) forControlEvents:UIControlEventTouchUpInside];
            //    _selectedControl.hidden = YES;
            //    _editControl.backgroundColor = [UIColor redColor];
            [self.contentView addSubview:_selectedControl];
            
            _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
            _nameLab.font = [UIFont systemFontOfSize:16];
            _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
            [self.contentView addSubview:_nameLab];
            
 
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
    
    
    _personalLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _personalLab.font = [UIFont systemFontOfSize:12];
    _personalLab.textColor = [UIColor colorWithHexString:@"#848484"];
    _personalLab.textAlignment = NSTextAlignmentRight;
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_personalLab];
    
    _selectedControl = [[UIButton alloc] initWithFrame:CGRectZero];
    [_selectedControl addTarget:self action:@selector(selected_action:) forControlEvents:UIControlEventTouchUpInside];
    //    _selectedControl.hidden = YES;
    //    _editControl.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_selectedControl];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.identifier isEqualToString:@"cell1"]) {
        
        _userImg.frame = CGRectMake(12, (self.height-76/2.0)/2.0, 76/2.0, 76/2.0);
//        [_userImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.ZWL.com/%@",self.profileModel.FaceUrl]] placeholderImage:[UIImage imageNamed:@"newfriends"]];
        
        _nameLab.frame = CGRectMake(_userImg.right + 12, (self.height-16)/2, 200, 16);
        //    _nameLab.text = self.profileModel.Nick;
        _nameLab.text = @"张伟良";
        
        
        _personalLab.frame = CGRectMake(self.width-200-10-20-12, (self.height-12)/2, 200, 12);
        //    _personalLab.text = self.profileModel.Signature;
        _personalLab.text = @"科技产业部-开发员";
        
        _selectedControl.frame = CGRectMake(self.width-45, 0, 45, self.height);
        [_selectedControl setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
        
    } else {
        
        _selectedControl.frame = CGRectMake(0, 0, 45, self.height);
        [_selectedControl setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
        
        _nameLab.frame = CGRectMake(_selectedControl.right, (self.height-16)/2, 200, 16);
        //    _nameLab.text = self.profileModel.Nick;
        _nameLab.text = self.model.name;

    }
    
    
    
    
    
}

- (void)selected_action:(UIButton *)btn
{
    
}


@end
