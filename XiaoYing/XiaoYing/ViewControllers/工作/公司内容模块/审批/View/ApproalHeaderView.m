//
//  ApproalHeaderView.m
//  XiaoYing
//
//  Created by YL20071 on 16/10/19.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ApproalHeaderView.h"
#import "ImagePlayerViewController.h"
#import "PlayVoiceView.h"
#import "CreatorModel.h"
#import "CellDetail.h"

@interface ApproalHeaderView () <UITextViewDelegate, UITextFieldDelegate>
{
    UILabel *_whoToApprovalLab;             // 等待审批
    UILabel *_kindLab;                      // 类型
    UILabel *_progressLab;                  // 审批进度
    UILabel *_currentTimeLab;               // 审批时间
    UILabel *_identifyLab;                  // 审批编号
    UILabel *_deparmentLab;                 // 审批部门
    UILabel *_typeLab;                      // 审批事假
    UILabel *_timeLab;                      // 审批时间
    UIButton *_applyExplationBtn;           // 申请说明按钮
    UILabel *_finicialLab;                  // 审批是否财务
    UILabel *_moneyLab;                     // 审批金额
    UILabel *_explainLab;                   // 审批说明
    UIView *_progressView;                  // 进度条
    BOOL _isFinicial;                       // 是否财务审批
    CGFloat _viewHieght;                    // 视图高度
    NSMutableArray *_imageURLsArray;               // 图片URL数组
    
    UIView *_bgView;
}
@end

@implementation ApproalHeaderView

- (UIButton *)imageBtn
{
    if (!_imageBtn) {
        _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageBtn setImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
        _imageBtn.frame = CGRectMake(12, _explainLab.bottom+7, 25, 20);
        [_imageBtn addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageBtn;
}

- (UIButton *)voiceBtn
{
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        _voiceBtn.frame = CGRectMake(_imageBtn.right+25, _imageBtn.top, 25, 20);
        [_voiceBtn addTarget:self action:@selector(VoiceAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}

- (instancetype)initWithFrame:(CGRect)frame IsFinicial:(BOOL)isFinicial {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self seutpSubViews];
    }
    return self;
}

#pragma mark - ViewsCreate
/**
 *  创建子视图
 */
- (void)seutpSubViews {
    
    // 审批编号
    _identifyLab = [self createLabelWithTitle:@"审批编号 : 2011329680126" andFrame:CGRectMake(12, 8, kScreen_Width - 24, 12)];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:_identifyLab.text];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(0, 6)];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(6, _identifyLab.text.length - 6)];
    _identifyLab.attributedText = attribute;
    [self addSubview:_identifyLab];
    
    // 审批类型
    _typeLab = [self createLabelWithTitle:@"审批种类 : 事假" andFrame:CGRectMake(12, _identifyLab.bottom+5, kScreen_Width - 24, 12)];
    attribute = [[NSMutableAttributedString alloc] initWithString:_typeLab.text];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(0, 6)];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(6, _typeLab.text.length - 6)];
    _typeLab.attributedText = attribute;
    [self addSubview:_typeLab];
    
    
    /**
     *  创建金融报销部分视图
     */
    [self setupFinicialView];
    
}

/**
 *  创建金融报销部分视图
 */
