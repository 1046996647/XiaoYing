//
//  ApproalPocessCell.m
//  XiaoYing
//
//  Created by YL20071 on 16/10/19.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ApproalPocessCell.h"
#import "ApproalProcessVC.h"
#import "ImagePlayerViewController.h"
#import "PlayVoiceView.h"

//NSString const *kRefreshTableViewNotification = @"kRefreshTableViewNotification";

@interface ApproalPocessCell ()
{
    UIView *_verticalLine;                       // 连接头像之间的竖线
    UIImageView *_headerImage;                   // 头像
    UILabel *_agreeTimeLab;                      // 审批同意的时间
    UIImageView *_backgroundImage;               // 气泡背景

    UILabel *_approverLab;                       // 审批人
    UILabel *_agreeOrNotLab;                     // 同意还是不同意
    UILabel *_tookTimeLab;                       // 该审批人的审批时间
    UIButton *_suggestionBtn;                    // 审批意见展示按钮
    UILabel *_aprovalSuggestionLab;              // 审批意见
    NSMutableArray *_imageURLsArray;             // 图片URL数组
}
@end

@implementation ApproalPocessCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        [self setupSubviews];
    }
    return self;
}

#pragma mark - ViewsCreate

// 创建视图
- (void)setupSubviews {
    
    // 竖线
    _verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_verticalLine];
    
    // 头像所在的方形
    UIView *rectView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 35, 35+3*2)];
    rectView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    //rectView.backgroundColor = [UIColor colorWithHexString:@"#848484"];
    [self.contentView addSubview:rectView];
    
    // 头像
    _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    _headerImage.clipsToBounds = YES;
    _headerImage.center = rectView.center;
    _headerImage.image = [UIImage imageNamed:@"ying"];
    _headerImage.layer.borderWidth = 2.5;
    _headerImage.layer.cornerRadius = 35/2.0;
    [self.contentView addSubview:_headerImage];
    
    // 审批同意时间
    _agreeTimeLab = [self createLabelWithTitle:@"2012-12-23 10:29" andFrame:CGRectMake(_headerImage.right+10, 10, 200, 10)];
    _agreeTimeLab.font = [UIFont systemFontOfSize:10];
    _agreeTimeLab.textColor = [UIColor colorWithHexString:@"#848484"];
    [self.contentView addSubview:_agreeTimeLab];
    
    // 气泡背景
    _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(_headerImage.right+3, 24, kScreen_Width - 40 - 19, 58)];
    UIImage *image = [UIImage imageNamed:@"record"];
    image = [image stretchableImageWithLeftCapWidth:50 topCapHeight:50];
    _backgroundImage.image = image;
    _backgroundImage.userInteractionEnabled = YES;
    [self.contentView addSubview:_backgroundImage];
    
    // 创建气泡背景内视图
    [self setupCellSubViews];
}

/**
 *  创建气泡背景内部视图
 */
