//
//  ConnectViewController.m
//  XiaoYing
//
//  Created by MengFanBiao on 15/10/21.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "ConnectViewController.h"
#import "HelpMac.h"
#import "FriendView.h"
#import "WorkmateView.h"
#import "ConversionListViewController.h"
#import "AddFriendViewController.h"
#import "ConnectModel.h"
#import <AVFoundation/AVFoundation.h>
#import "SweepBySweepVC.h"
#import "GroupListView.h"
#import "SelectContactsVC.h"
#import "UIView+redPoint.h"

@interface ConnectViewController ()
{
    UIView * titileView; // bar的背景
    FriendView * friendV; // 好友列表
    WorkmateView * workmateV; // 同事列表
    GroupListView *groupListView;// 群组列表
    UIView * backgroundView; // 红色指示条
    ConversionListViewController* conversionListVC;
    UIView * backView; // 会话 好友 同事 下边的灰色条
//    NSArray * _myFriendArray;// 好友数据
    UILabel *_countLabel; // 好友请求数量
    UIImageView *_backImage; // 背景
    AVAudioPlayer *player; // 好友提示音
    
    UIView *coverView;//展开下拉框后的覆盖视图
    UIView *nextView;//下拉框
    
    RCDiscussion *discussion;//讨论组
    
    UIButton *_conversationBtn;
    UIButton *_friendBtn;

}
@end

@implementation ConnectViewController


static int mark = 0;


/**
 *  联系人界面,以及一些操作
 */
- (void)viewDidLoad {
    
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
//    self.navigationController.navigationBarHidden =NO;
//    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    
    // 添加好友
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 0, 40, 20);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setImage:[UIImage imageNamed:@"add_approva"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jumpAddFriendViewController) forControlEvents:UIControlEventTouchUpInside];
//    // 红色背景图
//   _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(21.5, 0, 17, 17)];
//    [_backImage setImage:[UIImage imageNamed:@"red"]];
//    [btn addSubview:_backImage];
//    
//    _countLabel = [[UILabel alloc] initWithFrame:_backImage.bounds];
//    _countLabel.textAlignment = NSTextAlignmentCenter;
//    _countLabel.font = [UIFont systemFontOfSize:11];
//    _countLabel.textColor = [UIColor whiteColor];
//    [_backImage addSubview:_countLabel];
//    _backImage.hidden = YES;
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightBar];
    // 设置导航栏图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:UIBarMetricsDefault];
    
    self.title=@"联系人";
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    titileView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,49)];
    titileView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:titileView];
//  会话 好友 同事 群 4个按钮
    [self creatTitleButton];
    
//会话view
    conversionListVC = [[ConversionListViewController alloc] init];
    [self addChildViewController:conversionListVC];
    conversionListVC.view.frame = CGRectMake(0, 49, kScreen_Width, kScreen_Height -64- 49-49);
    conversionListVC.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:conversionListVC.view];

    
//我的好友View
    friendV =[[FriendView alloc] initWithFrame:CGRectMake(0, 49, kScreen_Width, kScreen_Height -64- 49-49)];
    friendV.hidden =YES;
    [self.view addSubview:friendV];