- (void)setupFinicialView {
    
    // 报销金额
    _moneyLab = [self createLabelWithTitle:@"报销金额 : 200" andFrame:CGRectMake(12, _typeLab.bottom+5, kScreen_Width - 24, 12)];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:_moneyLab.text];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(0, 6)];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(6, _moneyLab.text.length - 6)];
    _moneyLab.attributedText = attribute;
    [self addSubview:_moneyLab];
    
    // 已经用的时间
    _timeLab = [self createLabelWithTitle:@"已用时间 : 48小时23分" andFrame:CGRectMake(12, _moneyLab.bottom+5, kScreen_Width - 24, 12)];
    attribute = [[NSMutableAttributedString alloc] initWithString:_timeLab.text];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(0, 6)];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#f94040"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(6, _timeLab.text.length - 6)];
    _timeLab.attributedText = attribute;
    [self addSubview:_timeLab];
    
    // 申请说明
    NSString *string = @"审批说明 : 审批说明审批说明审批说明审批说明审批说明审批说明审批说明审批说明审批说明审批说明审批说明审批说明审批说明";
    _explainLab = [self createLabelWithTitle:string andFrame:CGRectMake(12, _timeLab.bottom+5, kScreen_Width - 24, 0)];
    _explainLab.numberOfLines = 0;
    attribute = [[NSMutableAttributedString alloc] initWithString:_explainLab.text];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(0, 6)];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(6, _explainLab.text.length - 6)];
    _explainLab.attributedText = attribute;
    CGRect rect = [_explainLab.text boundingRectWithSize:CGSizeMake(kScreen_Width - 24, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]                                                                            } context:nil];
    _explainLab.height = rect.size.height;
    [self addSubview:_explainLab];
    
    // 照片浏览按钮(imageAction:)
    [self addSubview:self.imageBtn];
    
    
    // 语音播放按钮(VoiceAction:)
    [self addSubview:self.voiceBtn];
    
    self.height = _imageBtn.bottom+12;
}

// 图片浏览按钮Action
- (void)imageAction:(UIButton *)btn {
    // 模板
    ImagePlayerViewController *imagePlayerVC = [[ImagePlayerViewController alloc] init];
   
    imagePlayerVC.imageArray = _imageURLsArray;
    //    [self.viewController.navigationController pushViewController:imagePlayerVC animated:YES];
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

// 封装的一个UILabel生成器
- (UILabel *)createLabelWithTitle:(NSString *)str andFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = str;
    label.font = [UIFont systemFontOfSize:13];
    return label;
}

