//
//  ListViewController.m
//  XiaoYing
//
//  Created by ZWL on 15/10/12.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#import "ListViewController.h"
#import "ListTableViewCell.h"
#import "CreatViewController.h"
#import "EditorViewController.h"
#import "StringChangeDate.h"

#import "taskDatabase.h"
#import "taskModel.h"

@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //新建任务
    UIButton *creatTaskBt_;
    //任务列表
    UITableView *textView_;
    //数据模型存储数据
    NSMutableArray *_arrData;
    //无信息显示这个图片
    UIImageView *imageviewNO_;
}
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton=YES;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Arrow-white"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:0];
    
    /**
     *  两个通知都是便是具体点击的哪一个cell
     *
     *  @param selectArr: 通知相应的方法
     *
     *  @return (void)
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectArr:) name:@"ModelTaskMarkFlag" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectFinish:) name:@"FinishNotification" object:nil];
    /**
     *  选择点击完成的时候的按钮
     *
     *  @param selectFinishWay: 通知相应的方法
     *
     *  @return （void）
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectFinishWay:) name:@"FinishButtonNotification" object:nil];
    
    self.navigationController.navigationBar.hidden=NO;
    //列表没有内容的时候显示这一个图片
    imageviewNO_=[[UIImageView alloc]initWithFrame:CGRectMake(kScreen_CenterX-40, kScreen_CenterY-40, 80, 80)];
    imageviewNO_.image=[UIImage imageNamed:@"wuxinxi.png"];
    
    _arrData=[[NSMutableArray alloc]init];
    
    [self initData];
    //初始化UI
    [self initUI];
    
    //处于登录状态
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *flag=[user objectForKey:@"YESORNOTLOGIN"];
    if ([flag isEqualToString:@"1"]) {
        static dispatch_once_t once;
        //设定请求数据，仅仅请求一次
        dispatch_once(&once, ^{
            [self GetData];
        });
        
        //获取增量任务
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self GetIncrement];
        });
        
    }

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabvc hideCustomTabbar];
    [self initData];
}
/**
 *用来判断是点击的哪一个cell
 *
 *  @param obj 用通知中心名字为"FinishButtonNotification"来实现;
 */
-(void)selectFinishWay:(NSNotification *)obj{
    
    ListTableViewCell *cell1=obj.object;
    
    NSIndexPath *indexpath1=[textView_ indexPathForCell:cell1];
    
    //点击完成任务上传到服务器
    if ([UserInfo getLoginOrNotLogin]) {
        taskModel *model = [_arrData objectAtIndex:indexpath1.row];
        dispatch_sync(dispatch_get_global_queue(0, 0)   , ^{
            NSString *url = [FinishTask stringByAppendingFormat:@"&taskId=%@",[NSNumber numberWithInteger:model.TaskId]];
            [AFNetClient POST_Path2:url completed:^(NSData *stringData, id JSONDict) {
                NSLog(@"任务完成%@",JSONDict);
            } failed:^(NSError *error) {
                
            }];
        });
    }
    
    [_arrData removeObjectAtIndex:indexpath1.row];
    
    
    for (NSInteger i=0; i<_arrData.count; i++) {
        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:i inSection:0];
        ListTableViewCell *cell=[textView_ cellForRowAtIndexPath:indexpath];
        [UIView animateWithDuration:0.1 animations:^{
                cell.StateBt2.frame=CGRectMake(10, 10,40 , 40);
                cell.StateBt1.frame=CGRectMake(10, 10,40 , 40);
                cell.TitleLab_.frame=CGRectMake(55, 15, cell.contentView.frame.size.width-150, 17.5);
                cell.TimeLab_.frame=CGRectMake(55, 37.5, cell.contentView.frame.size.width-150, 8.5);
                cell.ListBt.frame=CGRectMake(kScreen_Width-16-24, 0,40 , 60);
                cell.ListBt.hidden=NO;
                cell.FinishBt.frame=CGRectMake(kScreen_Width, 0, 64, 60);
                cell.StateBt.frame=CGRectMake(10, 10,40 , 40);
            } completion:^(BOOL finished) {
                cell.StateBt1.hidden=YES;
                cell.StateBt2.hidden=YES;
            }];
        
    }

    [textView_ reloadData];
}
/**
 *用来判断是点击的哪一个cell
 *
 *  @param obj 用通知中心名字为"FinishNotification"来实现;
 */
