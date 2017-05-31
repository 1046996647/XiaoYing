//
//  EditTaskVCViewController.m
//  XiaoYing
//
//  Created by ZWL on 16/5/17.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "EditTaskVC.h"
#import "AddTaskVC.h"

@interface EditTaskVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    
}

@property (nonatomic,strong) UITextField *titleField;


@end

@implementation EditTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"编辑设置";

    
    _titleArray = @[@"",@"开始时间",@"结束时间",@"执行人",@"任务共享"];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    //导航栏的下一步按钮
    [self initRightBtn];
    
}

//导航栏的下一步按钮
- (void)initRightBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 20);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightBar];
}

- (void)nextAction
{
    [self.navigationController pushViewController:[[AddTaskVC alloc] init] animated:YES];
}

#pragma mark - UITableViewDataSource


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
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }
    
    if (indexPath.row == 0) {
        _titleField = [[UITextField alloc] initWithFrame:CGRectMake(14, 0, kScreen_Width-12, 50)];
        _titleField.font = [UIFont systemFontOfSize:16];
        _titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _titleField.placeholder = @"标题";
        _titleField.textColor = [UIColor colorWithHexString:@"#333333"];
        [cell.contentView addSubview:_titleField];
    }

    if (indexPath.row == 1 || indexPath.row == 2) {
        cell.detailTextLabel.text = @"2015-09-90";

    }
    
    //系统设定的frame(248 10; 51 31)
    if (indexPath.row == 4) {
        UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreen_Width - 12 - 51, (50 - 31)/2.0, 0, 0)];
        aSwitch.on = NO;
        [aSwitch addTarget: self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:aSwitch];

    }
    
    if (indexPath.row == 2 || indexPath.row == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];

    return cell;
}

//开关事件
- (void)switchValueChanged:(UISwitch *)control
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
