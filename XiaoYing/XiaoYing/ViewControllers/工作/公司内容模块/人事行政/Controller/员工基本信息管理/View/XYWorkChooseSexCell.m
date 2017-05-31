//
//  XYWorkChooseSexCell.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/7/28.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "XYWorkChooseSexCell.h"

@implementation XYWorkChooseSexCell

//初始化cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }

        
        //创建label
        _chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
        _chooseLabel.font = [UIFont systemFontOfSize:16];
        _chooseLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _chooseLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_chooseLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
