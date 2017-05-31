//
//  ApplyVoucherViewController.m
//  申请凭证
//
//  Created by YL20071 on 16/10/14.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "ApplyVoucherViewController.h"

//#import "FakeModel.h"//假数据
#import "ApplyVoucherModel.h"
#import "ApplyVoucherCell.h"


static NSString *cellIdentifier = @"cell";

@interface ApplyVoucherViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;//表视图
    NSArray *_dataList;//数据数组
    NSString *_applyVoucherUrl;//获取申请凭证列表的url
    MBProgressHUD *_hud;//菊花
}
@end

@implementation ApplyVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请凭证";
    //背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    
    //加载网络数据
    [self loadData];
    
//    //获取数据数组
//    _dataList = [FakeModel getFakeDataArray];
    
    [self setTableView];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载中";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//*********设置表视图*********/
-(void)setTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    //设置不能选择
    _tableView.allowsSelection = NO;
    //去除底部的分割线
    _tableView.separatorStyle = NO;
    //消除底部的空白cell
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource delegateMethods
//返回的分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//返回的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplyVoucherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ApplyVoucherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.model = _dataList[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate delegateMethods
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

//选择某个cell之后
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //去除被选择后的高亮状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 网络加载方法 methods
-(void)loadData{
    _applyVoucherUrl = [NSString stringWithFormat:@"%@/api/Apply/myExcute?Token=%@",BaseUrl1,[UserInfo getToken]];
    [AFNetClient GET_Path:_applyVoucherUrl completed:^(NSData *stringData, id JSONDict) {
        NSInteger code = [JSONDict[@"Code"] integerValue];
        if (code == 0) {//成功
            NSArray *dataArray = JSONDict[@"Data"];
            NSLog(@"jsonDic:%@",JSONDict);
            _dataList = [ApplyVoucherModel getApplyVoucherModelArrayFromArray:dataArray];
            [_tableView reloadData];
            [_hud hide:YES];
        }
    } failed:^(NSError *error) {
        [_hud hide:YES];
        [MBProgressHUD showMessage:@"网络出错，请稍后再试" toView:self.view];
        NSLog(@"请求失败Error--%ld",(long)error.code);
    }];
}

@end
