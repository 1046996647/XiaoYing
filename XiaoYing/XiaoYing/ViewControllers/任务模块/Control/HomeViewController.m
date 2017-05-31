//
//  HomeViewController.m
//  XiaoYing
//
//  Created by ZWL on 15/10/12.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#import "HomeViewController.h"
#import "GuideViewController.h"
#import "HomeViewController.h"
#import "TaskTableViewCell.h"
#import "TaskItem.h"
#import "StateItem.h"
#import "CreatViewController.h"
#import "ListViewController.h"

#import "PersonCenteVC.h"
#import "PersonalMessageController.h"

#import "PersonCenterModel.h"
#import "FirstModel.h"
//数据库
#import "taskDatabase.h"
#import "taskModel.h"
#import "ZLImageViewDisplayView.h"

//列表多少个
#define taskCount   3
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //任务列表
    UITableView *PlanTableView_;
    //任务列表的数据
    NSMutableArray *taskArr_;
    //创建任务的按钮
    UIButton *creatTaskBt_;
    //存储数据库里面的数据的数组
    NSMutableArray *_arrData;
    
    //服务器请求数据
    NSMutableArray *arr;
    
    //个人中心的信息
    ProfileMyModel *_mycentermodel;
    
    ProfileCompanyModel * _companycentermodel;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title =@"小赢计划";
    [self preferredStatusBarStyle];
    //添加导航栏背景图片
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:0];
//     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //设置背景颜色
    self.view.backgroundColor=[UIColor  colorWithHexString:@"#efeff4"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initUI];
    
    
    
}
#pragma mark --获取所有任务的状态
-(void)getAllTask{
    //获取所有数据
    arr=[[NSMutableArray alloc]init];
    //向服务器发送get请求
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [AFNetClient GET_Path:InfoTask completed:^(NSData *stringData, id JSONDict) {
            
            NSLog(@"%@",JSONDict);
            if (![[JSONDict objectForKey:@"Data"] isKindOfClass:[NSNull class]]) {
                for(NSInteger i=0;i<[[JSONDict objectForKey:@"Data"]count];i++){
                    StateItem *item=[[StateItem alloc]init];
                    item.CurrentTaskCount=[[[JSONDict objectForKey:@"Data"] objectAtIndex:i] objectForKey:@"CurrentTaskCount"];
                    item.TotalCount=[[[JSONDict objectForKey:@"Data"] objectAtIndex:i] objectForKey:@"TotalCount"];
                    item.Type=[[[JSONDict objectForKey:@"Data"] objectAtIndex:i] objectForKey:@"Type"];
                    [arr addObject:item];
                }
                
            }
            //将数据存储到沙盒里面
            [self keepDataIntoSandbox];
            
            
            
            //初始化数据模型
            [self initData];
            
            
        } failed:^(NSError *error) {
            NSLog(@"  %@",error);
        }];
    });
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.tabvc showCustomTabbar];
    
    self.view.backgroundColor=[UIColor colorWithHexString:@"#efeff4"];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    //

//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"task-nav"] forBarMetrics:0];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
  
    //处于登录状态
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *flag=[user objectForKey:@"YESORNOTLOGIN"];
    if ([flag isEqualToString:@"1"]) {
        //得到个人信息登录后仅仅执行一次
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            [self getAllTask];
        });
        
        
        
        //检测数据库中是否有需要上传
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *arr1 = [taskDatabase queryData:@"所有任务"];
            
            for (NSInteger i=0; i<arr1.count; i++) {
                taskModel *model = arr1[i];
                
                if (model.TaskUpAndDown==0) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [self PostTask:model];
                    });
                }
            }
            
        });
        [self getDataIntoSandbox];
        
    }else{
        //从沙盒里面读取数据
        [self getDataIntoSandbox];
    }
    
}
/**
 *  从数据库中读取数据来筛选是否应该上传到服务器
 *
 *  @param model 任务的Model
 */
