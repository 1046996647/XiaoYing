//
//  HeadViewOfWork.m
//  XiaoYing
//
//  Created by GZH on 16/8/15.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "HeadViewOfWork.h"
#import "PersonalCardVC.h"


@interface HeadViewOfWork ()
@end

@implementation HeadViewOfWork

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
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = _imageView.width / 2;
    [view addSubview:_imageView];
    
    _label = [self Z_createLabelWithTitle:nil buttonFrame:CGRectMake(12, _imageView.bottom + 10, kScreen_Width - 24, 16)];
    _label.font = [UIFont systemFontOfSize:16];
    [view addSubview:_label];

    _label2 = [self Z_createLabelWithTitle:nil buttonFrame:CGRectMake(12 + 32, _label.bottom + 7, kScreen_Width - 24 - 64, 14)];
    [view addSubview:_label2];
    
    _label3 = [self Z_createLabelWithTitle:@"" buttonFrame:CGRectMake(12, _label2.bottom + 6, kScreen_Width - 24, 12)];
    [view addSubview:_label3];
    
    _imageCodeOfQr = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 12 - 25, view.height - 10 - 25, 25, 25)];
    _imageCodeOfQr.image = [UIImage imageNamed:@"erweima"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(makeThePictureBigAction)];
    _imageCodeOfQr.userInteractionEnabled = YES;
    [_imageCodeOfQr addGestureRecognizer:tap];
    _imageCodeOfQr.hidden = YES;
    [view addSubview:_imageCodeOfQr];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[UserInfo GetfaceURLofCard]] placeholderImage:[UIImage imageNamed:@"LOGO"]];
    _label.text = [UserInfo GetnameOfCard];
    _label2.text = [UserInfo GetDepartmentOfCard];
    _label3.text = [UserInfo GetPositionOfCard];

}

- (void)makeThePictureBigAction {
    
    ImageBrowseVC *browserVC = [ImageBrowseVC new];
    browserVC.sizeType = @"1";
    browserVC.tempImage = _imageCodeOfQr.image;
    [self.viewController presentViewController:browserVC animated:YES completion:nil];
}


- (void)tapAction {
    PersonalCardVC *perVC = [[PersonalCardVC alloc]init];
    [self.viewController.navigationController pushViewController:perVC animated:YES];
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
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

//如果在工作界面就可以跳转
- (void)setMark:(NSInteger)mark
{
    _mark = mark;
    if (mark == 1) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
}


@end
