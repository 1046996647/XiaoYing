//
//  XYNoteCell.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/8.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYNoteCell.h"
#import "UIViewExt.h"
#import "XYNoteModel.h"


@interface XYNoteCell(){
//    
    UIImageView * _iconImageView;
    UILabel * _titleLabel;
    UILabel * _miniLabel;
//    UILabel *title; // 标题
//    UILabel *time; // 时间
//    UILabel *attach; // 附加信息
//    UIView *line;

    UIView * _iconView;
    UIView * _baseView;
    UILabel * _timeLabel;//时间label
    BOOL isBG;
    UIColor * color;
    
}

@end
@implementation XYNoteCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.identifier = reuseIdentifier;
        
        if ([reuseIdentifier isEqualToString:@"cell"]) {
            
             [self initUI];
        }
       
    }
    
    return self;
}

-(void)initUI{
    
    self.backgroundColor = [UIColor clearColor];
    
    _baseView = [[UIView alloc]init];
    [self.contentView addSubview:_baseView];
    _baseView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    
    _iconView = [[UIView alloc]init];
    [_baseView addSubview:_iconView];
    if (isBG) {
        _iconView.backgroundColor = color;
    }else
    {
        _iconView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        color = _iconView.backgroundColor;
        isBG = 1;
    }


    
   
    _titleLabel = [[UILabel alloc]init];
    [_baseView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
//    _titleLabel.backgroundColor = [UIColor redColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;

    

    
    _miniLabel = [[UILabel alloc]init];
    [_baseView addSubview:_miniLabel];
    _miniLabel.font = [UIFont systemFontOfSize:12];
    _miniLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    _miniLabel.textAlignment = NSTextAlignmentRight;
    
//    _miniLabel.backgroundColor = [UIColor blueColor];
    
    
    
    
    _timeLabel = [[UILabel alloc]init];
    [_baseView addSubview:_timeLabel];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    _timeLabel.textAlignment = NSTextAlignmentRight;
//    _timeLabel.backgroundColor = [UIColor blackColor];


}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    

    _baseView.frame = CGRectMake(0, 0, kScreen_Width -10, 44);
    UIBezierPath * viewPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * viewLayer = [[CAShapeLayer alloc]init];
    viewLayer.frame = self.contentView.bounds;
    viewLayer.path = viewPath.CGPath;
    _baseView.layer.mask = viewLayer;
    
    _iconView.frame = CGRectMake(0, 0, 10, 44);
    UIBezierPath *iconView = [UIBezierPath bezierPathWithRoundedRect:_iconView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * iconLayer = [[CAShapeLayer alloc]init];
    iconLayer.frame = _iconView.bounds;
    iconLayer.path = iconView.CGPath;
    _iconView.layer.mask = iconLayer;
    
    CGSize size = CGSizeMake(MAXFLOAT, 16);
    CGSize countSize = [_titleLabel sizeThatFits:size];
    _titleLabel.frame = CGRectMake(20, (44 - countSize.height)/2, kScreen_Width-112, countSize.height);
    
    size = CGSizeMake(MAXFLOAT, 12);
    countSize = [_miniLabel sizeThatFits:size];
    _miniLabel.frame = CGRectMake(_titleLabel.right, (44 -(countSize.height*2 + 7))/2, countSize.width, countSize.height);
    
    _timeLabel.frame =CGRectMake(_titleLabel.right, _miniLabel.bottom + 7, countSize.width, countSize.height);
   
    
}

#pragma mark set


- (void)setNoteData:(XYNoteModel *)model
{
    
    //获取年月日日期
    NSString *timeStr = [model.NoteTime substringToIndex:10];
    if(![timeStr isEqualToString:[self getTodayDate]]){ // 昨天及之前的日期,获取的是今天的日期
        _miniLabel.text = timeStr;
    }

    //获取时间
    NSString *todayTime = [model.NoteTime substringWithRange:NSMakeRange(11, 5)];
    _timeLabel.text = todayTime;

    _miniLabel.text = timeStr;

    _titleLabel.text = model.NoteContent;
    
  
}

- (NSString *)getTodayDate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    NSString *nowStr = [dateFormatter stringFromDate:now];
    return nowStr;
}
- (NSMutableArray *)stringContains:(NSString *)string
{
    __block BOOL returnValue = NO;
    __block NSMutableArray *rangArr = [NSMutableArray arrayWithCapacity:1];
    __block NSInteger index = -1;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         index += 1;
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
                 else{
                     NSArray *tempArr = @[@(index),@1];
                     [rangArr addObject:tempArr];
                 }
             }
         }
         else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             else{
                 NSArray *tempArr = @[@(index),@1];
                 [rangArr addObject:tempArr];
             }
         }
         else {
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             }
             else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             }
             else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             }
             else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             }
             else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
             else{
                 NSArray *tempArr = @[@(index),@1];
                 [rangArr addObject:tempArr];
             }
         }
     }];
    
    return rangArr;
}






@end
