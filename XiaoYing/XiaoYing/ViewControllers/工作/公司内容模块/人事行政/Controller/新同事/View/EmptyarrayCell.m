//
//  EmptyarrayCell.m
//  XiaoYing
//
//  Created by GZH on 16/9/22.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "EmptyarrayCell.h"

@implementation EmptyarrayCell






- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
 
            _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
            
            [self.contentView addSubview:_backView];
        
        
    }
    return self;
}

















- (void)layoutSubviews {
    [super layoutSubviews];

    
    _backView.backgroundColor = [UIColor whiteColor];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(12, 15, 80, 14)];
    _label.text = @"(空)";
    _label.font = [UIFont systemFontOfSize:14];
    _label.textColor = [UIColor colorWithHexString:@"#cccccc"];
    _label.textAlignment = NSTextAlignmentLeft;
    [_backView addSubview:_label];
        
}

@end
