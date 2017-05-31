//
//  HeadViewOfCard.m
//  XiaoYing
//
//  Created by GZH on 2016/12/21.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "HeadViewOfCard.h"

@implementation HeadViewOfCard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
        
    }
    return self;
}


- (void)initUI {
    UIView *view = [self Z_createViewWithFrame:CGRectMake(0, 0, kScreen_Width, 156) ColorStr:@"#f99740"];
    [self addSubview:view];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreen_Width - 80) / 2, 0, 80, 80)];
    _imageView.image = [UIImage imageNamed:@"LOGO"];
    [view addSubview:_imageView];
    

    _label = [self Z_createLabelWithTitle:nil buttonFrame:CGRectMake(12, _imageView.bottom + 10, kScreen_Width - 24, 16)];
    _label.font = [UIFont systemFontOfSize:12];
    [view addSubview:_label];
    
    _label2 = [self Z_createLabelWithTitle:nil buttonFrame:CGRectMake(12, _label.bottom + 5, kScreen_Width - 24, 10)];
    _label2.font = [UIFont systemFontOfSize:10];
    [view addSubview:_label2];
    
    _label3 = [self Z_createLabelWithTitle:@"" buttonFrame:CGRectMake(12, _label2.bottom + 15, kScreen_Width - 24, 12)];
    [view addSubview:_label3];
    
    _imageCodeOfQr = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 12 - 25, view.height - 10 - 25, 25, 25)];
    _imageCodeOfQr.image = [UIImage imageNamed:@"erweima"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(makeThePictureBigAction)];
    _imageCodeOfQr.userInteractionEnabled = YES;
    [_imageCodeOfQr addGestureRecognizer:tap];
    [view addSubview:_imageCodeOfQr];
    
    
//    _label.text = @"杭州赢萊金融信息服务有限公司";
//    _label2.text = @"HANGZHOUYINGLAIJINRONGXINXIFUWUYOUXIANGONGSI";
//    _label3.text = @"企业ID : 123456";
    
    _label.text = [UserInfo getcompanyName];
    _label2.text = [self getPinYinWithChinese:_label.text];
    _label3.text = @"企业ID : 123456";


}


- (void)makeThePictureBigAction {
    
    ImageBrowseVC *browserVC = [ImageBrowseVC new];
    browserVC.sizeType = @"1";
    browserVC.tempImage = _imageCodeOfQr.image;
    [self.viewController presentViewController:browserVC animated:YES completion:nil];
}



#pragma mark --将汉字转变为拼音--
- (NSString *)getPinYinWithChinese:(NSString *)stringOfchinese {
    //将字符串转换成可变字符串
    NSMutableString *nameM = [[NSMutableString alloc]initWithString:stringOfchinese];
    //将可变字符串转换成带音标的拼音
    CFStringTransform((__bridge CFMutableStringRef)nameM, 0, kCFStringTransformMandarinLatin, NO);
   //将带音标的拼音转换成不带音标的拼音
    CFStringTransform((__bridge CFMutableStringRef)nameM, 0, kCFStringTransformStripDiacritics, NO);
    //转化为大写拼音
    NSString *pinYin = [nameM uppercaseString];
    
    pinYin = [pinYin stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return pinYin;
}


#pragma mark --Z_Button--  --Z_Label--
- (UIView *)Z_createViewWithFrame:(CGRect)frame
                         ColorStr:(NSString *)colorStr{
    
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithHexString:colorStr];
    return view;
}



- (UILabel *)Z_createLabelWithTitle:(NSString *)title
                        buttonFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithHexString:@"#ffffff"];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
@end
