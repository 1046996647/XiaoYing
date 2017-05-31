//
//  NewMessageController.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/14.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "NewMessageController.h"
#import "Switch.h"
#import "NoDisturbingController.h"

@interface NewMessageController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    NSArray *_footArray;
    Switch *_switch;
}

@end

@implementation NewMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    _titleArray = @[@"声音",@"振动"];
    
    //组的尾视图标题
    _footArray = @[@"关闭后，通知提示将不显示信息人与摘要",
                   @"你可以选择声音加震动提示信息和任务计划，但触发任务计划时手机会屏现提示",
                   @"设置系统消息提示声音和震动时段"];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];
    
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return _titleArray.count;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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
        //分开开关点击事件
        _switch.indexPath = indexPath;
        [_switch addTarget: self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.text = _titleArray[indexPath.row];
        if (indexPath.row == 0) {
            //分割线
            [cell.contentView addSubview:sepView];
        }
        
    } else if (indexPath.section == 2) {
        
        cell.textLabel.text=@"功能消息免打扰";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.textLabel.text=@"通知显示消息详情";
        
    }
    
    if (indexPath.section != 2) {
        //开关控件
        [cell.contentView addSubview:_switch];
    }
    
    //免打扰
    if (indexPath.section != 2) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        NoDisturbingController * noDisturbingController = [[NoDisturbingController alloc] init];
        noDisturbingController.title = @"功能消息免打扰";
        [self.navigationController pushViewController:noDisturbingController animated:YES];
    }
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
        if (isOn == 0) {
            //处理事情
            NSLog(@"%d",isOn);
        } else {
            //处理事情
            NSLog(@"%d",isOn);
        }
    } else {
        if (row == 0) {
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
    if (section == 1 || section == 2) {
        return 0;
    }
    return 12;
}

//组的尾视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 48;
    }
    return 33;
}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    return headerView;
}

//组的尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40 - 12)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    //尾标题
    UILabel *sectionLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 6, kScreen_Width - 16 - 24, 20)];
    sectionLab.font = [UIFont systemFontOfSize:13];
    sectionLab.textColor = [UIColor colorWithHexString:@"#848484"];
    sectionLab.text = _footArray[section];
    [footerView addSubview:sectionLab];
    
    if (section == 1) {
        footerView.height = 50 - 12;
        
        sectionLab.top = 3;
        sectionLab.height = 40;
        sectionLab.numberOfLines = 2;
    }
    
    return footerView;
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
