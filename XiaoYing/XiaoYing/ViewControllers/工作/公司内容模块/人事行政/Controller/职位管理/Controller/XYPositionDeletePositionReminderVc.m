//
//  XYPositionDeletePositionReminderVc.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/8/11.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYPositionDeletePositionReminderVc.h"

@interface XYPositionDeletePositionReminderVc ()
{
    UIView  *_errorView;
}

@end

@implementation XYPositionDeletePositionReminderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

-(void)initUI{
    
    //弹框View
    _errorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 540/2, 0)];
    _errorView.backgroundColor = [UIColor whiteColor];
    _errorView.layer.cornerRadius = 5;
    _errorView.clipsToBounds = YES;
    [self.view addSubview:_errorView];
    
    //messageLabel
    UILabel * messageLabel = [[UILabel alloc]init];
    messageLabel.text = @"这个里面有人担任职位,不能删除啊!!!";
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont systemFontOfSize:16];
    
    
    
    
    
    //设置最大宽度和最大高度
    CGSize maxLabelSize = CGSizeMake(270 - 24, MAXFLOAT);
    //关键,返回最佳大小
    CGSize expectSize = [messageLabel sizeThatFits:maxLabelSize];
    messageLabel.frame = CGRectMake(12, 12, expectSize.width, expectSize.height);
    [_errorView addSubview:messageLabel];
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, messageLabel.bottom + 12, _errorView.width, .5)];
    [_errorView addSubview:line];
    line.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    
    UIButton * messageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, line.bottom, _errorView.width, 44)];
    [_errorView addSubview:messageButton];
    [messageButton setTitle:@"知道了" forState:UIControlStateNormal];
    messageButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [messageButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    
    [messageButton addTarget:self action:@selector(setKnowButton) forControlEvents:UIControlEventTouchUpInside];
    
    _errorView.frame = CGRectMake((kScreen_Width - 540/2)/2, (kScreen_Height - messageButton.bottom)/2, 540/2, messageButton.bottom );
    


}

#pragma mark method
-(void)setKnowButton{
    
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
