//
//  InviteNewStuView.m
//  XiaoYing
//
//  Created by GZH on 16/9/27.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "InviteNewStuView.h"


@implementation InviteNewStuView

- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        
        
        [self initUI];
        
    }
    return self;
}




- (void)initUI {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    UIImageView *imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(12, 15, 64, 64)];
    imageIcon.image = [UIImage imageNamed:@"003"];
    imageIcon.layer.masksToBounds = YES;
    imageIcon.layer.cornerRadius = 5.0;
    [backView addSubview:imageIcon];
    
    _nameLabel = [self Z_createLabelWithTitle:@"南京东京纽约" buttonFrame:CGRectMake( imageIcon.right + 12, 35, kScreen_Width / 3, 16) textFont:16 colorStr:@"#333333" aligment:NSTextAlignmentLeft];
//    nameLabel.backgroundColor = [UIColor cyanColor];
    [backView addSubview:_nameLabel];
    
    _imageMan = [[UIImageView alloc]initWithFrame:CGRectMake(_nameLabel.right + 12, _nameLabel.top, 15, 19)];
    _imageMan.image = [UIImage imageNamed:@"woman-1"];
//    _imageMan.image = [UIImage imageNamed:@"man-1"];
    [backView addSubview:_imageMan];
    
    _idnumberLabel = [self Z_createLabelWithTitle:@"321369741@qq.com" buttonFrame:CGRectMake( _nameLabel.left, _nameLabel.bottom + 10, kScreen_Width / 3, 12) textFont:12 colorStr:@"#848484" aligment:NSTextAlignmentLeft];
    [backView addSubview:_idnumberLabel];
    
    _birthdayLabel = [self Z_createLabelWithTitle:@"生日 :" buttonFrame:CGRectMake( 12, imageIcon.bottom + 15, imageIcon.width + 9, 16) textFont:16 colorStr:@"#848484" aligment:NSTextAlignmentRight];
    [backView addSubview:_birthdayLabel];
    
    _regionLabel = [self Z_createLabelWithTitle:@"地区 :" buttonFrame:CGRectMake( 12, _birthdayLabel.bottom + 15, imageIcon.width + 9, 16) textFont:16 colorStr:@"#848484" aligment:NSTextAlignmentRight];
    [backView addSubview:_regionLabel];
    
    _personalLabel = [self Z_createLabelWithTitle:@"个性签名 :" buttonFrame:CGRectMake( 12, _regionLabel.bottom + 15, imageIcon.width + 9, 16) textFont:16 colorStr:@"#848484" aligment:NSTextAlignmentRight];
    [backView addSubview:_personalLabel];
    
    _answerBirthdayLabel = [self Z_createLabelWithTitle:@"1993.03.11" buttonFrame:CGRectMake( _birthdayLabel.right + 9, imageIcon.bottom + 15, kScreen_Width - _birthdayLabel.right - 12, 16) textFont:16 colorStr:@"#333333" aligment:NSTextAlignmentLeft];
//    answerBirthdayLabel.backgroundColor = [UIColor cyanColor];
    [backView addSubview:_answerBirthdayLabel];
    
    _answerRegionLabel = [self Z_createLabelWithTitle:@"杭州浙江" buttonFrame:CGRectMake( _birthdayLabel.right + 9, _answerBirthdayLabel.bottom + 15, kScreen_Width - _birthdayLabel.right - 12, 16) textFont:16 colorStr:@"#333333" aligment:NSTextAlignmentLeft];
    [backView addSubview:_answerRegionLabel];
    
    _answerPersonalLabel = [self Z_createLabelWithTitle:@"个性签名性签名个性签名个性签名个性签名性签名个性签名个性签名个性签名性签名个性签名个性签名" buttonFrame:CGRectMake( _birthdayLabel.right + 9, _answerRegionLabel.bottom + 15, kScreen_Width - _birthdayLabel.right - 12, 75) textFont:16 colorStr:@"#333333" aligment:NSTextAlignmentLeft];
    _answerPersonalLabel.numberOfLines = 0;
//    answerPersonalLabel.backgroundColor = [UIColor cyanColor];
    [backView addSubview:_answerPersonalLabel];
    
    backView.frame = CGRectMake(0, 0, kScreen_Width, _answerPersonalLabel.bottom + 15);
    
    
    UIView *backView1 = [[UIView alloc]initWithFrame:CGRectMake(0, backView.bottom, kScreen_Width, 69)];
    backView1.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self addSubview:backView1];
    
    
    UIButton *button = [self Z_createButtonWithTitle:@"邀请加入公司" buttonFrame:CGRectMake(12, 25, kScreen_Width - 24, 44)];
    [button addTarget:self action:@selector(inviteJoinCompany) forControlEvents:UIControlEventTouchUpInside];
    [backView1 addSubview:button];
    
    UIButton *deleteButton = [self Z_createButtonWithTitle:@"已加入公司" buttonFrame:CGRectMake(12, 25, kScreen_Width - 24, 44)];
    deleteButton.hidden = YES;
    [deleteButton addTarget:self action:@selector(JoinCompanyAlready) forControlEvents:UIControlEventTouchUpInside];
    [backView1 addSubview:deleteButton];
    
}

- (void)inviteJoinCompany {
    
     NSLog(@"邀请加入公司");
}

- (void)JoinCompanyAlready {
    
    NSLog(@"已加入公司");
}

- (UILabel *)Z_createLabelWithTitle:(NSString *)title
                        buttonFrame:(CGRect)frame
                           textFont:(CGFloat)font
                           colorStr:(NSString *)colorStr
                           aligment:(NSTextAlignment)aligment {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = [UIColor colorWithHexString:colorStr];
    label.textAlignment = aligment;
    return label;
}


- (UIButton *)Z_createButtonWithTitle:(NSString *)title
                          buttonFrame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setFrame:frame];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.textColor = [UIColor whiteColor];
    button.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    return button;
}




@end
