//
//  DelegateDetailsViewController.m
//  XiaoYing
//
//  Created by Li_Xun on 16/5/10.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DelegateDetailsViewController.h"
#import "PullDownViewCreate.h"
#import "PullDownViewExcute.h"

@interface DelegateDetailsViewController ()

@property (nonatomic,strong) PullDownViewCreate *pullDownViewCreate;//下拉视图
@property (nonatomic,strong) PullDownViewExcute *pullDownViewExcute;//下拉视图

@end

@implementation DelegateDetailsViewController
@synthesize tabView,rightBtn;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"委派详情";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self rightNavigationBarInitialize];
    
    tabView = [[DelegateDetailsTableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStyleGrouped];
    tabView.backgroundColor = [UIColor whiteColor];
    tabView.allowsSelection = NO;
    [self.view addSubview:tabView];
    
    
    // 请求数据
    [self requestData];
}

// 请求数据
- (void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
    
    NSString *urlStr = [NSString stringWithFormat:@"%@&id=%@",GetDesignateDetail,@103];
    
    [AFNetClient GET_Path:urlStr completed:^(NSData *stringData, id JSONDict) {
        
        [hud hide:YES];
        
        NSLog(@"%@",JSONDict[@"Message"]);
        //        NSMutableArray *arrM = [NSMutableArray array];
        //        for (NSDictionary *dic in JSONDict[@"Data"]) {
        //            NewApprovalModel *model = [[NewApprovalModel alloc] initWithContentsOfDic:dic];
        //            [arrM addObject:model];
        //        }
        //
        //        _approveArr = arrM;
        //        [_approveTable reloadData];
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.pullDownViewCreate removeFromSuperview];
    rightBtn.tag = 0;
}


-(void)rightBtnSelected
{
    NSLog(@"sss");
    rightBtn.enabled = YES;
}

#pragma mark - 定制右导航栏函数
-(void)rightNavigationBarInitialize
{
    rightBtn = [[UIButton alloc]init];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"menu-1"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(menuEvent:) forControlEvents:UIControlEventTouchDown];
    rightBtn.selected = NO;
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)menuEvent:(UIButton *)btn
{
    
    if (_markInt == 100) {
        
        if (btn.tag == 0) {
            
            if (self.pullDownViewCreate == nil) {
                PullDownViewCreate *pullDownView = [[PullDownViewCreate alloc] initWithFrame:self.view.bounds];
                self.pullDownViewCreate = pullDownView;
            }
            
            self.pullDownViewCreate.btn = btn;
            [self.view addSubview:self.pullDownViewCreate];
            btn.tag = 1;
        }
        else {
            [self.pullDownViewCreate removeFromSuperview];
            btn.tag = 0;
        }
        
    } else {
        
        if (btn.tag == 0) {
            
            if (self.pullDownViewExcute == nil) {
                PullDownViewExcute *pullDownViewExcute = [[PullDownViewExcute alloc] initWithFrame:self.view.bounds];
                self.pullDownViewExcute = pullDownViewExcute;
            }
            
            self.pullDownViewExcute.btn = btn;
            [self.view addSubview:self.pullDownViewExcute];
            btn.tag = 1;
        }
        else {
            [self.pullDownViewExcute removeFromSuperview];
            btn.tag = 0;
        }
        
    }
    
    

}

@end
