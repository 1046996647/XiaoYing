//
//  DelegateTableView.m
//  XiaoYing
//
//  Created by Li_Xun on 16/5/9.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DelegateTableView.h"
#import "DelegateTableViewCell.h"
#import "DelegateDetailsViewController.h"
#import "DelegateDiscussionGroupsViewController.h"

@interface DelegateTableView ()<UITableViewDataSource,UITableViewDelegate>

@end


@implementation DelegateTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rowHeight = 100*scaleY;
    
    return self;
}

#pragma mark - cell个数函数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

#pragma mark - 初始化cell函数
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellid1";
    DelegateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[DelegateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.delegateTitle.text = @"委派任务标题";
    cell.progressImage.image = [UIImage imageNamed:@"progress"];
    cell.delegatePeopleName.text = @"总经理-李先生";
    cell.performPeopleName.text = @"网络主管、营销经理...(3人)";
    cell.timeDetails.text = @"2016-02-22~2016-12-22";
    cell.progressTitle.text = @"已完成 : 1/2";
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:cell.progressTitle.text];
    [attribute setAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"]
                               } range:NSMakeRange(0, 5)];
    [attribute setAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#f94040"]
                               } range:NSMakeRange(5, cell.progressTitle.text.length - 5)];
    cell.progressTitle.attributedText = attribute;
    [cell.discussionGroups setBackgroundImage:[UIImage imageNamed:@"background"] forState:UIControlStateNormal];
    [cell.discussionGroups addTarget:self action:@selector(discussionGroupsEvent) forControlEvents:UIControlEventTouchDown];
    [cell.unreadMessages setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
    [cell.unreadMessages setTitle:@"7" forState:UIControlStateNormal];

    return cell;
}

-(void)discussionGroupsEvent
{
    [self.viewController.navigationController pushViewController:[[DelegateDiscussionGroupsViewController alloc] init] animated:YES];
}


#pragma mark - 选中cell函数
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DelegateDetailsViewController *delegateDetailsViewController = [[DelegateDetailsViewController alloc] init];
    delegateDetailsViewController.markInt = 100;
    [self.viewController.navigationController pushViewController:delegateDetailsViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
