//
//  SelectRankVC.m
//  XiaoYing
//
//  Created by ZWL on 16/9/11.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "SelectRankVC.h"
@interface SelectRankVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@end

@implementation SelectRankVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake((kScreen_Width - 248) / 2, 112.5+44+64, 248, 526/2) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark --tableViewDelegate--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.minRank == self.maxRank) {
        return 1;
    }
    else {
        return (self.maxRank-self.minRank+1);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (_clickBlock) {
        _clickBlock(self.minRank+indexPath.row);
    }
    [self dismissViewControllerAnimated:NO completion:nil];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];;
    cell.layer.borderWidth = 0.5;
    cell.layer.cornerRadius = 0.9;
    cell.layer.borderColor=[[UIColor whiteColor] CGColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = [NSString stringWithFormat:@"%d级单元", self.minRank+indexPath.row];
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if ([touches anyObject].view == self.view) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}


@end
