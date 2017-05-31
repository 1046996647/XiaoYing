//
//  XYDeleteListVc.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/21.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYDeleteListVc.h"
#import "XYPositionViewController.h"

@interface XYDeleteListVc (){
    
    //弹框View
    UIView * _messageBackView;
}

@end

@implementation XYDeleteListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}


   /********** 创建UI界面 *********/
-(void)setupUI{
    
    //弹框View
    _messageBackView = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width - 540/2)/2, (kScreen_Height - 64-200/2)/2, 540/2, 100)];
    _messageBackView.backgroundColor = [UIColor whiteColor];
    _messageBackView.layer.cornerRadius = 5;
    _messageBackView.clipsToBounds = YES;
    [self.view addSubview:_messageBackView];
    
    //弹框上的标题Label
    UILabel * messageLabel = [[UILabel alloc]init];
    messageLabel.text = @"是否确认删除所选职位类别?";
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
    line.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_messageBackView addSubview:line];
    
    
    
    //确定按钮(clickDeleteRight)
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, line.bottom, _messageBackView.width/2, 44)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightBtn addTarget:self action:@selector(clickDeleteRight) forControlEvents:UIControlEventTouchUpInside];
    [_messageBackView addSubview:rightBtn];
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(_messageBackView.width/2 - 0.5, line.bottom, 0.5, 44)];
    middleView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_messageBackView addSubview:middleView];
    
    
    //取消按钮(clickCancelBtn)
    UIButton * cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(rightBtn.right, line.bottom, _messageBackView.width/2, 44)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelButton addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [_messageBackView addSubview:cancelButton];
    
    
    _messageBackView.frame = CGRectMake((kScreen_Width - 540/2)/2, (kScreen_Height -rightBtn.bottom)/2, 540/2, rightBtn.bottom );
    

    
    
    
}

//点击确定按钮
-(void)clickDeleteRight{
    NSLog(@"删除");
    
  //创建通知
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
         [[NSNotificationCenter defaultCenter]postNotificationName:@"delete" object:self];
    
    }];
   
    
    
    
    
}

//点击取消按钮
-(void)clickCancelBtn{
    
    NSLog(@"取消删除");
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
