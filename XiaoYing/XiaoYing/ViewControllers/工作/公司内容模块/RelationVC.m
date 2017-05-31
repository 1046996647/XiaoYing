//
//  RelationVC.m
//  XiaoYing
//
//  Created by ZWL on 15/11/10.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "RelationVC.h"
#import "MyCustomerView.h"
#import "DoSthForSbView.h"
@interface RelationVC ()
{
    UIView *ItemView;
    UIButton *leftBt;//我的客户
    UIButton *rightBt;//代办任务
}

@property (nonatomic,strong)MyCustomerView *myView;
@property (nonatomic,strong)DoSthForSbView *dosthView;

@end

@implementation RelationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    //重写导航栏
    [self initNavUI];
    //初始化UI控件
    [self initUI];
    
}
- (void)initNavUI{
    ItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
 
    leftBt = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBt.frame = CGRectMake(20, 0, 80, 30);
    [leftBt setTitle:@"我的客户" forState:UIControlStateNormal];
    [leftBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBt.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [leftBt addTarget:self action:@selector(waitAndMine:) forControlEvents:UIControlEventTouchUpInside];
    leftBt.tag = 1;
    [ItemView addSubview:leftBt];
    
    rightBt = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBt.frame = CGRectMake(100, 0, 80, 30);
    [rightBt setTitle:@"待办任务" forState:UIControlStateNormal];
    [rightBt setTitleColor:[UIColor colorWithHexString:@"#d5d7dc"] forState:UIControlStateNormal];
    rightBt.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [rightBt addTarget:self action:@selector(waitAndMine:) forControlEvents:UIControlEventTouchUpInside];
    rightBt.tag = 2;
    [ItemView addSubview:rightBt];
    
    self.navigationItem.titleView =ItemView;
}
- (void)waitAndMine:(UIButton *)bt{
    [leftBt setTitleColor:[UIColor colorWithHexString:@"#d5d7dc"] forState:UIControlStateNormal];
    [rightBt setTitleColor:[UIColor colorWithHexString:@"#d5d7dc"] forState:UIControlStateNormal];
    if (bt.tag == 1) {
        [leftBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.dosthView.hidden = YES;
        self.myView.hidden = NO;
    }else if (bt.tag == 2){
        [rightBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.dosthView.hidden = NO;
        self.myView.hidden = YES;
    }
}
- (void)initUI{
    self.myView = [[MyCustomerView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64)];
    
    [self.view addSubview:self.myView];
    
    self.dosthView = [[DoSthForSbView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64)];
   
    [self.view addSubview:self.dosthView];
    self.dosthView.hidden = YES;
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
