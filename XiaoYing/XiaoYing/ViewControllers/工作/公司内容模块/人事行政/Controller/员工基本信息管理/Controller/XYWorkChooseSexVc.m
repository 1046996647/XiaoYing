//
//  XYWorkChooseSexVc.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/7/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "XYWorkChooseSexVc.h"

#import "XYWorkChooseSexCell.h"

@interface XYWorkChooseSexVc ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSArray * _titleArr;
    AppDelegate *_appDelegate;
}

@end

@implementation XYWorkChooseSexVc

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}


-(void)initUI
{

    //标题数组
    _titleArr = @[@"男",@"女"];
    
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


//展示cell数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell
    XYWorkChooseSexCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sexCell"];
    //判断缓存池当中是否存在这一类型的cell
    if (cell == nil) {
        
        cell = [[XYWorkChooseSexCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sexCell"];
        
    }
    
    //在这里设置cell 要展示的数据
    if (indexPath.section == 0) {
        
        cell.chooseLabel.text = _titleArr[indexPath.row];
        
    }else
    {
        cell.chooseLabel.text = @"取消";
    }
    
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}


/*
////选中单元格
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    [tableView deselectRowAtIndexPath:indexPath animated:YES];
////    UINavigationController *nav = _appDelegate.tabvc.viewControllers[1];
////    
////    if (indexPath.section == 0) {
////        
////        [self dismissViewControllerAnimated:NO completion:^{
////            
////            // 必须写在里面不然消除不了
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissVC" object:nil];
////            
////            if (indexPath.row == 0) {
////                
////                SelectNewExcutePeopleVC *selectNewExcutePeopleVC = [[SelectNewExcutePeopleVC alloc] init];
////                [nav pushViewController:selectNewExcutePeopleVC animated:YES];
////            } else {
////                
////                SelectExistingPeopleVC *selectExistingPeopleVC = [[SelectExistingPeopleVC alloc] init];
////                [nav pushViewController:selectExistingPeopleVC animated:YES];
////            }
////        }];
////        
////    
////    } else {
////        
////        //        [UIView animateWithDuration:.5 animations:^{
////        //            _tableView.top = kScreen_Height;
////        //            [self dismissViewControllerAnimated:YES completion:nil];
////        //        }];
////        
////        [UIView animateWithDuration:.35 animations:^{
////            _tableView.top = kScreen_Height;
////            
////        } completion:^(BOOL finished) {
////            [self dismissViewControllerAnimated:NO completion:nil];
////            
////        }];
////        
////    }
////    
////    
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    TurnToCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
////    
////    if (cell == nil) {
////        cell = [[TurnToCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
////        
////    }
////    
////    if (indexPath.section == 0) {
////        cell.nameLab.text = _titleArr[indexPath.row];
////    } else {
////        cell.nameLab.text = @"取消";
////    }
////    
////    return cell;
//}

 */
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
