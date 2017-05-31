//
//  DelegateViewController.m
//  XiaoYing
//
//  Created by Li_Xun on 16/5/9
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DelegateViewController.h"
#import "DelegateTableView.h"
#import "DelegateTableView2.h"
#import "newDelegateViewController.h"


@interface DelegateViewController ()<UIScrollViewDelegate>
{
    UIButton * _btn;
}

@end

@implementation DelegateViewController
@synthesize delegateScrollView,iCreated,iPerform,buttonBackgroundLine,backgroundOnTheRightLine,screening,screenInterface,ongoing,failure,complete,screeningDetermine,screeningView,backgroundScreeningLineOne,backgroundScreeningLineSecond;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"委派";
    self.view.backgroundColor = [UIColor whiteColor];
    [self headButton];
    [self delegateTableView];
    [self newDelegateRightNavigation];
    
    // 请求数据
    [self requestData];
}

// 请求数据
- (void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
    
    [AFNetClient GET_Path:GetDesignateAsCreator completed:^(NSData *stringData, id JSONDict) {
        
//        [hud hide:YES];
        
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
    
    [AFNetClient GET_Path:GetDesignateAsExecutor completed:^(NSData *stringData, id JSONDict) {
        
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

#pragma mark - 表格滚动视图初始化
-(void)delegateTableView
{
    delegateScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 46, kScreen_Width, kScreen_Height-64-46)];
    delegateScrollView.backgroundColor = [UIColor redColor];
//    delegateScrollView.contentSize = CGSizeMake(kScreen_Width*2, kScreen_Height-64-46);
    delegateScrollView.bounces = NO;
    delegateScrollView.pagingEnabled = YES;
    delegateScrollView.showsHorizontalScrollIndicator = NO;
//    delegateScrollView.delegate = self;
//    delegateScrollView.contentSize = CGSizeMake(kScreen_Width*2, 0);
    [self.view addSubview:delegateScrollView];

    DelegateTableView *tabView = [[DelegateTableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-46) style:UITableViewStylePlain];
    [delegateScrollView addSubview:tabView];
    
    DelegateTableView2 *tabView2 = [[DelegateTableView2 alloc]initWithFrame:CGRectMake(kScreen_Width, 0, kScreen_Width, kScreen_Height-64-46) style:UITableViewStylePlain];
    [delegateScrollView addSubview:tabView2];
}


#pragma mark - 头视图上的初始化
-(void)headButton
{
    iCreated = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (kScreen_Width-44)/2, 44)];
    iCreated.tag = 1;
    [iCreated setTitle:@"我创建的" forState:UIControlStateNormal];
    [iCreated setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    iCreated.titleLabel.font = [UIFont systemFontOfSize:16];
    [iCreated addTarget:self action:@selector(buttonEvents:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:iCreated];
//    [self adapter:(UIButton*)iCreated left:0 top:0 width:138 heigth:44 ];
    
    iPerform = [[UIButton alloc]initWithFrame:CGRectMake((kScreen_Width-44)/2, 0, (kScreen_Width-44)/2, 44)];
    iPerform.tag = 2;
    [iPerform setTitle:@"我执行的" forState:UIControlStateNormal];
    [iPerform setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
    iPerform.titleLabel.font = [UIFont systemFontOfSize:16];
    [iPerform addTarget:self action:@selector(buttonEvents:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:iPerform];
//    [self adapter:(UIButton*)iPerform left:138 top:0 width:138 heigth:44 ];
    
    buttonBackgroundLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, (kScreen_Width-44)/2, 2)];
    buttonBackgroundLine.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [self.view addSubview:buttonBackgroundLine];
    //[self adapter:buttonBackgroundLine left:0 top:44 width:138 heigth:2];
    
    backgroundOnTheRightLine = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width-44, 12, 0.5, 20)];
    backgroundOnTheRightLine.backgroundColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [self.view addSubview:backgroundOnTheRightLine];
//    [self adapter:backgroundOnTheRightLine left:276 top:12 width:0.5 heigth:20];
    
    screening = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width-32, 12, 20, 20)];
    screening.tag = 3;
    [screening setImage:[UIImage imageNamed:@"choose_task"] forState:UIControlStateNormal];
    [screening addTarget:self action:@selector(buttonEvents:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:screening];
//    [self adapter:(UIButton*)screening left:276+12 top:12 width:20 heigth:20 ];
    
}

