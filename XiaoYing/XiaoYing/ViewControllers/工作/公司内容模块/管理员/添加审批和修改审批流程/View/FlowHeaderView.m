//
//  FlowHeaderView.m
//  XiaoYing
//
//  Created by ZWL on 16/4/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FlowHeaderView.h"
#import "MulSelectDepartmentVC.h"

@implementation FlowHeaderView

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
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 12, kScreen_Width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:baseView];
    self.baseView = baseView;
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, kScreen_Width-12, 44)];
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.placeholder = @"请输入审批种类名";
    tf.delegate = self;
    tf.tag = 1000;
    [baseView addSubview:tf];
    self.tf = tf;
    
    UIButton *allowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allowBtn.backgroundColor = [UIColor whiteColor];
    allowBtn.frame = CGRectMake(0, baseView.bottom+12, kScreen_Width, 44);
    [allowBtn addTarget:self action:@selector(allowAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:allowBtn];
    
    NSString *content = @"允许申请的部门";
    CGSize size =[content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    UILabel *allowLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, size.width, allowBtn.height)];
    allowLab.text = @"允许申请的部门";
//    allowLab.backgroundColor = [UIColor cyanColor];
    allowLab.textColor = [UIColor colorWithHexString:@"#333333"];
    allowLab.font = [UIFont systemFontOfSize:16];
    [allowBtn addSubview:allowLab];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width-10-12, (44-18)/2.0, 10, 18)];
    imgView.image = [UIImage imageNamed:@"arrow_set"];
//    imgView.backgroundColor = [UIColor blueColor];

    [allowBtn addSubview:imgView];
    
    UILabel *depLab = [[UILabel alloc] initWithFrame:CGRectMake(allowLab.right+12, 0, kScreen_Width-(allowLab.right+12)-30, allowBtn.height)];
    depLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    depLab.textAlignment = NSTextAlignmentRight;
//    depLab.backgroundColor = [UIColor redColor];
//    depLab.text = @"类型 : 日常行政";
    depLab.textColor = [UIColor colorWithHexString:@"#333333"];
    depLab.font = [UIFont systemFontOfSize:14];
    [allowBtn addSubview:depLab];
    self.depLab = depLab;
    
//    NSLog(@"%f",allowLab.right);
    /////////////////////////////
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, allowBtn.bottom, kScreen_Width, 44)];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    self.bgView = bgView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(21, 0, 2, bgView.height+25
                                                                )];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [bgView addSubview:lineView];
    
    UIView *rectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18+3*2)];
    rectView.center = lineView.center;
    rectView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [bgView addSubview:rectView];

    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    circleView.layer.cornerRadius = 18/2.0;
    circleView.clipsToBounds = YES;
    circleView.center = lineView.center;
    circleView.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [bgView addSubview:circleView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(circleView.right+10, 0, 100, bgView.height)];
    lab.text = @"审批开始";
    lab.textColor = [UIColor colorWithHexString:@"848484"];
    lab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:lab];
    
    NSArray *titleArr = @[@"金钱",@"天数",@"无"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kScreen_Width-(50*3+16*3)+i*(50+16), (bgView.height-30)/2.0, 50, 30);
        btn.tag = i+100;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        btn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        
        if (i == 0) {
            btn.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
            _lastBtn = btn;
        }
    }
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(lab.left, lab.bottom, bgView.width-lab.left-12, 25)];
    lab1.text = @"赋予每一级领导人的审批权限，审批的流程按照直属领导的路线递交。";
    lab1.numberOfLines = 2;
    lab1.backgroundColor = [UIColor clearColor];
    lab1.textColor = [UIColor colorWithHexString:@"#848484"];
    lab1.font = [UIFont systemFontOfSize:10];
    [bgView addSubview:lab1];
    self.lab1 = lab1;
    
    bgView.height = lab1.bottom;
    
    // 该头视图的位置大小
    self.frame = CGRectMake(0, 0, kScreen_Width, bgView.bottom);

}

- (void)btnAction:(UIButton *)btn
{
    NSInteger tag = btn.tag - 100;
    
    if (_clickBlock) {
        _clickBlock(tag);
    }

    _lastBtn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    btn.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    _lastBtn = btn;
    
    if (tag == 0) {
        self.lab1.text = @"赋予每一级领导人的审批权限，审批的流程按照直属领导的路线递交。";

    } else if (tag == 1) {
        self.lab1.text = @"可添加多级上级领导，赋予每一级领导人的审批权限，审批的流程按照直属领导的路线递交。";

    } else {
        self.lab1.text = @"可添加多级上级领导，审批的流程按照直属领导的路线递交。";

    }
}

- (void)allowAction
{
    [self.viewController.view endEditing:YES];
    
    MulSelectDepartmentVC *mulSelectDepartmentVC = [[MulSelectDepartmentVC alloc] init];
//    mulSelectDepartmentVC.CompanyName = self.CompanyName;
//    mulSelectDepartmentVC.CompanyRanks = self.CompanyRanks;
//    mulSelectDepartmentVC.departments = self.departments;
    mulSelectDepartmentVC.selectedArr = self.selectedDepArr.mutableCopy;
    mulSelectDepartmentVC.title = @"允许申请的部门";
    [self.viewController.navigationController pushViewController:mulSelectDepartmentVC animated:YES];
    mulSelectDepartmentVC.sendBlock = ^(NSMutableArray *arrM) {
        
        self.selectedDepArr = arrM;

    };
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.tag == 100) {

        return NO;
    }
    else {
        
        if (self.tfBlock) {
            self.tfBlock(textField);
        }
        return YES;

    }

}

- (void)setSelectedDepArr:(NSMutableArray *)selectedDepArr
{
    _selectedDepArr = selectedDepArr.mutableCopy;
    self.departments = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    
    NSMutableString *strM = [NSMutableString string];
    
    for (NSString *departmentId in self.selectedDepArr) {
        
        if ([departmentId isEqualToString:@""]) {// 公司
            NSString *str = [NSString stringWithFormat:@"%@、",[UserInfo getcompanyName]];
            [strM appendString:str];
        }
        else {// 部门
            for (NSDictionary *dic in self.departments) {
                
                if ([departmentId isEqualToString:dic[@"DepartmentId"]]) {
                    
                    NSString *str = [NSString stringWithFormat:@"%@、",dic[@"Title"]];
                    [strM appendString:str];
                }
            }
        }

    }
    
    if (strM.length > 0) {
        [strM deleteCharactersInRange:NSMakeRange(strM.length-1, 1)];
        strM = [NSString stringWithFormat:@"%@(%ld)",strM,(unsigned long)selectedDepArr.count].mutableCopy;
        self.depLab.text = strM;
    }

}

- (void)setFrame:(CGRect)frame{
//    NSLog(@"_______ frame = %@",NSStringFromCGRect(frame));
    
    CGRect sectionRect = [self.tableView rectForSection:self.section];
    CGRect newFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(sectionRect), CGRectGetWidth(frame), CGRectGetHeight(frame)); [super setFrame:newFrame];
}


@end
