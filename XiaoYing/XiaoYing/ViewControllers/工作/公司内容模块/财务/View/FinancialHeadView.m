//
//  FinancialHeadView.m
//  XiaoYing
//
//  Created by ZWL on 16/3/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FinancialHeadView.h"
@interface FinancialHeadView()
{
    UILabel *timeLab;//时间
    UILabel *IncomeAndExpensesLab;//收支差
}
@end
@implementation FinancialHeadView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        timeLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, 30)];
        timeLab.text = @"2016-2";
        timeLab.textAlignment = NSTextAlignmentLeft;
        timeLab.font = [UIFont systemFontOfSize:14];
        timeLab.textColor = [UIColor colorWithHexString:@"#848484"];
        [self addSubview:timeLab];
        
        IncomeAndExpensesLab = [[UILabel alloc] initWithFrame:CGRectMake(112, 0, kScreen_Width-112-12, 30)];
        IncomeAndExpensesLab.text = @"收支差:-8697";
        IncomeAndExpensesLab.textAlignment = NSTextAlignmentRight;
        IncomeAndExpensesLab.font = [UIFont systemFontOfSize:14];
        IncomeAndExpensesLab.textColor = [UIColor colorWithHexString:@"#f75d5c"];
        [self addSubview:IncomeAndExpensesLab];

        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
