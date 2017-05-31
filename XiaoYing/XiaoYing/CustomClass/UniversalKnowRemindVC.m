//
//  DownloadRemindVC.m
//  XiaoYing
//
//  Created by ZWL on 16/7/13.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "UniversalKnowRemindVC.h"

@interface UniversalKnowRemindVC ()
{
    UIView *_baseView;
    
}

@end

@implementation UniversalKnowRemindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化视图
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    _baseView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-(540/2))/2, (kScreen_Height-100)/2, 540/2, 100)];
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.layer.cornerRadius = 6;
    _baseView.clipsToBounds = YES;
    [self.view addSubview:_baseView];
    
    UILabel *remindLab = [[UILabel alloc] initWithFrame:CGRectMake(12, (_baseView.height-44-40)/2, _baseView.width-12*2, 40)];
    remindLab.font = [UIFont systemFontOfSize:16];
    remindLab.textColor = [UIColor colorWithHexString:@"#333333"];
    remindLab.numberOfLines = 2;
//    remindLab.text = @"对不起，暂时只支持单个文件下载!";
//    remindLab.text = self.textStr;
    remindLab.textAlignment = NSTextAlignmentCenter;
    [_baseView addSubview:remindLab];
    self.remindLab = remindLab;
    
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, _baseView.height-44, _baseView.width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [_baseView addSubview:baseView];
    
    //顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _baseView.width, .5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:topView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, _baseView.width, 44);
    [btn setTitle:@"知道了" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:btn];
    
}
- (void)btnAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)setTextStr:(NSString *)textStr
{
    _textStr = textStr;
    self.remindLab.text = self.textStr;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches anyObject].view == self.view) {

         [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
