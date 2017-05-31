//
//  RejectVC.m
//  XiaoYing
//
//  Created by ZWL on 16/5/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "RejectVC.h"

@interface RejectVC ()
{
    UIView *_baseView;
}

@end

@implementation RejectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-(540/2))/2, (kScreen_Height-100)/2, 540/2, 100)];
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.layer.cornerRadius = 6;
    _baseView.clipsToBounds = YES;
    [self.view addSubview:_baseView];
    
    UILabel *remindLab = [[UILabel alloc] initWithFrame:CGRectMake(12, (_baseView.height-44-40)/2, _baseView.width-12*2, 40)];
    remindLab.font = [UIFont systemFontOfSize:16];
    remindLab.textColor = [UIColor colorWithHexString:@"#333333"];
    remindLab.numberOfLines = 2;
//    remindLab.textAlignment = NSTextAlignmentCenter;
    [_baseView addSubview:remindLab];
    if (self.indexPath.row == 0) {
        remindLab.text = @"是否确定驳回张伟良的更换执行人申请?";
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:remindLab.text];
        [attribute addAttributes:@{
                                   NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#f94040"],
                                   NSFontAttributeName : [UIFont systemFontOfSize:16]
                                   }range:NSMakeRange(4, 2)];
        
        remindLab.attributedText = attribute;
    } else {
        if ([self.text isEqualToString:@"同意"]) {
            remindLab.text = @"是否确定同意张伟良的放弃任务申请?";
            NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:remindLab.text];
            [attribute addAttributes:@{
                                       NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#02bb00"],
                                       NSFontAttributeName : [UIFont systemFontOfSize:16]
                                       }range:NSMakeRange(4, 2)];
            
            remindLab.attributedText = attribute;
        } else {
            remindLab.text = @"是否确定驳回张伟良的放弃任务申请?";
            NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:remindLab.text];
            [attribute addAttributes:@{
                                       NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#f94040"],
                                       NSFontAttributeName : [UIFont systemFontOfSize:16]
                                       }range:NSMakeRange(4, 2)];
            
            remindLab.attributedText = attribute;
        }
    }

    
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
        
        [self dismissViewControllerAnimated:NO completion:^{
            
            // 必须写在里面不然消除不了
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissVC" object:nil];

        }];

    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches anyObject].view == self.view) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}

@end
