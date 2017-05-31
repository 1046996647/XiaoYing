//
//  AttendanceSignCell.m
//  XiaoYing
//
//  Created by ZWL on 16/1/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AttendanceSignCell.h"
#import "AttendanceSignModel.h"
@interface AttendanceSignCell()

@property (nonatomic,strong) UILabel *morningLab;//上午下午
@property (nonatomic,strong) UILabel *timeLab;//时间
@property (nonatomic,strong) UILabel *distanceLab;//距离签到地点

@property (nonatomic,strong) UIView *spaceView;//框

@end


@implementation AttendanceSignCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.spaceView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width-90, 44)];
        self.spaceView.layer.borderWidth = 0.5;
        self.spaceView.backgroundColor = [UIColor whiteColor];
        self.spaceView.layer.borderColor = [[UIColor colorWithHexString:@"#d5d7dc"] CGColor];
        self.spaceView.clipsToBounds = YES;
        self.spaceView.layer.cornerRadius = 5;
        [self.contentView addSubview:self.spaceView];
        
        self.morningLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 100, 14)];
        self.morningLab.text = @"上午上班";
        self.morningLab.textColor = [UIColor colorWithHexString:@"#333333"];
        self.morningLab.font = [UIFont systemFontOfSize:14];
        
        [self.spaceView addSubview:self.morningLab];
        
        self.distanceLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 24, 100, 12)];
        self.distanceLab.text = @"距离签到点100米";
        self.distanceLab.textColor = [UIColor colorWithHexString:@"#848484"];
        self.distanceLab.font = [UIFont systemFontOfSize:12];
        
        [self.spaceView addSubview:self.distanceLab];
        
        self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.spaceView.frame.size.width-100, 2, 90, 40)];
        self.timeLab.text = @"00:00-00:30";
        self.timeLab.textColor = [UIColor colorWithHexString:@"#848484"];
        self.timeLab.font = [UIFont systemFontOfSize:14];
        self.timeLab.textAlignment = NSTextAlignmentCenter;
        [self.spaceView addSubview:self.timeLab];
        
        self.signBt = [UIButton buttonWithType:UIButtonTypeCustom];
        self.signBt.frame = CGRectMake(kScreen_Width-70, 1, 62, 42);
        [self.signBt setTitle:@"已签" forState:UIControlStateNormal];
        [self.signBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.signBt.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
      
        self.signBt.layer.cornerRadius = 5;
        self.signBt.clipsToBounds = YES;
        self.signBt.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.signBt];

    }
    return self;
}

- (void)setModel:(AttendanceSignModel *)model{
    self.morningLab.text = model.morningStr;
    self.distanceLab.text = model.distanceStr;
    self.timeLab.text = model.timeStr;
    if (model.modelFlag == 1) {
        NSLog(@"已签");
        self.signBt.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        [self.signBt setTitle:@"已签" forState:UIControlStateNormal];
    }else if(model.modelFlag == 2){
        NSLog(@"漏签");
        self.signBt.backgroundColor = [UIColor colorWithHexString:@"#f75d5c"];
        [self.signBt setTitle:@"漏签" forState:UIControlStateNormal];
    }else if(model.modelFlag == 3){
        NSLog(@"早签");
        self.signBt.backgroundColor = [UIColor colorWithHexString:@"#f7cb5c"];
        [self.signBt setTitle:@"早签" forState:UIControlStateNormal];
    }else if(model.modelFlag == 4){
        NSLog(@"签到");
        self.signBt.backgroundColor = [UIColor colorWithHexString:@"#60c8f7"];
        [self.signBt setTitle:@"签到" forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
