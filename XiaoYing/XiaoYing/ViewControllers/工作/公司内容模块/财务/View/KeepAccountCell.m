//
//  KeepAccountCell.m
//  XiaoYing
//
//  Created by ZWL on 16/3/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "KeepAccountCell.h"

@interface KeepAccountCell()
{
    UILabel *leftLab;
    UILabel *rightLab;
}
@end

@implementation KeepAccountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        leftLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 40, 44)];
        leftLab.text = @"公司";
        leftLab.textColor = [UIColor colorWithHexString:@"#333333"];
        leftLab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:leftLab];
        
        rightLab = [[UILabel alloc] initWithFrame:CGRectMake(12+40+12, 0, kScreen_Width-(12+40+12+12), 44)];
        rightLab.text = @"杭州赢萊金融信息服务有限公司";
        rightLab.textColor = [UIColor colorWithHexString:@"#848484"];
        rightLab.font = [UIFont systemFontOfSize:14];
        rightLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:rightLab];
    }
    return self;
    
}


@end
