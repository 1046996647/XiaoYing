//
//  EmployeeDeparture.m
//  XiaoYing
//
//  Created by GZH on 16/10/28.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "EmployeeDeparture.h"

@interface EmployeeDeparture ()

@property (nonatomic, strong)UIView *baseView;
@property (nonatomic, strong)NSString *sureBtn;
@property (nonatomic) int countOfClick;
@end

@implementation EmployeeDeparture

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
    
    _baseView.frame = CGRectMake((kScreen_Width-270)/2.0, (kScreen_Height - 200) / 2, 270,(210+88)/2);
    lab.frame = CGRectMake(16, 10, _baseView.width-16*2, 95);
    NSString *redStr = @"是否确认删除该员工信息？\n此操作不可逆，请谨慎处理！";
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:redStr];
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, 2)];
    [lab setAttributedText:noteStr] ;


    _countOfClick = 3;
    _sureBtn = [NSString stringWithFormat:@"确定（%d）",_countOfClick];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(_baseView.width/2.0), _baseView.height-44, _baseView.width/2.0, 44);
        btn.tag = i;
        
        if (btn.tag == 0) {
            NSMutableAttributedString *btnTitle = [[NSMutableAttributedString alloc]initWithString:_sureBtn];
            [btnTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
            [btn setAttributedTitle:btnTitle forState:UIControlStateNormal];
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
    
    if (btn.tag == 0) {
        if (_countOfClick != 1) {
            _countOfClick = _countOfClick-1;
             _sureBtn = [NSString stringWithFormat:@"确定（%d）",_countOfClick];
            NSMutableAttributedString *btnTitle = [[NSMutableAttributedString alloc]initWithString:_sureBtn];
            [btnTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)];
            [btn setAttributedTitle:btnTitle forState:UIControlStateNormal];
            
        }else {

            if ([self.delegate respondsToSelector:@selector(employDepareture)]) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.delegate employDepareture];
            }
        }
    }else {
        NSLog(@"987删除");
          [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
