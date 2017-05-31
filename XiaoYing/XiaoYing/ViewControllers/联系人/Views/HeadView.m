//
//  HeadView.m
//  XiaoYing
//
//  Created by yinglaijinrong on 16/6/6.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "HeadView.h"

#import "HeadView.h"
#import "HelpMac.h"
#import "UIColor+Expend.h"

@implementation HeadView

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        //       我的同事页面 区头按钮
        _clickBut =[UIButton buttonWithType:UIButtonTypeCustom];
        _clickBut.frame =CGRectMake(0, 0, kScreen_Width, 57.5);
        _clickBut.backgroundColor =[UIColor clearColor];
        [self addSubview:_clickBut];
        //        我的同事页面 区头名字
        _headNameLab =[[UILabel alloc]initWithFrame:CGRectMake(10, 20,kScreen_Width - 80, 18)];
        _headNameLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _headNameLab.font =[UIFont systemFontOfSize:16];
        [self addSubview:_headNameLab];
        //        我的同事页面  区头图片
        _headImageview =[[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width -40, 24, 18, 10)];
        _headImageview.image =[UIImage imageNamed:@"arrow"];
        [self addSubview:_headImageview];
    }
    return self;
}

/**
 *  我的同事页面 区头图片的旋转
 *
 *  @return void
 */
-(void)openAnimate:(NSString *)flag
{
    if ([flag isEqualToString:@"0"])
    {
        self.headImageview.transform = CGAffineTransformMakeRotation(M_PI);
    }
    else if ([flag isEqualToString:@"1"]){
        self.headImageview.transform = CGAffineTransformIdentity;
    }
    
}

@end
