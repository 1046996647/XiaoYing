//
//  XYWorkCollectionViewCell.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/7/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "XYWorkCollectionViewCell.h"
@interface XYWorkCollectionViewCell()

@property(nonatomic,strong)UILabel * label;
@property(nonatomic,strong)UIView * linView;

@end

@implementation XYWorkCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {


        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreen_Width/3 - 43)/2, (90 -30)/2, 43, 30)];
        //设置imageView的显示风格
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        
        //label
        self.label = [[UILabel alloc]init];
        self.label.textColor = [UIColor colorWithHexString:@"848484"];
        self.label.font = [UIFont systemFontOfSize:10];
        [self.label sizeToFit];
        [self.contentView addSubview:self.label];
        
        _padgeView = [[UIView alloc]initWithFrame:CGRectMake(_imageView.right - 16, _imageView.top - 6, 12, 12)];
        _padgeView.clipsToBounds = YES;
        _padgeView.backgroundColor = [UIColor redColor];
        _padgeView.layer.cornerRadius = _padgeView.width / 2;
        _padgeView.hidden = YES;
        [self.contentView addSubview:self.padgeView];
        
        
        
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.imageView.mas_bottom).offset(7);
            make.centerX.equalTo(self.imageView);
            
        }];
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    
    self.label.text = title;
}

@end
