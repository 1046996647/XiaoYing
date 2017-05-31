//
//  PersonalpermissionCe.m
//  XiaoYing
//
//  Created by GZH on 16/9/22.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "PersonalpermissionCe.h"

@implementation PersonalpermissionCe

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.label];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (UILabel *)label {
    if (_label == nil) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, kScreen_Width, 44)];
        _label.text = @"(空)";
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor colorWithHexString:@"#cccccc"];
        
    }
    return _label;
}


@end
