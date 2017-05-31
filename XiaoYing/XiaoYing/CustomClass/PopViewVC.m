//
//  PopViewVC.m
//  XiaoYing
//
//  Created by ZWL on 16/9/9.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "PopViewVC.h"
#import "TurnToCell.h"

@interface PopViewVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    AppDelegate *_appDelegate;
}

@end

@implementation PopViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}


-(void)initUI
{
    
    //标题数组
//    _titleArr = @[@"相册",@"拍照"];
    
    //创建tableView
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 132 + 12) style:UITableViewStylePlain];
    
    //设置tableView的代理和属性
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.scrollEnabled = NO;
    
    //    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    //这个应该是那个线
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //延迟1秒执行这个方法
    [self performSelector:@selector(delayAction) withObject:nil afterDelay:.1];
    
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
}

- (void)delayAction
{
    [UIView animateWithDuration:.5 animations:^{
        _tableView.top = kScreen_Height-(132+12);
    }];
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
    
    return 44;
}



////选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UINavigationController *nav = _appDelegate.tabvc.viewControllers[1];
    
    if (indexPath.section == 0) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            if (_clickBlock) {
                _clickBlock(indexPath.row);
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}




//点击蒙版 蒙版退下
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if ([touches anyObject].view == self.view) {
        
        [UIView animateWithDuration:.35 animations:^{
            _tableView.top = kScreen_Height;
        } completion:^(BOOL finished) {
            
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
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

