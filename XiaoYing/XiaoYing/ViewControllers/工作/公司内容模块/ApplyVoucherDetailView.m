//
//  ApplyVoucherDetailView.m
//  XiaoYing
//
//  Created by 王思齐 on 16/12/1.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ApplyVoucherDetailView.h"
@interface ApplyVoucherDetailView()
@property(nonatomic,strong)UIView *MainView;//主视图
@property(nonatomic,strong)UILabel *creatorLabel;//申请人
@property(nonatomic,strong)UILabel *identiFielLabel;//申请人身份
@property(nonatomic,strong)UILabel *timeLabel;//时间
@property(nonatomic,strong)UILabel *applyNumberLabel;//申请编号
@property(nonatomic,strong)UILabel *applyTagLabel;//审批种类
@property(nonatomic,strong)UILabel *applyCatgoryLabel;//审批类别
@property(nonatomic,strong)UILabel *applyaddLabel;//附加信息
@property(nonatomic,strong)UILabel *contentLabel;//内容标题
@property(nonatomic,strong)UILabel *contentDetailLabel;//内容详情
@property(nonatomic,strong)UIImageView *headerImageView;//头像
@property(nonatomic,strong)UIImageView *applyVImageView;//申请凭证图
@end
@implementation ApplyVoucherDetailView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        //头像
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 63, 63)];
        _headerImageView.layer.cornerRadius = 5;
        _headerImageView.layer.masksToBounds = YES;
        [self addSubview:_headerImageView];

        //申请人
        _creatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headerImageView.right + 10, 17, 200, 20)];
        _creatorLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _creatorLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:_creatorLabel];
        
        //申请人身份
        _identiFielLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headerImageView.right + 10, _creatorLabel.bottom + 10, 200, 12)];
        _identiFielLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _identiFielLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_identiFielLabel];
        
        //时间
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headerImageView.right + 10, _identiFielLabel.bottom + 5, 200, 12)];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_timeLabel];
        
        //申请凭证图
        _applyVImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width - 60, 10, 50, 50)];
        _applyVImageView.image = [UIImage imageNamed:@"credentials_big"];
        [self addSubview:_applyVImageView];
        
        //审批编号
        _applyNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _headerImageView.bottom + 7, self.width - 20, 14)];
        _applyNumberLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_applyNumberLabel];
        
        //审批类别
        _applyCatgoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _applyNumberLabel.bottom + 7, self.width - 20, 14)];
        _applyCatgoryLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_applyCatgoryLabel];
        
        //审批种类
        _applyTagLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _applyCatgoryLabel.bottom + 7, self.width - 20, 14)];
        _applyTagLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_applyTagLabel];
        
        //附加信息
        _applyaddLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _applyTagLabel.bottom + 7, self.width - 20, 14)];
        _applyaddLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_applyaddLabel];
        
        //申请说明标题
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _applyaddLabel.bottom + 7, 80, 14)];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_contentLabel];
        
        //申请说明内容
        _contentDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(79, _applyaddLabel.bottom + 5, self.width - 79 -10, 14)];
        _contentDetailLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_contentDetailLabel];
    }
    return self;
}

-(void)setModel:(ApplyVoucherModel *)model{
    _model = model;
     NSString *iconStr = [NSString replaceString:model.faceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:iconStr]];
    //申请人名字
    _creatorLabel.text = model.createrName;
    //申请人身份
    _identiFielLabel.text = model.role;
    //时间
    _timeLabel.text = [self changeTime:model.passingTime];
    //审批编号
    _applyNumberLabel.text = [NSString stringWithFormat:@"审批编号 : %@",model.serialNumber];
    _applyNumberLabel.attributedText = [self changeString:_applyNumberLabel.text];
    //审批类别
    _applyCatgoryLabel.text = [NSString stringWithFormat:@"审批类别 : %@",model.approvalCategoryName];
    _applyCatgoryLabel.attributedText = [self changeString:_applyCatgoryLabel.text];
    //审批种类
    _applyTagLabel.text = [NSString stringWithFormat:@"审批种类 : %@",model.approvalTypeName];
    _applyTagLabel.attributedText = [self changeString:_applyTagLabel.text];
    //附加信息
    if (model.tagtype == 0) {//没有
        _applyaddLabel.hidden = YES;
        _contentLabel.top = _applyTagLabel.bottom + 7;
        _contentDetailLabel.top = _applyTagLabel.bottom + 7;
    }else if (model.tagtype == 1){//金额
        _applyaddLabel.text = [NSString stringWithFormat:@"报销金额 : %@",model.approvalTag];
        _applyaddLabel.attributedText = [self changeString:_applyaddLabel.text];
    }else{//天数
        _applyaddLabel.text = [NSString stringWithFormat:@"请假天数 : %@",model.approvalTag];
        _applyaddLabel.attributedText = [self changeString:_applyaddLabel.text];
    }
    //申请说明
    _contentLabel.text = @"申请说明 : ";
    _contentLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    _contentDetailLabel.text = model.applyContent;
    _contentDetailLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _contentDetailLabel.numberOfLines = 0;
//    [_contentDetailLabel sizeToFit];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize sizeToFit = [_contentDetailLabel.text boundingRectWithSize:CGSizeMake(self.width - 79 -10, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                                        attributes:attributes        // 文字的属性
                                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    _contentDetailLabel.height = sizeToFit.height;
     self.height = _contentDetailLabel.bottom + 10;
}

-(NSString*)changeTime:(NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:timeStr];
    NSDateFormatter *anoformatter = [[NSDateFormatter alloc]init];
    [anoformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *str = [anoformatter stringFromDate:date];
    return str;
}

-(NSMutableAttributedString*)changeString:(NSString *)string{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:string];
    [attribute addAttributes: @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#848484"],
                                NSFontAttributeName : [UIFont systemFontOfSize:14]
                                }range:NSMakeRange(0, 6)];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"],
                               NSFontAttributeName : [UIFont systemFontOfSize:14]
                               }range:NSMakeRange(6, string.length - 6)];
    return attribute;
}
@end
