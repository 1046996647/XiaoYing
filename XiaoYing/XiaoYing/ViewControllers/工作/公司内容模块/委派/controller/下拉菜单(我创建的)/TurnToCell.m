//
//  TurnToCell.m
//  XiaoYing
//
//  Created by ZWL on 16/5/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "TurnToCell.h"

@implementation TurnToCell

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
        
        _nameLab = [[UILabel alloc] initWithFrame:_nameLab.frame = CGRectMake(0, 0, kScreen_Width, 50)];
        _nameLab.font = [UIFont systemFontOfSize:16];
        _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLab];
    }
    return self;
}




@end
