//
//  SettingCell.m
//  XiaoYing
//
//  Created by ZWL on 15/12/14.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "SelectWayCell.h"

@implementation SelectWayCell

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
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLab.font = [UIFont systemFontOfSize:16];
    _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_nameLab];
    
    _selectedControl = [[UIButton alloc] initWithFrame:CGRectZero];
    [_selectedControl addTarget:self action:@selector(selected_action:) forControlEvents:UIControlEventTouchUpInside];
    //    _selectedControl.hidden = YES;
    //    _editControl.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_selectedControl];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _nameLab.frame = CGRectMake(12, (self.height-16)/2, 200, 16);
    //    _nameLab.text = self.profileModel.Nick;
    _nameLab.text = self.way;
    
//    _selectedControl.frame = CGRectMake(kScreen_Width-45, 0, 45, self.height);
//    [_selectedControl setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
    
    
    
}

//- (void)selected_action:(UIButton *)btn
//{
//    
//}








@end
