//
//  FinancialAffairsVC.m
//  XiaoYing
//
//  Created by ZWL on 16/3/7.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FinancialAffairsVC.h"
#import "FinancialCell.h"
#import "FinancialHeadView.h"
#import "KeepAccountVC.h"
@interface FinancialAffairsVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *headView;//财务的头
    UILabel *dateLab;//日期
    UILabel *ProfitDeficitLab;//收支差
    UILabel *profitLab;//收入
    UILabel *deficitLab;//支出
    UITableView *financialTable;//tableview
    NSMutableArray *financialArr;//数据数组
}
@end

@implementation FinancialAffairsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"财务";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"记账" style:UIBarButtonItemStylePlain target:self action:@selector(keepaccountway)];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self initUI];
}
- (void)keepaccountway{
    KeepAccountVC *keepVC = [[KeepAccountVC alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:keepVC animated:YES];
}
- (void)initUI{
    
    //今天日期
    dateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, 16)];
    dateLab.text = @"2016年02月22日";
    dateLab.textColor =[UIColor whiteColor];
    dateLab.textAlignment = NSTextAlignmentCenter;
    dateLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:dateLab];
    
    
    ProfitDeficitLab = [[UILabel alloc] initWithFrame:CGRectMake((kScreen_Width-200)/2, 10+16+8, 200, 50)];
    ProfitDeficitLab.text = @"-5358";
    ProfitDeficitLab.textColor =[UIColor colorWithHexString:@"#fa2e2d"];
    ProfitDeficitLab.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    ProfitDeficitLab.textAlignment = NSTextAlignmentCenter;
    ProfitDeficitLab.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:ProfitDeficitLab];
    
    profitLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10+16+8+50+17.5, kScreen_Width/2-23, 12)];
    profitLab.text = @"收入:+3285";
    profitLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    profitLab.font = [UIFont systemFontOfSize:12];
    profitLab.textAlignment = NSTextAlignmentRight;
   
    [self.view addSubview:profitLab];
    
    
    deficitLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2+23, 10+16+8+50+17.5, kScreen_Width/2-23, 12)];
    deficitLab.text = @"支出:-8643";
    deficitLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    deficitLab.font = [UIFont systemFontOfSize:12];
    deficitLab.textAlignment = NSTextAlignmentLeft;
   
    [self.view addSubview:deficitLab];
    
    financialTable = [[UITableView alloc] initWithFrame:CGRectMake(0,20+16+8+50+15+12+20, kScreen_Width, kScreen_Height-64-(20+16+8+50+15+12+20)) style:UITableViewStylePlain];
    financialTable.delegate = self;
    financialTable.dataSource = self;
    [self.view addSubview:financialTable];
    
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FinancialHeadView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headView"];
    
    if (view == nil) {
        
        view = [[FinancialHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];

    }
    
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FinancialCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[FinancialCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
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