-(void)PostTask:(taskModel*)model
{
    
    
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    [paramDic  setValue:model.TaskTitle forKey:@"title"];
    [paramDic  setValue:model.TaskRemark forKey:@"remark"];
    [paramDic  setValue:[NSNumber numberWithInteger:model.TaskFlag] forKey:@"flag"];
    [paramDic  setValue:model.TaskTime forKey:@"time"];
    // 检测未添加到服务器的数据，来上传到服务器
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [AFNetClient  POST_Path:AddTask params:paramDic completed:^(NSData *stringData, id JSONDict) {
            NSLog(@"添加任务JSONDict=%@",JSONDict);
            
            taskModel *modelSQL = [[taskModel alloc] init];
            
            modelSQL.TaskRemark=[[JSONDict objectForKey:@"Data"] objectForKey:@"Remark"];
            modelSQL.TaskTitle=[[JSONDict objectForKey:@"Data"] objectForKey:@"Title"];
            modelSQL.TaskTime=[[JSONDict objectForKey:@"Data"] objectForKey:@"Time"];
            modelSQL.TaskFlag=[[[JSONDict objectForKey:@"Data"] objectForKey:@"Flag"]integerValue];
            modelSQL.TaskId=[[[JSONDict objectForKey:@"Data"] objectForKey:@"Id"]integerValue];
            modelSQL.TaskAddTime=[[JSONDict objectForKey:@"Data"] objectForKey:@"AddTime"];
            modelSQL.TaskExpiresTime=[[JSONDict objectForKey:@"Data"] objectForKey:@"ExpiresTime"];
            modelSQL.TaskState=[[[JSONDict objectForKey:@"Data"] objectForKey:@"Status"]integerValue];
            modelSQL.TaskUpAndDown=1;
            
            if (![modelSQL.TaskTime isEqual:[NSNull null]]) {
                NSArray *arrSepreate=[modelSQL.TaskTime componentsSeparatedByString:@" "];
                modelSQL.TaskDay=arrSepreate[0];
            }
//            BOOL sucess1 = [taskDatabase deleteData:model.TaskTime];
//            
//            NSLog(@"sucess1=%d",sucess1);
            
            BOOL sucess=[taskDatabase insertModal:modelSQL];
            if (sucess==YES) {
                NSLog(@"数据插入数据库成功");
            }else{
                NSLog(@"数据插入数据库失败");
            }
            
        } failed:^(NSError *error) {
            NSLog(@"请求失败Error--%ld",(long)error.code);
        }];
    });
}


#pragma mark ---将数据存储到沙盒里面
-(void)keepDataIntoSandbox{
    //将数据写入plist文件
    
    [[DataHandle shareHandleData]storeObjectToPlist:arr forFileName:@"TaskInfo.plist"];
}
/**
 *  从沙盒中的Plist文件读取数据
 */
-(void)getDataIntoSandbox{
    //从Plist文件中取出数据
    arr=[[DataHandle shareHandleData]getDataAccordingToFileName:@"TaskInfo.plist"];
    //初始化数据模型
    
    //个人信息取出
    _mycentermodel = [[FirstStartData shareFirstStartData] getPersonCentrePlist];
    
    _companycentermodel = [[FirstStartData shareFirstStartData] getProfileCompanyModelPlist];
    
    
    //个人信息的界面修改根据Plist文件
    [self renovateUI];
    //根据数据库里面的数据更新tableview的数据
    [self initData];
}
/**
 *  修改个人信息的界面
 */
-(void)renovateUI{
    
 
//    [_imageviewHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.ZWL.com/%@",_mycentermodel.FaceUrl]]];
//    _labCompanyName.text = _companycentermodel.companyName;
//    if ([_companycentermodel.userName isEqualToString:@"未设置"]) {
//        _labName.text = _companycentermodel.userName;
//    }else{
//        _labName.text = [NSString stringWithFormat:@"%@  %@",_companycentermodel.userName,_companycentermodel.positionName];
//    }
//    _labDepartment.text = _companycentermodel.departmentName;
}

#pragma mark ---初始化数据
-(void)initData{
    NSArray *arr1=[[NSArray alloc]initWithObjects:@"day.png",@"week.png",@"all.png",nil];
    NSArray *arr2=[[NSArray alloc]initWithObjects:@"今日任务",@"本周任务",@"本月任务",@"所有任务",nil];
    taskArr_=[[NSMutableArray alloc]init];
    for(NSInteger i=0;i<taskCount;i++){
        TaskItem *item=[[TaskItem alloc]init];
        item.ImageName_=arr1[i];
        for (NSInteger j=0; j<arr.count; j++) {
            StateItem *ite=arr[j];
            if (i==0&&[ite.Type isEqual:@1]) {
                item.TaskCount_=[NSString stringWithFormat:@"%@",ite.TotalCount];
                item.ProccedCount_=[NSString stringWithFormat:@"%@",ite.CurrentTaskCount];
            }else if (i==1&&[ite.Type isEqual:@2]){
                item.TaskCount_=[NSString stringWithFormat:@"%@",ite.TotalCount];
                item.ProccedCount_=[NSString stringWithFormat:@"%@",ite.CurrentTaskCount];
            }else if (i==2&&[ite.Type isEqual:@9]){
                item.TaskCount_=[NSString stringWithFormat:@"%@",ite.TotalCount];
                item.ProccedCount_=[NSString stringWithFormat:@"%@",ite.CurrentTaskCount];
            }
            
        }
        item.TitleName_=arr2[i];
        [taskArr_ addObject:item];
    }
    TaskItem *item=[[TaskItem alloc]init];
    item.TaskCount_ = @"24";
    item.TitleName_=@"所有任务";
    item.ProccedCount_=@"25";
    [taskArr_ addObject:item];
    [PlanTableView_ reloadData];
}
#pragma mark ---初始化UI界面

