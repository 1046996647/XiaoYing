//
//  AccordingToDepartmentView.m
//  XiaoYing
//
//  Created by ZWL on 16/1/30.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AccordingToDepartmentView.h"
#import "DepartmentStatisticsVC.h"
#import "DoStatisticsVC.h"
@interface AccordingToDepartmentView()
{
    NSMutableArray *modelArr;
}
@property (nonatomic,strong)UITableView *ListTable;//数据列表
@property (nonatomic,strong)UILabel *companyNameLab;//公司名称
@property (nonatomic,strong) UISearchBar *statisticsSearch;//收索框

@end
@implementation AccordingToDepartmentView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        modelArr = [[NSMutableArray alloc] init];
        [modelArr addObject:@"人事行政部"];
        [modelArr addObject:@"科技产业部"];
        [modelArr addObject:@"财务部"];
        
        [self initUI];
    }
    return self;
}
- (void)initUI{
    self.ListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-44-64)];
    self.ListTable.delegate = self;
    self.ListTable.dataSource = self;
    self.ListTable.backgroundColor = [UIColor clearColor];
    [self addSubview:self.ListTable];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DepartmentStatisticsVC *deparmentVC  =[[DepartmentStatisticsVC alloc]init];
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[DoStatisticsVC class]]) {
            DoStatisticsVC *vc = (DoStatisticsVC *)nextResponder;
            
            vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            deparmentVC.title = modelArr[indexPath.row];
            [vc.navigationController pushViewController:deparmentVC animated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 88;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44+44)];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    lab.backgroundColor = [UIColor whiteColor];
    lab.text = @"杭州赢萊金融信息服务有限公司";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    
    
    self.statisticsSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, kScreen_Width, 44)];
    self.statisticsSearch.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.statisticsSearch.placeholder = @"查找成员";
    [view addSubview:lab];
    [view addSubview:self.statisticsSearch];
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = modelArr[indexPath.row];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
