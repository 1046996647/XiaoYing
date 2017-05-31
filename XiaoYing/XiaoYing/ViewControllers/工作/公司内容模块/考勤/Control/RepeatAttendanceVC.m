//
//  RepeatAttendanceVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/29.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "RepeatAttendanceVC.h"
@interface RepeatAttendanceVC ()
{
    NSMutableArray *weekArr;
}
@property (nonatomic,strong) UITableView *table1;


@end

@implementation RepeatAttendanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(certainWay)];
    weekArr = [[NSMutableArray alloc] init];
    [weekArr addObject:@"星期一"];
    [weekArr addObject:@"星期二"];
    [weekArr addObject:@"星期三"];
    [weekArr addObject:@"星期四"];
    [weekArr addObject:@"星期五"];
    [weekArr addObject:@"星期六"];
    [weekArr addObject:@"星期日"];
    
    [self initUI];
}
- (void)initUI{
    self.table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    self.table1.delegate = self;
    self.table1.dataSource = self;
    self.table1.backgroundColor = [UIColor clearColor];
    self.table1.allowsMultipleSelection = YES;
    [self.view addSubview:self.table1];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType =UITableViewCellAccessoryCheckmark;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType =UITableViewCellAccessoryNone;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.textLabel.text = weekArr[indexPath.row];
    
    return cell;
}
- (void)certainWay{
    NSLog(@"完成");
       
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