static int flag1=0;
-(void)selectFinish:(NSNotification *)obj{
    NSLog(@"点击完成2");
    //获取
    flag1=1;
    for (NSInteger i=0; i<_arrData.count; i++) {
        ListTableViewCell *cell1=obj.object;
        NSIndexPath *indexpath1=[textView_ indexPathForCell:cell1];
        if (indexpath1.row==i) {
            
        }else{
            
            NSIndexPath *indexpath=[NSIndexPath indexPathForRow:i inSection:0];
            taskModel *model=_arrData[indexpath.row];
            model.TaskMarkFlag=0;
            ListTableViewCell *cell=[textView_ cellForRowAtIndexPath:indexpath];
            [UIView animateWithDuration:0.1 animations:^{
                cell.StateBt2.frame=CGRectMake(10, 10,40 , 40);
                cell.StateBt1.frame=CGRectMake(10, 10,40 , 40);
                cell.TitleLab_.frame=CGRectMake(55, 15, cell.contentView.frame.size.width-150, 17.5);
                cell.TimeLab_.frame=CGRectMake(55, 37.5, cell.contentView.frame.size.width-150, 8.5);
                cell.ListBt.frame=CGRectMake(kScreen_Width-16-24, 0,40 , 60);
                cell.ListBt.hidden=NO;
                cell.FinishBt.frame=CGRectMake(kScreen_Width, 0, 64, 60);
                cell.StateBt.frame=CGRectMake(10, 10,40 , 40);
            } completion:^(BOOL finished) {
                cell.StateBt.hidden=NO;
                cell.StateBt1.hidden=YES;
                cell.StateBt2.hidden=YES;
                cell.ListBt.hidden=NO;
            }];
        }
    }

}
/**
 *  用来判断是点击的哪一个cell
 *
 *  @param obj 用通知中心名字为"ModelTaskMarkFlag"来实现;
 */
-(void)selectArr:(NSNotification *)obj{
  
    flag1=1;
    for (NSInteger i=0; i<_arrData.count; i++) {
        ListTableViewCell *cell1=obj.object;
        NSIndexPath *indexpath1=[textView_ indexPathForCell:cell1];
        if (indexpath1.row==i) {

        }else{
            NSIndexPath *indexpath=[NSIndexPath indexPathForRow:i inSection:0];
            ListTableViewCell *cell=[textView_ cellForRowAtIndexPath:indexpath];
            [UIView animateWithDuration:0.1 animations:^{
                cell.StateBt2.frame=CGRectMake(10, 10,40 , 40);
                cell.StateBt1.frame=CGRectMake(10, 10,40 , 40);
                cell.TitleLab_.frame=CGRectMake(55, 15, cell.contentView.frame.size.width-150, 17.5);
                cell.TimeLab_.frame=CGRectMake(55, 37.5, cell.contentView.frame.size.width-150, 8.5);
                cell.ListBt.frame=CGRectMake(kScreen_Width-16-24, 0,40 , 60);
                cell.FinishBt.frame=CGRectMake(kScreen_Width, 0, 64, 60);
                cell.StateBt.frame=CGRectMake(10, 10,40 , 40);
            } completion:^(BOOL finished) {
                taskModel *model=_arrData[indexpath.row];
                model.TaskMarkFlag=0;
                cell.StateBt1.hidden=YES;
                cell.StateBt2.hidden=YES;
                cell.StateBt.hidden=NO;
                cell.ListBt.hidden=NO;
            }];
        }
    }
    
    
    
}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  获取增量内容
 */
