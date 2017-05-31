//
//  MyCustomerCell.m
//  XiaoYing
//
//  Created by ZWL on 16/2/1.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "MyCustomerCell.h"
@interface MyCustomerCell()
{
    
}
@property (nonatomic,strong)UIImageView *headImageview;//头像
@property (nonatomic,strong)UILabel *nameLab;//姓名
@property (nonatomic,strong)UIImageView *sexImageview;//性别


@end
@implementation MyCustomerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.headImageview = [[UIImageView alloc] initWithFrame:CGRectMake(12, 7, 30, 30)];
        self.headImageview.image = [UIImage imageNamed:@"1.1.png"];
        self.headImageview.layer.cornerRadius = 5;
        self.headImageview.clipsToBounds = YES;
        [self.contentView addSubview:self.headImageview];
        
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(12+30+12, 7, 150, 30)];
        self.nameLab.text = @"钱老板";
        self.nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
        self.nameLab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.nameLab];
        
        self.sexImageview = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width-30, 14.5, 12, 15)];
        
        if (markFlag >5) {
            self.sexImageview.image = [UIImage imageNamed:@"customer_woman"];
            markFlag --;
        }else{
            self.sexImageview.image = [UIImage imageNamed:@"customer_man"];
            markFlag ++;
        }
        [self.contentView addSubview:self.sexImageview];
        
    }
    return self;
}
int markFlag = 0;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
