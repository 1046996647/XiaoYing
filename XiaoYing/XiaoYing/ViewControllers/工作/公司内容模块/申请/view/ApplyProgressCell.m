//
//  ApprovalProgressTableViewCell.m
//  XiaoYing
//
//  Created by ZWL on 15/12/25.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "ApplyProgressCell.h"
#import "ApplyProcessVC.h"
#import "ImagePlayerViewController.h"
#import "PlayVoiceView.h"

//NSString const *kRefreshTableViewNotification = @"kRefreshTableViewNotification";

@interface ApplyProgressCell ()
{
    UIView *_verticalLine;                       // 连接头像之间的竖线
    UIImageView *_headerImage;                   // 头像
    UILabel *_agreeTimeLab;                      // 接收到申请的时间
    UIImageView *_backgroundImage;               // 气泡背景
    

    UILabel *_approverLab;                       // 审批人+岗位
    UILabel *_agreeOrNotLab;                     // 批复状态名称
    UILabel *_tookTimeLab;                       // 已用时
    UIButton *_suggestionBtn;                    // 审批意见展示按钮
    UILabel *_aprovalSuggestionLab;              // 批复意见UILabel
    NSArray *_imagesArray;                       // 照片数组
}
@end

@implementation ApplyProgressCell
@synthesize approvalNodeModel = _approvalNodeModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        [self setupSubviews];
    }
    return self;
}

- (void)setApprovalNodeModel:(ApprovalNodeModel *)approvalNodeModel
{
    NSLog(@"setApprovalNodeModel~~~");
    
    _approvalNodeModel = approvalNodeModel;
    
    //-----头像
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:self.approvalNodeModel.commenterFaceFormatUrl]];;
    
    //-----接收到申请的时间
    if ([self.approvalNodeModel.statusName isEqualToString:@"待审批"] || [self.approvalNodeModel.statusName isEqualToString:@""]) {
        _agreeTimeLab.text = @"";
    }else {
        _agreeTimeLab.text = self.approvalNodeModel.receiveTime;
    }
    
    //-----审批人+岗位
    _approverLab.text = [NSString stringWithFormat:@"%@  %@", self.approvalNodeModel.commneterName, self.approvalNodeModel.commenterJobName];
    
    //-----批复状态名称
    _agreeOrNotLab.text = self.approvalNodeModel.statusName;
    
    //-----已用时
    if ([self.approvalNodeModel.statusName isEqualToString:@"待审批"] || [self.approvalNodeModel.statusName isEqualToString:@""]) {
        _tookTimeLab.text = [NSString stringWithFormat:@"用时: 0"];
    }else {
        _tookTimeLab.text = [NSString stringWithFormat:@"用时:%@", self.approvalNodeModel.tookTime];
    }
    
    //-----审批意见展示按钮
    if ((![self.approvalNodeModel.comment isEqualToString:@""]) || (self.approvalNodeModel.photosArray.count > 0)) { //判断审批意见不为空，审批意见展示按钮为黑色
        [_suggestionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _suggestionBtn.userInteractionEnabled = YES;
    }else {
        [_suggestionBtn setTitleColor:[UIColor colorWithHexString:@"#cccccc"] forState:UIControlStateNormal];
        _suggestionBtn.userInteractionEnabled = NO;
    }
    
    //-----批复意见UILabel
    _aprovalSuggestionLab.text = self.approvalNodeModel.comment;
    
    //-----照片数组
    _imagesArray = self.approvalNodeModel.photosArray;
    
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
    [self.contentView addSubview:rectView];
    
    // 头像
    _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    _headerImage.clipsToBounds = YES;
    _headerImage.center = rectView.center;
    _headerImage.layer.borderWidth = 2.5;
    _headerImage.layer.cornerRadius = 35/2.0;
    [self.contentView addSubview:_headerImage];
    
    // 接收到申请的时间
    _agreeTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(_headerImage.right+10, 10, 200, 10)];
    _agreeTimeLab.font = [UIFont systemFontOfSize:10];
    _agreeTimeLab.textColor = [UIColor colorWithHexString:@"#848484"];
    [self.contentView addSubview:_agreeTimeLab];
    
    // 气泡背景
    _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(_headerImage.right+3, 24, kScreen_Width - 40 - 19, 58)];
    UIImage *image = [UIImage imageNamed:@"record"];
    image = [image stretchableImageWithLeftCapWidth:50 topCapHeight:50]; //UIImage的一个实例函数，它的功能是创建一个内容可拉伸，而边角不拉伸的图片，需要两个参数，第一个是左边不拉伸区域的宽度，第二个参数是上面不拉伸的高度。
    _backgroundImage.image = image;
    _backgroundImage.userInteractionEnabled = YES;
    [self.contentView addSubview:_backgroundImage];
    
    // 创建气泡背景内视图
    [self setupCellSubViews];
}

