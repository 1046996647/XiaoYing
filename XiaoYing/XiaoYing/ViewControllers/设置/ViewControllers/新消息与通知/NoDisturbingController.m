//
//  NewMessageController.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/14.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "NoDisturbingController.h"

@interface NoDisturbingController()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    UIImageView *_imgView;   //选中提示
    NSIndexPath *_lastIndexPath; //上一个选中的单元格
}

@end

@implementation NoDisturbingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    _titleArray = @[@"开启",@"只在夜间开启",@"关闭"];
    
    
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
    
    if (indexPath.row != 2) {
        //分割线
        [cell.contentView addSubview:sepView];

    } else {
        cell.accessoryView = _imgView;
        
        //记录当前indexPath
        _lastIndexPath = indexPath;
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
}






//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

//组的尾视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    return headerView;
}

//组的尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    //尾标题
    UILabel *sectionLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 2, kScreen_Width - 16 * 2, 60)];
    sectionLab.font = [UIFont systemFontOfSize:13];
    sectionLab.textColor = [UIColor colorWithHexString:@"#848484"];
    sectionLab.text = @"开启后，“邮箱提醒“在收到邮件后手机不会震动与发出声音。如果设置为”只在夜间开启“，则只在22:00到8:00间生效";
    sectionLab.textAlignment = NSTextAlignmentCenter;
    sectionLab.numberOfLines = 3;
    [footerView addSubview:sectionLab];
    
    return footerView;
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
