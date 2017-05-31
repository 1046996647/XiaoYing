//
//  AddAlreadyCompanyView.m
//  XiaoYing
//
//  Created by GZH on 16/8/11.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "AddAlreadyCompanyView.h"

@interface AddAlreadyCompanyView ()<UITextViewDelegate>
//@property (nonatomic, strong)UITextView *textView;


@end

@implementation AddAlreadyCompanyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        
        
    }
    return self;
}


- (void)initUI {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 270, 142 + 112)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    CALayer * layer = [view layer];
    layer.borderColor = [[UIColor grayColor] CGColor];
    layer.borderWidth = 0.5;
    [self addSubview:view];
    
    _imageView = [[UIImageView alloc]init];
    _imageView.frame = CGRectMake((270 - 60) / 2, 15, 60, 60);
    _imageView.image = [UIImage imageNamed:@"LOGO"];
    [view addSubview:_imageView];
    
    _companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageView.bottom + 12, 270, 16)];
//    _companyLabel.text = @"杭州赢莱金融信息服务有限公司";
    _companyLabel.font = [UIFont systemFontOfSize:16];
    _companyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _companyLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_companyLabel];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, _companyLabel.bottom + 12, 270, 12)];
//    _label.text = @"创建者 :  李总";
    _label.font = [UIFont systemFontOfSize:12];
    _label.textColor = [UIColor colorWithHexString:@"#848484"];
    _label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_label];
    
    _textView = [[UITextView alloc]init];
    _textView.frame = CGRectMake(10, _label.bottom + 10, 250, 100);
    _textView.delegate = self;
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 5;
    _textView.scrollEnabled = NO;
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _textView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    _textView.font = [UIFont systemFontOfSize:14];
    [view addSubview:_textView];
    
    _placeholder = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 250 - 20, 14)];
    _placeholder.text = @"我是...";
    _placeholder.backgroundColor = [UIColor clearColor];
    _placeholder.textColor = [UIColor colorWithHexString:@"#cccccc"];
    [_textView addSubview:_placeholder];

}

//开始编辑的时候,占位符消失
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _placeholder.hidden = YES;
}

//输入到一定字数,不能编辑
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(range.location > 50)
            return NO;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if ([textView.text containsString:@"\n"]) {
        NSMutableString *mStr = [NSMutableString stringWithString:textView.text];
        [mStr deleteCharactersInRange:NSMakeRange(mStr.length-1, 1)];
        textView.text = mStr;
        return;
    }

    if (textView.text.length >= 50) {
        
        textView.text = [textView.text substringToIndex:50];
    }
    
    
    if (textView.text.length > 0) {
        _placeholder.hidden = YES;
    }else {
        _placeholder.hidden = NO;
    }
    
}


@end
