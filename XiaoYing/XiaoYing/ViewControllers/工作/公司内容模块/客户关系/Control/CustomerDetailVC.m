//
//  CustomerDetailVC.m
//  XiaoYing
//
//  Created by ZWL on 16/2/1.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "CustomerDetailVC.h"

@interface CustomerDetailVC ()
{
    
}
@property (nonatomic,strong) UILabel *nameLab;//姓名
@property (nonatomic,strong) UILabel *timeLab;//时间
@property (nonatomic,strong) UITableView *table1;//列表
@end

@implementation CustomerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
//初始化UI控件
- (void)initUI{
    self.table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64)];
    self.table1.delegate = self;
    self.table1.dataSource = self;
    self.table1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.table1];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if (indexPath.row == 0) {
            UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 30, kScreen_Width-24, 25)];
            lab1.text = @"钱老板";
            lab1.textColor = [UIColor colorWithHexString:@"#f99740"];
            lab1.font = [UIFont systemFontOfSize:25];
            [cell.contentView addSubview:lab1];
        }else if (indexPath.row == 1){
            UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 32, 44)];
            lab1.textColor = [UIColor colorWithHexString:@"#848484"];
            lab1.text = @"时间";
            lab1.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:lab1];
            
            UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(12+32+13, 0, kScreen_Width-(12+32+13), 44)];
            lab2.text = @"2016-01-28（今天）";
            lab2.textColor = [UIColor colorWithHexString:@"#333333"];
            lab2.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:lab2];
        }else if (indexPath.row == 2){
            UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 32, 44)];
            lab1.textColor = [UIColor colorWithHexString:@"#848484"];
            lab1.text = @"提醒";
            lab1.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:lab1];
            
            UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-12-12-10-100, 0, 100, 44)];
            lab2.textColor = [UIColor colorWithHexString:@"#cccccc"];
            lab2.text = @"一天前";
            lab2.textAlignment = NSTextAlignmentRight;
            lab2.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:lab2];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 66;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 150;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    
    view.tintColor = [UIColor redColor];
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
