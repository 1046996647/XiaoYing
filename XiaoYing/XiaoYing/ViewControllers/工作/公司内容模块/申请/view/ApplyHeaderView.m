//
//  ApprovalHeaderView.m
//  XiaoYing
//
//  Created by ZWL on 15/12/25.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "ApplyHeaderView.h"
#import "ImagePlayerViewController.h"
#import "PlayVoiceView.h"

@interface ApplyHeaderView () <UITextViewDelegate, UITextFieldDelegate>
{
    //_____________________________________________________
    UILabel *_identifyLab;                  // 审批编号
    UILabel *_typeLab;                      // 审批类型
    
    UILabel *_moneyLab;                     // 审批金额
    UILabel *_timeLab;                      // 审批时间
    UILabel *_explainLab;                   // 审批说明
    NSMutableArray *_imagesArray;           // 图片数组
    UIButton *_imageBtn;                    // 图片展示按钮
    UIButton *_voiceBtn;                    // 语音播放按钮
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
}
@property (nonatomic, strong) UIButton *voiceBtn;

@end

@implementation ApplyHeaderView

- (instancetype)initWithFrame:(CGRect)frame IsFinicial:(BOOL)isFinicial {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

- (void)setApplicationMessageModel:(ApplicationMessageModel *)applicationMessageModel headerHeight:(void(^)(NSInteger headerHeight))headerHeight
{
    _applicationMessageModel = applicationMessageModel;
    
    //-----申请编号
    _identifyLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, kScreen_Width - 24, 12)];
    NSString *identifyLabText = [NSString stringWithFormat:@"申请编号 : %@", _applicationMessageModel.requestSerialNumber];
    NSMutableAttributedString *identifyAttribute = [[NSMutableAttributedString alloc] initWithString:identifyLabText];
    [identifyAttribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(0, 6)];
    [identifyAttribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(6, identifyLabText.length - 6)];
    _identifyLab.attributedText = identifyAttribute;
    [self addSubview:_identifyLab];
    
    //-----申请种类
    _typeLab = [[UILabel alloc] initWithFrame:CGRectMake(12, _identifyLab.bottom+5, kScreen_Width - 24, 12)];
    NSString *typeLabText = [NSString stringWithFormat:@"申请种类 : %@", _applicationMessageModel.typeName];
    NSMutableAttributedString *typeAttribute = [[NSMutableAttributedString alloc] initWithString:typeLabText];
    [typeAttribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(0, 6)];
    [typeAttribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(6, typeLabText.length - 6)];
    _typeLab.attributedText = typeAttribute;
    [self addSubview:_typeLab];
    
    
    //-----附加信息值
    _moneyLab = [[UILabel alloc] init];
    
    if ([_applicationMessageModel.approvalTag isEqualToString:@""]) {
        _moneyLab.frame = CGRectMake(12, _typeLab.bottom+5, kScreen_Width - 24, 0);
    }else {
        _moneyLab.frame = CGRectMake(12, _typeLab.bottom+5, kScreen_Width - 24, 12);
    }
    
    if (_applicationMessageModel.tagType == 1) {  //money
        
        NSString *moneyLabText = [NSString stringWithFormat:@"报销金额 : %@", _applicationMessageModel.approvalTag];
        NSMutableAttributedString *moneyAttribute = [[NSMutableAttributedString alloc] initWithString:moneyLabText];
        [moneyAttribute addAttributes:@{
                                        NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                                        NSFontAttributeName : [UIFont systemFontOfSize:12]
                                        }range:NSMakeRange(0, 6)];
        [moneyAttribute addAttributes:@{
                                        NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"],
                                        NSFontAttributeName : [UIFont systemFontOfSize:12]
                                        }range:NSMakeRange(6, moneyLabText.length - 6)];
        _moneyLab.attributedText = moneyAttribute;
        [self addSubview:_moneyLab];
        
    } else if (_applicationMessageModel.tagType == 2) { //day
        
        NSString *moneyLabText = [NSString stringWithFormat:@"申请天数 : %@", _applicationMessageModel.approvalTag];
        NSMutableAttributedString *moneyAttribute = [[NSMutableAttributedString alloc] initWithString:moneyLabText];
        [moneyAttribute addAttributes:@{
                                        NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                                        NSFontAttributeName : [UIFont systemFontOfSize:12]
                                        }range:NSMakeRange(0, 6)];
        [moneyAttribute addAttributes:@{
                                        NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"],
                                        NSFontAttributeName : [UIFont systemFontOfSize:12]
                                        }range:NSMakeRange(6, moneyLabText.length - 6)];
        _moneyLab.attributedText = moneyAttribute;
        [self addSubview:_moneyLab];
        
    }
    
    //-----显示已用时间
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(12, _moneyLab.bottom+5, kScreen_Width - 24, 12)];
    NSString *timeLabText = [NSString stringWithFormat:@"已用时间 : %@", _applicationMessageModel.passDateTime];
    NSMutableAttributedString *timeAttribute = [[NSMutableAttributedString alloc] initWithString:timeLabText];
    [timeAttribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(0, 6)];
    [timeAttribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#f94040"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(6, timeLabText.length - 6)];
    _timeLab.attributedText = timeAttribute;
    [self addSubview:_timeLab];
    
    //-----申请说明
    _explainLab = [[UILabel alloc] initWithFrame:CGRectMake(12, _timeLab.bottom+5, kScreen_Width - 24, 0)];
    _explainLab.numberOfLines = 0;
    NSString *explainLabText = [NSString stringWithFormat:@"申请说明 : %@", _applicationMessageModel.remark];
    NSMutableAttributedString *explainAttribute = [[NSMutableAttributedString alloc] initWithString:explainLabText];
    [explainAttribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(0, 6)];
    [explainAttribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(6, explainLabText.length - 6)];
    _explainLab.attributedText = explainAttribute;
    CGRect rect = [_explainLab.text boundingRectWithSize:CGSizeMake(kScreen_Width - 24, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]                                                                            } context:nil];
    _explainLab.height = rect.size.height;
    [self addSubview:_explainLab];
    
    //-----图片数组
    _imagesArray = [NSMutableArray array];
    _imagesArray = _applicationMessageModel.imagesArray;
    
    //-----图片展示按钮(imageAction:)
    _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imageBtn setImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
    
    if (_imagesArray.count == 0) {
        _imageBtn.frame = CGRectMake(12, _explainLab.bottom+7, 25, 0);
    }else {
        _imageBtn.frame = CGRectMake(12, _explainLab.bottom+7, 25, 20);
    }
    
    [_imageBtn addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_imageBtn];

    //-----语音播放按钮(VoiceAction:)
    _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_voiceBtn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    _voiceBtn.frame = CGRectMake(_imageBtn.right+25, _imageBtn.top, 25, 20);
    _voiceBtn.frame = CGRectMake(_imageBtn.right+25, _imageBtn.top, 25, 0); //暂时不需要
    [_voiceBtn addTarget:self action:@selector(VoiceAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_voiceBtn];
    
    //-----断定该view的高度
    self.height = _imageBtn.bottom+12;
    
    if (headerHeight) {
        headerHeight(self.height);
    }
    
}

// 图片浏览按钮Action
- (void)imageAction:(UIButton *)btn {
    // 模板
    ImagePlayerViewController *imagePlayerVC = [[ImagePlayerViewController alloc] init];
    imagePlayerVC.imageArray = _imagesArray;
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

- (NSArray *)replaceImageUrlFromImageArray:(NSArray *)images
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *urlDic in images) {
        NSString *url = urlDic[@"URL"];
        NSString *imageStr = [NSString replaceString:url Withstr1:@"1000" str2:@"1000" str3:@"c"];
        [tempArray addObject:imageStr];
        
    }
    return tempArray;
}

@end
