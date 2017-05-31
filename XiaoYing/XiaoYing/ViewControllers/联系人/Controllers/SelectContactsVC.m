//
//  SelectContactsVC.m
//  XiaoYing
//
//  Created by ZWL on 16/11/23.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "SelectContactsVC.h"
#import "SelectFriendView.h"
#import "SelectWorkmateView.h"
#import "SelectedPeopleVC.h"
#import "NewViewVC.h"
#import "RCIM.h"
#import "ChatViewController.h"

@interface SelectContactsVC ()
{
    UIView * titileView; // bar的背景
    SelectFriendView * friendV; // 好友列表
    SelectWorkmateView * workmateV; // 同事列表
    UIView * backgroundView; // 红色指示条
    MBProgressHUD *_hud;


}

// 选中的人
@property (nonatomic, strong)NSMutableArray *selectedArr;
@property (nonatomic, strong) UIButton *okBtn;

@property (nonatomic,strong) NSArray *employees;
@property (nonatomic, strong) NSArray * myFriendArray; // 好友信息数组
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *discussionId;



@end

@implementation SelectContactsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"选择联系人";
    
    // 选中的人
    self.selectedArr = [NSMutableArray array];

    titileView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,49)];
    titileView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:titileView];
    
    // 按钮
    [self creatTitleButton];
    
    //我的好友View
    friendV =[[SelectFriendView alloc] initWithFrame:CGRectMake(0, 49, kScreen_Width, kScreen_Height -64- 49-49)];
    friendV.selectedArr = self.selectedArr;
    friendV.iDArr = self.iDArr;
    [self.view addSubview:friendV];
    
    // 我的同事View
    workmateV=[[SelectWorkmateView alloc] initWithFrame:CGRectMake(0, 49,kScreen_Width,kScreen_Height -64- 49-49)];
    workmateV.selectedArr = self.selectedArr;
    workmateV.hidden =YES;
    workmateV.iDArr = self.iDArr;
    [self.view addSubview:workmateV];
    
    backgroundView =[[UIView alloc]init];
    backgroundView.frame =CGRectMake(0, 48, kScreen_Width / 2, 2);
    backgroundView.backgroundColor =[UIColor redColor];
    backgroundView.backgroundColor =[UIColor colorWithHexString:@"f99740"];
    [self.view addSubview:backgroundView];
    
    [self initRightBtn];
    [self initBottomView];
    
    // 数据刷新
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataRefresh)
                                                 name:@"kDataRefreshNotification"
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataRefresh
{
    [friendV.myFriendtab reloadData];
    [workmateV.tableView reloadData];

    [self buttonStateChange];
    
}

- (void)initBottomView {
    // 确定视图
    UIView *currentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-44-64, kScreen_Width, 44)];
    [self.view addSubview:currentView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    button.frame = currentView.bounds;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [currentView addSubview:button];
    self.okBtn = button;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [currentView addSubview:lineView];
}

- (void)confirmAction
{
    if (_selectedArr.count > 0) {
        
        // 添加群组成员
        if (self.addMember) {
            self.addMember(self.selectedArr);
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        NewViewVC *newViewVC = [[NewViewVC alloc] init];
        newViewVC.markText = @"群聊名称";
        newViewVC.placeholderText = @"请输入";
        newViewVC.content = [NSString stringWithFormat:@"%ld人群",(unsigned long)_selectedArr.count];
        newViewVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //淡出淡入
        newViewVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        newViewVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [self presentViewController:newViewVC animated:YES completion:nil];
        newViewVC.clickBlock = ^(NSString *text) {
            
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            if (![self.selectedArr containsObject:[RCIM sharedRCIM].currentUserInfo.userId]) {
                
                [self.selectedArr insertObject:[RCIM sharedRCIM].currentUserInfo.userId atIndex:0];
            }
            [[RCIMClient sharedRCIMClient] createDiscussion:text userIdList:self.selectedArr
                                                    success:^(RCDiscussion *discussion)
             {
                 // 服务器同步群聊列表
                 [self saveDiscussionList:text discussionId:discussion.discussionId];
                 self.name = text;
                 self.discussionId = discussion.discussionId;
                 
             } error:^(RCErrorCode status) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [_hud hide:YES];
                     [MBProgressHUD showMessage:@"网络连接失败，请重试!"];

                 });
                 
                 NSLog(@"创建讨论组失败  %ld",(long)status);
             }];
        };
        

    }
    else {
        [MBProgressHUD showMessage:@"未选择任何人"];

    }
}

