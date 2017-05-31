//
//  newDelegate.m
//  XiaoYing
//
//  Created by Li_Xun on 16/5/10.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "NewDelegateViewController.h"
#import "NewDelegateTaskViewController.h"
//#import "performPeopleViewController.h"
#import "MulSelectPeopleVC.h"
#import "ZWLDatePickerView.h"
#import "BirthdayController.h"

#define PATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"list.data"]


@interface NewDelegateViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIButton *b1;
    UIButton *b2;
    NSString *companyName;
    NSArray *dataArray;
    NSMutableArray *titleArr;
}

@property (nonatomic,strong) NSMutableArray *selectedDepArr;
@property (nonatomic,strong) NSMutableArray *selectedEmpArr;
@property (nonatomic,strong) UITextField *tv;
@property (nonatomic,strong) UIButton *startTimeBtn;
@property (nonatomic,strong) UIButton *endTime;
@property (nonatomic,strong) UIButton *performPeopleName;

@property (nonatomic,assign) NSInteger index;

@end

@implementation NewDelegateViewController
@synthesize tabView,arr;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置新委派";
    arr = [NSMutableArray arrayWithObjects:@"开始时间",@"结束时间",@"执行人",@"讨论组",@"单独发送",@"任务共享", nil];
    
    [self newDelegateTableView];
    [self newDelegateRightNavigation];
    [self hiddenTableViewLine];
    
    // 标题数组
    titleArr = [NSMutableArray array];
    
    // 假数据
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:@"node" ofType:@"plist"];
    dataArray = [[NSArray alloc] initWithContentsOfFile:nodePath];

    // 归档
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:PATH]) {
        
        NSMutableArray* arrM = [NSMutableArray array];
        
        [NSKeyedArchiver archiveRootObject:arrM toFile:PATH];
    }

    
}


-(void)newDelegateTableView
{
    tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:UITableViewStylePlain];
    //    tabView.backgroundColor = [UIColor blueColor];
    tabView.scrollEnabled = NO;
    tabView.delegate = self;
    tabView.dataSource = self;
    [self.view addSubview:tabView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellid3";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    if (indexPath.row <3) {
        if (indexPath.row == 0) {
            UIButton *startTimeBtn = [[UIButton alloc]initWithFrame:CGRectMake(146*scaleX, 11*scaleY, 140*scaleX, 20*scaleY)];
            [startTimeBtn setTitle:@"" forState:UIControlStateNormal];
            startTimeBtn.userInteractionEnabled = NO;
            [startTimeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [startTimeBtn setTitleColor:[UIColor colorWithHexString:@"#848484"] forState:UIControlStateNormal];
            [cell addSubview:startTimeBtn];
            self.startTimeBtn = startTimeBtn;
            
            UIImageView *startTimeImage = [[UIImageView alloc]initWithFrame:CGRectMake(298*scaleX, 12*scaleY, 10*scaleX, 18*scaleY)];
            [startTimeImage setImage:[UIImage imageNamed:@"arrow_set"]];
            [cell addSubview:startTimeImage];
        }else if (indexPath.row == 1)
        {
            UIButton *endTime = [[UIButton alloc]initWithFrame:CGRectMake(146*scaleX, 11*scaleY, 140*scaleX, 20*scaleY)];
            endTime.userInteractionEnabled = NO;
            [endTime setTitle:@"" forState:UIControlStateNormal];
            [endTime setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [endTime setTitleColor:[UIColor colorWithHexString:@"#848484"] forState:UIControlStateNormal];
            [cell addSubview:endTime];
            self.endTime = endTime;

            
            UIImageView *endTimeImage = [[UIImageView alloc]initWithFrame:CGRectMake(298*scaleX, 12*scaleY, 10*scaleX, 18*scaleY)];
            [endTimeImage setImage:[UIImage imageNamed:@"arrow_set"]];
            [cell addSubview:endTimeImage];
        }else if (indexPath.row == 2)
        {
            UIButton *performPeopleName = [[UIButton alloc]initWithFrame:CGRectMake(116*scaleX, 11*scaleY, 170*scaleX, 20*scaleY)];
            [performPeopleName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            performPeopleName.userInteractionEnabled = NO;
            [performPeopleName setTitleColor:[UIColor colorWithHexString:@"#848484"] forState:UIControlStateNormal];
//            [performPeopleName addTarget:self action:@selector(performPeopleEvent) forControlEvents:UIControlEventTouchDown];
            [cell addSubview:performPeopleName];
            self.performPeopleName = performPeopleName;
            
            UIImageView *performPeopleNameImage = [[UIImageView alloc]initWithFrame:CGRectMake(298*scaleX, 12*scaleY, 10*scaleX, 18*scaleY)];
            [performPeopleNameImage setImage:[UIImage imageNamed:@"arrow_set"]];
            [cell addSubview:performPeopleNameImage];
        }
        
    }else
    {
        if (indexPath.row == 3) {
            UISwitch *discussionGroups = [[UISwitch alloc]initWithFrame:CGRectMake(258*scaleX, 6.5*scaleY, 50*scaleX, 10*scaleY)];
            [cell addSubview:discussionGroups];
        }else if (indexPath.row == 4)
        {
            UISwitch *separateSend = [[UISwitch alloc]initWithFrame:CGRectMake(258*scaleX, 6.5*scaleY, 50*scaleX, 15*scaleY)];
            [cell addSubview:separateSend];
        }else if (indexPath.row == 5)
        {
            UISwitch *tasksSharing = [[UISwitch alloc]initWithFrame:CGRectMake(258*scaleX, 6.5*scaleY, 50*scaleX, 15*scaleY)];
            [cell addSubview:tasksSharing];
        }
    }
    
    return cell;
}

//-(void)performPeopleEvent
//{
//    [self.navigationController pushViewController:[[SelectNewExcutePeopleVC alloc] init] animated:YES];
//}

#pragma mark - 表头函数
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerV = [UIView new];
    
    UITextField *tv = [[UITextField alloc]initWithFrame:CGRectMake(14*scaleX, 15*scaleY, 180*scaleX, 20*scaleY)];
    tv.placeholder = @"标题";
    tv.delegate = self;
//    texttitle.backgroundColor = [UIColor redColor];
    [headerV addSubview:tv];
    self.tv = tv;
    
    UIImageView *image = [[UIImageView alloc]init];
    image.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [headerV addSubview:image];
    [self adapter:image left:14 bottom:0 width:296 heigth:0.5];
    return headerV;
}

#pragma mark - 表头高度函数
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44*scaleY;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        
        [self datepickerView:indexPath.row];
        
    }
    if (indexPath.row == 2) {

        MulSelectPeopleVC *mulSelectPeopleVC = [[MulSelectPeopleVC alloc] init];
        mulSelectPeopleVC.selectedDepArr = self.selectedDepArr.mutableCopy;
        
        mulSelectPeopleVC.selectedEmpArr = self.selectedEmpArr.mutableCopy;
        mulSelectPeopleVC.title = @"执行人";
        [self.navigationController pushViewController:mulSelectPeopleVC animated:YES];
        mulSelectPeopleVC.sendAllBlock = ^(NSMutableArray *depArr, NSMutableArray *empArr) {
            
            self.selectedDepArr = depArr;
            self.selectedEmpArr = empArr;
        };
    }
}

