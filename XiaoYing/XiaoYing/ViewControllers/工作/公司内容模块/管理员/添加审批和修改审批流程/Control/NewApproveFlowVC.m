//
//  NewApproveFlowVC.m
//  XiaoYing
//
//  Created by ZWL on 16/4/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "NewApproveFlowVC.h"
#import "FlowCell.h"
#import "FlowHeaderView.h"
#import "FlowFooterView.h"
//#import "FlowFooterView1.h"
#import "NewCreateFormworkVC.h"
#import "UniversalKnowRemindVC.h"

#define MaxValue 2147483647

@interface NewApproveFlowVC ()<UITableViewDataSource,UITableViewDelegate,FlowCellDelegate>
{
    BOOL _keyboardIsVisible;
    CGFloat _initialTVHeight;
    NSInteger _tag;
    
    NSInteger _maxRank;// 最大职级
    NSInteger _maxLevel;// 最大层级
    
    MBProgressHUD *hud;
    
    NSInteger _tagType;
    NSMutableArray *_arrM;

}

@property (nonatomic,strong) UITableView *approveTable;
//@property (nonatomic,assign) NSInteger count;   // 单元格个数
@property (nonatomic,strong) FlowFooterView *footerView;
//@property (nonatomic,strong) FlowFooterView1 *footerView1;
@property (nonatomic,strong) FlowHeaderView *headerView;

@property (nonatomic,strong) NSMutableArray *moneyArr;
@property (nonatomic,strong) NSMutableArray *dayArr;
@property (nonatomic,strong) NSMutableArray *noneArr;

@property (nonatomic,strong) NSMutableArray *selectedDepArr;
@property (nonatomic,strong) NSMutableArray *selectedPeopleArr;
@property (nonatomic,strong)NSMutableArray *ContentTemp;


@property (nonatomic,copy) NSString *CompanyId;
@property (nonatomic,strong) UIButton *saveCreate;
@property (nonatomic,strong) UITextField *tf;


@end

@implementation NewApproveFlowVC

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    [self initData];
    
    [self initUI];
    
    // 键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // 范文数组
    _ContentTemp = [NSMutableArray array];

    //获取公司所有职级
    [self getRanks];
}

- (void)initData
{
    // 所有部门
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    // 得到最大层级
    _maxLevel = 0;
    for (NSDictionary *dic in arr) {
        if ([dic[@"NodeLevel"] integerValue] > _maxLevel) {
            _maxLevel = [dic[@"NodeLevel"] integerValue];
        }
    }
    
    NSMutableArray *arrM2 = [NSMutableArray array];
    
    for (int i = 0; i < 1; i++) {
        TypeFlowModel *model = [[TypeFlowModel alloc] init];
        model.Used = YES;
        model.maxPower = MaxValue;
        model.unLimit = 1;
        [arrM2 addObject:model];
    }
    _dayArr = arrM2;
    
    NSMutableArray *arrM3 = [NSMutableArray array];
    
    for (int i = 0; i < 1; i++) {
        TypeFlowModel *model = [[TypeFlowModel alloc] init];
        model.Used = YES;
        [arrM3 addObject:model];
    }
    _noneArr = arrM3;

    
}

//获取公司所有职级
- (void)getRanks
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
    [AFNetClient GET_Path:GetRanksList completed:^(NSData *stringData, id JSONDict) {
        
        [hud hide:YES];

        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
            NSArray *arr = JSONDict[@"Data"];
            
            NSMutableArray *arrM1 = [NSMutableArray array];
            
            for (NSDictionary *dic in arr) {
                TypeFlowModel *model = [[TypeFlowModel alloc] initWithContentsOfDic:dic];
                model.level = model.Rank.integerValue;
                [arrM1 addObject:model];
                
                if (model.Rank.integerValue == 1) {
                    model.maxPower = MaxValue;
                    model.unLimit = 1;
                    model.Used = YES;
                }
            }
            
            arrM1 = [[arrM1 reverseObjectEnumerator] allObjects].mutableCopy;
            
            _moneyArr = arrM1;
            
            [_approveTable reloadData];
            
        }
        
    } failed:^(NSError *error) {
        [hud hide:YES];
        [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
        
    }];
}

