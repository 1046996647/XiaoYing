//
//  XYModalErrorViewController.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/7/23.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "XYModalErrorViewController.h"

#import "XYModalMessageViewController.h"


@interface XYModalErrorViewController ()
{
    //弹框view
    UIView * _messageBackView;
    AppDelegate *_appDelegate;
}


@end

@implementation XYModalErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //弹框View
    _messageBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 540/2, 0)];
    _messageBackView.backgroundColor = [UIColor whiteColor];
    _messageBackView.layer.cornerRadius = 5;
    _messageBackView.clipsToBounds = YES;
    [self.view addSubview:_messageBackView];
    
    //messageLabel
    
    UILabel * messageLabel = [[UILabel alloc]init];
    messageLabel.text = @"fsdfsfsdfsefsfsfsfsfefsfsfeu96y892b5j4bio2tjo54v2jtj5iot4j2tvop2jit4p2vjtpo";
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont systemFontOfSize:16];
    //设置最大宽度和最大高度
    CGSize maxLabelSize = CGSizeMake(250, MAXFLOAT);
    //关键,返回最佳大小
    CGSize expectSize = [messageLabel sizeThatFits:maxLabelSize];
    messageLabel.frame = CGRectMake(10, 10, expectSize.width, expectSize.height);
    [_messageBackView addSubview:messageLabel];


    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, messageLabel.bottom + 10, _messageBackView.width, .5)];
    [_messageBackView addSubview:line];
    line.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    
    UIButton * messageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, line.bottom, _messageBackView.width, 44)];
    [_messageBackView addSubview:messageButton];
    [messageButton setTitle:@"知道了" forState:UIControlStateNormal];
    messageButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [messageButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    
    [messageButton addTarget:self action:@selector(putOnView) forControlEvents:UIControlEventTouchUpInside];
 
    _messageBackView.frame = CGRectMake((kScreen_Width - 540/2)/2, (kScreen_Height - messageButton.bottom)/2, 540/2, messageButton.bottom );
    
  }

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches anyObject].view == self.view) {
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }
    
}

#pragma mark 

-(void)putOnView
{
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