// 服务器同步群聊列表
- (void)saveDiscussionList:(NSString *)name discussionId:(NSString *)discussionId
{

    NSMutableDictionary *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    [paramDic  setValue:name forKey:@"name"];
    [paramDic  setValue:@9 forKey:@"type"];
    [paramDic  setValue:self.selectedArr forKey:@"profileIds"];
    [paramDic  setValue:discussionId forKey:@"rongCloudChatRoomId"];
    
    [AFNetClient  POST_Path:CreateDiscussion params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        [_hud hide:YES];
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg];
            
        } else {
            
            // 刷新讨论组列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDiscussionListNotification" object:nil];
            
            ChatViewController *rcVC = [[ChatViewController alloc] initWithConversationType:ConversationType_DISCUSSION targetId:self.discussionId];
            rcVC.title = self.name;
            rcVC.enableContinuousReadUnreadVoice =YES;
            [self.navigationController pushViewController:rcVC animated:YES];
            
        }
        
    } failed:^(NSError *error) {
        [_hud hide:YES];

    }];
}

// 确定按钮的显示改变
- (void)buttonStateChange
{
    if (_selectedArr.count > 0) {
        
        NSString *str = [NSString stringWithFormat:@"确定(%ld)",(unsigned long)_selectedArr.count];
        [self.okBtn setTitle:str forState:UIControlStateNormal];
        
    }
    else {
        
        [self.okBtn setTitle:@"确定" forState:UIControlStateNormal];
        
    }
}

- (void)initRightBtn
{
    UIButton *newCreate = [UIButton buttonWithType:UIButtonTypeCustom];
    newCreate.frame = CGRectMake(0, 0, 40, 30);
    [newCreate setTitle:@"已选" forState:UIControlStateNormal];
    [newCreate addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newCreate];
}

// 已选
-(void)btnAction:(UIButton *)btn {
    
    // 移除搜索视图
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kRemoveSearchViewNotification" object:nil];
    
    if (self.selectedArr.count == 0) {
        [MBProgressHUD showMessage:@"未选择任何人"];
    }
    else {
//        // 所有员工
//        NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
//        
//        // 所有好友
//        NSArray *friendArr = [ZWLCacheData unarchiveObjectWithFile:FriendPath];
        
        SelectedPeopleVC *selectedPeopleVC = [[SelectedPeopleVC alloc] init];
        selectedPeopleVC.employees = _employees;
        selectedPeopleVC.friends = _myFriendArray;
        selectedPeopleVC.selectedArr = self.selectedArr;
        selectedPeopleVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //淡出淡入
        selectedPeopleVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //        self.definesPresentationContext = YES; //不盖住整个屏幕
        selectedPeopleVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [self presentViewController:selectedPeopleVC animated:YES completion:nil];
        
//        selectedPeopleVC.sendBlock = ^(NSMutableArray *arrM) {
//            
//            [_tableView reloadData];
//            [self buttonStateChange];
//        };
    }
    
}


/**
 *  按钮
 */
-(void)creatTitleButton {
    //            从本地读取数据
    NSArray *friendArray = [ZWLCacheData unarchiveObjectWithFile:FriendPath];
    _myFriendArray = friendArray;
    
    // 所有员工
    NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
    self.employees = employeesArr;
    
    NSString *friendStr = [NSString stringWithFormat:@"好友(%ld)",(long)friendArray.count];
    NSString *employeesStr = [NSString stringWithFormat:@"同事(%ld)",(long)employeesArr.count];
    
    NSArray * arr =@[friendStr,employeesStr];
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
    
    NSArray *arr = [titileView subviews];
    for (int i=0; i<arr.count;i++) {
        UIButton *bt=(UIButton*)arr[i];
        [bt setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
    }
    if (butt.tag ==1) {
        
        backgroundView.frame =CGRectMake(0, 48, kScreen_Width / arr.count, 2);
        friendV.hidden =NO;
        workmateV.hidden =YES;
        
    }
    else if(butt.tag ==2){
        
        backgroundView.frame =CGRectMake(kScreen_Width / arr.count, 48, kScreen_Width / arr.count, 2);
        friendV.hidden =YES;
        workmateV.hidden =NO;
        
    }
    [butt setTitleColor:[UIColor colorWithHexString:@"f99740"] forState:UIControlStateNormal];
    
    
}


@end