- (void)initUI
{
    // 头视图
    FlowHeaderView *headerView = [[FlowHeaderView alloc] initWithFrame:CGRectZero];
//    headerView.selectedDepArr = self.selectedDepArr;
    headerView.tfBlock = ^(UITextField *tf) {
        _tf = tf;
    };
    headerView.clickBlock = ^(NSInteger tag) {
        _tag = tag;
        
        if (_tag == 1) {
            
            [self footerChange:_dayArr];
            
        }
        if (_tag == 2) {
            
            [self footerChange:_noneArr];
            
        }
        [_approveTable reloadData];
    };
    self.headerView = headerView;

    
    // 组的尾视图1
    FlowFooterView *footerView = [[FlowFooterView alloc] initWithFrame:CGRectZero];
    [footerView.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.footerView = footerView;


    // 表视图
    self.approveTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:UITableViewStylePlain];
//    self.approveTable.tableHeaderView = headerView;
//    self.approveTable.tableFooterView = footerView;
    self.approveTable.delegate = self;
    self.approveTable.dataSource = self;
    self.approveTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.approveTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.approveTable];
    
    //导航栏的保存按钮
    [self initRightBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//导航栏的保存按钮
- (void)initRightBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
//    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.saveCreate = btn;
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightBar];
}

- (void)rightBtnAction
{
    [self.view endEditing:YES];
    
    UniversalKnowRemindVC *universalKnowRemindVC = [[UniversalKnowRemindVC alloc] init];
    universalKnowRemindVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    universalKnowRemindVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    self.definesPresentationContext = YES; //不盖住整个屏幕
    universalKnowRemindVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    
    NSString *textStr = nil;
    if (self.headerView.tf.text.length == 0) {
        textStr = @"种类名未添加，不能保存!";
        universalKnowRemindVC.textStr = textStr;
        [self presentViewController:universalKnowRemindVC animated:YES completion:nil];
        return;
    }
    
    if (self.headerView.selectedDepArr.count == 0) {
        textStr = @"允许申请的单元未添加，不能保存!";
        universalKnowRemindVC.textStr = textStr;
        [self presentViewController:universalKnowRemindVC animated:YES completion:nil];
        return;
    }
    
    if (_tag == 0) {
        _arrM = _moneyArr;
        _tagType = 1;

    } else if (_tag == 1)
    {
        _arrM = _dayArr;
        _tagType = 2;

    } else {
        _arrM = _noneArr;
        _tagType = 0;

    }
    for (TypeFlowModel *model in _arrM) {
        
        NSLog(@"%ld",(long)model.maxPower);
        NSInteger index = [_arrM indexOfObject:model];
        
        if (index < _arrM.count-1) {
            TypeFlowModel *nextModel = [_arrM objectAtIndex:index+1];
            if (model.maxPower == 0 && nextModel.maxPower == 0) {
                
            } else {
                if (model.maxPower >= nextModel.maxPower) {
                    textStr = @"下级领导审批权限应小于上级领导!";
                    universalKnowRemindVC.textStr = textStr;
                    [self presentViewController:universalKnowRemindVC animated:YES completion:nil];
                    return;
                }
            }

        }
        
    }
    
    if (self.footerView.selectedEmpArr.count == 0) {
        textStr = @"执行人未添加，不能保存!";
        universalKnowRemindVC.textStr = textStr;
        [self presentViewController:universalKnowRemindVC animated:YES completion:nil];
        return;
    }
    
    NewCreateFormworkVC *newCreateFormworkVC = [[NewCreateFormworkVC alloc] init];
    newCreateFormworkVC.title = @"范文";
    newCreateFormworkVC.CategoryID = _categoryID;
    newCreateFormworkVC.selectedDepArr = _headerView.selectedDepArr;
    newCreateFormworkVC.selectedEmpArr = _footerView.selectedEmpArr;
    newCreateFormworkVC.TypeName = _headerView.tf.text;
    newCreateFormworkVC.ContentTemp = _ContentTemp;
    if (_tag == 0) {// 钱
        newCreateFormworkVC.TagType = 1;
        newCreateFormworkVC.flowsArr = _moneyArr;
        
    } else if (_tag == 1)// 天
    {
        newCreateFormworkVC.TagType = 2;
        newCreateFormworkVC.flowsArr = _dayArr;
    } else {// 无
        newCreateFormworkVC.TagType = 0;
        newCreateFormworkVC.flowsArr = _noneArr;
    }
    [self.navigationController pushViewController:newCreateFormworkVC animated:YES];
    newCreateFormworkVC.refreshBlock = self.refreshBlock;
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        if (_tag == 0) {// 金钱
            
            return _moneyArr.count;
            
        }
        else if (_tag == 1) {// 天数
            return _dayArr.count;
            
        }
        else {// 无
            return _noneArr.count;
            
        }
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section == 0) {
        NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];//以indexPath来唯一确定cell
        
        FlowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSInteger row = indexPath.row;
        
        if (cell == nil) {
            
            cell = [[FlowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.delegate = self;
            cell.tfBlock = ^(UITextField *tf) {
                _tf = tf;
            };
        }
        
        TypeFlowModel *model = nil;
        cell.row = row;
        cell.tf.tag = row;
        
        if (_tag == 0) {
            
            model = _moneyArr[row];
            model.level = model.Rank.integerValue;
            cell.tag = _tag;
            cell.lineView.frame = CGRectMake(21, 0, 2, 70+12);
            cell.baseView.height = 70;
            cell.circleView1.hidden = NO;
            cell.circleView.hidden = YES;
            cell.lab.text = [NSString stringWithFormat:@"%ld级单元领导",(long)model.level];
            if (model.maxPower > 0 && model.maxPower < MaxValue) {
                cell.tf.text = [NSString stringWithFormat:@"<=%ld元",(long)model.maxPower];

            }
            else {
                cell.tf.text = @"";
                
            }
            
            if (model.level == 1) {
                cell.tf.placeholder = @"无上限";
            }
            else {
                cell.tf.placeholder = @"无权";
            }
            
        }
        
        if (_tag == 1) {
            
            model = _dayArr[row];
            
            row = row+1;
            model.level = row;
            cell.tag = _tag;
            cell.lineView.frame = CGRectMake(21, 0, 2, 70+12);
            cell.baseView.height = 70;
            cell.circleView.hidden = NO;
            cell.circleView1.hidden = YES;
            cell.lab.text = [NSString stringWithFormat:@"%ld级领导",(long)row];
            if (model.maxPower > 0 && model.maxPower < MaxValue) {
                cell.tf.text = [NSString stringWithFormat:@"<=%ld天",(long)model.maxPower];
            }
            else {
                cell.tf.text = @"";
                
            }
            
            if (model.maxPower == MaxValue) {
                cell.tf.placeholder = @"无上限";
            }
            else {
                cell.tf.placeholder = @"无权";
            }
            
            if (_dayArr.count > 1) {
                if (row == _dayArr.count) {
                    cell.circleView.selected = YES;
                    cell.circleView.userInteractionEnabled = YES;
                }
                else {
                    cell.circleView.selected = NO;
                    cell.circleView.userInteractionEnabled = NO;
                }
            }
        }
        
        if (_tag == 2) {
            
            model = _noneArr[row];
            row = row+1;
            model.level = row;
            cell.lineView.frame = CGRectMake(21, 0, 2, 35+12);
            cell.baseView.height = 35;
            cell.circleView.hidden = NO;
            cell.circleView1.hidden = YES;
            cell.lab.text = [NSString stringWithFormat:@"%ld级领导",(long)row];
            
            
            if (_noneArr.count > 1) {
                if (row == _noneArr.count) {
                    cell.circleView.selected = YES;
                    cell.circleView.userInteractionEnabled = YES;
                }
                else {
                    cell.circleView.selected = NO;
                    cell.circleView.userInteractionEnabled = NO;
                }
            }
            
        }
        cell.model = model;
        
        return cell;
    }
    else {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tag == 2) {
        return 35+12;
        
    }
    else {
        return 70+12;
        
    }
}