//创建气泡背景内部视图
- (void)setupCellSubViews {
    
    // 批复人的名称＋批复人的岗位名称
    _approverLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, 145, 14)];
    _approverLab.font = [UIFont systemFontOfSize:14];
    _approverLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_backgroundImage addSubview:_approverLab];
    
    // 批复状态名称
    _agreeOrNotLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 34, 150, 12)];
    _agreeOrNotLab.font = [UIFont systemFontOfSize:12];
    [_backgroundImage addSubview:_agreeOrNotLab];
    
    // 已用时
    _tookTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(158, 13, _backgroundImage.frame.size.width - 158 - 9, 10)];
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
    
    // 审批意见展示按钮 的内部布局
    UIImage *image = [UIImage imageNamed:@"opinion_read"];
    [_suggestionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, image.size.width - 6, 0, 0)];
    [_suggestionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _suggestionBtn.titleLabel.bounds.size.width , 0, -_suggestionBtn.titleLabel.bounds.size.width )];
    [_backgroundImage addSubview:_suggestionBtn];
    
    // 审批意见lab
    _aprovalSuggestionLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _aprovalSuggestionLab.numberOfLines = 0;
    _aprovalSuggestionLab.font = [UIFont systemFontOfSize:10];
    _aprovalSuggestionLab.textColor = [UIColor colorWithHexString:@"#848484"];
    [_backgroundImage addSubview:_aprovalSuggestionLab];
    
    //照片数组
    _imagesArray = [[NSArray alloc] init];
    
    // 照片浏览按钮
    _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imageBtn setImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
    _imageBtn.hidden = YES;
    [_imageBtn addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundImage addSubview:_imageBtn];
    
    /**
    // 语音播放按钮
    _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _voiceBtn.hidden = YES;
    [_voiceBtn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [_voiceBtn addTarget:self action:@selector(VoiceAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundImage addSubview:_voiceBtn];
    **/

}

//刷新视图
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    NSLog(@"layoutSubviews");
    
    _verticalLine.frame = CGRectMake(_headerImage.center.x-1, 0, 2, self.height);
    _verticalLine.backgroundColor = [self getColorBaseonStatusName:self.approvalNodeModel.statusName];
    _agreeOrNotLab.textColor = [self getColorBaseonStatusName:self.approvalNodeModel.statusName];
    _headerImage.layer.borderColor = [[self getColorBaseonStatusName:self.approvalNodeModel.statusName] CGColor];
    
    NSString *text = self.approvalNodeModel.comment;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreen_Width-60-12-30, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                                                                                                                                              NSFontAttributeName : [UIFont systemFontOfSize:10]
                                                                                                                                              } context:nil];
    
    if ([self.approvalNodeModel.comment isEqualToString:@""]) { //如果审批意见为空，则直接不现实
        _aprovalSuggestionLab.frame = CGRectMake(15, 58, _backgroundImage.width - 9  - 9, 0);
    }else {
        _aprovalSuggestionLab.frame = CGRectMake(15, 58, _backgroundImage.width - 9  - 9, rect.size.height);
        _aprovalSuggestionLab.text = text;
    }
    
    if (_imagesArray.count == 0) { //如果没有照片就不现实图片显示按钮
        _imageBtn.frame = CGRectMake(15, _aprovalSuggestionLab.bottom+7, 25, 0);
    }else {
        _imageBtn.frame = CGRectMake(15, _aprovalSuggestionLab.bottom+7, 25, 20);
    }
    
    _voiceBtn.frame = CGRectMake(_imageBtn.right+25, _imageBtn.top, 25, 20);
    _voiceBtn.frame = CGRectMake(_imageBtn.right+25, _imageBtn.top, 25, 0); //语音播放按钮暂时不用
    
    if (self.approvalNodeModel.isExpand) {
        
        _suggestionBtn.selected = YES;
        _aprovalSuggestionLab.hidden = NO;
        _imageBtn.hidden = NO;
        _voiceBtn.hidden = NO;
        _backgroundImage.height = 58 + _aprovalSuggestionLab.frame.size.height + 7 + 20 + 10;
        
    } else {
        _suggestionBtn.selected = NO;
        _aprovalSuggestionLab.hidden = YES;
        _imageBtn.hidden = YES;
        _voiceBtn.hidden = YES;
        _backgroundImage.height = 58;
    }


    
}

// 点击 审批意见按钮
- (void)aprovalSuggestionAction:(UIButton *)btn {
    
    self.approvalNodeModel.isExpand = !self.approvalNodeModel.isExpand;
    
    [(ApplyProcessVC *)self.viewController reloadTableView];
}

#pragma mark - ButtonActions
// 图片浏览按钮Action
- (void)imageAction:(UIButton *)btn {
    // 模板
    ImagePlayerViewController *imagePlayerVC = [[ImagePlayerViewController alloc] init];
    imagePlayerVC.imageArray = self.approvalNodeModel.photosArray;
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

- (UIColor *)getColorBaseonStatusName:(NSString *)statusName
{
    UIColor *tempColor = [[UIColor alloc] init];
    
    if ([statusName isEqualToString:@"待审批"]) {
        
        tempColor = [UIColor colorWithHexString:@"#848484"];
        
    }else if([statusName isEqualToString:@""]) {
        
        tempColor = [UIColor colorWithHexString:@"#848484"];
        
    }else if([statusName isEqualToString:@"审批中"]) {
        
        tempColor = [UIColor colorWithHexString:@"#f99740"];
        
    }else if([statusName isEqualToString:@"已拒绝"]) {
    
        tempColor = [UIColor colorWithHexString:@"#f94040"];
    
    }else if([statusName isEqualToString:@"越级审批中"]) {
    
        tempColor = [UIColor colorWithHexString:@"#f99740"];
    
    }else if([statusName isEqualToString:@"审批通过"]) {
    
        tempColor = [UIColor colorWithHexString:@"#02bb00"];
    
    }
    
    return tempColor;
}

@end
