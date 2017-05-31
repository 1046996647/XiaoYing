//
//  XYWorkChooseCateVc.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/8/9.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//



//添加类别界面
#import "XYWorkChooseCateVc.h"
#import "XYWorkPositionCell.h"
#import "XYWorkAddPositionVc.h"
#import "XYSearchBar.h"

#import "XYPositionAddListVc.h"
@interface XYWorkChooseCateVc ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView * _tableView;
    NSArray * _titleArray;
    UIButton * _bottomButton;
    
    XYSearchBar * search;
}

//@property(nonatomic,strong)UITableView * tableView;

@end

@implementation XYWorkChooseCateVc

- (void)viewDidLoad {
    [super viewDidLoad];
////    self.title = @"选择类别";
//    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
//    _titleArray = @[@"类别1",@"类别1",@"类别1"];
   
    [self setNav];
    [self initUI];

    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }


}

- (void)setNav{
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    
    UIView * btnView = [[UIView alloc]initWithFrame:rightButton.frame];
    [btnView addSubview:rightButton];
    
    UIBarButtonItem * rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:btnView];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}
- (void)initUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64)];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_bottomButton];
    _bottomButton.backgroundColor = [UIColor whiteColor];
    _bottomButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_bottomButton setTitle:@"添加类别" forState:UIControlStateNormal];
    [_bottomButton addTarget:self action:@selector(addPosition) forControlEvents:UIControlEventTouchUpInside];
    [_bottomButton setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    _bottomButton.titleLabel.textAlignment = NSTextAlignmentCenter;

    
    [_bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.right.equalTo(self.view).offset(0);
        make.height.equalTo(@44);
        
    }];
    
    
}

#pragma mark method
-(void)clickNext:(UIButton *)nextButton{
    
    XYWorkAddPositionVc * addPositionVc = [[XYWorkAddPositionVc alloc]init];
    [self.navigationController pushViewController:addPositionVc animated:YES];
    
}

-(void)addPosition{
    
    XYPositionAddListVc  * addListVc = [[XYPositionAddListVc alloc]init];
    addListVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //淡出淡入
    addListVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    //设置背景颜色
    addListVc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self presentViewController:addListVc animated:YES completion:nil];
}

#pragma mark dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYWorkPositionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellOne"];
    if (cell == nil) {
        
        cell = [[XYWorkPositionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellOne"];
    }
    
    cell.title = _titleArray[indexPath.row];
    return cell;
    

}

#pragma tableViewSpea
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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
