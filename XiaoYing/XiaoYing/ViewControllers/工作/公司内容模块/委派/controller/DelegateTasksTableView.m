//
//  DelegateTasksTableView.m
//  XiaoYing
//
//  Created by Li_Xun on 16/5/11.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DelegateTasksTableView.h"
#import "DelegateTasksTableViewCell.h"
#import "DelegateTasksDetailsViewController.h"

@interface DelegateTasksTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DelegateTasksTableView



-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rowHeight = 50;
    self.scrollEnabled = NO;
    
    
    return self;
}

//表格视图单元格数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

//表格视图单元格初始化
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellid8";
    DelegateTasksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[DelegateTasksTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.stateLabel.text = @"进\n行\n中";
    cell.stateLabel.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    cell.numberLabel.text = @"1 :";
    cell.titleLabel.text = @"标题";
    cell.tasksDetailsLabel.text = @"任务详情任务详情任务详情任务详情任务详情任务详情任务详情任务详情任务详情任务详情";
    cell.proportionLabel.text = @"任务比 : 高";
    NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:cell.proportionLabel.text];
    [attribute1 setAttributes:@{
                                NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"]
                                } range:NSMakeRange(0, 5)];
    [attribute1 setAttributes:@{
                                NSForegroundColorAttributeName : [UIColor redColor]
                                } range:NSMakeRange(5, cell.proportionLabel.text.length - 5)];
    cell.proportionLabel.attributedText = attribute1;
    
    [cell.performPeopleImage setImage:[UIImage imageNamed:@"enen2"] forState:UIControlStateNormal];
    cell.statePrompt.backgroundColor = [UIColor colorWithHexString:@"#02bb00"];
    cell.statePrompt.text = @"完成";
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

//表格单元格点击函数
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.viewController.navigationController pushViewController:[[DelegateTasksDetailsViewController alloc]init] animated:YES];
    NSLog(@"zhangsan ");
}

@end
