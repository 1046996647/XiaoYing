//
//  AddFriendDetailVC.m
//  XiaoYing
//
//  Created by MengFanBiao on 16/1/4.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "AddFriendDetailVC.h"

@interface AddFriendDetailVC ()

@property (nonatomic,strong) UITableView *DetailTab;
@property (nonatomic,copy) NSMutableArray *arr;

@end

@implementation AddFriendDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.title = @"详细资料";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self initUI];
}
-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void) initUI{
    _DetailTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-200)];
    _DetailTab.delegate = self;
    _DetailTab.dataSource = self;
    _DetailTab.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    _DetailTab.scrollEnabled = NO;
    [self.view addSubview:_DetailTab];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }else if (indexPath.section == 1 ){
        return 44;
    }else if (indexPath.section == 2 && indexPath.row == 0){
        return 44;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        return 100;
    }else if (indexPath.section == 2 && indexPath.row == 2){
        return 44;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 60, 60)];
        imageview.image = [UIImage imageNamed:@"1.1"];
        [cell.contentView addSubview:imageview];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(84, 16, 40, 20)];
        lab.text = @"姓名";
        lab.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:lab];
        
        UIImageView *imasex = [[UIImageView alloc] initWithFrame:CGRectMake(124, 16, 20, 20)];
        imasex.image = [UIImage imageNamed:@"man"];
        [cell.contentView addSubview:imasex];
        
        UILabel *labNum = [[UILabel alloc] initWithFrame:CGRectMake(124, 40, 100, 20)];
        labNum.text = @"小赢号:XX1234567";
        labNum.textColor = [UIColor colorWithHexString:@"#848484"];
        labNum.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:labNum];
        
        
    }else if (indexPath.section == 1 ){
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(12,0,kScreen_Width-100,44)];
        lab1.text = @"设置备注和标签";
        [cell.contentView addSubview:lab1];
        
    }else if (indexPath.section == 2 && indexPath.row == 0){
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(12,0,kScreen_Width-100,44)];
        lab1.text = @"地区         浙江   杭州";
        [cell.contentView addSubview:lab1];
        
    }else if (indexPath.section == 2 && indexPath.row == 1){
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, 100)];
        lab2.text = @"个人相册";
        [cell.contentView addSubview:lab2];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(112, 20, 60, 60)];
        imageview.image = [UIImage imageNamed:@"1.1"];
        [cell.contentView addSubview:imageview];
    }else if (indexPath.section == 2 && indexPath.row == 2){
        UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, 44)];
        lab3.text = @"更多";
        [cell.contentView addSubview:lab3];

    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section ==2){
        return 3;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 3;
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
