//
//  CountAndSecurityViewController.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/14.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "AcountAndSecurityViewController.h"
#import "BindingPhoneNumberController.h"
#import "PasswordChangeController.h"

@interface AcountAndSecurityViewController()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    
}

@property(nonatomic,strong) UILabel *telLab;           //手机号

@end

@implementation AcountAndSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    _titleArray = @[@"小赢密码",@"账号保护",@"小赢安全中心"];
    
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
    
    if (section == 0) {
        return 1;
    }
    
    return _titleArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.section == 0) {
    //        return 80;
    //    }
    return 50;
}


//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        BindingPhoneNumberController *bindingPhoneNumberController = [[BindingPhoneNumberController alloc] init];
        bindingPhoneNumberController.phoneText = _telLab.text;
        bindingPhoneNumberController.title = @"绑定手机号";
        [self.navigationController pushViewController:bindingPhoneNumberController animated:YES];
    } else {
        if (indexPath.row == 0) {
            PasswordChangeController *passwordChangeController = [[PasswordChangeController alloc] init];
            passwordChangeController.title = @"小赢密码";
            [self.navigationController pushViewController:passwordChangeController animated:YES];
        }
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //自定义分割线
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(16, 49, kScreen_Width - 16, 1)];
    sepView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row != 2) {
            //自定义分割线
            [cell.contentView addSubview:sepView];
        }
        
        if (indexPath.row == 1) {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 50, (50 - 15) / 2.0, 15, 15)];
            img.image = [UIImage imageNamed:@"safe"];
            [cell.contentView addSubview:img];
        }
        cell.textLabel.text = _titleArray[indexPath.row];
        
    } else {
        
        //手机号
        _telLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 150 - 12 - 27, (50 - 20) / 2.0, 150, 20)];
        _telLab.font = [UIFont systemFontOfSize:16];
        _telLab.textColor = [UIColor colorWithHexString:@"#848484"];
        _telLab.textAlignment = NSTextAlignmentRight;
        _telLab.text = @"11223444433";
        [cell.contentView addSubview:_telLab];
        
        cell.textLabel.text = @"手机号";
    }
    
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    
    return cell;
}


//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
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