#pragma mark - 所有按钮点击事件
-(void)buttonEvents:(UIButton *)send
{
    if (send.tag == 1) {
        NSLog(@"1");
        [UIView animateWithDuration:0.5 animations:^{
            [iCreated setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
            [iPerform setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
            buttonBackgroundLine.frame = CGRectMake(0, 44, (kScreen_Width-44)/2, 2);
            delegateScrollView.contentOffset = CGPointMake(0*scaleX, 0*scaleY);
        }];
        
    }else if (send.tag == 2)
    {
        NSLog(@"2");
        [UIView animateWithDuration:0.5 animations:^{
            [iCreated setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
            [iPerform setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
            buttonBackgroundLine.frame = CGRectMake((kScreen_Width-44)/2, 44, (kScreen_Width-44)/2, 2);
            delegateScrollView.contentOffset = CGPointMake(320*scaleX, 0*scaleY);
        }];
    }
    else if (send.tag == 3)
    {
        
        iCreated.userInteractionEnabled = NO;
        iPerform.userInteractionEnabled = NO;
        [self.view addSubview:self.screenInterface];

    }
}

- (UIControl *)screenInterface
{
    if (!screenInterface) {
        //筛选背景界面
        screenInterface = [[UIControl alloc]initWithFrame:CGRectMake(0, 46, kScreen_Width, kScreen_Height-64)];
        screenInterface.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//        [screenInterface addTarget:self action:@selector(okEvents) forControlEvents:UIControlEventTouchUpInside];

        
        //筛选视图
        screeningView = [[UIView alloc]init];
        screeningView.backgroundColor = [UIColor whiteColor];
        [screenInterface addSubview:screeningView];
        [self adapter:screeningView left:0 top:0 width:320 heigth:98];
        //筛选进行中按钮
        ongoing = [[UIButton alloc]init];
        ongoing.tag = 4;
        ongoing.selected = YES;
        [ongoing setTitle:@"进行中" forState:UIControlStateNormal];
        [ongoing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ongoing.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        ongoing.titleLabel.font = [UIFont systemFontOfSize:16];
        ongoing.layer.masksToBounds =YES;
        ongoing.layer.cornerRadius = 5;
        [ongoing addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        [screeningView addSubview:ongoing];
        [self adapter:ongoing left:23.75 top:12 width:75 heigth:30];
        //筛选失败按钮
        failure = [[UIButton alloc]init];
        failure.tag = 5;
        failure.selected = YES;
        [failure setTitle:@"失败" forState:UIControlStateNormal];
        [failure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        failure.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        failure.titleLabel.font = [UIFont systemFontOfSize:16];
        failure.layer.masksToBounds =YES;
        failure.layer.cornerRadius = 5;
        [failure addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        [screeningView addSubview:failure];
        [self adapter:failure left:122.5 top:12 width:75 heigth:30];
        //筛选完成按钮
        complete = [[UIButton alloc]init];
        complete.tag = 6;
        complete.selected = YES;
        [complete setTitle:@"完成" forState:UIControlStateNormal];
        [complete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        complete.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        complete.titleLabel.font = [UIFont systemFontOfSize:16];
        complete.layer.masksToBounds =YES;
        complete.layer.cornerRadius = 5;
        [complete addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        [screeningView addSubview:complete];
        [self adapter:complete left:221.25 top:12 width:75 heigth:30];
        //筛选背景线一二
        backgroundScreeningLineOne = [[UIImageView alloc]init];
        backgroundScreeningLineOne.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [screeningView addSubview:backgroundScreeningLineOne];
        [self adapter:backgroundScreeningLineOne left:0 top:0 width:320 heigth:0.5];
        backgroundScreeningLineSecond = [[UIImageView alloc]init];
        backgroundScreeningLineSecond.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [screeningView addSubview:backgroundScreeningLineSecond];
        [self adapter:backgroundScreeningLineSecond left:0 top:54 width:320 heigth:0.5];
        //筛选确定按钮
        screeningDetermine = [[UIButton alloc]init];
        screeningDetermine.tag = 7;
        [screeningDetermine setTitle:@"确定" forState:UIControlStateNormal];
        [screeningDetermine setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
        screeningDetermine.titleLabel.font = [UIFont systemFontOfSize:16];
        [screeningDetermine addTarget:self action:@selector(okEvents) forControlEvents:UIControlEventTouchUpInside];
        [screeningView addSubview:screeningDetermine];
        [screeningDetermine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(screeningView);
            make.top.mas_equalTo(62*scaleY);
            make.size.mas_equalTo(CGSizeMake(75*scaleX, 30*scaleY));
        }];
    }
    
    return screenInterface;
}

- (void)buttonAction:(UIButton *)btn
{
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    _btn = btn;
}

#pragma mark - 定制右导航栏函数
-(void)newDelegateRightNavigation
{
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"add_approva"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(newDelegate) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma  mark - 点击右导航栏视图跳转
-(void)newDelegate
{
    NSLog(@"sdfeges");
    [self.navigationController pushViewController:[[NewDelegateViewController alloc] init] animated:YES];
}


- (void)okEvents
{
    screening.selected = NO;
    iCreated.userInteractionEnabled = YES;
    iPerform.userInteractionEnabled = YES;
    [screenInterface removeFromSuperview];
}


#pragma mark - 适配器
-(void)adapter:(id)childview left:(CGFloat)lwidth top:(CGFloat)theight width:(CGFloat)width heigth:(CGFloat)heigth
{
    [childview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lwidth*scaleX);
        make.top.mas_equalTo(theight*scaleY);
        make.size.mas_equalTo(CGSizeMake(width*scaleX, heigth*scaleY));
    }];
}


@end
