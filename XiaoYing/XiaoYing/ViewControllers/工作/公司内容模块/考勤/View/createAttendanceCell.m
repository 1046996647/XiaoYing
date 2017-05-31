//
//  createAttendanceCell.m
//  XiaoYing
//
//  Created by ZWL on 16/1/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "createAttendanceCell.h"
@interface createAttendanceCell()

@property (nonatomic,strong) UITextField *titleField;//标题
@property (nonatomic,strong) UILabel *attendanceLab;//考勤对象
@property (nonatomic,strong) UILabel *attendanceCountLab;//考勤对象的数量
@property (nonatomic,strong) UILabel *repeatLab;//重复
@property (nonatomic,strong) UILabel *repeatWeekLab;//周1，周2，周3，周4

@property (nonatomic,strong)UILabel *signLab;//签到
@property (nonatomic,strong)UILabel *morningTitleLab; //标题


@end

@implementation createAttendanceCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        if ([reuseIdentifier isEqualToString:@"cell1"]) {
            self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, kScreen_Width-24, self.contentView.frame.size.height)];
            self.titleField.placeholder = @"标题";
            self.titleField.font = [UIFont systemFontOfSize:16];
            [self.contentView addSubview:self.titleField];
        }else if ([reuseIdentifier isEqualToString:@"cell2"]){
            self.attendanceLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, self.contentView.frame.size.height)];
            self.attendanceLab.text = @"考勤对象";
            self.attendanceLab.textColor = [UIColor colorWithHexString:@"#333333"];
            self.attendanceLab.font = [UIFont systemFontOfSize:16];
            [self.contentView addSubview:self.attendanceLab];
            
            self.attendanceCountLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-136, 0, 105, self.contentView.frame.size.height)];
            self.attendanceCountLab.text = @"107";
            self.attendanceCountLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
            self.attendanceCountLab.font = [UIFont systemFontOfSize:14];
            self.attendanceCountLab.textAlignment = NSTextAlignmentRight;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self.contentView addSubview:self.attendanceCountLab];
            
        }else if ([reuseIdentifier isEqualToString:@"cell3"]){
            self.repeatLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 40, self.contentView.frame.size.height)];
            self.repeatLab.text = @"重复";
            self.repeatLab.textColor = [UIColor colorWithHexString:@"#333333"];
            self.repeatLab.font = [UIFont systemFontOfSize:16];
            [self.contentView addSubview:self.repeatLab];
            
            self.repeatWeekLab = [[UILabel alloc] initWithFrame:CGRectMake(52, 0, kScreen_Width-80, self.contentView.frame.size.height)];
            self.repeatWeekLab.text = @"周一 周二 周三 周四 周五 周六 周日";
            self.repeatWeekLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
            self.repeatWeekLab.font = [UIFont systemFontOfSize:14];
            self.repeatWeekLab.textAlignment = NSTextAlignmentRight;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self.contentView addSubview:self.repeatWeekLab];
            
        }else if ([reuseIdentifier isEqualToString:@"cell4"]){
            
            UILabel *signLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 40, 12)];
            signLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
            signLab.text = @"签到一";
            signLab.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:signLab];
            
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, 12+12+8, kScreen_Width-24, 44*3)];
            view.layer.cornerRadius = 5;
            view.clipsToBounds = YES;
            view.layer.borderColor = [[UIColor colorWithHexString:@"#d5d7dc"] CGColor];
            view.layer.borderWidth = 0.5;
            view.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:view];
            
            
            UITextField *titleField1;
            titleField1 = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, view.frame.size.width-24, 43.5)];
            titleField1.placeholder = @"标题";
            titleField1.font = [UIFont systemFontOfSize:16];
            [view addSubview: titleField1];
            
            UIView *viewline1 = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, view.frame.size.width, 0.5)];
            viewline1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
            [view addSubview:viewline1];
            
            UIView *viewline2 = [[UIView alloc] initWithFrame:CGRectMake(0, 44+43.5, view.frame.size.width, 0.5)];
            viewline2.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
            [view addSubview:viewline2];
            
            
//            UILabel *setSignTimeLab;//设置签到点
            _setSignTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 44, 100, 43.5)];
            _setSignTimeLab.text = @"设置签到点";
            _setSignTimeLab.textColor = [UIColor colorWithHexString:@"#333333"];
            _setSignTimeLab.font = [UIFont systemFontOfSize:16];
            [view addSubview:_setSignTimeLab];
            
            
        //    UILabel *hitSignLab;//点击设置
            _hitSignLab = [[UILabel alloc] initWithFrame:CGRectMake(150, 44, view.frame.size.width-150-24, 43.5)];
            _hitSignLab.text = @"点击设置";
            _hitSignLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
            _hitSignLab.font = [UIFont systemFontOfSize:14];
            _hitSignLab.textAlignment = NSTextAlignmentRight;
            [view addSubview:_hitSignLab];

            UIButton *startTimeBt;//开始时间
            UIButton *endTimeBt;//到什么时间
            
            startTimeBt = [UIButton buttonWithType:UIButtonTypeCustom];
            startTimeBt.frame = CGRectMake(0, 87.5, view.frame.size.width/2-0.25, 44);
            [startTimeBt setTitle:@"开始时间" forState:UIControlStateNormal];
            [startTimeBt setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            startTimeBt.titleLabel.font = [UIFont systemFontOfSize:16];
            [view addSubview:startTimeBt];
            
            
            endTimeBt = [UIButton buttonWithType:UIButtonTypeCustom];
            endTimeBt.frame = CGRectMake(view.frame.size.width/2+0.25, 87.5, view.frame.size.width/2-0.25, 44);
            [endTimeBt setTitle:@"结束时间" forState:UIControlStateNormal];
            [endTimeBt setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            endTimeBt.titleLabel.font = [UIFont systemFontOfSize:16];
            [view addSubview:endTimeBt];
            
            UIView *viewline3;
            
            viewline3 = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width/2-0.25, 87.5, 0.5, 44)];
            viewline3.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
            [view addSubview:viewline3];
            
            
            
        }else{
            
        }
    }
    return self;
}



@end