-(void)GetIncrement{
    
    
    
    [UserInfo saveTaskLastTime:@"2015-12-15 17:10:16"];
    
    
    
    NSString *date = [UserInfo getTaskLastTime];
    
    
    NSString *url = [IncrementTask stringByAppendingFormat:@"&lastTime=%@",date];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [AFNetClient GET_Path:url completed:^(NSData *stringData, id JSONDict) {
            NSLog(@"JSONDict=%@",JSONDict);
            
//            for (NSInteger i=0; i<[[JSONDict objectForKey:@"Data"]count]; i++) {
//                //数据模型，插入到数组中
//                taskModel *model=[[taskModel alloc]init];
//                model.TaskRemark=[[[JSONDict objectForKey:@"Data"] objectAtIndex:i] objectForKey:@"Remark"];
//                model.TaskTitle=[[[JSONDict objectForKey:@"Data"] objectAtIndex:i] objectForKey:@"Title"];
//                model.TaskTime=[[[JSONDict objectForKey:@"Data"] objectAtIndex:i]objectForKey:@"Time"];
//                model.TaskFlag=[[[[JSONDict objectForKey:@"Data"] objectAtIndex:i]objectForKey:@"Flag"]integerValue];
//                model.TaskId=[[[[JSONDict objectForKey:@"Data"] objectAtIndex:i]objectForKey:@"Id"]integerValue];
//                model.TaskAddTime=[[[JSONDict objectForKey:@"Data"] objectAtIndex:i]objectForKey:@"AddTime"];
//                model.TaskExpiresTime=[[[JSONDict objectForKey:@"Data"] objectAtIndex:i]objectForKey:@"ExpiresTime"];
//                model.TaskState=[[[[JSONDict objectForKey:@"Data"] objectAtIndex:i]objectForKey:@"Status"]integerValue];
//                model.TaskUpAndDown=1;
//                NSArray *arr=[model.TaskTime componentsSeparatedByString:@" "];
//                model.TaskDay=arr[0];
//                
//                BOOL sucess=[taskDatabase insertModal:model];
//                if (sucess==YES) {
//                    NSLog(@"插入成功");
//                }else{
//                    NSLog(@"插入失败");
//                }
//            }

        } failed:^(NSError *error) {
            
        }];
    });
    
}
/**
 *  向服务器请求数据，来得到所有的任务，这个方法仅仅执行一次就可以了
 */
