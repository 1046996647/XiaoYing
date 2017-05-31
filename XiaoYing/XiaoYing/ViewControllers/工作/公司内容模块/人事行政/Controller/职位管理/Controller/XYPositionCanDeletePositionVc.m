//
//  XYPositionCanDeletePositionVc.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/8/11.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYPositionCanDeletePositionVc.h"
#import "XYAddListVc.h"
#import "XYEditPositionVc.h"
#import "XYPositionDeletePositionReminderVc.h"
#import "CompanyJobViewModel.h"

@interface XYPositionCanDeletePositionVc ()
{
    //弹框view
    UIView * _messageBackView;
    AppDelegate *_appDelegate;
    
    //该职位下的员工数量
    NSInteger _employeeCount;

}

@end

@implementation XYPositionCanDeletePositionVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getEmployeeCountInsideJobByJobId:self.jobModel.jobId];
    
    //弹框View
    _messageBackView = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width - 540/2)/2, (kScreen_Height - 64-200/2)/2, 540/2, 100)];
    _messageBackView.backgroundColor = [UIColor whiteColor];
    _messageBackView.layer.cornerRadius = 5;
    _messageBackView.clipsToBounds = YES;
    [self.view addSubview:_messageBackView];
    
    
    UILabel * messageLabel = [[UILabel alloc]init];
    messageLabel.text = [NSString stringWithFormat:@"确定删除 %@ 职位?",self.jobModel.jobName];
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
    
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, messageLabel.bottom + 10, _messageBackView.width, .5)];
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
    if (_employeeCount) {//这个界面暂时无法测试

        [self dismissViewControllerAnimated:YES completion:nil];
        [MBProgressHUD showError:@"有成员任职,不能删除!" toView:self.presentedViewController.view];
        

    }else {

        [self deleteJobMessageByJobId:self.jobModel.jobId];
        [self dismissViewControllerAnimated:YES completion:nil];

        
    
    }


}

//点击取消
-(void)clickCancelBtn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteJobMessageByJobId:(NSString *)jobId
{
    [CompanyJobViewModel deleteJobMessageWithJobId:jobId success:^(id JSONDict) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"popTheSuperViewController" object:nil];
        
    } failed:^(NSError *error) {
        
        NSLog(@"删除职位失败:%@",error);
        
    }];
}

- (void)getEmployeeCountInsideJobByJobId:(NSString *)jobId
{
    [CompanyJobViewModel getEmpolyeeCountWithJobId:jobId success:^(NSInteger empolyeeCount) {
        
        _employeeCount = empolyeeCount;
        
    } failed:^(NSError *error) {
        
        NSLog(@"获取该职位下的员工数目失败:%@",error);
        
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
