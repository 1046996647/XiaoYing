//
//  HeaderView.m
//  CityListWithIndex
//
//  Created by ljw on 16/7/19.
//  Copyright © 2016年 ljw. All rights reserved.
//

#import "ChatHeaderView.h"

#define UIBounds [[UIScreen mainScreen] bounds]

@implementation ChatHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _titleView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
        [self addSubview:_titleView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, self.frame.size.width-12*2, 20)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"848484"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [_titleView addSubview:_titleLabel];
    }
    return self;
}

- (void)setTitleString:(NSString *)titleString
{
    _titleLabel.text = titleString;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
