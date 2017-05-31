//
//  SelectWayVC.m
//  XiaoYing
//
//  Created by ZWL on 16/5/18.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "TurnToVC.h"
#import "TurnToCell.h"
#import "SelectExistingPeopleVC.h"

@interface TurnToVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArr;
    AppDelegate *_appDelegate;
}

@end

@implementation TurnToVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _titleArr = @[@"移交新执行人",@"移交至现有执行人"];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 150+12) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self performSelector:@selector(delayAction) withObject:nil afterDelay:.1];

    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
}

- (void)delayAction
{
    [UIView animateWithDuration:.5 animations:^{
        _tableView.top = kScreen_Height-(150+12);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *nav = _appDelegate.tabvc.viewControllers[1];
    
    if (indexPath.section == 0) {
        
        [self dismissViewControllerAnimated:NO completion:^{
            
            // 必须写在里面不然消除不了
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissVC" object:nil];
            
            if (indexPath.row == 0) {
                
//                SelectNewExcutePeopleVC *selectNewExcutePeopleVC = [[SelectNewExcutePeopleVC alloc] init];
//                [nav pushViewController:selectNewExcutePeopleVC animated:YES];
            } else {
                
                SelectExistingPeopleVC *selectExistingPeopleVC = [[SelectExistingPeopleVC alloc] init];
                [nav pushViewController:selectExistingPeopleVC animated:YES];
            }
        }];
        

    } else {
        
//        [UIView animateWithDuration:.5 animations:^{
//            _tableView.top = kScreen_Height;
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }];
        
        [UIView animateWithDuration:.35 animations:^{
            _tableView.top = kScreen_Height;

        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];

        }];
        
    }
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TurnToCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[TurnToCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    if (indexPath.section == 0) {
        cell.nameLab.text = _titleArr[indexPath.row];
    } else {
        cell.nameLab.text = @"取消";
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return 12;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches anyObject].view == self.view) {
        [UIView animateWithDuration:.35 animations:^{
            _tableView.top = kScreen_Height;
            
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
            
        }];
   
    }
    
}

@end