-(void)setDetailModel:(ApproalDetailModel *)detailModel{
    _detailModel = detailModel;
    //_whoToApprovalLab.text = self.statusDesc;
    _kindLab.text = detailModel.typeName;
    _progressLab.text = self.progress;
     NSDate *currentDate=[NSDate date];//获取当前时间
     NSDate *applyData = detailModel.sendDateTime;//申请发出的时间
    // 当前时间与申请发出的时间之间的时间差（秒）
    double intervalTime = [currentDate timeIntervalSinceReferenceDate] - [applyData timeIntervalSinceReferenceDate];
    NSInteger time = (NSInteger)intervalTime;
    NSInteger minutes = (time / 60) % 60;
    NSInteger hours = (time / 3600);
    _timeLab.text = [NSString stringWithFormat:@"已用时间 : %ld小时%ld分",hours,minutes];
    
  
//    NSLog(@"_t:%@",_timeLab.text);
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:_timeLab.text];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(0, 6)];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(6, _timeLab.text.length - 6)];
    _timeLab.attributedText = attribute;
    
    _identifyLab.text = [NSString stringWithFormat:@"申请编号 : %@",detailModel.requestSerialNumber];
    
    attribute = [[NSMutableAttributedString alloc] initWithString:_identifyLab.text];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(0, 6)];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(6, _identifyLab.text.length - 6)];
    _identifyLab.attributedText = attribute;
    _typeLab.text = [NSString stringWithFormat:@"申请种类 : %@",detailModel.typeName];
    attribute = [[NSMutableAttributedString alloc] initWithString:_typeLab.text];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(0, 6)];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(6, _typeLab.text.length - 6)];
    _typeLab.attributedText = attribute;
    if (detailModel.tagType == 2) {//请假类型
        _moneyLab.text = [NSString stringWithFormat:@"请假天数 : %@",detailModel.approvalTag];
    }
    if (detailModel.tagType == 1) {//金额类型
        _moneyLab.text = [NSString stringWithFormat:@"报销金额 : %@",detailModel.approvalTag];
    }
    attribute = [[NSMutableAttributedString alloc] initWithString:_moneyLab.text];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(0, 6)];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(6, _moneyLab.text.length - 6)];
    _moneyLab.attributedText = attribute;
    _explainLab.text = [NSString stringWithFormat:@"审批说明 : %@",detailModel.remark];
    attribute = [[NSMutableAttributedString alloc] initWithString:_explainLab.text];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(0, 6)];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(6, _explainLab.text.length - 6)];
    _explainLab.attributedText = attribute;
    CGRect rect = [_explainLab.text boundingRectWithSize:CGSizeMake(kScreen_Width - 24, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]                                                                            } context:nil];
    _explainLab.height = rect.size.height;
    NSLog(@"_explainHeight:%f",_explainLab.height);
    if (detailModel.images.count == 0 || !detailModel.images) {
        _imageBtn.hidden = YES;
    }else{
        _imageURLsArray = [NSMutableArray array];
        NSLog(@"imagurl:%@",_detailModel.images[0]);
        for (NSDictionary *urlDic in _detailModel.images) {
            NSString *url = urlDic[@"URL"];
            NSString *imageStr = [NSString replaceString:url Withstr1:@"1000" str2:@"1000" str3:@"c"];
            [_imageURLsArray addObject:imageStr];
        }
    }
    
    //一些情况的判断
    //如果是金额或者假期类型，没有审批说明，没有图片
    if (detailModel.tagType != 0 && [detailModel.remark isEqualToString:@""] && detailModel.images.count == 0) {
        _explainLab.hidden = YES;
        self.height = _timeLab.bottom + 12;
    }
    //如果是金额或者假期类型，没有审批说明，有图片
    if (detailModel.tagType != 0 && [detailModel.remark isEqualToString:@""] && detailModel.images.count != 0) {
        _explainLab.hidden = YES;
        _imageBtn.top = _timeLab.bottom + 7 ;
        self.height = _imageBtn.bottom + 12;
    }
    //如果是金额或者假期类型，有审批说明，有图片
    if (detailModel.tagType != 0 && ![detailModel.remark isEqualToString:@""] && detailModel.images.count != 0) {
        _imageBtn.top = _explainLab.bottom + 7;
        self.height = _imageBtn.bottom + 12;
    }
    //如果是金额或者假期类型，有审批说明，没有图片
    if (detailModel.tagType != 0 && ![detailModel.remark isEqualToString:@""] && detailModel.images.count == 0) {
        _imageBtn.hidden = YES;
        self.height = _explainLab.bottom + 12;
    }
    //如果不是金额或者假期类型,没有审批说明，没有图片
    if (detailModel.tagType == 0 && ![detailModel.remark isEqualToString:@""] && detailModel.images.count == 0){
        _explainLab.hidden = YES;
        _moneyLab.hidden = YES;
        _timeLab.top = _typeLab.bottom + 5;
        self.height = _timeLab.bottom + 12;
    }
    //如果不是金额或者假期类型,没有审批说明，有图片
    if (detailModel.tagType == 0 && [detailModel.remark isEqualToString:@""] && detailModel.images.count != 0){
        _explainLab.hidden = YES;
        _moneyLab.hidden = YES;
        _timeLab.top = _typeLab.bottom + 5;
        _imageBtn.top = _timeLab.bottom + 7 ;
         self.height = _imageBtn.bottom + 12;
    }
    //如果不是金额或者假期类型,有审批说明，有图片
    if (detailModel.tagType == 0 && ![detailModel.remark isEqualToString:@""] && detailModel.images.count != 0){
        _moneyLab.hidden = YES;
        _timeLab.top = _typeLab.bottom + 5;
        _explainLab.top = _timeLab.bottom + 5;
        _imageBtn.top = _explainLab.bottom + 7 ;
        self.height = _imageBtn.bottom + 12;
    }
    //如果不是金额或者假期类型,有审批说明，没有图片
    if (detailModel.tagType == 0 && ![detailModel.remark isEqualToString:@""] && detailModel.images.count == 0){
        _explainLab.hidden = NO;
        _moneyLab.hidden = YES;
        _timeLab.top = _typeLab.bottom + 5;
        _explainLab.top = _timeLab.bottom + 5;
        //_imageBtn.top = _timeLab.bottom + 7 ;
        self.height = _explainLab.bottom + 12;
    }
}

