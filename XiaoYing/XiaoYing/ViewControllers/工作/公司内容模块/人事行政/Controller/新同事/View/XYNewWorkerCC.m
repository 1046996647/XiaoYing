//
//  XYNewWorkerCC.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/7/23.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "XYNewWorkerCC.h"
@interface XYNewWorkerCC()

//@property(nonatomic,strong)UILabel * label;
//@property(nonatomic,strong)UIImageView * imageView;

@end

@implementation XYNewWorkerCC

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc]init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
 
        [self.contentView addSubview:self.imageView];
        
        
        self.label = [[UILabel alloc]init];
        self.label.textColor = [UIColor colorWithHexString:@"#848484"];
        self.label.font = [UIFont systemFontOfSize:10];
        self.label.numberOfLines = 0;
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
        
        
        
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.imageView.mas_bottom).offset(7);
        make.centerX.equalTo(self.imageView);
        //确定label的宽度,写成定值或者不定都行
        make.width.equalTo(@65);
        
    }];
    
      self.imageView.frame =CGRectMake((80 -33)/2, 12, 33, 30);
}

//-(void)setImage:(UIImage *)image
//{
//    self.imageView.image = image;
//    
//}

//-(void)setTitle:(NSString *)title{
//    
//    self.label.text = title;
//}
@end