- (void)setSelectedDepArr:(NSMutableArray *)selectedDepArr
{
    _selectedDepArr = selectedDepArr.mutableCopy;
}

- (void)setSelectedEmpArr:(NSMutableArray *)selectedEmpArr
{
    _selectedEmpArr = selectedEmpArr;
    
    // 所有员工
    NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
    NSMutableString *strM = [NSMutableString string];
    
    for (NSString *empolyeeId in self.selectedEmpArr) {
        for (NSDictionary *dic in employeesArr) {
            
            if ([empolyeeId isEqualToString:dic[@"ProfileId"]]) {
                
                NSString *str = [NSString stringWithFormat:@"%@、",dic[@"EmployeeName"]];
                [strM appendString:str];
            }
        }
    }
    if (strM.length > 0) {
        [strM deleteCharactersInRange:NSMakeRange(strM.length-1, 1)];
        strM = [NSString stringWithFormat:@"%@(%ld)",strM,(unsigned long)selectedEmpArr.count].mutableCopy;
        [self.performPeopleName setTitle:strM forState:UIControlStateNormal];

    }
    
}


- (void)datepickerView:(NSInteger)index
{
    
    self.index = index;
    
    //日期选择视图
    ZWLDatePickerView *datepickerView = [[ZWLDatePickerView alloc] initWithFrame:CGRectMake(0,kScreen_Height - 270, kScreen_Width, 270)];
    datepickerView.dataBlock = ^(NSString *dateStr){
        
        if (self.index == 0) {
            [self.startTimeBtn setTitle:dateStr forState:UIControlStateNormal];
            
        }
        else {
            [self.endTime setTitle:dateStr forState:UIControlStateNormal];
            
        }

    };
    BirthdayController *birthdayCtrl = [[BirthdayController alloc] init];
    birthdayCtrl.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //      self.definesPresentationContext = YES; //不盖住整个屏幕
    //淡出淡入
    birthdayCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    birthdayCtrl.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [birthdayCtrl.view addSubview:datepickerView];
    [self presentViewController:birthdayCtrl animated:YES completion:nil];
    if (index == 0) {
        datepickerView.dateStr = self.startTimeBtn.currentTitle;

    }
    else {
        datepickerView.dateStr = self.endTime.currentTitle;

    }

}

#pragma mark - 隐藏表格视图中没有数据的分割线
-(void)hiddenTableViewLine
{
    //隐藏表格视图中没有数据的分割线
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor clearColor];
    [tabView setTableFooterView:v];
}

#pragma mark - 定制右导航栏函数
-(void)newDelegateRightNavigation
{
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.frame = CGRectMake(0, 0, 50, 20);
    [rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(newDelegate) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma  mark - 点击右导航栏视图跳转
-(void)newDelegate
{

    if (self.tv.text.length == 0) {
        [MBProgressHUD showMessage:@"标题未输入"];
        return;
    }
    
    if (self.startTimeBtn.currentTitle.length == 0 || self.endTime.currentTitle.length == 0) {
        [MBProgressHUD showMessage:@"未选择时间"];
        return;
    }
    if (self.startTimeBtn.currentTitle.length == 0 || self.endTime.currentTitle.length == 0) {
        [MBProgressHUD showMessage:@"未选择时间"];
        return;
    }
    [self.navigationController pushViewController:[[NewDelegateTaskViewController alloc] init] animated:YES];
    
}


#pragma mark - 适配器
-(void)adapter:(id)childview left:(CGFloat)lwidth bottom:(CGFloat)theight width:(CGFloat)width heigth:(CGFloat)heigth
{
    [childview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lwidth*scaleX);
        make.bottom.mas_equalTo(theight*scaleY);
        make.size.mas_equalTo(CGSizeMake(width*scaleX, heigth*scaleY));
    }];
}


//#pragma  mark - 收起键盘
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//}

#pragma  mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.view endEditing:YES];

    return YES;
}


@end