- (void)setupCellSubViews {
    
    // 审批人
    _approverLab = [self createLabelWithTitle:@"李大谦" andFrame:CGRectMake(15, 13, 100 + 60, 14)];
    _approverLab.font = [UIFont systemFontOfSize:14];
    _approverLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_backgroundImage addSubview:_approverLab];
    
    // 同意
    _agreeOrNotLab = [self createLabelWithTitle:@"同意" andFrame:CGRectMake(15, 34, 150, 12)];
    _agreeOrNotLab.font = [UIFont systemFontOfSize:12];
    _agreeOrNotLab.textColor = [UIColor colorWithHexString:@"#02bb00"];
    [_backgroundImage addSubview:_agreeOrNotLab];
    
    // 该审批人的审批时间
    _tookTimeLab = [self createLabelWithTitle:@"用时:1小时40分" andFrame:CGRectMake(158, 13, _backgroundImage.frame.size.width - 158 - 9, 10)];
    _tookTimeLab.font = [UIFont systemFontOfSize:10];
    _tookTimeLab.textColor = [UIColor colorWithHexString:@"#848484"];
    _tookTimeLab.textAlignment = NSTextAlignmentRight;
    [_backgroundImage addSubview:_tookTimeLab];
    
    
    // 审批意见展示按钮(aprovalSuggestionAction:)
    _suggestionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_suggestionBtn setTitle:@" 审批意见" forState: UIControlStateNormal];
    _suggestionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_suggestionBtn setTitleColor:[UIColor colorWithHexString:@"#cccccc"] forState:UIControlStateNormal];
    [_suggestionBtn setImage:[UIImage imageNamed:@"opinion_read"] forState:UIControlStateNormal];
    [_suggestionBtn setImage:[UIImage imageNamed:@"opinion_reading"] forState:UIControlStateSelected];
    _suggestionBtn.frame = CGRectMake(_backgroundImage.frame.size.width - 78, 35, 70, 12);
    [_suggestionBtn addTarget:self action:@selector(aprovalSuggestionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"opinion_read"];
    [_suggestionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, image.size.width - 6, 0, 0)];
    [_suggestionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _suggestionBtn.titleLabel.bounds.size.width , 0, -_suggestionBtn.titleLabel.bounds.size.width )];
    [_backgroundImage addSubview:_suggestionBtn];
    
    // 审批意见lab
    _aprovalSuggestionLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _aprovalSuggestionLab.numberOfLines = 0;
    _aprovalSuggestionLab.font = [UIFont systemFontOfSize:10];
    _aprovalSuggestionLab.textColor = [UIColor colorWithHexString:@"#848484"];
    _aprovalSuggestionLab.hidden = YES;
    [_backgroundImage addSubview:_aprovalSuggestionLab];
    
    // 照片浏览按钮
    _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imageBtn setImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
    _imageBtn.hidden = YES;
    [_backgroundImage addSubview:_imageBtn];
    
    // 语音播放按钮
    _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _voiceBtn.hidden = YES;
    [_voiceBtn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [_backgroundImage addSubview:_voiceBtn];
    
    [_imageBtn addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
    [_voiceBtn addTarget:self action:@selector(VoiceAction:) forControlEvents:UIControlEventTouchUpInside];
    
}





/**
 *  刷新视图
 */
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    NSLog(@"layoutSubviews");
    
    _verticalLine.frame = CGRectMake(_headerImage.center.x-1, 0, 2, self.height);
//    _verticalLine.backgroundColor = [UIColor colorWithHexString:@"#02bb00"];
//    
//    _headerImage.layer.borderColor = [[UIColor colorWithHexString:@"#02bb00"] CGColor];
    
   // NSString *text = self.approvalPeople.suggestion;
    NSString *text = self.flowModel.comment;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreen_Width-60-12-30, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                                                                                                                                              NSFontAttributeName : [UIFont systemFontOfSize:10]
                                                                                                                                              } context:nil];
    
    _aprovalSuggestionLab.frame = CGRectMake(15, 55, _backgroundImage.width - 9  - 9, rect.size.height);
    _aprovalSuggestionLab.text = text;
    _imageBtn.frame = CGRectMake(12, _aprovalSuggestionLab.bottom+7, 25, 20);
    _voiceBtn.frame = CGRectMake(_imageBtn.right+25, _imageBtn.top, 25, 20);
    
    if (self.flowModel.isExpand) {
        
        _suggestionBtn.selected = YES;
        
        //一些判断
        //如果没有审批意见，没有图片
        if (self.flowModel.photos.count == 0 && [self.flowModel.comment isEqualToString:@""]) {
            _aprovalSuggestionLab.hidden = NO;
            _imageBtn.hidden = YES;
            _aprovalSuggestionLab.height = .5;
           // _backgroundImage.height = _aprovalSuggestionLab.bottom;
        }
        //如果有审批意见，没有图片
        if (self.flowModel.photos.count == 0 && ![self.flowModel.comment isEqualToString:@""]) {
            _aprovalSuggestionLab.hidden = NO;
            _imageBtn.hidden = YES;
            _backgroundImage.height = _aprovalSuggestionLab.bottom+10;
        }
        //如果没有审批意见，有图片
        if (self.flowModel.photos.count !=0 && [self.flowModel.comment isEqualToString:@""]) {
            _aprovalSuggestionLab.hidden = NO;
            _imageBtn.hidden = NO;
            _aprovalSuggestionLab.height = .5;
            _imageBtn.top = _aprovalSuggestionLab.bottom+7;
             _backgroundImage.height = _imageBtn.bottom+10;
        }
        //有审批意见，有图片
        if (self.flowModel.photos.count !=0 && ![self.flowModel.comment isEqualToString:@""]) {
            _aprovalSuggestionLab.hidden = NO;
            _imageBtn.hidden = NO;
            _backgroundImage.height = _imageBtn.bottom+10;
        }
    } else {
        _suggestionBtn.selected = NO;
        _aprovalSuggestionLab.hidden = YES;
        _imageBtn.hidden = YES;
        //_voiceBtn.hidden = YES;
        _backgroundImage.height = 58;
    }
    
}

