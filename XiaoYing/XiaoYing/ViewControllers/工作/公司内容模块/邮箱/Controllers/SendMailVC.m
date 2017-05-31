//
//  SendMailVC.m
//  XiaoYing
//
//  Created by ZWL on 16/2/29.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "SendMailVC.h"

@interface SendMailVC ()<UITextViewDelegate>{
    UILabel *placeLabel;
}
 @end

@implementation SendMailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style: UIBarButtonItemStylePlain target:self action:@selector(deleteAction)];
    self.title = @"新邮件";
    [self initView];
    
}



-(void)initView{
    
   [self createLabelText:@"收件人:" Withframe:CGRectMake(12, 0, 14*4, 38)];
   [self createLabelText:@"抄送/密送:" Withframe:CGRectMake(12, 38, 14*5, 38)];
   [self createLabelText:@"发件人:" Withframe:CGRectMake(12, 38*2, 14*4, 38)];
   [self createLabelText:@"主题:" Withframe:CGRectMake(12, 38*3, 14*3, 38)];
   
    for (int i = 1; i < 5; i++) {
        [self creatrLineWithFrame:CGRectMake(12, 38*i, 296, 0.5)];
    }
    
    [self createFieldWithFlag:100 andframe:CGRectMake(14*4+12, 0, 200, 38)];
    [self createFieldWithFlag:101 andframe:CGRectMake(14*5+12, 38, 200, 38)];
    [self createFieldWithFlag:102 andframe:CGRectMake(14*3+12, 38*3, 200, 38)];
    
    UILabel *sendLabel = [[UILabel alloc]initWithFrame:CGRectMake(14*4+12, 38*2, 200, 38)];
    sendLabel.text = @"linying@yinlaijinrong.com";
    sendLabel.textAlignment = NSTextAlignmentLeft;
    sendLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    sendLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:sendLabel];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(12, 38*4+16, 296, 250)];
    textView.delegate = self;
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
    [self.view addSubview:textView];
    
    placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 6, 14*2, 14)];
    placeLabel.text = @"内容";
    placeLabel.font = [UIFont systemFontOfSize:14];
    placeLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
    [textView addSubview:placeLabel];
    
}

-(void)sendAction{
    NSLog(@"发送");
}
-(void)deleteAction{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"取消");
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    placeLabel.hidden = YES;
    return YES;
}
-(void)createFieldWithFlag:(NSInteger)flag andframe:(CGRect)rect{
    UITextField *filed = [[UITextField alloc]initWithFrame:rect];
    filed.font = [UIFont systemFontOfSize:14];
    filed.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.view addSubview:filed];
}
-(void)createLabelText:(NSString *)str Withframe:(CGRect)rect {
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.text = str;
    label.textColor = [UIColor colorWithHexString:@"#848484"];
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
}

-(void)creatrLineWithFrame:(CGRect)rect{
    UIView *view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [self.view addSubview:view];
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
