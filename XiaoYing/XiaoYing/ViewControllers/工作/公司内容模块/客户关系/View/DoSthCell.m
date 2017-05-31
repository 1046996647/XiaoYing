//
//  DoSthCell.m
//  XiaoYing
//
//  Created by ZWL on 16/2/2.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DoSthCell.h"
@interface DoSthCell()
{
    
}
@property (nonatomic,strong) UIImageView *headImageview;//重要程度
@property (nonatomic,strong) UILabel *titleLab;//标题
@property (nonatomic,strong) UILabel *departmentLab;//部门-人员
@property (nonatomic,strong) UILabel *dateTimeLab;//时间

@property (nonatomic,strong) UIView *rightView;//右边的View
@property (nonatomic,strong) UILabel *customLab;//客户
@property (nonatomic,strong) UIImageView *stateImageview;//完成状态

@end

@implementation DoSthCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //重要程度
        self.headImageview = [[UIImageView alloc] initWithFrame:CGRectMake(12, 7, 15, 15)];
        self.headImageview.image = [UIImage imageNamed:@"red"];
        [self.contentView addSubview:self.headImageview];
        
        //标题
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10+12+15, 7, 100, 16)];
        self.titleLab.text = @"标题";
        self.titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        self.titleLab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.titleLab];
        
        //部门
        self.departmentLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 7+16+6, 150, 12)];
        self.departmentLab.textColor = [UIColor colorWithHexString:@"#848484"];
        self.departmentLab.text = @"科技产业部-应俊俊";
        self.departmentLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.departmentLab];
        
        
        
        self.rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width-150, 0, 138, 50)];
        [self.contentView addSubview:self.rightView];
        
        //时间
        self.dateTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 138, 12)];
        self.dateTimeLab.text = @"2016-01-28 13:00";
        self.dateTimeLab.textColor = [UIColor colorWithHexString:@"#848484"];
        self.dateTimeLab.font = [UIFont systemFontOfSize:12];
        self.dateTimeLab.textAlignment = NSTextAlignmentRight;
        [self.rightView addSubview:self.dateTimeLab];
        
        //客户
        self.customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 7+12+7, 138, 12)];
        self.customLab.text = @"客户:钱老板";
        self.customLab.textColor = [UIColor colorWithHexString:@"#848484"];
        self.customLab.font = [UIFont systemFontOfSize:12];
        self.customLab.textAlignment = NSTextAlignmentRight;
        [self.rightView addSubview:self.customLab];
        
        markFlag ++;
        if (markFlag > 3) {
            self.rightView.frame = CGRectMake(kScreen_Width-200, 0, 138, 50);
            self.stateImageview = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width-62+6, 7, 62-6-12, 36)];
            if (markFlag >6) {
                self.stateImageview.image = [UIImage imageNamed:@"customer_finish"];
            }else{
                self.stateImageview.image = [UIImage imageNamed:@"customer_nofinish"];
            }
            [self.contentView addSubview:self.stateImageview];
            
        }

        
    }
    return self;
}

static int markFlag= 0;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