-(void)GetData{
    
    //设定现在的时间
    NSDate *date=[StringChangeDate getNowDateFromatAnDate:[NSDate date]];
    [UserInfo saveTaskLastTime:[StringChangeDate DateChangeStringWay:date]];
    
    //将代码块提交给系统的全局并发队列
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        //向服务器发送get请求
        [AFNetClient GET_Path:ALlTask completed:^(NSData *stringData, id JSONDict) {
            NSLog(@"%@",JSONDict);
            
            for (NSInteger i=0; i<[[JSONDict objectForKey:@"Data"]count]; i++) {
                //数据模型，插入到数组中
                taskModel *model=[[taskModel alloc]init];
                model.TaskRemark=[[[JSONDict objectForKey:@"Data"] objectAtIndex:i] objectForKey:@"Remark"];
                model.TaskTitle=[[[JSONDict objectForKey:@"Data"] objectAtIndex:i] objectForKey:@"Title"];
                model.TaskTime=[[[JSONDict objectForKey:@"Data"] objectAtIndex:i]objectForKey:@"Time"];
                model.TaskFlag=[[[[JSONDict objectForKey:@"Data"] objectAtIndex:i]objectForKey:@"Flag"]integerValue];
                model.TaskId=[[[[JSONDict objectForKey:@"Data"] objectAtIndex:i]objectForKey:@"Id"]integerValue];
                model.TaskAddTime=[[[JSONDict objectForKey:@"Data"] objectAtIndex:i]objectForKey:@"AddTime"];
                model.TaskExpiresTime=[[[JSONDict objectForKey:@"Data"] objectAtIndex:i]objectForKey:@"ExpiresTime"];
                model.TaskState=[[[[JSONDict objectForKey:@"Data"] objectAtIndex:i]objectForKey:@"Status"]integerValue];
                model.TaskUpAndDown=1;
                NSArray *arr=[model.TaskTime componentsSeparatedByString:@" "];
                model.TaskDay=arr[0];
                
                BOOL sucess=[taskDatabase insertModal:model];
                if (sucess==YES) {
                    NSLog(@"插入成功");
                }else{
                    NSLog(@"插入失败");
                }
            }
            
            NSArray *arr=(NSMutableArray*)[taskDatabase queryData:self.title];
            [_arrData removeAllObjects];
            for(NSInteger i=0;i<arr.count;i++){
                [_arrData addObject:arr[i]];
            }
            if (arr.count==0) {
                [self.view addSubview:imageviewNO_];
            }else{
                [imageviewNO_ removeFromSuperview];
            }

            [textView_ reloadData];
        } failed:^(NSError *error) {
            
        }];
    });

}
#pragma mark -----初始化相关数据
-(void)initData{
    [_arrData removeAllObjects];
    //从数据库中取出数据
    NSArray *arr=(NSMutableArray*)[taskDatabase queryData:self.title];
    for(NSInteger i=0;i<arr.count;i++){
        [_arrData addObject:arr[i]];
    }
    if (arr.count==0) {
        [self.view addSubview:imageviewNO_];
    }else{
        [imageviewNO_ removeFromSuperview];
    }
    [textView_ reloadData];
}
#pragma mark ---初始化UI界面
-(void)initUI{
    
    creatTaskBt_=[UIButton buttonWithType:UIButtonTypeCustom];
    creatTaskBt_.frame=CGRectMake(0, kScreen_Height-64-44, kScreen_Width, 44);
    [creatTaskBt_ setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [creatTaskBt_ addTarget:self action:@selector(creatTask) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:creatTaskBt_];
    
    textView_=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-44) style:UITableViewStyleGrouped];
    textView_.backgroundColor=[UIColor clearColor];
    
    textView_.delegate=self;
    textView_.dataSource=self;
   
    if ([textView_ respondsToSelector:@selector(setSeparatorInset:)]) {
        [textView_ setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([textView_ respondsToSelector:@selector(setLayoutMargins:)]) {
        [textView_ setLayoutMargins:UIEdgeInsetsZero];
    }
    //隐藏滑动条
    textView_.showsVerticalScrollIndicator=NO;
    [self.view addSubview:textView_];
    
    
}
#pragma mark ------创建新任务
-(void)creatTask{
    
    CreatViewController *creat=[[CreatViewController alloc]init];
    
    [self.navigationController pushViewController:creat animated:YES];
}
#pragma mark -------UITableViewDataSource

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (flag1==1) {
        //恢复原状
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FinishNotification1" object:nil];
        flag1=0;
    }else{
        //跳转到下一页
        EditorViewController *editor=[[EditorViewController alloc]init];
        editor.taskmodel_=_arrData[indexPath.row];
        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:editor animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrData.count;
}
//cell消失的时候一直用这一个方法进行监听
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSIndexPath *path =  [textView_ indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    ListTableViewCell *cell=[textView_ cellForRowAtIndexPath:path];
    [UIView  animateWithDuration:0.1 animations:^{
        cell.StateBt1.frame=CGRectMake(10, 10, 40, 40);
        cell.StateBt2.frame=CGRectMake(10, 10, 40, 40);
        cell.TitleLab_.frame=CGRectMake(55, 15, cell.contentView.frame.size.width-150, 17.5);
        cell.TimeLab_.frame=CGRectMake(55, 37.5, cell.contentView.frame.size.width-150, 8.5);
        cell.ListBt.frame=CGRectMake(kScreen_Width-16-24, 0,40 , 60);
        cell.ListBt.hidden=NO;
        cell.FinishBt.frame=CGRectMake(kScreen_Width, 0, 64, 60);
        cell.StateBt.frame=CGRectMake(10, 10, 40, 40);
    } completion:^(BOOL finished) {
        taskModel *model=_arrData[path.row];
        model.TaskMarkFlag=0;
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    if (!cell) {
        cell=[[ListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListCell"];
    }
    cell.tag=indexPath.row;
    //取消选中状态
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    taskModel *model=_arrData[indexPath.row];
    cell.model=model;
    return cell;
}
/**
 *  管理内存
 */
-(void)dealloc{
    [creatTaskBt_ removeFromSuperview];
    [textView_ removeFromSuperview];
    [imageviewNO_ removeFromSuperview];
    creatTaskBt_=nil;
    textView_=nil;
    _arrData=nil;
    imageviewNO_=nil;
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
