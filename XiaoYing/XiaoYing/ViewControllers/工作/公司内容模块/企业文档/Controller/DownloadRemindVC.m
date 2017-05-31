//
//  DownloadRemindVC.m
//  XiaoYing
//
//  Created by ZWL on 16/7/13.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DownloadRemindVC.h"

@interface DownloadRemindVC ()
{
    UIView *_baseView;
    
}

@end

@implementation DownloadRemindVC

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
    
//    UILabel *remindLab = [[UILabel alloc] initWithFrame:CGRectMake(12, (_baseView.height-44-40)/2, _baseView.width-12*2, 40)];
//    remindLab.font = [UIFont systemFontOfSize:16];
//    remindLab.textColor = [UIColor colorWithHexString:@"#333333"];
//    remindLab.numberOfLines = 2;
//    remindLab.text = @"对不起，暂时只支持单个文件下载!";
//    remindLab.textAlignment = NSTextAlignmentCenter;
//    [_baseView addSubview:remindLab];
//    
//    
//    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, _baseView.height-44, _baseView.width, 44)];
//    baseView.backgroundColor = [UIColor whiteColor];
//    [_baseView addSubview:baseView];
//    
//    //顶部横线
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _baseView.width, .5)];
//    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
//    [baseView addSubview:topView];
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, _baseView.width, 44);
//    [btn setTitle:@"知道了" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
//    
//    btn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [baseView addSubview:btn];
    
}
- (void)btnAction:(UIButton *)btn
{
    if (btn.tag == 100) {
        self.sureBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)setIsSingle:(BOOL)isSingle{
    _isSingle = isSingle;
    if (isSingle == YES) {
        UILabel *remindLab = [[UILabel alloc] initWithFrame:CGRectMake(12, (_baseView.height-44-40)/2, _baseView.width-12*2, 40)];
        remindLab.font = [UIFont systemFontOfSize:16];
        remindLab.textColor = [UIColor colorWithHexString:@"#333333"];
        remindLab.numberOfLines = 2;
        remindLab.text = @"对不起，暂时只支持单个文件下载!";
        remindLab.textAlignment = NSTextAlignmentCenter;
        [_baseView addSubview:remindLab];
        
        
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
    }else{
        UILabel *remindLab = [[UILabel alloc] initWithFrame:CGRectMake(12, (_baseView.height-44-40)/2, _baseView.width-12*2, 40)];
        remindLab.font = [UIFont systemFontOfSize:16];
        remindLab.textColor = [UIColor colorWithHexString:@"#333333"];
        remindLab.numberOfLines = 2;
        remindLab.text = @"文件已下载，是否确定重新下载？";
        remindLab.textAlignment = NSTextAlignmentCenter;
        [_baseView addSubview:remindLab];
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, _baseView.height-44, _baseView.width, 44)];
        baseView.backgroundColor = [UIColor whiteColor];
        [_baseView addSubview:baseView];
        
        //顶部横线
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _baseView.width, .5)];
        topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [baseView addSubview:topView];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, _baseView.width/2, 44);
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.tag = 100;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(_baseView.width/2, 0, _baseView.width/2, 44);
        [btn2 setTitle:@"取消" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        
        btn2.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn2];

    }
}

@end
