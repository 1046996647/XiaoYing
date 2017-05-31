//
//  SetVC.m
//  XiaoYing
//
//  Created by ZWL on 16/2/24.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "SetVC.h"

@interface SetVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableView;
    int i;
}

@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self initView];
    
    
    i = 2;
}

-(void)initView{
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 12+44*4+12) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 12)];
        view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        return view;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44+12)];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(12, 0, kScreen_Width, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [view addSubview:lineView];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
        [button addTarget:self action:@selector(addMail) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"adduser"]];
        imageView.frame = CGRectMake(12, 14, 16, 16);
        [button addSubview:imageView];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(12+16+10, 0, 200, 44)];
        lable.text = @"添加帐户...";
        [button addSubview:lable];
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreen_Width, 12)];
        bottomView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        [view addSubview:bottomView];
        return view;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 12;
    }else{
        return 12+44;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return i;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.section == 1) {
        cell.textLabel.text = @"清除缓存";
    }else if (indexPath.section == 0){
        NSArray *mailArr = @[@"784946336@qq.com",@"15757164486@163.com"];
        NSArray *arr = @[@"主",@""];
        cell.textLabel.text = mailArr[indexPath.row];
        cell.detailTextLabel.text = arr[indexPath.row];
    }
    return cell;
}


-(void)addMail{
   [UIView animateWithDuration:0.3 animations:^{
       tableView.height = tableView.height+44;
       i++;
       [tableView beginUpdates];
       [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]withRowAnimation:UITableViewRowAnimationNone];
       [tableView endUpdates];
   }];
   
    NSLog(@"添加邮箱");
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
