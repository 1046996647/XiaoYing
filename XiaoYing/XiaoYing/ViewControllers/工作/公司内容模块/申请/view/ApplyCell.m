//
//  ApprovalTableViewCell.m
//  XiaoYing
//
//  Created by ZWL on 15/11/14.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "ApplyCell.h"
#import "XYExtend.h"

@interface ApplyCell()
{
    UIImageView *_applicantImageview;       // 申请人的头像
    UILabel *_applicantNameLabel;           // 申请人姓名
    UILabel *_applicationTypeLabel;         // 申请的种类
    UILabel *_statusDescLabel;              // 状态的描述说明
    UILabel *_contentLabel;                 // 申请内容
    UILabel *_progressLabel;                // 申请进度
    UILabel *_tookTimeLabel;                // 已经花费的时间
    UILabel *_createTimeLabel;              // 申请日期
}
@end

@implementation ApplyCell

- (void)setApplicationModel:(ApplicationModel *)applicationModel
{
    _applicationModel = applicationModel;
    
    //-----申请人的头像
    [_applicantImageview sd_setImageWithURL:[NSURL URLWithString:[NSString replaceString:self.applicationModel.createrFaceUrl Withstr1:@"100" str2:@"100" str3:@"c"]]];
    
    //-----申请人姓名
    [_applicantNameLabel setText:self.applicationModel.createrName];
    
    //-----申请的种类
    [_applicationTypeLabel setText:self.applicationModel.applyTypeName];
    
    //-----状态的描述说明
    [_statusDescLabel setText:self.applicationModel.statusDesc];
    [_statusDescLabel setTextColor:self.applicationModel.statusDescColor];
    
    //-----申请进度
    [_contentLabel setText:self.applicationModel.context];
    
    //-----已经花费的时间
    [_progressLabel setText:self.applicationModel.progress];
    
    //-----创建申请的时间
    NSDate *createDate = [NSStringAndNSDate dateFromString:self.applicationModel.createTime];
    [_createTimeLabel setText: [NSStringAndNSDate stringFromDateYMD:createDate]];
    
    //-----已经过去多长时间
    NSString *passTime = [NSString stringWithFormat:@"已用时: %@", [NSStringAndNSDate passTimeFromCreateWithDate:createDate]];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:passTime];
    [attribute setAttributes:@{
                                NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"]
                                } range:NSMakeRange(0, 4)];
    [attribute setAttributes:@{
                                NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#f94040"]
                                } range:NSMakeRange(4, passTime.length - 4)];
    _tookTimeLabel.attributedText = attribute;
    
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        // 申请人的头像
        _applicantImageview = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 60, 60)];
        _applicantImageview.layer.cornerRadius = 6;
        _applicantImageview.clipsToBounds = YES;
        [self.contentView addSubview:_applicantImageview];
        
        // 申请人姓名
        _applicantNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _applicantImageview.height-15, 60, 15)];
        _applicantNameLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
        _applicantNameLabel.textAlignment = NSTextAlignmentCenter;
        _applicantNameLabel.layer.cornerRadius = 6;
        _applicantNameLabel.clipsToBounds = YES;
        _applicantNameLabel.font = [UIFont systemFontOfSize:11];
        _applicantNameLabel.textColor = [UIColor whiteColor];
        [_applicantImageview addSubview:_applicantNameLabel];
        
        // 申请的种类
        _applicationTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, 10, 106, 14)];
        _applicationTypeLabel.font = [UIFont systemFontOfSize:14];
        _applicationTypeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_applicationTypeLabel];
        
        // 状态的描述说明
        _statusDescLabel = [[UILabel alloc] initWithFrame: CGRectMake(kScreen_Width - _applicationTypeLabel.right + 12, 10, kScreen_Width - (kScreen_Width - _applicationTypeLabel.right + 12) - 12, 14)];
        _statusDescLabel.font = [UIFont systemFontOfSize:14];
        _statusDescLabel.textAlignment = NSTextAlignmentRight;
        _statusDescLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _statusDescLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        [self.contentView addSubview:_statusDescLabel];
        
        // 申请内容
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, 30, kScreen_Width - 100, 24)];
        _contentLabel.font = [UIFont systemFontOfSize:10];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        // 申请进度
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, 58, 30, 14)];
        _progressLabel.font = [UIFont systemFontOfSize:14];
        _progressLabel.textColor = [UIColor colorWithHexString:@"#02bb00"];
        [self.contentView addSubview:_progressLabel];
        
        // 申请耗费时间
        _tookTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(116, 58, 200, 14)];
        _tookTimeLabel.text = @"已用时: 36时39分";
        _tookTimeLabel.textAlignment = NSTextAlignmentLeft;
        _tookTimeLabel.font = [UIFont systemFontOfSize:14];
        NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:_tookTimeLabel.text];
        [attribute1 setAttributes:@{
                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"]
                                    } range:NSMakeRange(0, 4)];
        [attribute1 setAttributes:@{
                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#f94040"]
                                    } range:NSMakeRange(4, _tookTimeLabel.text.length - 4)];
        _tookTimeLabel.attributedText = attribute1;
        [self.contentView addSubview:_tookTimeLabel];
        
        // 申请时间
        _createTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 12 - 150, 58, 150, 12)];
        _createTimeLabel.text = @"2015-12-21";
        _createTimeLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _createTimeLabel.font = [UIFont systemFontOfSize:12];
        _createTimeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_createTimeLabel];
        
    }
    
    return self;
}

@end
