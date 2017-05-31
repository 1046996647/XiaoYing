//
//  NewMessageController.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/14.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "SexController.h"

@interface SexController()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    UIImageView *_imgView;   //选中提示
    NSIndexPath *_lastIndexPath; //上一个选中的单元格
    
    NSNumber *_keyNum; //性别表示
    MBProgressHUD *_hud;
}


@end

@implementation SexController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    //从本地获取个人信息
    self.profileMyModel = [[FirstStartData shareFirstStartData] getPersonCentrePlist];
    
    _titleArray = @[@"男",@"女"];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    //单元格选中提示视图
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 9)];
    _imgView.image = [UIImage imageNamed:@"draw"];
    
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    //自定义分割线
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(16, 49, kScreen_Width - 16, 1)];
    sepView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    if (indexPath.row == 0) {
        //分割线
        [cell.contentView addSubview:sepView];
        
    }
//    else {
//        cell.accessoryView = _imgView;
//        
//        //记录当前indexPath
//        _lastIndexPath = indexPath;
//    }
    
    if (self.profileMyModel.Gender == 1 && indexPath.row == 0) {
        cell.accessoryView = _imgView;
         _lastIndexPath = indexPath;
    }
    else if (self.profileMyModel.Gender == 2 && indexPath.row == 1) {
        cell.accessoryView = _imgView;
         _lastIndexPath = indexPath;
    }
    else {
        cell.accessoryView = nil;

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    return cell;
}

//隐藏状态栏
// - (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //取消上一个单元格的accessoryView（必须取消，不然内存不断增大）
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:_lastIndexPath];
    lastCell.accessoryView = nil;
    
    //显示当前单元格的accessoryView
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = _imgView;
    
    //记录上一个indexPath
    _lastIndexPath = indexPath;
    
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载...";
    
    //昵称修改
    if ([cell.textLabel.text isEqualToString:@"男"]) {
        
        _keyNum = [NSNumber numberWithInt:1];
    }
    else if ([cell.textLabel.text isEqualToString:@"女"]) {
        
        _keyNum = [NSNumber numberWithInt:2];
    }
 
    
    
    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
    [paramDic  setValue:_keyNum forKey:@"gender"];
    
    [AFNetClient  POST_Path:Profile params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        [self getMyMessage];
        
    } failed:^(NSError *error) {
        NSLog(@"请求失败Error--%ld",(long)error.code);
    }];
    
    
    
}


/**
 *  获取个人信息
 */
-(void)getMyMessage{
    
    
    [AFNetClient GET_Path:ProfileMy completed:^(NSData *stringData, id JSONDict) {
        
        [_hud hide:YES];
        
        ProfileMyModel * model1 = [FirstModel GetProfileMyModel:[JSONDict objectForKey:@"Data"]];
        //获取存储沙盒路径
        NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        documentPath = [documentPath stringByAppendingPathComponent:@"PersonCentre.plist"];
        //用归档存储数据在plist文件中
        NSLog(@"个人中心存储在PersonCentre.plist文件中%@",documentPath);
        
        [NSKeyedArchiver archiveRootObject:model1 toFile:documentPath];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}




//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}


//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    return headerView;
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
