//
//  RevokeApplyViewController.m
//  XiaoYing
//
//  Created by chenchanghua on 16/12/28.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "RevokeApplyViewController.h"
#import "ApplyViewModel.h"
#import "XYExtend.h"
#import "ApplyProcessVC.h"

@interface RevokeApplyViewController ()

@end

@implementation RevokeApplyViewController
{
    //弹框view
    UIView * _messageBackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化提示框
    [self setupBaseView];
}

- (void)setupBaseView
{
    //弹框View
    _messageBackView = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width - 540/2)/2, (kScreen_Height - 64-200/2)/2, 540/2, 100)];
    _messageBackView.backgroundColor = [UIColor whiteColor];
    _messageBackView.layer.cornerRadius = 5;
    _messageBackView.clipsToBounds = YES;
    [self.view addSubview:_messageBackView];
    
    //提示文字的设置
    UILabel * messageLabel = [[UILabel alloc]init];
    messageLabel.text = @"是否确定撤销申请?";
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont systemFontOfSize:16];
    messageLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    messageLabel.numberOfLines = 0;
    //设置最大宽度和最大高度
    CGSize maxLabelSize = CGSizeMake(270, MAXFLOAT);
    //关键,返回最佳大小
    CGSize expectSize = [messageLabel sizeThatFits:maxLabelSize];
    messageLabel.frame = CGRectMake(0, 10, _messageBackView.width, expectSize.height);
    [_messageBackView addSubview:messageLabel];
    
    //说明文字下面的一条线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, messageLabel.bottom + 10, _messageBackView.width, 1.5)];
    [_messageBackView addSubview:line];
    line.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    
    //确定按钮的设置
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, line.bottom, _messageBackView.width/2, 44)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightBtn addTarget:self action:@selector(clickDeleteRight) forControlEvents:UIControlEventTouchUpInside];
    [_messageBackView addSubview:rightBtn];
    
    //确定按钮和取消按钮之间的分割线
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(_messageBackView.width/2 - 0.5, line.bottom, 0.5, 44)];
    middleView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_messageBackView addSubview:middleView];
    
    //取消按钮的设置
    UIButton * cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(rightBtn.right, line.bottom, _messageBackView.width/2, 44)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelButton addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [_messageBackView addSubview:cancelButton];
    
    //确定提示框的frame
    _messageBackView.frame = CGRectMake((kScreen_Width - 540/2)/2, (kScreen_Height -rightBtn.bottom)/2, 540/2, rightBtn.bottom );
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches anyObject].view == self.view) {
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }

}

//确定删除
-(void)clickDeleteRight
{
    NSLog(@"删除");
    
    //点击完“确定”后，立马让该提示框消失
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //在网络端撤销
    [ApplyViewModel revokeApplicationWithApplicationId:self.applyRequestId success:^(NSDictionary *dataList) {
        
        //1.提示已经撤销
        [MBProgressHUD showMessage:@"已撤销"];
        
        //2.刷新
        /*由于接口问题，无法实现，暂时改为－跳转到上一个界面*/
        
        //设置时间为2
        double delayInSeconds = 1.5;
        //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
        dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        //推迟两纳秒执行
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_after(delayInNanoSeconds, mainQueue, ^(void){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplyProgressVCGoBackNotification" object:nil];
        });
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@", error);
    }];
    
}

//点击取消
-(void)clickCancelBtn
{
    NSLog(@"取消");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
