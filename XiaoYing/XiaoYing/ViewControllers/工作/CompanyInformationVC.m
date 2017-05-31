//
//  CompanyInformationVC.m
//  XiaoYing
//
//  Created by ZWL on 15/12/18.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "CompanyInformationVC.h"
#import "AppliedViewController.h"

@interface CompanyInformationVC ()<UITextViewDelegate>
{
    UILabel * companyListLab;
    UILabel * companyNameLab;
    UILabel * companyBriefLab;
    
    UITextView *_remarkView;
    
}
@end

@implementation CompanyInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"公司信息";
    self.view.backgroundColor =[UIColor whiteColor];
    [self leftBackBarButton];
    [self rightBackBarButton];
    
    companyListLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 40, 50)];
    companyListLab.text=@"名称:";
    companyListLab.textColor=[UIColor blackColor];
    [self.view addSubview:companyListLab];
    
    companyNameLab=[[UILabel alloc]initWithFrame:CGRectMake(12+50, 0, kScreen_Width -62-12,50)];
    
    companyNameLab.textColor=[UIColor blackColor];
    [self.view addSubview:companyNameLab];
    
    UIView *viewLine=[[UIView alloc]initWithFrame:CGRectMake(12, 50.5, kScreen_Width-24, 0.5)];
    viewLine.backgroundColor=[UIColor colorWithHexString:@"#d5d7dc"];
    [self.view addSubview:viewLine];
    
    companyBriefLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 67.5, 100, 30)];
    companyBriefLab.text=@"公司简介";
    companyBriefLab.textAlignment =NSTextAlignmentLeft;
    companyBriefLab.textColor=[UIColor blackColor];
    [self.view addSubview:companyBriefLab];
    
    [self getCompanyInformation];
    _remarkView=[[UITextView alloc]initWithFrame:CGRectMake(12, 67.5+30+10, kScreen_Width-24, 250)];
    _remarkView.delegate = self;
    _remarkView.font = [UIFont systemFontOfSize:14];
    _remarkView.layer.borderColor = [UIColor colorWithHexString:@"#dfdfdf"].CGColor;
    _remarkView.layer.borderWidth = 0.5;
    _remarkView.layer.cornerRadius=3;
    
    [self.view addSubview:_remarkView];

}

-(void)getCompanyInformation{
    NSMutableString *urlString = [NSMutableString stringWithString:InfoCompany];
    [urlString appendFormat:@"&companyId=%@",self.CompanyId];
    
    [AFNetClient POST_Path2:urlString completed:^(NSData *stringData, id JSONDict) {
        if ([[JSONDict objectForKey:@"Code"] isEqual:@1]) {
            
            [UIView animateWithDuration:2.0 animations:^{
                [MBProgressHUD showError:@"该公司不存在" toView:self.view];
            } completion:^(BOOL finished) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            _remarkView.text = [NSString stringWithFormat:@"%@",[[JSONDict objectForKey:@"Data"] objectForKey:@"CompanyDescription"]];
            companyNameLab.text = [[JSONDict objectForKey:@"Data"] objectForKey:@"CompanyName"];
            
        }
    } failed:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}
//导航栏左边按钮
-(void)leftBackBarButton{
    UIButton * leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame =CGRectMake(0, 0, 30, 30);
    [leftBtn addTarget:self action:@selector(leftBackbtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * leftImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 7.5, 10, 18)];
    leftImage.image =[UIImage imageNamed:@"Arrow-white"];
    [leftBtn addSubview:leftImage];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}
//导航栏右边边按钮
-(void)rightBackBarButton{
    UIButton * rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame =CGRectMake(kScreen_Width -52, 33, 40, 18);
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightWithFinishButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}
-(void)leftBackbtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightWithFinishButtonClick{
    
    //加入公司
    [self postJoinCompany];
    
}
-(void)postJoinCompany{
    //加入公司
    NSMutableString *urlString = [NSMutableString stringWithString:JoinCompany];
    [urlString appendFormat:@"&companyId=%@",self.CompanyId];
    
    
    [AFNetClient POST_Path2:urlString completed:^(NSData *stringData, id JSONDict) {
        NSLog(@"JSONDict=%@",JSONDict);
        [UserInfo saveJoinCompany_YesOrNo:@"0"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetCompanyNotification object:nil];
        
    } failed:^(NSError *error) {
        
        
        NSLog(@"error=%@",error);
    }];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
