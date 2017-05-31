//
//  CountAndSecurityViewController.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/14.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "BindingPhoneNumberController.h"

@interface BindingPhoneNumberController()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    UITextField *_phoneTF;
    UITextField *_verifyTF;
    UILabel *_lab;
}
@end

@implementation BindingPhoneNumberController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    _titleArray = @[@"手机号",@"验证码"];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    //导航栏的保存按钮
    [self initRightBtn];
    
}


//导航栏的确定按钮
- (void)initRightBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 20);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightBar];
}

//确定
- (void)confirmAction
{
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titleArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //自定义分割线
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(16, 49, kScreen_Width - 16, .5)];
    sepView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        //手机号
        _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(80, (50 - 20) / 2.0, 130, 20)];
        _phoneTF.font = [UIFont systemFontOfSize:14];
        _phoneTF.text = self.phoneText;
        _phoneTF.delegate = self;
        _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTF.textColor = [UIColor colorWithHexString:@"#333333"];
        
        //验证码
        _verifyTF = [[UITextField alloc] initWithFrame:CGRectMake(80, (50 - 20) / 2.0, 130, 20)];
        _verifyTF.font = [UIFont systemFontOfSize:14];
        _verifyTF.delegate = self;
        _verifyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _verifyTF.placeholder = @"请输入您的验证码";
        _verifyTF.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
        
        //获取验证码
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 100, 0, 100, 51)];
        _lab.text = @"获取验证码";
        _lab.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
        _lab.font = [UIFont systemFontOfSize:13];
        _lab.textColor = [UIColor whiteColor];
        _lab.numberOfLines = 2;
        //开启点击事件
        _lab.userInteractionEnabled = YES;
        _lab.textAlignment = NSTextAlignmentCenter;
        //手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getNumber:)];
        [_lab addGestureRecognizer:tap];

    
    }
    
    if (indexPath.row == 0) {
        [cell.contentView addSubview:sepView];
        [cell.contentView addSubview:_phoneTF];
    } else {
        [cell.contentView addSubview:_verifyTF];
        [cell.contentView addSubview:_lab];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    
    return cell;
}


//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    return view;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取验证码
- (void)getNumber:(UITapGestureRecognizer *)tap
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    });

}

//定时器方法
static int count = 1;//计数
- (void)timerAction:(NSTimer *)timer
{
    //取消label响应事件
    _lab.userInteractionEnabled = NO;
    _lab.text = [NSString stringWithFormat:@"重新获取验证码(%dS)",count++];
    if (count > 16) {
        count = 1;
        [timer invalidate];
        _lab.text = @"获取验证码";
        //开启label响应事件
        _lab.userInteractionEnabled = YES;
    }
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
