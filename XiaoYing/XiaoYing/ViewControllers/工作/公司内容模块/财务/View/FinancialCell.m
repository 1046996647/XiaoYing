//
//  FinancialCell.m
//  XiaoYing
//
//  Created by ZWL on 16/3/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FinancialCell.h"
@interface FinancialCell()
{
    UILabel *shopLab;//采购商品
    UILabel *dateLab;//时间
    UILabel *moneyLab;//金额
}
@end

@implementation FinancialCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        shopLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, kScreen_Width/2, 16)];
        shopLab.text = @"采购电脑";
        
        shopLab.textColor = [UIColor colorWithHexString:@"#333333"];
        shopLab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:shopLab];
        
        dateLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 6+16+5, kScreen_Width/2, 12)];
        dateLab.text = @"今天 14:41";
        
        dateLab.textColor = [UIColor colorWithHexString:@"#848484"];
        dateLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:dateLab];
        
        
        moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2+12+12, 6, kScreen_Width/2-12-12-12, 32)];
        moneyLab.text = @"-8697";
       
        moneyLab.textColor = [UIColor colorWithHexString:@"#f75d5c"];
        moneyLab.font = [UIFont systemFontOfSize:20];
        moneyLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:moneyLab];
        
        
    }
    return self;
}



@end
