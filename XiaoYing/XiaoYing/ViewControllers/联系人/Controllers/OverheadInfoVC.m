//
//  ComfirmMoveController.m
//  XiaoYing
//
//  Created by yinglaijinrong on 16/1/20.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "OverheadInfoVC.h"

@interface OverheadInfoVC()<UITextViewDelegate>
{
    UIView *_baseView;
    UITextView *_textView;
    UILabel *_remindLab;
    UILabel *_fontLab;

}

@end

@implementation OverheadInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //初始化视图
    [self initView];
}

- (void)initView
{
    _baseView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-(540/2))/2, 100, 540/2, 278/2)];
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.layer.cornerRadius = 6;
    _baseView.clipsToBounds = YES;
    [self.view addSubview:_baseView];
    
    //文本视图
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, _baseView.width-20, 118/2)];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.delegate = self;
    _textView.textColor = [UIColor colorWithHexString:@"333333"];
    [_textView becomeFirstResponder];
    [_baseView addSubview:_textView];
    
    _remindLab = [[UILabel alloc] initWithFrame:CGRectMake(4, 8, 60, 14)];
    _remindLab.text = @"我是...";
    _remindLab.font = [UIFont systemFontOfSize:14];
    _remindLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    [_textView addSubview:_remindLab];
    
    //剩余字数label
    _fontLab = [[UILabel alloc] initWithFrame:CGRectMake(_baseView.width - 20 - 12, _textView.bottom+5, 40, 20)];
    _fontLab.text = @"50";
    _fontLab.font = [UIFont systemFontOfSize:12];
    _fontLab.textColor = [UIColor colorWithHexString:@"#848484"];
    [_baseView addSubview:_fontLab];
    
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, _baseView.height-44, _baseView.width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [_baseView addSubview:baseView];
    
    //顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _baseView.width, .5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:topView];
    
    
    NSArray *titleArr = @[@"发送",@"取消"];
    
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(_baseView.width/2.0), 0, _baseView.width/2.0, 44);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
        
    }
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(baseView.width/2.0, (44-20)/2, .5, 20)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView];
    
}


- (void)btnAction:(UIButton *)btn
{
    if (btn.tag == 0) {
        
        if (self.clickBlock) {
            self.clickBlock(_textView.text);
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
//    if ([textView.text containsString:@"\n"]) {
//        
//        NSMutableString *mStr = [NSMutableString stringWithString:textView.text];
//        [mStr deleteCharactersInRange:NSMakeRange(mStr.length-1, 1)];
//        textView.text = mStr;
//        [self saveAction];
//        return;
//    }
    
    if (textView.text.length > 0) {
        _remindLab.hidden = YES;
    }
    else {
        _remindLab.hidden = NO;

    }
    
    //余数统计
    NSString  *textContent = textView.text;
    NSInteger existTextNum = [textContent length];
    
    if (existTextNum > 50) {
        textView.text = [textView.text substringToIndex:50];
        existTextNum = 50;
    }
    
    NSInteger remainTextNum_ = 50 - existTextNum;
    _fontLab.text = [NSString stringWithFormat:@"%ld",(long)remainTextNum_];
    
}



@end
