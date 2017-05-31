//
//  FlowFooterView.m
//  XiaoYing
//
//  Created by ZWL on 16/4/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FlowFooterView.h"
#import "MulSelectPeopleVC.h"

@implementation FlowFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 60)];
    baseView.backgroundColor = [UIColor clearColor];
    [self addSubview:baseView];
    self.baseView = baseView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(21, 0, 2, baseView.height)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [baseView addSubview:lineView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(lineView.right+20, 0, 160, 30);
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    [btn setTitle:@"添加上一级领导" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:@"#7c94a5"];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [baseView addSubview:btn];
    self.btn = btn;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(btn.left, baseView.height-14-5, 100, 14)];
    lab.text = @"审批结束";
    lab.textColor = [UIColor colorWithHexString:@"848484"];
    lab.font = [UIFont systemFontOfSize:14];
    [baseView addSubview:lab];
    
    UIView *rectView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18+3*2)];
    rectView1.center = CGPointMake(lineView.center.x, btn.center.y);
    rectView1.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [baseView addSubview:rectView1];
    self.rectView1 = rectView1;
    
    // 添加按钮
    UIButton *circleView1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [circleView1 setImage:[UIImage imageNamed:@"add"]forState:UIControlStateNormal];
    [circleView1 setImage:[UIImage imageNamed:@"add_approval_grey"]forState:UIControlStateSelected];
    circleView1.clipsToBounds = YES;
    circleView1.center = rectView1.center;
    [baseView addSubview:circleView1];
    self.circleView1 = circleView1;
    
//    UILabel *circleView1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
//    circleView1.text = @"+";
//    circleView1.textAlignment = NSTextAlignmentCenter;
//    circleView1.textColor = [UIColor whiteColor];
//    circleView1.font = [UIFont systemFontOfSize:18];
//    circleView1.layer.cornerRadius = 18/2.0;
//    circleView1.clipsToBounds = YES;
//    circleView1.center = rectView1.center;
//    circleView1.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
//    [baseView addSubview:circleView1];
//    self.circleView1 = circleView1;
    
    UIView *rectView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18+3*2)];
    rectView2.center = CGPointMake(lineView.center.x, lab.center.y);
    rectView2.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [baseView addSubview:rectView2];
    
    UIView *circleView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    circleView2.layer.cornerRadius = 18/2.0;
    circleView2.clipsToBounds = YES;
    circleView2.center = rectView2.center;
    circleView2.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [baseView addSubview:circleView2];
    
///////////////////////////////////////////////////////
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, baseView.bottom+10, kScreen_Width, 44+10+12+10)];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    
    UIButton *excutePeopleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    excutePeopleBtn.backgroundColor = [UIColor whiteColor];
    excutePeopleBtn.frame = CGRectMake(0, 0, kScreen_Width, 44);
    [excutePeopleBtn addTarget:self action:@selector(excuteAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:excutePeopleBtn];
    
    NSString *content = @"执行人";
    CGSize size =[content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    UILabel *excutePeopleLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, size.width, excutePeopleBtn.height)];
    excutePeopleLab.text = @"执行人";
    excutePeopleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    excutePeopleLab.font = [UIFont systemFontOfSize:16];
    [excutePeopleBtn addSubview:excutePeopleLab];
    
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width-10-12, (44-18)/2.0, 10, 18)];
    imgView1.image = [UIImage imageNamed:@"arrow_set"];
    [excutePeopleBtn addSubview:imgView1];
    
    UILabel *peopleLab = [[UILabel alloc] initWithFrame:CGRectMake(excutePeopleLab.right+12, 0, kScreen_Width-(excutePeopleLab.right+12)-30, excutePeopleBtn.height)];
    peopleLab.textAlignment = NSTextAlignmentRight;
    peopleLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    //    depLab.backgroundColor = [UIColor redColor];
    peopleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    peopleLab.font = [UIFont systemFontOfSize:14];
    [excutePeopleBtn addSubview:peopleLab];
    self.peopleLab = peopleLab;
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, excutePeopleBtn.bottom+10, excutePeopleBtn.width, 12)];
    lab1.text = @"审批结束后，执行人会得到通知";
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.backgroundColor = [UIColor clearColor];
    lab1.textColor = [UIColor colorWithHexString:@"#848484"];
    lab1.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:lab1];
    
    self.frame = CGRectMake(0, 0, kScreen_Width, bgView.bottom
                            );

    
}

- (void)excuteAction
{
    MulSelectPeopleVC *mulSelectPeopleVC = [[MulSelectPeopleVC alloc] init];
//    mulSelectPeopleVC.CompanyName = self.CompanyName;
//    mulSelectPeopleVC.CompanyRanks = self.CompanyRanks;
//    mulSelectPeopleVC.departments = self.departments;
//    mulSelectPeopleVC.employees = self.employees;
    mulSelectPeopleVC.selectedDepArr = self.selectedDepArr.mutableCopy;
    
    mulSelectPeopleVC.selectedEmpArr = self.selectedEmpArr.mutableCopy;
    mulSelectPeopleVC.title = @"执行人";
    [self.viewController.navigationController pushViewController:mulSelectPeopleVC animated:YES];
    mulSelectPeopleVC.sendAllBlock = ^(NSMutableArray *depArr, NSMutableArray *empArr) {
        
        self.selectedDepArr = depArr;
        self.selectedEmpArr = empArr;
    };
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
        self.peopleLab.text = strM;
    }
    
}

// 去掉section停靠效果
- (void)setFrame:(CGRect)frame{
//    NSLog(@"_______ frame = %@",NSStringFromCGRect(frame));
    
    CGRect sectionRect = [self.tableView rectForSection:self.section];
    CGRect newFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(sectionRect), CGRectGetWidth(frame), CGRectGetHeight(frame));
    [super setFrame:newFrame];
}



@end
