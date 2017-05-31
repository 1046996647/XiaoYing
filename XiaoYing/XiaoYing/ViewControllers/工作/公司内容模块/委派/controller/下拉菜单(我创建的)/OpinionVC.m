//
//  OpinionVC.m
//  XiaoYing
//
//  Created by ZWL on 16/5/31.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "OpinionVC.h"
#import "RecordView.h"

@interface OpinionVC ()<UITextViewDelegate>
{
    UIView *_baseView;
    UILabel *_remindLab;

}

@end

@implementation OpinionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-(540/2))/2, (kScreen_Height-(450/2))/2, 540/2, 450/2)];
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.layer.cornerRadius = 6;
    _baseView.clipsToBounds = YES;
    [self.view addSubview:_baseView];
    
    
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(10, 11, _baseView.width-20, _baseView.height-11-44)];
    tv.delegate = self;
    [_baseView addSubview:tv];
    
    UILabel *remindLab = [[UILabel alloc] initWithFrame:CGRectMake(2, 8, tv.width, 12)];
    remindLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    remindLab.text = @"请输入批改意见，限字280个";
    remindLab.font = [UIFont systemFontOfSize:12];
    [tv addSubview:remindLab];
    _remindLab = remindLab;

    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, tv.bottom, _baseView.width, .5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_baseView addSubview:lineView];
    
    RecordView *recordView = [[RecordView alloc] initWithFrame:CGRectMake(10, tv.bottom+7, 390/2, 30)];
    recordView.layer.cornerRadius = 6;
    recordView.clipsToBounds = YES;
    recordView.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
    recordView.layer.borderWidth = .5;
    [_baseView addSubview:recordView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(recordView.right+10, tv.bottom+7, 45, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.cornerRadius = 6;
    btn.clipsToBounds = YES;
    [btn setTitle:self.btnText forState:UIControlStateNormal];
    [_baseView addSubview:btn];
    
    if ([self.btnText isEqualToString:@"成功"]) {
        btn.backgroundColor = [UIColor colorWithHexString:@"#02bb00"];

    } else if ([self.btnText isEqualToString:@"重做"]) {
        btn.backgroundColor = [UIColor colorWithHexString:@"#f99740"];

    } else {
        btn.backgroundColor = [UIColor colorWithHexString:@"#f94040"];

    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches anyObject].view == self.view) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        _remindLab.hidden = YES;
        
    } else {
        _remindLab.hidden = NO;
        
    }
}


@end