// 点击 审批意见按钮
- (void)aprovalSuggestionAction:(UIButton *)btn {
    
    self.flowModel.isExpand = !self.flowModel.isExpand;
    
    [(ApproalProcessVC *)self.viewController reloadTableView];
}

#pragma mark - ButtonActions
// 图片浏览按钮Action
- (void)imageAction:(UIButton *)btn {
    // 模板
    ImagePlayerViewController *imagePlayerVC = [[ImagePlayerViewController alloc] init];
//    imagePlayerVC.imageArray = @[
//                                 @"h",
//                                 @"b",
//                                 @"c",
//                                 @"i",
//                                 @"e",
//                                 ];
//    [self.viewController.navigationController pushViewController:imagePlayerVC animated:YES];
    imagePlayerVC.imageArray = _imageURLsArray;
    [self.viewController presentViewController:imagePlayerVC animated:YES completion:nil];
}

// 声音播放按钮Action
- (void)VoiceAction:(UIButton *)btn {
    
    PlayVoiceView *voiceView = [[PlayVoiceView alloc] initWithFrame:self.bounds];
    [self.viewController.view addSubview:voiceView];
    voiceView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        voiceView.hidden = NO;
        voiceView.transform = CGAffineTransformIdentity;
        voiceView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        voiceView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        voiceView.transform = CGAffineTransformIdentity;
    }];
    
}

// 封装的一个UILabel的生成器
- (UILabel *)createLabelWithTitle:(NSString *)str andFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = str;
    label.font = [UIFont systemFontOfSize:13];
    return label;
}

