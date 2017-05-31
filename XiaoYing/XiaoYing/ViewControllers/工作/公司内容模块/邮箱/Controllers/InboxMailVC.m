//
//  InboxMailVC.m
//  XiaoYing
//
//  Created by ZWL on 16/2/25.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "InboxMailVC.h"
#import "AlertView.h"


@interface InboxMailVC (){
    UIView *hideView;
    UIView *deleteView;
    
    AlertView *alertView;
}

@end

@implementation InboxMailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *beforMail = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow_up"] style:UIBarButtonItemStylePlain target:self action:@selector(beforeMailAction)];
    UIBarButtonItem *nextMail = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow_down-"] style:UIBarButtonItemStylePlain target:self action:@selector(nextMailAction)];
    NSArray *itemArr = @[nextMail,beforMail];
    self.navigationItem.rightBarButtonItems = itemArr;
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self initView];
    
}


-(void)initView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 265)];
    [self.view addSubview:view];
    
    UILabel *titleLabel = [self createLabelWithFont:16 andTextColor:@"#333333"];
    titleLabel.frame = CGRectMake(12, 12, kScreen_Width-24, 16+16+8);
    titleLabel.text = @"标题标题标题标题标题标题标题标题标题标题标题标题标题标题标";
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 2;
    [view addSubview:titleLabel];
    
    UILabel *sendLabel = [self createLabelWithFont:14 andTextColor:@"#848484"];
    sendLabel.frame = CGRectMake(12, titleLabel.bottom+12, 14*4, 14);
    sendLabel.text = @"发件人 : ";
    [view addSubview:sendLabel];
    
    UIView *sendView = [self createMailViewWithName:@"ZWL" andMail:@"linying@yinlaijinrong.com"];
    sendView.frame = CGRectMake(sendLabel.right, sendLabel.top, 200, 32);
    [view addSubview:sendView];
    
    UIButton *hideButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width-50, sendLabel.top, 14*3, 14)];
//    [hideButton setFont:[UIFont systemFontOfSize:14]];
    hideButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [hideButton setTitle:@"隐藏" forState:UIControlStateNormal];
    [hideButton addTarget:self action:@selector(hideAction) forControlEvents:UIControlEventTouchUpInside];
    [hideButton setTitleColor:[UIColor colorWithHexString:@"#40cbf9"] forState:UIControlStateNormal];
 
    [view addSubview:hideButton];
    
    UILabel *getLabel = [self createLabelWithFont:14 andTextColor:@"#848484"];
    getLabel.frame = CGRectMake(12, sendView.bottom+6, 14*4, 14);
    getLabel.text = @"收件人 : ";
    [view addSubview:getLabel];
    
    UIView *getView1 = [self createMailViewWithName:@"ZWL" andMail:@"linying@yinlaijinrong.com"];
    getView1.frame = CGRectMake(getLabel.right, getLabel.top, 200, 35);
    [view addSubview:getView1];
    
    UIView *getView2 = [self createMailViewWithName:@"ZWL" andMail:@"linying@yinlaijinrong.com"];
    getView2.frame = CGRectMake(getView1.left, getView1.bottom+5, 200, 35);
    [view addSubview:getView2];
    
    UILabel *copyLabel = [self createLabelWithFont:14 andTextColor:@"#848484"];
    copyLabel.frame = CGRectMake(26, getView2.bottom+5, 14*3, 14);
    copyLabel.text = @"抄送 : ";
    [view addSubview:copyLabel];
    
    UIView *copyView = [self createMailViewWithName:@"ZWL" andMail:@"linying@yinlaijinrong.com"];
    copyView.frame = CGRectMake(copyLabel.right, copyLabel.top, 200, 35);
    [view addSubview:copyView];

    UILabel *timeLabel = [self createLabelWithFont:14 andTextColor:@"#848484"];
    timeLabel.frame = CGRectMake(26, copyView.bottom+5, 14*3, 14);
    timeLabel.text = @"时间 : ";
    [view addSubview:timeLabel];
    
    UILabel *timerLabel = [self createLabelWithFont:14 andTextColor:@"#333333"];
    timerLabel.frame = CGRectMake(timeLabel.right, timeLabel.top, 200, 14);
    timerLabel.text = @"2016-01-19 17:35";
    [view addSubview:timerLabel];

    UILabel *attachLabel = [self createLabelWithFont:14 andTextColor:@"#848484"];
    attachLabel.frame = CGRectMake(26, timerLabel.bottom+5, 14*3, 14);
    attachLabel.text = @"附件 : ";
    [view addSubview:attachLabel];

    UILabel *attachNumLabel = [self createLabelWithFont:14 andTextColor:@"#333333"];
    attachNumLabel.frame = CGRectMake(attachLabel.right, attachLabel.top, 28, 14);
    attachNumLabel.text = @"2个";
    [view addSubview:attachNumLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 264, kScreen_Width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [view addSubview:lineView];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 265, kScreen_Width, 84)];
    [self.view addSubview:contentView];
    
    UILabel *contentlabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 8, kScreen_Width-24, 70)];
    contentlabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentlabel.numberOfLines = 0;
    contentlabel.textColor = [UIColor colorWithHexString:@"#333333"];
    contentlabel.font = [UIFont systemFontOfSize:14];
    contentlabel.text = @"内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内";
    [contentView addSubview:contentlabel];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 83, kScreen_Width, 0.5)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [contentView addSubview:lineView2];
    
    UIView *attachView = [self createAttachView];
    attachView.frame = CGRectMake(0, 350, kScreen_Width, 44);
    [self.view addSubview:attachView];
    
    UIView *btnLine = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height-102, kScreen_Width, 0.5)];
    btnLine.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [self.view addSubview:btnLine];
    
    if (self.emailBoxStyle == 2) {
        NSArray *imageArr = @[[UIImage imageNamed:@"staring"],[UIImage imageNamed:@"editor"],[UIImage imageNamed:@"forwarding"],[UIImage imageNamed:@"deletemail"]];
        for (int i = 0; i<4; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*kScreen_Width/4, kScreen_Height-102, kScreen_Width/4, 38)];
            button.tag = 100;
            [button setImage:imageArr[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        }

    }else if (self.emailBoxStyle == 3) {
        NSArray *imageArr = @[[UIImage imageNamed:@"editor"],[UIImage imageNamed:@"deletemail"]];
        for (int i = 0; i<2; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*kScreen_Width/2, kScreen_Height-102, kScreen_Width/2, 38)];
            [button setImage:imageArr[i] forState:UIControlStateNormal];
            [self.view addSubview:button];
        }
    }else if (self.emailBoxStyle == 4){
        NSArray *imageArr = @[[UIImage imageNamed:@"restore"],[UIImage imageNamed:@"reply"],[UIImage imageNamed:@"forwarding"],[UIImage imageNamed:@"deletemail"]];
        for (int i = 0; i<4; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*kScreen_Width/4, kScreen_Height-102, kScreen_Width/4, 38)];
            button.tag = 100+i;
            [button setImage:imageArr[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        }

    }else{
        NSArray *imageArr = @[[UIImage imageNamed:@"staring"],[UIImage imageNamed:@"reply"],[UIImage imageNamed:@"forwarding"],[UIImage imageNamed:@"deletemail"]];
        for (int i = 0; i<4; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*kScreen_Width/4, kScreen_Height-102, kScreen_Width/4, 38)];
            button.tag = 100;
            [button setImage:imageArr[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        }
 
    }
   
    alertView = [[AlertView alloc]initWithFrame:self.view.bounds];
    alertView.hidden = YES;
    alertView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];    
    [self.view addSubview:alertView];
    
}


