//
//  SthMailVC.m
//  XiaoYing
//
//  Created by ZWL on 16/2/25.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "SthMailVC.h"
#import "InboxVC.h"

@interface SthMailVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SthMailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    
}

- (void)initView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 12, kScreen_Width, 5*44) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = @"12";
    NSArray *imageArr = @[[UIImage imageNamed:@"inbox2"],[UIImage imageNamed:@"star2"],[UIImage imageNamed:@"sended"],[UIImage imageNamed:@"draft"],[UIImage imageNamed:@"delete"]];
    NSArray *lableArr  = @[@"收件箱",@"星标邮件",@"已发送",@"草稿箱",@"垃圾箱"];
    
    cell.imageView.image = imageArr[indexPath.row];
    cell.textLabel.text = lableArr[indexPath.row];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        InboxVC *vc = [[InboxVC alloc]init];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        vc.title = @"收件箱";
        [self.navigationController pushViewController:vc animated:YES];
        vc.emailBoxStyle = 0;
        
    }else if (indexPath.row == 1){
        InboxVC *vc = [[InboxVC alloc]init];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        vc.title = @"星标邮件";
        [self.navigationController pushViewController:vc animated:YES];
        vc.emailBoxStyle = 1;
    }else if (indexPath.row == 2){
        InboxVC *vc = [[InboxVC alloc]init];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        vc.title = @"已发送";
        [self.navigationController pushViewController:vc animated:YES];
        vc.emailBoxStyle = 2;
    }else if (indexPath.row == 3){
        InboxVC *vc = [[InboxVC alloc]init];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        vc.title = @"草稿箱";
        [self.navigationController pushViewController:vc animated:YES];
        vc.emailBoxStyle = 3;
    }else if (indexPath.row == 4){
        InboxVC *vc = [[InboxVC alloc]init];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        vc.title = @"垃圾箱";
        [self.navigationController pushViewController:vc animated:YES];
        vc.emailBoxStyle = 4;
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
