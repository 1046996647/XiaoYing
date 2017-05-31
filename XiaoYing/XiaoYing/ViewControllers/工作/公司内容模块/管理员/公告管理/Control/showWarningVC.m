//
//  showWarningVC.m
//  XiaoYing
//
//  Created by 王思齐 on 16/11/23.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "showWarningVC.h"

@interface showWarningVC ()
@property(nonatomic,strong)UIView *baseView;

@end

@implementation showWarningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}


- (void)initView
{
    _baseView = [[UIView alloc] initWithFrame:CGRectZero];
    _baseView.layer.cornerRadius = 5;
    _baseView.clipsToBounds = YES;
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baseView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_baseView addSubview:lab];
    
    _baseView.frame = CGRectMake((kScreen_Width-265)/2.0, (kScreen_Height - 200) / 2, 265,(210+88)/2);
    lab.frame = CGRectMake(16, 10, _baseView.width-16*2, 95);
    lab.text = @"是否确定删除所选公告？";
    
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(_baseView.width/2.0), _baseView.height-44, _baseView.width/2.0, 44);
        btn.tag = i + 100;
        if (btn.tag == 100) {
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        }else {
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        }
        
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_baseView addSubview:btn];
    }
    
    //横分割线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _baseView.frame.size.height - 44, _baseView.width, .5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_baseView addSubview:lineView1];
    
    //竖分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(_baseView.width/2 - 0.5, lineView1.bottom, .5, 44)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_baseView addSubview:lineView2];
    
}


- (void)btnAction:(UIButton *)btn {
    
    if (btn.tag == 100) {
        self.sureBlock();
    }else {
    }
     [self dismissViewControllerAnimated:YES completion:nil];
}

@end