-(UIView *)createAttachView{
    UIView *attachView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
   
    [self.view addSubview:attachView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 7, 30, 30)];
    imageView.backgroundColor = [UIColor grayColor];
    [attachView addSubview:imageView];
    
    UILabel *nameLabel = [self createLabelWithFont:14 andTextColor:@"#333333"];
    nameLabel.frame = CGRectMake(imageView.right+12, 7, 100, 14);

    nameLabel.text = @"名称.jpg";
    [attachView addSubview:nameLabel];
    
    UILabel *sizeLabel = [self createLabelWithFont:12 andTextColor:@"#848484"];
    sizeLabel.frame = CGRectMake(nameLabel.left, nameLabel.bottom+6, 50, 12);
    sizeLabel.text = @"139k";
    [attachView addSubview:sizeLabel];
    
    UIImageView  *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width-12-12, 13, 12, 18)];
    arrowImageView.image = [UIImage imageNamed:@"arrow-set"];
    [attachView addSubview:arrowImageView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 42.5, kScreen_Width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [attachView addSubview:lineView];
    
    return  attachView;
}


-(UIView *)createMailViewWithName:(NSString *)name andMail:(NSString *)mail{
    UIView *view = [[UIView alloc]init];
    UILabel *personLabel = [self createLabelWithFont:14 andTextColor:@"#333333"];
    personLabel.frame = CGRectMake(0, 0, 50, 14);
    personLabel.text = name;
    [view addSubview:personLabel];
    
    UILabel *mailLabel = [self createLabelWithFont:12 andTextColor:@"#848484"];
    mailLabel.frame = CGRectMake(0, personLabel.bottom+5, 150, 14);
    mailLabel.text = mail;
    [view addSubview:mailLabel];
    return view;
    
}
- (UILabel *)createLabelWithFont:(CGFloat)font andTextColor:(NSString *)color{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor colorWithHexString:color];
    label.font = [UIFont systemFontOfSize:font];
    return label;
}


-(void)bottomBtnAction:(UIButton *)btn{
    
    alertView.hidden = NO;
    
}

-(void)noDeleteAction{
    
    alertView.hidden = YES;
}
-(void)deleteAllAction{
    
    alertView.hidden = YES;
}
-(void)hideAction{
    NSLog(@"隐藏");
}

-(void)beforeMailAction{
    NSLog(@"上一封邮件");
}

-(void)nextMailAction{
    NSLog(@"下一封邮件");
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