// 我的同事View
    workmateV=[[WorkmateView alloc] initWithFrame:CGRectMake(0, 49,kScreen_Width,kScreen_Height -64- 49-49)];
    workmateV.hidden =YES;
    [self.view addSubview:workmateV];
    
    
    // 群组列表
    groupListView = [[GroupListView alloc] initWithFrame:workmateV.frame];
    groupListView.hidden =YES;
    [self.view addSubview:groupListView];
    
    backView =[[UIView alloc]initWithFrame:CGRectMake(0, 48.5, kScreen_Width, 0.5)];
    backView.backgroundColor =[UIColor colorWithHexString:@"d5d7dc"];
    [self.view addSubview:backView];
    
    backgroundView =[[UIView alloc]init];
    backgroundView.frame =CGRectMake(0, 48, kScreen_Width / 4, 2);
    backgroundView.backgroundColor =[UIColor redColor];
    backgroundView.backgroundColor =[UIColor colorWithHexString:@"f99740"];
    [self.view addSubview:backgroundView];
    
    AppDelegate *appDelelgate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    coverView.hidden = YES;
    [appDelelgate.window addSubview:coverView];
    
    nextView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width-130,64.5, 120, 40*3+.5*2)];
    nextView.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    nextView.hidden = YES;
    [coverView  addSubview:nextView];
    
    UIButton *shareQR = [UIButton buttonWithType:UIButtonTypeCustom];
    shareQR.frame = CGRectMake(0, 0, 120, 40);
    [shareQR setTitle:@"添加好友" forState:UIControlStateNormal];
    [shareQR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareQR.titleLabel.font = [UIFont systemFontOfSize:14];
    shareQR.tag = 1;
    [shareQR addTarget:self action:@selector(jumpConnect:) forControlEvents:UIControlEventTouchUpInside];
    [nextView addSubview:shareQR];
    
    UIView *firstline = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 100, 0.5)];
    firstline.backgroundColor = [UIColor whiteColor];
    [nextView addSubview:firstline];
    
    UIButton *keepQR = [UIButton buttonWithType:UIButtonTypeCustom];
    keepQR.frame = CGRectMake(0, 40.5 , 120, 40);
    [keepQR setTitle:@"扫一扫" forState:UIControlStateNormal];
    [keepQR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    keepQR.titleLabel.font = [UIFont systemFontOfSize:14];
    keepQR.tag = 2;
    [keepQR addTarget:self action:@selector(jumpConnect:) forControlEvents:UIControlEventTouchUpInside];
    [nextView addSubview:keepQR];
    
    UIView *secondline = [[UIView alloc] initWithFrame:CGRectMake(10, 80.5, 100, 0.5)];
    secondline.backgroundColor = [UIColor whiteColor];
    [nextView addSubview:secondline];
    
    
    UIButton *sweepQR = [UIButton buttonWithType:UIButtonTypeCustom];
    sweepQR.frame = CGRectMake(0, 81 , 120, 40);
    [sweepQR setTitle:@"发起群聊" forState:UIControlStateNormal];
    [sweepQR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sweepQR.titleLabel.font = [UIFont systemFontOfSize:14];
    sweepQR.tag = 3;
    [sweepQR addTarget:self action:@selector(jumpConnect:) forControlEvents:UIControlEventTouchUpInside];
    [nextView addSubview:sweepQR];
    
   
    
    //触摸页面时，下拉视图收起
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap)];
    [coverView addGestureRecognizer:singleFingerTap];
    
    // 从其他界面跳进来显示会话界面通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAction) name:@"kConversionListShow" object:nil];

    [self checkMessage];
    // 未读消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkMessage) name:@"MESSAGECOUNT" object:nil];

    // 有好友请求通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasFriendRequest:) name:@"kHasFriendRequestNotification" object:nil];
}

-(void)checkMessage {
    
    NSInteger messageCount = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //检测消息的个数
        if (messageCount <= 0) {
            [_conversationBtn.titleLabel hideRedPoint];
        } else{
            [_conversationBtn.titleLabel showRedAtOffSetX:0 AndOffSetY:0 OrValue:nil];
            
        }
    });
    
}

-(void)hasFriendRequest:(NSNotification *)not {
    NSInteger count = [not.object integerValue];
    
    //检测消息的个数
    if (count == 0) {
        [_friendBtn.titleLabel hideRedPoint];
    } else{
        [_friendBtn.titleLabel showRedAtOffSetX:0 AndOffSetY:0 OrValue:nil];
        
    }
}

