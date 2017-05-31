//
//  AddTaskVC.m
//  XiaoYing
//
//  Created by ZWL on 16/5/18.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "NewDelegateTaskViewController.h"
#import "EditCell.h"
#import "LocalTaskModel.h"
#import "ModelJson.h"

#define PATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"list.data"]


@interface NewDelegateTaskViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *_arrM;
    
}

@end

@implementation NewDelegateTaskViewController

- (void)dealloc
{
    // 本地
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:PATH]) {
        
        [NSKeyedArchiver archiveRootObject:_arrM toFile:PATH];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"添加任务";
    
    // 解档
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:PATH]) {
        
        _arrM = [NSKeyedUnarchiver unarchiveObjectWithFile:PATH];
    }
    
    if (_arrM.count == 0) {
        
        //        _arrM = [NSMutableArray array];
        LocalTaskModel *model = [[LocalTaskModel alloc] init];
        [_arrM addObject:model];
    }
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    //    _count = 1;
    
    //导航栏的保存按钮
    [self initRightBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageCountNotificationAction:) name:@"imageCountNotificationAction" object:nil];
    
    // 
    
    // 请求数据
    [self requestData];
}

// 请求数据
- (void)requestData
{
    
    // 新建委派接口测试
//    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
//    [paramDic  setValue:@"2016-7-12" forKey:@"startDate"];
//    [paramDic  setValue:@"2016-7-14" forKey:@"endDate"];
//    [paramDic  setValue:@false forKey:@"discussionGroup"];
//    [paramDic  setValue:@false forKey:@"sendSeparately"];
//    [paramDic  setValue:@false forKey:@"taskSharing"];
//    [paramDic  setValue:@6 forKey:@"creator"];
//    [paramDic  setValue:@"travel" forKey:@"title"];
//    
//    
//    [AFNetClient  POST_Path:NewDesignate params:paramDic completed:^(NSData *stringData, id JSONDict) {
//        
//        
//        //        [hud hide:YES];
//        
//        
//        NSLog(@"%@",JSONDict[@"Message"]);
//        
//    } failed:^(NSError *error) {
//        NSLog(@"请求失败Error--%ld",(long)error.code);
//    }];
    
    // 添加执行人接口测试
//    NSArray *arr = @[@1,@2];
//    NSString *string = [arr componentsJoinedByString:@","];
//    NSString *urlStr = [NSString stringWithFormat:@"%@&strProfileIds=%@&designateId=%@&title=%@",AddExecutor,string,@103,@"travel"];
//    [AFNetClient  POST_Path:urlStr completed:^(NSData *stringData, id JSONDict) {
//
//
//        //        [hud hide:YES];
//
//
//        NSLog(@"%@",JSONDict[@"Message"]);
//
//    } failed:^(NSError *error) {
//        NSLog(@"请求失败Error--%ld",(long)error);
//    }];
    
    // 添加任务
    DelegateTaskModel *model = [[DelegateTaskModel alloc] init];
    model.designateId = @103;
    model.rank = @1;
    model.order = @1;
    model.title = @"shame";
    model.content = @"fdsfefdfewfewfefregregregregregergregregresds";
    
    
    FileModel *fileModel1 = [[FileModel alloc] init];
    fileModel1.Url = @"f/1607/25/9bda6a36d10a493699f4e91f76b010d4/491121483691.caf";
    fileModel1.Order = @1;
    fileModel1.FileType = @1;
    
    FileModel *fileModel2 = [[FileModel alloc] init];
    fileModel2.Url = @"f/1607/25/4afead6db20044baa1cb9cf722021bc5/2016-07-250.png";
    fileModel2.Order = @2;
    fileModel2.FileType = @2;
    
    model.achments = @[fileModel1,fileModel2].mutableCopy;
    
    NSDictionary *dic = [ModelJson getObjectData:model];


    NSArray *arr1 = @[dic];

//    [AFNetClient  POST_Path:AddDuty params:arr1 completed:^(NSData *stringData, id JSONDict) {
//
//
//        //        [hud hide:YES];
//
//
//        NSLog(@"%@",JSONDict[@"Message"]);
//
//    } failed:^(NSError *error) {
//        NSLog(@"请求失败Error--%ld",(long)error.code);
//    }];
}

//导航栏的保存按钮
- (void)initRightBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 20);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightBar];
}

- (void)sendAction
{
    
}

#pragma mark - UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrM.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LocalTaskModel *model = _arrM[indexPath.row];
    
    CGFloat width = (kScreen_Width-5*12)/4.0;
    
    if (model.imagesArr.count < 4) {
        return (44+40+312/2.0+44+12+width+16);
    } else if (model.imagesArr.count < 8) {
        return (44+40+312/2.0+44+12+width*2+12+16);
        
    } else {
        return (44+40+312/2.0+44+12+width*3+12*2+16);
        
    }
    
    
}


//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EditCell *cell = cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    
    if (cell == nil) {
        
        cell = [[EditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
    }
    
//    EditCell *cell = [[EditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
    
    //    cell.delegate = self;
    cell.row = indexPath.row + 1;
    cell.model = _arrM[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 31;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 31)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(12, 0, kScreen_Width-24, 30);
    [btn setTitle:@"添加任务" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"f99740"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 6;
    btn.clipsToBounds = YES;
    btn.layer.borderWidth = .5;
    btn.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view;
}


- (void)addAction
{
    LocalTaskModel *model = [[LocalTaskModel alloc] init];
    [_arrM addObject:model];
    
    [_tableView reloadData];
    
    if (_arrM.count >= 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_arrM.count-1 inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - EditCellDelegate
//- (void)refresh:(NSInteger)picCount row:(NSInteger)row
//{
//    _picCount = picCount;
////    _row = row;
//    [_tableView reloadData];
//}
#pragma mark - 通知方法
- (void)imageCountNotificationAction:(NSNotification *)not
{
    //    _picCount = [not.object integerValue];
    [_tableView reloadData];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
