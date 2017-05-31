//
//  SecretController.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/16.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "SecretController.h"
#import "Switch.h"

@interface SecretController()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_sectionArr;
    NSArray *_cellArr;
    Switch *_switch;
}
@end

@implementation SecretController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    //组标题
    _sectionArr = @[@"通讯录",@"可以搜索到我"];
    
    //单元格内容
    _cellArr = @[@[@"加我时需要验证",@"向我推荐企业好友",@"向我推荐联系人好友"],
                 @[@"可以通过手机号搜索到我",@"可以通过小赢号搜索到我",@"可以通过企业推荐搜索到我"]];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_cellArr[section] count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //自定义分割线
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(16, 49, kScreen_Width - 16, 1)];
    sepView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        //系统设定的frame(248 10; 51 31)
        _switch = [[Switch alloc] initWithFrame:CGRectMake(kScreen_Width - 12 - 51, (50 - 31)/2.0, 0, 0)];
        _switch.on = YES;
        _switch.tag = indexPath.row;
        //分开开关点击事件
        _switch.indexPath = indexPath;
        
        [_switch addTarget: self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:_switch];
    }
    
    if (indexPath.row != 2) {
        //自定义分割线
        [cell.contentView addSubview:sepView];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _cellArr[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    
    return cell;
}

//开关事件
- (void)switchValueChanged:(Switch*)control
{
    //开关所在的组
    NSInteger section = control.indexPath.section;
    //开关所在的行
    NSInteger row = control.indexPath.row;
    //开关状态
    BOOL isOn = control.on;
    
    //先分组，再分行，再判断开关状态
    if (section == 0) {
        if (row == 0) {
            if (isOn == 0) {
                //处理事情
                NSLog(@"%d",isOn);
            } else {
                //处理事情
                NSLog(@"%d",isOn);
            }
            NSLog(@"%ld",row);
        } else if (row == 1) {
            if (isOn == 0) {
                //处理事情
            } else {
                //处理事情
            }
            NSLog(@"%ld",row);
        } else {
            if (isOn == 0) {
                //处理事情
            } else {
                //处理事情
            }
            NSLog(@"%ld",row);
        }
    } else {
        if (row == 0) {
            if (isOn == 0) {
                //处理事情
            } else {
                //处理事情
            }
            NSLog(@"%ld",row);
        } else if (row == 1) {
            if (isOn == 0) {
                //处理事情
            } else {
                //处理事情
            }
            NSLog(@"%ld",row);
        } else {
            if (isOn == 0) {
                //处理事情
            } else {
                //处理事情
            }
            NSLog(@"%ld",row);
        }
    }
//    NSLog(@"%ld",control.indexPath.section);
//    NSLog(@"%d",c);
}


//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 35)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    //组标题
    UILabel *sectionLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, 150, 20)];
    sectionLab.font = [UIFont systemFontOfSize:14];
    sectionLab.textColor = [UIColor colorWithHexString:@"#848484"];
    sectionLab.text = _sectionArr[section];
    [view addSubview:sectionLab];
    
    return view;
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
