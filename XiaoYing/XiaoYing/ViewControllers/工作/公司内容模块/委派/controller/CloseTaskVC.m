//
//  RejectVC.m
//  XiaoYing
//
//  Created by ZWL on 16/5/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "CloseTaskVC.h"

@interface CloseTaskVC ()
{
    UIView *_baseView;
}

@end

@implementation CloseTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-(540/2))/2, (kScreen_Height-100)/2, 540/2, 120)];
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.layer.cornerRadius = 6;
    _baseView.clipsToBounds = YES;
    [self.view addSubview:_baseView];
    
    UILabel *remindLab = [[UILabel alloc] initWithFrame:CGRectMake(12, (_baseView.height-44-60)/2, _baseView.width-12*2, 60)];
    remindLab.font = [UIFont systemFontOfSize:16];
    remindLab.textColor = [UIColor colorWithHexString:@"#333333"];
    remindLab.numberOfLines = 3;
    remindLab.text = @"若关闭任务，执行人将无法提交任务的成果，该任务将不计入委派进度，确定关闭任务吗?";
    //    remindLab.textAlignment = NSTextAlignmentCenter;
    [_baseView addSubview:remindLab];
    
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, _baseView.height-44, _baseView.width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [_baseView addSubview:baseView];
    
    //顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _baseView.width, .5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:topView];
    
    NSArray *titleArr = @[@"取消",@"确定"];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnAction:(UIButton *)btn
{
    if (btn.tag == 0) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    else {
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches anyObject].view == self.view) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}

@end
