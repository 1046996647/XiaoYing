//
//  XYAddPositionSecondWrongVc.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/8/11.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYAddPositionSecondWrongVc.h"

@interface XYAddPositionSecondWrongVc (){
    
    UIView * _secondErrorView;
}

@end

@implementation XYAddPositionSecondWrongVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI{
    
    //弹框View
    _secondErrorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 540/2, 0)];
    _secondErrorView.backgroundColor = [UIColor whiteColor];
    _secondErrorView.layer.cornerRadius = 5;
    _secondErrorView.clipsToBounds = YES;
    [self.view addSubview:_secondErrorView];
    
    //messageLabel
    UILabel * messageLabel = [[UILabel alloc]init];
    messageLabel.text = @"同一类别不能存在相同职位!";
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont systemFontOfSize:16];
    //设置最大宽度和最大高度
    CGSize maxLabelSize = CGSizeMake(270 - 24, MAXFLOAT);
    //关键,返回最佳大小
    CGSize expectSize = [messageLabel sizeThatFits:maxLabelSize];
    messageLabel.frame = CGRectMake( (540/2 - expectSize.width)/2, 12, expectSize.width, expectSize.height);
    [_secondErrorView addSubview:messageLabel];
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, messageLabel.bottom + 12, _secondErrorView.width, .5)];
    [_secondErrorView addSubview:line];
    line.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    
    UIButton * messageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, line.bottom, _secondErrorView.width, 44)];
    [_secondErrorView addSubview:messageButton];
    [messageButton setTitle:@"知道了" forState:UIControlStateNormal];
    messageButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [messageButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    
    [messageButton addTarget:self action:@selector(setKnowButton) forControlEvents:UIControlEventTouchUpInside];
    
    _secondErrorView.frame = CGRectMake((kScreen_Width - 540/2)/2, (kScreen_Height - messageButton.bottom)/2, 540/2, messageButton.bottom );
}

#pragma mark method
-(void)setKnowButton{
    

    [self dismissViewControllerAnimated:YES completion:nil];
    
    
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
