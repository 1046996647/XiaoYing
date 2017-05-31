//
//  MailVC.m
//  XiaoYing
//
//  Created by ZWL on 15/11/10.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "MailVC.h"
#import "SetVC.h"
#import "SthMailVC.h"
#import "InboxVC.h"
#import "SendMailVC.h"



@interface MailVC ()<UITableViewDataSource,UITableViewDelegate>{
    int i ; //标记是一个邮箱还是多个邮箱 0时表示一个邮箱，1时表示多个邮箱
     NSArray *upLabelArr;
    NSArray *mailArr;
    int height;//tableView的高度
}

@end

@implementation MailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    i = 1;
    self.title=@"邮箱";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setAction)];
    
    if(i == 0){
        upLabelArr = @[@"收件箱",@"星标邮件",@"通讯录"];
        height = 12+44*6+29;
    }else if (i == 1){
        upLabelArr = @[@"所有收件箱",@"所有星标邮件",@"通讯录"];
        mailArr = @[@"784946336@qq.com",@"15757164486@163.com"];
        height = 12+29+44*(3+(int)mailArr.count);
    }
    [self initView];
    

}


-(void)initView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, height) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    UIButton *sendBtnb = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreen_Height-44-65, kScreen_Width, 44)];
    sendBtnb.backgroundColor = [UIColor whiteColor];
    [sendBtnb addTarget:self action:@selector(sendMailAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtnb];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((kScreen_Width-84)/2, 0, 16*3, 44)];
    label.text = @"发邮件";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor colorWithHexString:@"#f99740"];
    [sendBtnb addSubview:label];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(label.right+10, 14, 16, 16)];
    image.image = [UIImage imageNamed:@"writemail"];
    [sendBtnb addSubview:image];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 12;
    }else{
        return 29;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 12)];
        view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        return view;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 29)];
        view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 29)];
        label.text = @"邮箱";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"#848484"];
        [view addSubview:label];
        return view;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        if (i == 0) {
            return 3;
        }else{
            return mailArr.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = @"10";
    
    if (indexPath.section == 0) {
        NSArray *imageArr = @[[UIImage imageNamed:@"inbox"],[UIImage imageNamed:@"star"],[UIImage imageNamed:@"address"]];
       
        cell.imageView.image = imageArr[indexPath.row];
        cell.textLabel.text = upLabelArr[indexPath.row];
      
    }else if (indexPath.section == 1){
        if (i == 0) {
            NSArray *imageArr = @[[UIImage imageNamed:@"sended"],[UIImage imageNamed:@"draft"],[UIImage imageNamed:@"delete"]];
            NSArray *labelArr = @[@"已发送",@"草稿箱",@"垃圾箱"];
            cell.imageView.image = imageArr[indexPath.row];
            cell.textLabel.text = labelArr[indexPath.row];
        }else{
            cell.textLabel.text = mailArr[indexPath.row];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            InboxVC *vc = [[InboxVC alloc]init];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
            [self.navigationController pushViewController:vc animated:YES];
            vc.title = @"收件箱";
        }else if (indexPath.row == 1){
            InboxVC *vc = [[InboxVC alloc]init];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
            [self.navigationController pushViewController:vc animated:YES];
            vc.title = @"星标邮件";
        }else {
            NSLog(@"通讯录");
        }
    }else{
        //单个邮箱
        if (i == 0) {
            if (indexPath.row == 0) {
                NSLog(@"已发送邮件");
            }else if (indexPath.row == 1){
                NSLog(@"草稿箱");
            }else{
                NSLog(@"垃圾箱");
            }
        }else{//多个邮箱
            SthMailVC *mail = [[SthMailVC alloc]init];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
            mail.title = mailArr[indexPath.row];
            [self.navigationController pushViewController:mail animated:YES];
        }
    }
}

-(void)sendMailAction{
    NSLog(@"发送邮件");
    SendMailVC *vc = [[SendMailVC alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setAction{
    NSLog(@"设置");
    
    SetVC *vc = [[SetVC alloc]init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