// 通知方法
- (void)showAction
{
    NSArray *arr=[titileView subviews];
    for (int i=0; i<arr.count;i++) {
        UIButton *bt=(UIButton*)arr[i];
        [bt setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
    }
    [arr[0] setTitleColor:[UIColor colorWithHexString:@"f99740"] forState:UIControlStateNormal];
    
    backgroundView.frame =CGRectMake(0, 48, kScreen_Width / arr.count, 2);
    friendV.hidden =YES;
    workmateV.hidden =YES;
    groupListView.hidden = YES;
    conversionListVC.view.hidden = NO;

}


-(void)handleSingleTap{
    coverView.hidden = YES;
    nextView.hidden = YES;
    mark = 0;
    NSLog(@"点击");
}


//跳转到下一个界面
-(void)jumpConnect:(UIButton *)bt{
    if (bt.tag==1) {
        
        
        AddFriendViewController * friendVC =[[AddFriendViewController alloc]init];
        [self.navigationController pushViewController:friendVC animated:YES];
        
    }else if (bt.tag==2){
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:[[SweepBySweepVC alloc]init] animated:YES];
 
    }else if (bt.tag== 3){
        
        //发起群聊
        SelectContactsVC * contactsVC =[[SelectContactsVC alloc]init];
        [self.navigationController pushViewController:contactsVC animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self handleSingleTap];
}


/**
 *  显示标签栏
 *
 *  @param animated
 */

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    mark = 0;
    coverView.hidden = YES;
    // 显示标签栏
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabvc showCustomTabbar];
    
    app.mesCount = 0;
    

}



/**
 *  点击条状视图控制器
 */

-(void)jumpAddFriendViewController {
    
    if (mark == 0) {
        nextView.hidden = NO;
        coverView.hidden = NO;
        mark = 1;
    }else{
        [self handleSingleTap];
    }
}
/**
 *  按钮
 */
-(void)creatTitleButton {
    NSArray * arr =@[@"会话",@"好友",@"同事",@"群聊"];
    for (int i=0; i<arr.count; i++) {
        UIButton * connectHeaderInSecBut =[UIButton buttonWithType:UIButtonTypeCustom];
        connectHeaderInSecBut.frame =CGRectMake(i*(self.view.frame.size.width /arr.count),0,self.view.frame.size.width /arr.count, 49);
        connectHeaderInSecBut.tag =i+1;
        connectHeaderInSecBut.titleLabel.font =[UIFont systemFontOfSize:16];
        [connectHeaderInSecBut addTarget:self action:@selector(connectionHeaderInSectionClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            [connectHeaderInSecBut setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
        }else{
            [connectHeaderInSecBut setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
        }
        
        if (i==0) {
            _conversationBtn = connectHeaderInSecBut;
        }
        if (i==1) {
            _friendBtn = connectHeaderInSecBut;

        }
        [connectHeaderInSecBut setTitle:arr[i] forState:UIControlStateNormal];
        [titileView addSubview:connectHeaderInSecBut];

    }
}

/**
 *  点击  会话  好友  同事  群
 *
 *  @param butt
 */
-(void)connectionHeaderInSectionClick:(UIButton *)butt
{
    // 移除搜索视图
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kRemoveSearchViewNotification" object:nil];
    
    NSArray *arr=[titileView subviews];
    for (int i=0; i<arr.count;i++) {
        UIButton *bt=(UIButton*)arr[i];
       [bt setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
    }
    if (butt.tag ==1) {
        
        backgroundView.frame =CGRectMake(0, 48, kScreen_Width / arr.count, 2);
        
        friendV.hidden =YES;
        workmateV.hidden =YES;
        groupListView.hidden =YES;

        
//        conversionListVC.view.frame = CGRectMake(0, 49, kScreen_Width, kScreen_Height - 49);
        conversionListVC.view.hidden = NO;
    }
    else if(butt.tag ==2){
        
        backgroundView.frame =CGRectMake(kScreen_Width / arr.count, 48, kScreen_Width / arr.count, 2);
        friendV.hidden =NO;
        workmateV.hidden =YES;
        conversionListVC.view.hidden = YES;
        groupListView.hidden =YES;

        
    }
    else if(butt.tag ==3){
        
        backgroundView.frame =CGRectMake(kScreen_Width / arr.count * 2, 48, kScreen_Width / arr.count, 2);
        friendV.hidden =YES;
        workmateV.hidden =NO;
        conversionListVC.view.hidden = YES;
        groupListView.hidden =YES;

    }
    else if(butt.tag ==4){
        
        backgroundView.frame =CGRectMake(kScreen_Width / arr.count * 3, 48, kScreen_Width / arr.count, 2);
        friendV.hidden =YES;
        workmateV.hidden =YES;
        conversionListVC.view.hidden = YES;
        groupListView.hidden =NO;
        
    }
    [butt setTitleColor:[UIColor colorWithHexString:@"f99740"] forState:UIControlStateNormal];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
