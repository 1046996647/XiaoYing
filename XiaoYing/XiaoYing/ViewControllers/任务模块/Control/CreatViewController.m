//
//  CreatViewController.m
//  XiaoYing
//
//  Created by ZWL on 15/10/12.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#import "CreatViewController.h"
#import "CreatTaskView.h"
#import "UIColor+Expend.h"
 
@interface CreatViewController ()
{
    //任务的view
    CreatTaskView *backView;
}
@end

@implementation CreatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Arrow-white"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 14)];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];

    self.title=@"新建任务";
    self.navigationController.navigationBar.hidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:100];

    [self initUI];
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *app=(AppDelegate *) [UIApplication sharedApplication].delegate;
    [app.tabvc hideCustomTabbar];
}


- (void)viewWillDisappear:(BOOL)animated{
   [super viewWillDisappear:animated];
    AppDelegate *app =(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabvc showCustomTabbar];
}


#pragma mark ---初始化UI
-(void)initUI
{
    backView=[[CreatTaskView alloc]initWithFrame:self.view.bounds];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
}

#pragma mark -- buttonAction
- (void)backAction:(UIBarButtonItem *)item{
    NSLog(@"返回");
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction:(UIBarButtonItem *)item{
    NSLog(@"保存");
     [backView postTask];
    
    [self.navigationController popViewControllerAnimated:NO];
    
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
