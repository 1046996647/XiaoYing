//
//  XYAboutAppThingVc.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/8/20.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYAboutAppThingVc.h"
#import "DataCollectionVC.h"//意见反馈
#import "PolicyVC.h"//服务协议
#import "BetaIntroduceVC.h"//新版本介绍

@interface XYAboutAppThingVc ()<UITableViewDelegate,UITableViewDataSource>{
    
    UIImageView * _aboutImageView;
    UILabel * _appLabel;
    UITableView * _appTableView;
    NSArray * _dataArray;
}

@end

@implementation XYAboutAppThingVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self initUI];
    
    if ([_appTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_appTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_appTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_appTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    


    _dataArray = @[@"意见反馈",@"新版本介绍",@"服务协议",@"联系我们"];
}

-(void)initUI{
    
    _aboutImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreen_Width - 80)/2, 20, 80, 80)];
    [self.view addSubview:_aboutImageView];
    _aboutImageView.image = [UIImage imageNamed:@"address"];

    
    _appLabel = [[UILabel alloc]init];
    [self.view addSubview:_appLabel];
    [_appLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_aboutImageView.mas_centerX);
        make.top.equalTo(_aboutImageView.mas_bottom).offset(7);
    }];
        _appLabel.text = @"1.0版本";
        [_appLabel sizeToFit];
        _appLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _appLabel.font = [UIFont systemFontOfSize:12];
        _appLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    _appTableView = [[UITableView alloc]init];
    [self.view addSubview:_appTableView];
    [_appTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_appLabel.mas_bottom).offset(19);
        make.width.equalTo(@kScreen_Width);
        make.height.equalTo(@(kScreen_Height - _appLabel.width - 19));
        
    }];
    _appTableView.delegate = self;
    _appTableView.dataSource = self;
    _appTableView.backgroundColor = [UIColor clearColor];
    _appTableView.tableFooterView = [UIView new];
    
//    _appTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _appLabel.bottom + 19, kScreen_Width, (kScreen_Height - _appLabel.bottom - 19))];
//    [self.view addSubview:_appTableView];
//    _appTableView.delegate = self;
//    _appTableView.dataSource = self;
//    _appTableView.backgroundColor = [UIColor clearColor];
//    _appTableView.tableFooterView = [UIView new];
    
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark TabelView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }
    
    if (indexPath.row == _dataArray.count-1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = @"400-114-7700";
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#4eabfa"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    return cell;
}

//选中单元行做的事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {//意见反馈
        DataCollectionVC *dataCollectionVC = [DataCollectionVC new];
        [self.navigationController pushViewController:dataCollectionVC animated:YES];
    }

    if (indexPath.row == 1) {//新版本介绍
        BetaIntroduceVC *betaIntroduce = [BetaIntroduceVC new];
        [self.navigationController pushViewController:betaIntroduce animated:YES];
    }
    
    if (indexPath.row == 2) {//服务协议
        PolicyVC *policyVC = [PolicyVC new];
        [self.navigationController pushViewController:policyVC animated:YES];
    }
    
    if (indexPath.row == 3) {//联系我们
        UIWebView *callWebView = [[UIWebView alloc] init];
        NSURL *telURL = [NSURL URLWithString:@"tel:400-114-77008"];
        [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebView];
    }
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
