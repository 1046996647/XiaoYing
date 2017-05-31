//
//  selectPalceCell.m
//  XiaoYing
//
//  Created by ZWL on 17/1/9.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "selectPalceCell.h"

@interface selectPalceCell()

@property (nonatomic,strong) UIButton *selectedControl;

@end

@implementation selectPalceCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _selectedControl = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - 50, 0, 50, 50)];
        [_selectedControl setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
        [_selectedControl setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
        [self.contentView addSubview:_selectedControl];
        _selectedControl.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setBtnSelected:(BOOL)btnSelected
{
    _btnSelected = btnSelected;
    [_selectedControl setSelected:self.btnSelected];
}

@end
