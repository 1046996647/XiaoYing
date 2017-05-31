//
//  EditorViewController.m
//  XiaoYing
//
//  Created by ZWL on 15/10/21.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "EditorViewController.h"
#import "taskDatabase.h"
#import "taskModel.h"
#import "AppDelegate.h"
#import "EditorView.h"

@interface EditorViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    //保存
    UIButton *preserveBt;
    //取消
    UIButton *cacleBt;
    //保存修改后的数据
    taskModel *Fixtask;
    //关于小旗
    UIView *banaerView;
    UIView *banaerBack;
    UIView *navbarBack;
    NSArray *arrimage;
    NSInteger markFlag;
    EditorView *editorView;
    
    //在4S与5S以及5上面会添加滑动的效果
    UIScrollView *scrollView;
}
@end

@implementation EditorViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#f99740"];
    //导航栏上按键颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];self.title=@"编辑任务";
    
    //导航栏标题颜色
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    
    //导航栏保存按钮
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 14)];
   // [saveBtn setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
     saveBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    
    //导航栏返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 14)];
   // [backBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    backBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [backBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

    
    [self initUI];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [app.tabvc hideCustomTabbar];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabvc showCustomTabbar];
}
-(void)initUI{
    
    editorView = [[EditorView alloc] initWithFrame:self.view.bounds];
    NSLog(@"EditorViewController    %@",self.taskmodel_.TaskRemark);
    
    editorView.taskmodel = self.taskmodel_;
    
    [self.view addSubview:editorView];
}
-(void)saveAction:(UIButton *)btn{
    
    self.taskmodel_.TaskRemark = editorView.remarkView.text;
   
    if (editorView.button1.hidden == NO) {
        self.taskmodel_.TaskFlag = 1;//绿色
    }else if (editorView.button2.hidden == NO){
        self.taskmodel_.TaskFlag = 2;//黄色
    }else if (editorView.button3.hidden == NO){
        self.taskmodel_.TaskFlag = 3;//红色
    }
    NSNumber *taskid=[NSNumber numberWithInteger:self.taskmodel_.TaskId];
    NSNumber *flag = [[NSNumber alloc]init];
    if (self.taskmodel_.TaskFlag == 1) {
        flag = @1;
    }else if (self.taskmodel_.TaskFlag == 2){
        flag = @2;
    }else if (self.taskmodel_.TaskFlag == 3){
        flag = @3;
    }
    //判断用户是否处于登录状态
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"YESORNOTLOGIN"] isEqualToString:@"0"]) {
        //修改过后没有上传到服务器
        self.taskmodel_.TaskUpAndDown=0;
        BOOL success=[taskDatabase deleteData:self.taskmodel_.TaskTime];
        
        self.taskmodel_.TaskTime = editorView.dateLabel1.text;
        //创建一个本地通知
     
          [[NSNotificationCenter defaultCenter] postNotificationName:@"CreatLocalNotification" object:self.taskmodel_];
        if (success) {
            BOOL success1 = [taskDatabase insertModal:self.taskmodel_];
            if (success1) {
                NSLog(@"修改本地数据库成功");
            }else{
                NSLog(@"修改本地数据库失败");
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        self.taskmodel_.TaskUpAndDown=1;
        //把修改的数据封装成一个dictionary，用来上传到服务器
        NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
        [paramDic setValue:flag forKey:@"flag"];
        [paramDic setValue:taskid forKey:@"taskId"];
        [paramDic  setValue:editorView.remarkView.text forKey:@"remark"];
        [paramDic  setValue:editorView.dateLabel1.text forKey:@"time"];
        //上传任务
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            [AFNetClient  POST_Path:EditorTask params:paramDic completed:^(NSData *stringData, id JSONDict){
                
                NSLog(@"编辑任务发送成功JSONDict=%@",JSONDict);
                
                BOOL success=[taskDatabase deleteData:self.taskmodel_.TaskTime];
                
                if (success) {
                    
                    BOOL success1 = [taskDatabase insertModal:self.taskmodel_];
                    if (success1) {
                        NSLog(@"修改本地数据库成功");
                    }else{
                        NSLog(@"修改本地数据库失败");
                    }
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } failed:^(NSError *error) {
                NSLog(@"请求失败Error--%ld",(long)error.code);
            }];
        });

    }
    
}

-(void)deleteAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
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