// 组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        self.headerView.section = section;
        self.headerView.tableView = tableView;
        return self.headerView;
        
    }
    else {
        
        if (_tag == 0) {
            self.footerView.btn.hidden = YES;
            self.footerView.circleView1.hidden = YES;
            self.footerView.rectView1.hidden = YES;
        }
        else {
            self.footerView.btn.hidden = NO;
            self.footerView.circleView1.hidden = NO;
            self.footerView.rectView1.hidden = NO;
        }
        self.footerView.section = section;
        self.footerView.tableView = tableView;
        return self.footerView;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.headerView.height;
        
    }
    else {
        return self.footerView.height;
        
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

// 增加单元格
- (void)btnAction:(UIButton *)btn
{
    
    NSInteger count = 0;
    if (_tag == 1) {
        
        TypeFlowModel *model = [[TypeFlowModel alloc] init];
        model.Used = YES;
        [_dayArr addObject:model];
        count = _dayArr.count;
        
        if (count > 1) {
            for (TypeFlowModel *model in _dayArr) {
                
                if (model.maxPower > 0 && model.maxPower < MaxValue) {
                    
                }
                else {
                    model.maxPower = 0;
                    model.unLimit = 0;
                }

            }
            TypeFlowModel *model = _dayArr.lastObject;
            model.maxPower = MaxValue;
            model.unLimit = 1;
        }
        [self footerChange:_dayArr];

    }
    if (_tag == 2) {
        
        TypeFlowModel *model = [[TypeFlowModel alloc] init];
        model.Used = YES;
        [_noneArr addObject:model];
        count = _noneArr.count;
        if (count == _maxLevel) {
//            model.maxPower = MaxValue;
            model.unLimit = 1;
        }
        
        [self footerChange:_noneArr];

    }
    [self.approveTable reloadData];
    
    if (count >= 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count-1 inSection:0];
        [self.approveTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

// 尾视图状态变化
- (void)footerChange:(NSArray *)arr
{
    [self.view endEditing:YES];
    if (arr.count < _maxLevel) {
        
        self.footerView.circleView1.selected = NO;
        self.footerView.circleView1.userInteractionEnabled = YES;
        self.footerView.btn.backgroundColor = [UIColor colorWithHexString:@"#7c94a5"];
        [self.footerView.btn setTitle:@"添加上一级领导" forState:UIControlStateNormal];
        self.footerView.btn.userInteractionEnabled = YES;
        
        
    }
    else {
        self.footerView.circleView1.selected = YES;
        self.footerView.circleView1.userInteractionEnabled = NO;
        self.footerView.btn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        [self.footerView.btn setTitle:@"已添加完公司所有层级" forState:UIControlStateNormal];
        
        self.footerView.btn.userInteractionEnabled = NO;
    }
}

#pragma mark - FlowCellDelegate
// 减少单元格
- (void)cutCell
{
    NSInteger count = 0;
    if (_tag == 1) {
        
        TypeFlowModel *model = [_dayArr lastObject];
        [_dayArr removeObject:model];
        count = _dayArr.count;
        
        if (count > 0) {
            for (TypeFlowModel *model in _dayArr) {
                
                if (model.maxPower > 0 && model.maxPower < MaxValue) {
                    
                }
                else {
                    model.maxPower = 0;
                    model.unLimit = 0;
                }
                
            }
            
            TypeFlowModel *model = _dayArr.lastObject;
            if (model.maxPower > 0 && model.maxPower < MaxValue) {
                
            }
            else {
                model.maxPower = MaxValue;
                model.unLimit = 1;
            }

        }
        
        [self footerChange:_dayArr];

    }
    if (_tag == 2) {
        TypeFlowModel *model = [_noneArr lastObject];
        [_noneArr removeObject:model];
        count = _noneArr.count;
        [self footerChange:_noneArr];

    }
    [self.approveTable reloadData];
    
    if (count >= 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count-1 inSection:0];
        [self.approveTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}



#pragma mark - keyboard
- (void)keyboardWillHide:(NSNotification *)noti {
    
    //恢复到默认y为0的状态，有时候要考虑导航栏要+64
    CGRect frame = self.view.frame;
    frame.origin.y = 0+64;
    self.view.frame = frame;
    
}

- (void)keyboardWillShow:(NSNotification *)noti {
    
//    NSLog(@"%f",_approveTable.contentOffset.y);
    if (_tf.tag == 1000) {
        return;
    }
    
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.origin.y - 64;
    CGFloat textField_maxY = (_tf.tag + 1) * (70+12);
    CGFloat space = - _approveTable.contentOffset.y + textField_maxY + self.headerView.height;
    CGFloat transformY = height - space;
    if (transformY < 0) {
        CGRect frame = self.view.frame;
        frame.origin.y = transformY;
        self.view.frame = frame;
    }
}


@end
