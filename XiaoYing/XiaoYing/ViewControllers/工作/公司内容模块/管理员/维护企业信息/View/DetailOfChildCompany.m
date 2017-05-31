//
//  DetailOfChildCompany.m
//  XiaoYing
//
//  Created by GZH on 16/7/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DetailOfChildCompany.h"

@implementation DetailOfChildCompany



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        
        
    }
    return self;
}


- (void)initUI {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 270, 142)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    CALayer * layer = [view layer];
    layer.borderColor = [[UIColor grayColor] CGColor];
    layer.borderWidth = 0.5;
    [self addSubview:view];
    
    _imageView = [[UIImageView alloc]init];
    _imageView.frame = CGRectMake((270 - 60) / 2, 15, 60, 60);
    _imageView.backgroundColor = [UIColor grayColor];
    [view addSubview:_imageView];
    
    _companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageView.bottom + 12, 270, 16)];
    _companyLabel.text = @"杭州赢莱金融信息服务有限公司";
    _companyLabel.font = [UIFont systemFontOfSize:16];
    _companyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _companyLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_companyLabel];
    
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, _companyLabel.bottom + 12, 270, 12)];
    _label.text = @"创建者 :  李大谦";
    _label.font = [UIFont systemFontOfSize:12];
    _label.textColor = [UIColor colorWithHexString:@"#848484"];
    _label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_label];
    
      
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
