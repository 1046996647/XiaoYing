//
//  InboxVC.m
//  XiaoYing
//
//  Created by ZWL on 16/2/25.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "InboxVC.h"
#import "InboxCell.h"
#import "InboxMailVC.h"

@interface InboxVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    UISearchBar *searchBar;
    UIButton *searchBut;
}

@end

@implementation InboxVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self initView];
}

-(void)initView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44+80*3) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    view.backgroundColor = [UIColor whiteColor];
    
    // 搜索框
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    searchBar.placeholder = @"查找邮件";
    searchBar.delegate = self;
    searchBar.barTintColor = [UIColor colorWithHexString:@"#efeff4"];
    searchBar.tintColor = [UIColor colorWithHexString:@"#efeff4"];
    [[[[ searchBar.subviews objectAtIndex : 0 ] subviews] objectAtIndex : 0 ] removeFromSuperview ];
    searchBar.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    searchBut =[UIButton buttonWithType:UIButtonTypeCustom];
    searchBut.frame =CGRectMake(kScreen_Width -31, 14, 16, 16);
    [searchBut setBackgroundImage:[UIImage imageNamed:@"search_delete@2x"] forState:UIControlStateNormal];
    [searchBut addTarget:self action:@selector(searchButClick) forControlEvents:UIControlEventTouchUpInside];
    searchBut.hidden =YES;
    [searchBar addSubview:searchBut];
    [view addSubview:searchBar];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreen_Width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5dcd7"];
    [view addSubview:lineView];
    
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
         cell = [[InboxCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InboxMailVC *vc = [[InboxMailVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.emailBoxStyle = self.emailBoxStyle;
    
}


#pragma mark - uisearchBarDelegate

-(void)searchButClick{
    NSLog(@"搜索");
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
