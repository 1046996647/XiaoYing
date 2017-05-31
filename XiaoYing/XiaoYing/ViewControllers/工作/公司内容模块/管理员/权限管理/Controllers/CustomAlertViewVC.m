//
//  CustomAlertViewVC.m
//  XiaoYing
//
//  Created by GZH on 16/8/3.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "CustomAlertViewVC.h"

@interface CustomAlertViewVC ()

@end

@implementation CustomAlertViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initView];
    
}



- (void)initView {
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectZero];
    baseView.layer.cornerRadius = 5;
    baseView.clipsToBounds = YES;
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    //    lab.text = self.text;
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    [baseView addSubview:lab];

    baseView.frame = CGRectMake((kScreen_Width-270)/2.0, (kScreen_Height - 100) / 2, 270, 100);
    lab.frame = CGRectMake(16, 15, baseView.width-16*2, baseView.height - 15 - 44 - .5);
    lab.text = @"是否确认重置Ta的管理密码?";

    NSArray *titleArr = @[@"确定", @"取消"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(baseView.width/2.0), baseView.height-44, baseView.width/2.0, 44);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
    }
 
    //竖分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(baseView.width/2 - 0.5, baseView.height - 44, .5, 44)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView2];

    //横分割线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, baseView.frame.size.height - 44, baseView.width, .5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView1];
   
}

- (void)initViewTwo {
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectZero];
    baseView.layer.cornerRadius = 5;
    baseView.clipsToBounds = YES;
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    //    lab.text = self.text;
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    [baseView addSubview:lab];
    
    
    baseView.frame = CGRectMake((kScreen_Width-270)/2.0, (kScreen_Height - 100) / 2, 270, 100);
    lab.frame = CGRectMake(16, 15, baseView.width-16*2, baseView.height - 15 - 44 - .5);
    lab.text = @"重置成功, 初始密码 : 1234556";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 1;
    btn.frame = CGRectMake(0, baseView.height - 44, baseView.width, 44);
    [btn setTitle:@"知道了" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:btn];

    //横分割线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, baseView.frame.size.height - 44, baseView.width, .5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView1];
}

- (void)btnAction:(UIButton *)btn {
    if (btn.tag == 0) {

//      [self initViewTwo];
        [self GivePerssionToSommeOneAction];
        
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//修改员工信息
- (void)GivePerssionToSommeOneAction {
    NSString *strURL = [NSString stringWithFormat:@"%@&ManagerProfileId=%@", ReSetSecretURL,_tempProfileId];
    
    
    [AFNetClient POST_Path:strURL params:nil completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if ([code isEqual:@0]) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self performSelector:@selector(hudAction) withObject:nil afterDelay:0.02];
            }];
            
            NSLog(@"-------------------------------%@",JSONDict);
            
        }else {
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
            NSLog(@"-------%@",JSONDict[@"Message"]);
        }
    } failed:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)hudAction {
    [MBProgressHUD showMessage:@"重置成功，该管理员可以重新设置自己的管理密码！" toView:self.view.superview];
}

@end
