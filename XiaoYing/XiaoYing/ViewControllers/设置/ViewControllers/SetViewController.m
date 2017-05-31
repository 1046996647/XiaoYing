//
//  SetViewController.m
//  XiaoYing
//
//  Created by MengFanBiao on 15/10/21.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "SetViewController.h"
#import "AppDelegate.h"
#import "SettingCell.h"
#import "PersonalMessageController.h"
#import "NewMessageController.h"
#import "UniversalController.h"
#import "AcountAndSecurityViewController.h"
#import "SecretController.h"
#import "XYAboutAppThingVc.h"
#import "PasswordChangeController.h"
#import "DeleteViewController.h"

#import <RongIMKit/RongIMKit.h>

@interface SetViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *setTable_;
    NSArray *_titleArrayOne;
    NSArray *_titleArrayTwo;
    ProfileMyModel *_profileMyModel;
}
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    _titleArrayOne = @[@"通用"];
    _titleArrayTwo = @[@"修改小赢密码",@"关于小赢"];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    //消除底部横线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    setTable_=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 49)];
    setTable_.delegate=self;
    setTable_.dataSource=self;
    setTable_.scrollEnabled = NO;
    setTable_.backgroundColor = [UIColor clearColor];
//    setTable_.separatorStyle = UITableViewCellSeparatorStyleNone;
    setTable_.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:setTable_];
    
    self.title=@"设置";

}



static int count;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //个人信息取出
    _profileMyModel = [[FirstStartData shareFirstStartData] getPersonCentrePlist];
    
    //为了去掉该死分割线BUG（在账号与安全 单元格）
    if (count == 0) {
        count++;
        return;
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    SettingCell *cell = [setTable_ cellForRowAtIndexPath:indexPath];
    cell.profileModel = _profileMyModel;
    [cell setNeedsLayout];
    
}





#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return _titleArrayTwo.count;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }
    return 50;
}

//选中单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        //个人信息
        PersonalMessageController *personalMessageController = [[PersonalMessageController alloc] init];
        [self.navigationController pushViewController:personalMessageController animated:YES];
    } else if (indexPath.section == 1) {
        UniversalController *universalController = [[UniversalController alloc] init];
        universalController.title = @"通用";
        [self.navigationController pushViewController:universalController animated:YES];
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            PasswordChangeController * changePassWordVc = [[PasswordChangeController alloc]init];
            changePassWordVc.title = @"修改小赢密码";
            [self.navigationController pushViewController:changePassWordVc animated:YES];
        }
        if (indexPath.row == 1) {
            
            XYAboutAppThingVc * appThingVc = [[XYAboutAppThingVc alloc]init];
            appThingVc.title = @"关于小赢";
            [self.navigationController pushViewController:appThingVc animated:YES];
        }
    } else {
        
        DeleteViewController *deleteViewController = [[DeleteViewController alloc] init];
        //    deleteViewController.urlStr = self.sessionModel.url;
        
        deleteViewController.fileDeleteBlock = ^(void)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StartExit" object:nil];
        };
        
        deleteViewController.titleStr = @"是否确定退出当前账号?";
        deleteViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //淡出淡入
        deleteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //            self.definesPresentationContext = YES; //不盖住整个屏幕
        deleteViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [self presentViewController:deleteViewController animated:YES completion:nil];
        
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //第一组的单元格
    SettingCell *firstCell=[tableView dequeueReusableCellWithIdentifier:@"firstCell"];
    
    UITableViewCell *otherCell=[tableView dequeueReusableCellWithIdentifier:@"otherCell"];
    
    //自定义分割线
//    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(16, 49, kScreen_Width - 16, .5)];
//    sepView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    
    if (indexPath.section == 0) {
        if (firstCell==nil) {
            firstCell=[[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstCell"];
        }
        firstCell.profileModel = _profileMyModel;
        return firstCell;
    } else {
        if (otherCell==nil) {
            otherCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"otherCell"];
        }
        
        if (indexPath.section == 1) {
            otherCell.textLabel.text = _titleArrayOne[indexPath.row];

        } else if (indexPath.section == 2) {
            otherCell.textLabel.text= _titleArrayTwo[indexPath.row];
            
        } else {
            otherCell.textLabel.text=@"退出当前账号";
    
        }
        otherCell.textLabel.font = [UIFont systemFontOfSize:16];
        otherCell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        otherCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return otherCell;
    }
    
}


//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 12;
}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    return view;
}

//去掉最后单元格最下面的线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
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
