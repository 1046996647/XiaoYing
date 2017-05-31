//
//  HeaderView.m
//  XiaoYing
//
//  Created by GZH on 16/8/12.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "HeaderView.h"


@interface HeaderView ()

@end


@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
        
    }
    return self;
}


- (void)initUI {
    UIView *view = [self Z_createViewWithFrame:CGRectMake(0, 0, kScreen_Width, 110) ColorStr:@"#f99740"];
    [self addSubview:view];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreen_Width - 80) / 2, 0, 80, 80)];
    _imageView.image = [UIImage imageNamed:@"LOGO"];
    [view addSubview:_imageView];
    
    _label = [self Z_createLabelWithTitle:@"公司ID : 775825" buttonFrame:CGRectMake(12, _imageView.bottom + 6, kScreen_Width - 24, 12)];
    [view addSubview:_label];
}














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
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}












@end