//如果是公告模块的话
-(void)setIsAffiche:(BOOL)isAffiche{
    _isAffiche = isAffiche;
    if (isAffiche == YES) {
        //审批编号
        _identifyLab.text = [NSString stringWithFormat:@"申请编号 : %@",self.detailModel.requestSerialNumber];
        _identifyLab.attributedText = [self changeString:_identifyLab.text];
        //已用时间
        _timeLab.attributedText = [self changeString:_timeLab.text];
        _timeLab.top = _identifyLab.bottom + 5;
        //公告标题
        _moneyLab.text = [NSString stringWithFormat:@"公告标题 : %@",self.detailModel.typeName];
        _moneyLab.attributedText = [self changeString:_moneyLab.text];
        _moneyLab.top = _timeLab.bottom + 5;
        //公告范围
        if ([self.detailModel.remark isEqualToString:@""]) {//公司层级
            _typeLab.text = [NSString stringWithFormat:@"公告范围 : %@",[UserInfo getcompanyName]];
        }else{//不是公司层级直接从模型中取即可
            _typeLab.text = [NSString stringWithFormat:@"公告范围 : %@",self.detailModel.remark];
        }
        _typeLab.attributedText = [self changeString:_typeLab.text];
        _typeLab.top = _moneyLab.bottom + 5;
        //公告内容
        _explainLab.text = @"公告内容 :";
        _explainLab.textColor = [UIColor colorWithHexString:@"#848484"];
        _explainLab.font = [UIFont systemFontOfSize:12];
        _explainLab.top = _typeLab.bottom + 5;
        _explainLab.hidden = NO;
        self.height = _explainLab.bottom + 12;
        
        //公告预览
        UIButton *afficheButton = [UIButton buttonWithType:UIButtonTypeCustom];
        afficheButton.frame = CGRectMake(69, _typeLab.bottom + 5, 78, 22);
        [afficheButton setImage:[UIImage imageNamed:@"dianjiyulan"] forState:UIControlStateNormal];
        [afficheButton addTarget:self action:@selector(gotoAfficheDetail) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:afficheButton];
    }
}

//点击公告预览之后进入公告详情
-(void)gotoAfficheDetail{
    CellDetail *detailVC = [[CellDetail alloc]init];
    detailVC.afficheid = self.detailModel.approvalTag;
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}

-(void)setOvered:(BOOL)overed{
    _overed = overed;
    if (overed == YES) {//审批已完成
        NSInteger minute = self.useTime % 60;
        NSInteger hour = (self.useTime / 60);
        if (hour == 0) {
            _timeLab.text = [NSString stringWithFormat:@"审批用时 : %ld分",minute];
        }else{
            _timeLab.text = [NSString stringWithFormat:@"审批用时 : %ld时%ld分",hour,minute];
        }
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:_timeLab.text];
        [attribute addAttributes:@{
                                   NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"],
                                   NSFontAttributeName : [UIFont systemFontOfSize:12]
                                   }range:NSMakeRange(0, 6)];
        [attribute addAttributes:@{
                                   NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                                   NSFontAttributeName : [UIFont systemFontOfSize:12]
                                   }range:NSMakeRange(6, _timeLab.text.length - 6)];
        _timeLab.attributedText = attribute;
    }
}

-(NSMutableAttributedString*)changeString:(NSString *)string{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:string];
    [attribute addAttributes: @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#848484"],
                                NSFontAttributeName : [UIFont systemFontOfSize:12]
                                }range:NSMakeRange(0, 6)];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(6, string.length - 6)];
    return attribute;
}

@end
