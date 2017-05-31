//
//  ApproalCell.m
//  XiaoYing
//
//  Created by YL20071 on 16/10/19.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ApproalCell.h"

@interface ApproalCell()
{
    UIImageView *_applicantImageview;       // 申请人的头像
    UILabel *_applicantNameLabel;           // 申请人姓名
    UILabel *_applicationTypeLabel;         // 申请的种类
    UILabel *_statusDescLabel;              // 状态的描述说明
    UILabel *_contentLabel;                 // 申请内容
    UILabel *_progressLabel;                // 申请进度
    UILabel *_tookTimeLabel;                // 已经花费的时间
    UILabel *_createTimeLabel;              // 申请日期
    UILabel *_createDetailTimeLabel;        // 申请的时间
}
@end

@implementation ApproalCell

-(void)setApprovalModel:(ApprovalModel *)approvalModel{
    _approvalModel = approvalModel;
    NSArray *timeArray = [approvalModel.timeSpan componentsSeparatedByString:@"分"];
    NSString *timeStr = timeArray[0];
    NSInteger time = [timeStr integerValue];
   // NSLog(@"timeStr:%ld",time);
    NSInteger minutes = time % 60;
    NSInteger hours = (time / 60);
    NSString *iconStr = [NSString replaceString:approvalModel.createFaceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [_applicantImageview sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"face"]];

    [_applicantNameLabel setText:approvalModel.createrName];
    
    [_applicationTypeLabel setText:approvalModel.applyTypeName];
    [_statusDescLabel setText:approvalModel.statusDesc];
    if (approvalModel.status == 5) {//审核通过
        [_statusDescLabel setTextColor:[UIColor colorWithHexString:@"#02bb00"]];
    }
    if (approvalModel.status == 1) {//审批中
        [_statusDescLabel setHidden:YES];
    }
    
    if (approvalModel.status == 6 ||approvalModel.status == 3) {//未通过或者越级审批
        [_statusDescLabel setTextColor:[UIColor colorWithHexString:@"#f94040"]];
    }
    [_contentLabel setText:approvalModel.context];
    [_progressLabel setText:approvalModel.progress];
    
    //设置开始的时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateTime = [formatter stringFromDate:approvalModel.createTime];
    NSString *day = [dateTime substringToIndex:10];
    _createTimeLabel.text = day;
    
//    //设置审批用时
//    NSDate *currentDate=[NSDate date];//获取当前时间
//    NSDate *applyDate = approvalModel.createTime;//申请发出的时间
//   
//    NSLog(@"applyDate:%@",applyDate);
////    // 当前时间与申请发出的时间之间的时间差（秒）
//     double intervalTime = [currentDate timeIntervalSinceReferenceDate] - [applyDate timeIntervalSinceReferenceDate];
//    NSInteger time = (NSInteger)intervalTime;
//     NSLog(@"createtime:%ld",time);
//    NSInteger minutes = (time / 60) % 60;
//    NSInteger hours = (time / 3600);
    
   
    if (self.overed == YES) {//是已审批的cell
        [_statusDescLabel setHidden:NO];
        //设置已用时
        if (hours == 0) {
            _tookTimeLabel.text = [NSString stringWithFormat:@"用时:%ld分",minutes];
        }else{
            _tookTimeLabel.text = [NSString stringWithFormat:@"用时:%ld小时%ld分",hours,minutes];
        }
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:_tookTimeLabel.text];
        [attribute setAttributes:@{
                                   NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"]
                                   } range:NSMakeRange(0, 3)];
        [attribute setAttributes:@{
                                   NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#f94040"]
                                   } range:NSMakeRange(3, _tookTimeLabel.text.length - 3)];
        _tookTimeLabel.attributedText = attribute;
    }else{
        if (hours == 0) {
            _tookTimeLabel.text = [NSString stringWithFormat:@"已用时:%ld分",minutes];
        }else{
            _tookTimeLabel.text = [NSString stringWithFormat:@"已用时:%ld小时%ld分",hours,minutes];
        }
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:_tookTimeLabel.text];
        [attribute setAttributes:@{
                                   NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"]
                                   } range:NSMakeRange(0, 4)];
        [attribute setAttributes:@{
                                   NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#f94040"]
                                   } range:NSMakeRange(4, _tookTimeLabel.text.length - 4)];
        _tookTimeLabel.attributedText = attribute;
    }
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        // 申请人的头像
        _applicantImageview = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 60, 60)];
        _applicantImageview.image = [UIImage imageNamed:@"finance"];
        _applicantImageview.layer.cornerRadius = 6;
        _applicantImageview.clipsToBounds = YES;
        [self.contentView addSubview:_applicantImageview];
        
        // 申请人姓名
        _applicantNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _applicantImageview.height-15, 60, 15)];
        _applicantNameLabel.text = @"应俊俊";
        _applicantNameLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
        _applicantNameLabel.textAlignment = NSTextAlignmentCenter;
        _applicantNameLabel.layer.cornerRadius = 6;
        _applicantNameLabel.clipsToBounds = YES;
        _applicantNameLabel.font = [UIFont systemFontOfSize:11];
        _applicantNameLabel.textColor = [UIColor whiteColor];
        [_applicantImageview addSubview:_applicantNameLabel];
        
        // 申请的种类
        _applicationTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, 10, 150, 14)];
        _applicationTypeLabel.text = @"标题";
        _applicationTypeLabel.font = [UIFont systemFontOfSize:14];
        _applicationTypeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_applicationTypeLabel];
        
        // 状态的描述说明
        _statusDescLabel = [[UILabel alloc] initWithFrame: CGRectMake(kScreen_Width - 12 - 200, 10, 200, 14)];
        _statusDescLabel.text = @"等待孟凡表审批";
        _statusDescLabel.font = [UIFont systemFontOfSize:14];
        _statusDescLabel.textAlignment = NSTextAlignmentRight;
        _statusDescLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        [self.contentView addSubview:_statusDescLabel];
        
        // 申请内容
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, 30, kScreen_Width - 100, 24)];
        _contentLabel.text = @"申请内容申请内容申请内容申请内容申请内容申请内容申请内容申请内容";
        _contentLabel.font = [UIFont systemFontOfSize:10];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        // 申请进度
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, 58, 30, 14)];
        _progressLabel.text = @"6/7";
        _progressLabel.font = [UIFont systemFontOfSize:14];
        _progressLabel.textColor = [UIColor colorWithHexString:@"#02bb00"];
        [self.contentView addSubview:_progressLabel];
        
        // 申请耗费时间
        _tookTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(116, 58, 200, 14)];
//        _tookTimeLabel.text = @"已用时: 36时39分";
        _tookTimeLabel.textAlignment = NSTextAlignmentLeft;
        _tookTimeLabel.font = [UIFont systemFontOfSize:14];
//        NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:_tookTimeLabel.text];
//        [attribute1 setAttributes:@{
//                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"]
//                                    } range:NSMakeRange(0, 4)];
//        [attribute1 setAttributes:@{
//                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#f94040"]
//                                    } range:NSMakeRange(4, _tookTimeLabel.text.length - 4)];
//        _tookTimeLabel.attributedText = attribute1;
        [self.contentView addSubview:_tookTimeLabel];
        
        // 申请时间
        _createTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 12 - 150, 58, 150 + 2, 12)];
        _createTimeLabel.text = @"2015-12-21";
        _createTimeLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _createTimeLabel.font = [UIFont systemFontOfSize:12];
        _createTimeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_createTimeLabel];
        
    }
    
    return self;
}

@end
