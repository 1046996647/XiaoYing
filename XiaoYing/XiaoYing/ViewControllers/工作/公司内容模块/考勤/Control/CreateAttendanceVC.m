//
//  CreateAttendanceVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "CreateAttendanceVC.h"
#import "createAttendanceCell.h"
#import "AttendanceBFVC.h"
#import "RepeatAttendanceVC.h"
#import "SetMapPositionVC.h"
@interface CreateAttendanceVC ()

@property (nonatomic,strong) UITableView *createTable;
@property (nonatomic,assign) NSInteger count;

@end

@implementation CreateAttendanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishway)];
    
    _count = 3;
    [self initUI];
}
//完成
- (void)finishway{
    NSLog(@"完成");
}
//初始化UI控件
- (void)initUI{
    self.createTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-20)];
    self.createTable.delegate = self;
    self.createTable.dataSource = self;
    [self.view addSubview:self.createTable];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        AttendanceBFVC *VC1 = [[AttendanceBFVC alloc] init];
        VC1.title =@"选择考勤对象";
        VC1.sssStr = @"1";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:VC1 animated:YES];
        
    }else if(indexPath.section == 0&& indexPath.row == 2){
        RepeatAttendanceVC *repeatVC = [[RepeatAttendanceVC alloc] init];
        repeatVC.title = @"重复";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:repeatVC animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44+15)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *addbt = [UIButton buttonWithType:UIButtonTypeCustom];
    addbt.frame = CGRectMake(12, 15, kScreen_Width-24, 44);
    [addbt setImage:[UIImage imageNamed:@"add_50"] forState:UIControlStateNormal];
    addbt.layer.cornerRadius = 5;
    addbt.clipsToBounds = YES;
    addbt.layer.borderColor = [[UIColor colorWithHexString:@"#d5d7dc"]CGColor];
    addbt.layer.borderWidth = 0.5;
    [addbt addTarget:self action:@selector(addSignWay) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:addbt];
    return view;
    
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor whiteColor];
}
- (void)addSignWay{
    _count ++;
    
    [self.createTable reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44.0+15.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==0 ||indexPath.row ==1 ||indexPath.row ==2 ) {
        return 44.0;
    }else{
        return (44.0*3)+12+12+8;
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    createAttendanceCell *cell = nil;
   
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    }else if (indexPath.section == 0 && indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    }else if (indexPath.section == 0 && indexPath.row == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
    }

    if (cell == nil) {
        if (indexPath.section == 0 && indexPath.row == 0) {
             cell = [[createAttendanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }else if (indexPath.section == 0 && indexPath.row == 1){
             cell = [[createAttendanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }else if (indexPath.section == 0 && indexPath.row == 2){
             cell = [[createAttendanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        }else {
            cell = [[createAttendanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
        }
       
    }
    //点击设置签到地点
    cell.hitSignLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setSignLSite)];
    [cell.hitSignLab addGestureRecognizer:tap];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//设置签到点
- (void)setSignLSite{
    SetMapPositionVC  *vc = [[SetMapPositionVC alloc] init];
    vc.title = @"设置签到点";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];

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