-(void)setFlowModel:(FlowModel *)flowModel{
    _flowModel = flowModel;
    
    //设置图片数组
    _imageURLsArray = [NSMutableArray array];
    for (NSDictionary *urlDic in flowModel.photos) {
        NSString *url = urlDic[@"URL"];
        NSString *imageStr = [NSString replaceString:url Withstr1:@"1000" str2:@"1000" str3:@"c"];
        [_imageURLsArray addObject:imageStr];
    }

    //设置头像
    NSString *iconStr = [NSString replaceString:flowModel.commenterFaceFormatUrl Withstr1:@"100" str2:@"100" str3:@"c"];
     NSURL *headURL = [NSURL URLWithString:iconStr];
    [_headerImage sd_setImageWithURL:headURL placeholderImage:[UIImage imageNamed:@"face"]];
    
    //设置审批人
    _approverLab.text = [NSString stringWithFormat:@"%@ %@",flowModel.commneterName,flowModel.commenterJobName];
    
    if ([flowModel.commenterJobName isEqualToString:@""] ) {//如果审批人没有职务名称的话
        _approverLab.text = [NSString stringWithFormat:@"%@",flowModel.commneterName];
    }
    
    
    //设置审批意见
    _aprovalSuggestionLab.text = flowModel.comment;
    if (![flowModel.comment isEqualToString:@""] || flowModel.photos.count !=0) {
        [_suggestionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if ([_approverLab.text isEqualToString:@""]) {//没有审批意见
        _approverLab.height = .5;
    }
    
//    //设置同意还是不同意
//    _agreeOrNotLab.text = flowModel.
    
    //根据审批状态的变换做出的一些改变
    if (flowModel.status == 0) {//待审批
//        _tookTimeLab.hidden = YES;
        _tookTimeLab.text = @"用时:0";
        _agreeTimeLab.hidden = YES;
        _agreeOrNotLab.text = @"待审批";
        _suggestionBtn.userInteractionEnabled = NO;//展开审批按钮设为不能点击
         [_suggestionBtn setImage:[UIImage imageNamed:@"opinion_noread"] forState:UIControlStateNormal];
        _verticalLine.backgroundColor = [UIColor colorWithHexString:@"#848484"];
        _headerImage.layer.borderColor = [[UIColor colorWithHexString:@"#848484"] CGColor];
        _agreeOrNotLab.textColor = [UIColor colorWithHexString:@"#848484"];
    }
    if (flowModel.status == 1 || flowModel.status == 3) {//审批中
        _suggestionBtn.userInteractionEnabled = NO;//展开审批按钮设为不能点击
          [_suggestionBtn setImage:[UIImage imageNamed:@"opinion_noread"] forState:UIControlStateNormal];
        _agreeOrNotLab.text = @"审批中";
        
        if (self.index == 0) {//如果处于第一层级
            //设置开始的时间
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *dateTime = [formatter stringFromDate:flowModel.submitTime];
            _agreeTimeLab.text = dateTime;
            
            //设置审批用时
            NSDate *currentDate=[NSDate date];//获取当前时间
            NSDate *applyData = flowModel.submitTime;//申请发出的时间
            // 当前时间与申请发出的时间之间的时间差（秒）
            double intervalTime = [currentDate timeIntervalSinceReferenceDate] - [applyData timeIntervalSinceReferenceDate];
            NSInteger time = (NSInteger)intervalTime;
            NSInteger minutes = (time / 60) % 60;
            NSInteger hours = (time / 3600);
            _tookTimeLab.text = [NSString stringWithFormat:@"用时:%ld小时%ld分",hours,minutes];
        }else{//如果不处于第一层级
            //获取上一个层级的流程模型
            FlowModel *previousModel = self.flowModels[self.index - 1];
            //获取上一级通过的时间
            NSDate *previousDate = previousModel.submitTime;
            //设置开始的时间
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *dateTime = [formatter stringFromDate:previousDate];
            _agreeTimeLab.text = dateTime;
            
            //设置审批用时
            NSDate *currentDate=[NSDate date];//获取当前时间
            NSDate *applyData = previousDate;//申请发出的时间
            // 当前时间与申请发出的时间之间的时间差（秒）
            double intervalTime = [currentDate timeIntervalSinceReferenceDate] - [applyData timeIntervalSinceReferenceDate];
            NSInteger time = (NSInteger)intervalTime;
            NSInteger minutes = (time / 60) % 60;
            NSInteger hours = (time / 3600);
            _tookTimeLab.text = [NSString stringWithFormat:@"用时:%ld小时%ld分",hours,minutes];
        }
        //设置竖线、头像圈、审批状态的颜色
        _verticalLine.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
        _headerImage.layer.borderColor = [[UIColor colorWithHexString:@"#f99740"] CGColor];
        _agreeOrNotLab.textColor = [UIColor colorWithHexString:@"f99740"];
    }
    if (flowModel.status == 4) {//已审批或者结束
        //设置开始的时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateTime = [formatter stringFromDate:flowModel.submitTime];
        _agreeTimeLab.text = dateTime;
        
        _agreeOrNotLab.text = @"同意";
        
        if (self.index == 0) {//如果处在第一级
            //设置审批用时
            NSDate *currentDate=flowModel.submitTime;//同意的时间
            NSDate *applyData = self.applyTime;//申请发出的时间
            // 当前时间与申请发出的时间之间的时间差（秒）
            double intervalTime = [currentDate timeIntervalSinceReferenceDate] - [applyData timeIntervalSinceReferenceDate];
            NSInteger time = (NSInteger)intervalTime;
            NSInteger minutes = (time / 60) % 60;
            NSInteger hours = (time / 3600);
            if (minutes == 0 && hours == 0) {//如果是立刻通过的话
                _tookTimeLab.text = [NSString stringWithFormat:@"用时:%ld小时1分",hours];
            }else{
                 _tookTimeLab.text = [NSString stringWithFormat:@"用时:%ld小时%ld分",hours,minutes];
            }
            
            
        }else{
            //获取上一个层级的流程模型
            FlowModel *previousModel = self.flowModels[self.index - 1];
            //获取上一级通过的时间
            NSDate *previousDate = previousModel.submitTime;
            
            //设置审批用时
            NSDate *currentDate=flowModel.submitTime;//同意的时间
            NSDate *applyData = previousDate;//上一级审批后的时间
            // 当前时间与申请发出的时间之间的时间差（秒）
            double intervalTime = [currentDate timeIntervalSinceReferenceDate] - [applyData timeIntervalSinceReferenceDate];
            NSInteger time = (NSInteger)intervalTime;
            NSInteger minutes = (time / 60) % 60;
            NSInteger hours = (time / 3600);
            _tookTimeLab.text = [NSString stringWithFormat:@"用时:%ld小时%ld分",hours,minutes];
        }
        
        //设置竖线、头像圈、审批状态的颜色
        _verticalLine.backgroundColor = [UIColor colorWithHexString:@"#02bb00"];
        _headerImage.layer.borderColor = [[UIColor colorWithHexString:@"#02bb00"] CGColor];
        _agreeOrNotLab.textColor = [UIColor colorWithHexString:@"02bb00"];
    }
    if (flowModel.status == 2) {//拒绝
        //设置开始的时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateTime = [formatter stringFromDate:flowModel.submitTime];
        _agreeTimeLab.text = dateTime;
        
        _agreeOrNotLab.text = @"拒绝";
        
        if (self.index == 0) {//如果处在第一级
            //设置审批用时
            NSDate *currentDate=flowModel.submitTime;//同意的时间
            NSDate *applyData = self.applyTime;//申请发出的时间
            // 当前时间与申请发出的时间之间的时间差（秒）
            double intervalTime = [currentDate timeIntervalSinceReferenceDate] - [applyData timeIntervalSinceReferenceDate];
            NSInteger time = (NSInteger)intervalTime;
            NSInteger minutes = (time / 60) % 60;
            NSInteger hours = (time / 3600);
            _tookTimeLab.text = [NSString stringWithFormat:@"用时:%ld小时%ld分",hours,minutes];
        }else{
            //获取上一个层级的流程模型
            FlowModel *previousModel = self.flowModels[self.index - 1];
            //获取上一级通过的时间
            NSDate *previousDate = previousModel.submitTime;
            
            //设置审批用时
            NSDate *currentDate=flowModel.submitTime;//同意的时间
            NSDate *applyData = previousDate;//上一级审批后的时间
            // 当前时间与申请发出的时间之间的时间差（秒）
            double intervalTime = [currentDate timeIntervalSinceReferenceDate] - [applyData timeIntervalSinceReferenceDate];
            NSInteger time = (NSInteger)intervalTime;
            NSInteger minutes = (time / 60) % 60;
            NSInteger hours = (time / 3600);
            _tookTimeLab.text = [NSString stringWithFormat:@"用时:%ld小时%ld分",hours,minutes];
        }
        
        //设置竖线、头像圈、审批状态的颜色
        _verticalLine.backgroundColor = [UIColor colorWithHexString:@"#f94040"];
        _headerImage.layer.borderColor = [[UIColor colorWithHexString:@"#f94040"] CGColor];
        _agreeOrNotLab.textColor = [UIColor colorWithHexString:@"f94040"];
    }
}

//设置审批意见能不能被看见
-(void)setShowComment:(BOOL)showComment{
    _showComment = showComment;
    //如果审批意见不能被看见
    if (showComment == NO) {
        _suggestionBtn.userInteractionEnabled = NO;//展开审批按钮设为不能点击
        [_suggestionBtn setImage:[UIImage imageNamed:@"opinion_noread"] forState:UIControlStateNormal];
        [_suggestionBtn setTitleColor:[UIColor colorWithHexString:@"#cccccc"] forState:UIControlStateNormal];
    }
}


@end