-(void)initUI{
//    self.view.backgroundColor=[UIColor colorWithHexString:@"#efeff4"];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    //

//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"task-nav"] forBarMetrics:0];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//    self.navigationController.navigationBar.translucent = NO;
    
    [self createScrollView];
    
//    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, kScreen_Width, 227-64)];
//    imageview.image=[UIImage imageNamed:@"background"];
//    imageview.userInteractionEnabled=YES;
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PersonCenter)];
//    [imageview addGestureRecognizer:tap];
//    
//    [self.view addSubview:imageview];
    
//    //头像
//    _imageviewHead=[[UIImageView alloc]initWithFrame:CGRectMake(20, 86-64, 76, 76)];
//    _imageviewHead.image=[UIImage imageNamed:_mycentermodel.FaceUrl];
//    _imageviewHead.layer.cornerRadius=38;
//    _imageviewHead.layer.masksToBounds=YES;
//    [self.view addSubview:_imageviewHead];
//    
//    //部门
//    _labDepartment=[[UILabel alloc]initWithFrame:CGRectMake(96+12, 86+27-64, kScreen_Width-96-12, 10)];
//    _labDepartment.textColor=[UIColor colorWithHexString:@"#ffffff"];
//    _labDepartment.font=[UIFont systemFontOfSize:13];
//    _labDepartment.text=_companycentermodel.departmentName;
//    [self.view addSubview:_labDepartment];
//    
//    //姓名
//    
//    _labName=[[UILabel alloc]initWithFrame:CGRectMake(96+12, 86+27+10+10-64, kScreen_Width-96-12, 20)];
//    _labName.textColor=[UIColor colorWithHexString:@"#ffffff"];
//    _labName.font=[UIFont systemFontOfSize:16];
//    _labName.text=@"孟凡标  iOS软件开发";
//    [self.view addSubview:_labName];
//    
//    //公司名称
//    
//    _labCompanyName=[[UILabel alloc]initWithFrame:CGRectMake(20, 86+76+12-64, kScreen_Width-20, 20)];
//    _labCompanyName.textColor=[UIColor colorWithHexString:@"#ffffff"];
//    _labCompanyName.font=[UIFont systemFontOfSize:13];
//    _labCompanyName.text=_companycentermodel.companyName;
//    [self.view addSubview:_labCompanyName];
    
    PlanTableView_=[[UITableView alloc]initWithFrame:CGRectMake(0, 227-32, kScreen_Width, 49*4) style:UITableViewStylePlain];
    PlanTableView_.scrollEnabled=NO;
    PlanTableView_.delegate=self;
    PlanTableView_.dataSource=self;
    PlanTableView_.separatorColor = [UIColor colorWithHexString:@"d5d7dc"];
    
    if ([PlanTableView_ respondsToSelector:@selector(setSeparatorInset:)]) {
        [PlanTableView_ setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([PlanTableView_ respondsToSelector:@selector(setLayoutMargins:)]) {
        [PlanTableView_ setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:PlanTableView_];
    
    creatTaskBt_=[UIButton buttonWithType:UIButtonTypeCustom];
    creatTaskBt_.frame=CGRectMake(kScreen_CenterX-15, kScreen_Height-49-30-14-64, 30, 30);
    
    [creatTaskBt_ setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    
    [creatTaskBt_ addTarget:self action:@selector(creatTask) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:creatTaskBt_];
    
}

-(void)createScrollView{
    CGRect frame = CGRectMake(0, 0, kScreen_Width, 227-32);
    NSArray *array = @[@"004.jpg",@"001.jpg",@"002.jpg",@"003.jpg",@"004.jpg",@"001.jpg"];
    
    ZLImageViewDisplayView *imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:frame];
    imageViewDisplay.imageViewArray = array;
    imageViewDisplay.scrollInterval = 1.5;
    imageViewDisplay.animationInterVale = 0.7;
    [self.view addSubview:imageViewDisplay];
}


//个人信息（更改。。。。。）
-(void)PersonCenter{
    PersonalMessageController *personcenter=[[PersonalMessageController alloc]init];
    personcenter.profileMyModel = _mycentermodel;
    [self.navigationController pushViewController:personcenter animated:YES];
}


//创建任务
-(void)creatTask{
    CreatViewController *creat=[[CreatViewController alloc]init];
    [self.navigationController pushViewController:creat animated:YES];
}

#pragma mark ----UITableViewDataSource,UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListViewController *listVC=[[ListViewController alloc]init];
    TaskItem *item=taskArr_[indexPath.row];
    listVC.title=item.TitleName_;
    [self.navigationController pushViewController:listVC animated:NO];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor colorWithHexString:@"d5d7dc"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return taskArr_.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Taskcell"];
    if (cell==nil) {
        cell=[[TaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Taskcell"];
    }else{
    }
    
    TaskItem *item=taskArr_[indexPath.row];
    
    cell.item=item;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
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
