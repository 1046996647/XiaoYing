//
//  FrameManagerVC.m
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/23.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FrameManagerVC.h"
#import "PushView.h"
#import "MaintainCompanyInfoVC.h"
//#import "UnitcView.h"
#import "DeleteViewController.h"
#import "SelectRankVC.h"
#import "DepartmentModel.h"
#import "SelectUnitVC.h"


@interface FrameManagerVC ()<UITextFieldDelegate>
{
    MBProgressHUD *hud;
    NSNumber *_maxRank;
}

@property (nonatomic, strong)UILabel *labelLineDown;
@property (nonatomic, strong)UIButton *downButton;
@property (nonatomic, strong)UIView *unitView;
@property (nonatomic, strong)UITextField *messageTextfield;

//@property (nonatomic, strong)UnitcView *unitV; //选择单元视图

@property (nonatomic, strong) UILabel *leaderUnitLabel;
@property (nonatomic, strong) UILabel *departmentLabel;
@property (nonatomic, strong) UILabel *detailLabel;


@end

@implementation FrameManagerVC

- (void)dealloc

{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.type isEqualToString:@"隐藏删除按钮"]) {
        _labelLineDown.hidden = YES;
        _downButton.hidden = YES;
    }
    else {
        [self.view computeWordCountWithTextField:_messageTextfield warningLabel:nil maxNumber:10];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initBasic];
    
    [self initUI];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:_messageTextfield];
   
}

- (void)initBasic {
    
    if ([self.type isEqualToString:@"隐藏删除按钮"]) {
        self.title = @"添加子单元";

    }
    else {
        self.title = self.subTitle;

    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItems = @[backItem];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(setKeepActionRight)];
}


- (void)pushView {
    
    NSMutableString *subStr = _detailLabel.text.mutableCopy;
    [subStr deleteCharactersInRange:[subStr rangeOfString:@"级单元"]];
    
    PushView *pushV = [[PushView alloc] init];
    pushV.ranks = @(subStr.integerValue);
    [self.view addSubview:pushV];
}

- (void)exitAction {
    NSLog(@"退出");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setKeepActionRight {
    
    [self.view endEditing:YES];
    
    if (_messageTextfield.text.length == 0) {
        
        [MBProgressHUD showMessage:@"名称不能为空" toView:self.view];
        
        return;
    }
    
    //保存中
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"保存中...";
    
    //创建字符串
//    NSMutableString *str = [NSMutableString stringWithString:@"我喜欢IOS"];
//    
//    //删除字符串中含"雨松"的字符
//    [str deleteCharactersInRange: [str rangeOfString: @"IOS"]];
    NSMutableString *subStr = _detailLabel.text.mutableCopy;
    [subStr deleteCharactersInRange:[subStr rangeOfString:@"级单元"]];
    
    NSMutableDictionary *paramDic = nil;
    NSString *depStr = nil;
    
    // 添加部门
    if ([self.type isEqualToString:@"隐藏删除按钮"]) {
        
        paramDic = [NSMutableDictionary  dictionary];
        [paramDic  setValue:_messageTextfield.text forKey:@"title"];
        [paramDic  setValue:@([subStr integerValue]) forKey:@"ranks"];
        [paramDic  setValue:self.ParentID forKey:@"parentID"];
        depStr = AddDepartment;
    }
    
    // 编辑部门
    else {
        paramDic = [NSMutableDictionary  dictionary];
        [paramDic  setValue:_messageTextfield.text forKey:@"title"];
        
        [paramDic  setValue:@([subStr integerValue]) forKey:@"ranks"];
        [paramDic  setValue:self.ParentID forKey:@"parentID"];
        
        [paramDic  setValue:self.DepartmentId forKey:@"departmentId"];
        depStr = EditDepartment;
    }

    
    //    NSString *str = AddDepartment;
    [AFNetClient  POST_Path:depStr params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            
            [hud  hide:YES];
            
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
            // 所有部门
            [self GetDepartmentURlAction];
            
            // 刷新部门和员工信息！
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshInfoNotification object:nil];
        }
        
    } failed:^(NSError *error) {
        
        [hud  hide:YES];
        
        [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
        
    }];
    
    
}

// 所有部门
- (void)GetDepartmentURlAction {
    
    
    [AFNetClient GET_Path:GetDepartmentURl completed:^(NSData *stringData, id JSONDict) {
        //        NSLog(@"--组织架构--+++++++++++%@-------------%@", JSONDict[@"Data"], JSONDict);
        [hud  hide:YES];
        
        NSMutableArray *arrM = [JSONDict[@"Data"] mutableCopy];
        [ZWLCacheData archiveObject:arrM toFile:DepartmentsPath];

        if (_sendBlock) {
            _sendBlock(arrM);
        }

        [self.navigationController popViewControllerAnimated:YES];

        
    } failed:^(NSError *error) {
        
    }];
    
    
}

- (void)deleteUnitAction {
    NSLog(@"删除单元");

    
    DeleteViewController *deleteViewController = [[DeleteViewController alloc] init];
    //    deleteViewController.urlStr = self.sessionModel.url;
    
    deleteViewController.fileDeleteBlock = ^(void)
    {
        NSString *delStr = [NSString stringWithFormat:@"%@&departmentId=%@",DelDepartment,self.DepartmentId];
        [AFNetClient  POST_Path:delStr completed:^(NSData *stringData, id JSONDict) {
            
            NSNumber *code=[JSONDict objectForKey:@"Code"];
            
            
            if (1 == [code integerValue]) {
                
                NSString *msg = [JSONDict objectForKey:@"Message"];
                [MBProgressHUD showMessage:msg toView:self.view];
                
            } else {
                
                // 所有部门
                [self GetDepartmentURlAction];
                
            }
            
        } failed:^(NSError *error) {
            
            [hud  hide:YES];
            
            [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
            
        }];
    };
    
    deleteViewController.titleStr = [NSString stringWithFormat:@"是否确定删除“%@”这个单元",self.subTitle];
    deleteViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    deleteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    deleteViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:deleteViewController animated:YES completion:nil];
}



- (void)initUI {
    
    UIView *positionbackView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, kScreen_Width, 156.5)];
    positionbackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:positionbackView];
    
    UILabel *labelLine0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 12)];
    labelLine0.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    [positionbackView addSubview:labelLine0];
    
    UIView *onetView = [[UIView alloc]initWithFrame:CGRectMake(0, labelLine0.bottom, kScreen_Width, 44)];
    onetView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseLeaderShip)];
    [onetView addGestureRecognizer:tapo];
    [positionbackView addSubview:onetView];
    
    UILabel *unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 80, 44)];
    unitLabel.text = @"上级单元";
    unitLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    unitLabel.font = [UIFont systemFontOfSize:16];
    unitLabel.textAlignment = NSTextAlignmentLeft;
    [onetView addSubview:unitLabel];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 22, 13, 10, 18)];
    imageV.image = [UIImage imageNamed:@"arrow_set"];
    [onetView addSubview:imageV];
    
    UILabel *leaderUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 32 - 50, 0, 60, 44)];
    leaderUnitLabel.text = [NSString stringWithFormat:@"%@级单元",self.superRanks];
    leaderUnitLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    leaderUnitLabel.font = [UIFont systemFontOfSize:12];
    leaderUnitLabel.textAlignment = NSTextAlignmentLeft;
    [onetView addSubview:leaderUnitLabel];
    self.leaderUnitLabel = leaderUnitLabel;
    
    UILabel *departmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 85 - 90, 0, 90, 44)];
    departmentLabel.text = self.superTitle;
    departmentLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    departmentLabel.font = [UIFont systemFontOfSize:16];
    departmentLabel.textAlignment = NSTextAlignmentRight;
    [onetView addSubview:departmentLabel];
    self.departmentLabel = departmentLabel;

    UILabel *labelLine1 = [[UILabel alloc]initWithFrame:CGRectMake(0, onetView.bottom, kScreen_Width, 12)];
    labelLine1.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    [positionbackView addSubview:labelLine1];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, labelLine1.bottom, 40, 44)];
    nameLabel.text = @"名称";
    nameLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [positionbackView addSubview:nameLabel];
    
    
    _messageTextfield = [[UITextField alloc]initWithFrame:CGRectMake(62 , labelLine1.bottom, kScreen_Width - 62-12, 44)];
    _messageTextfield.delegate = self;
    _messageTextfield.placeholder = @"请输入名称";
    _messageTextfield.textColor = [UIColor colorWithHexString:@"#333333"];
//    [_messageTextfield addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    _messageTextfield.font = [UIFont systemFontOfSize:16];
    [positionbackView addSubview:_messageTextfield];
    _messageTextfield.text = self.subTitle;

    
    UILabel *labelLine2 = [[UILabel alloc]initWithFrame:CGRectMake(0, nameLabel.bottom, kScreen_Width, 0.5)];
    labelLine2.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [positionbackView addSubview:labelLine2];
    
    _unitView = [[UIView alloc]initWithFrame:CGRectMake(0, labelLine2.bottom, kScreen_Width, 44)];
    _unitView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseUnit)];
    [_unitView addGestureRecognizer:tap];
    [positionbackView addSubview:_unitView];
    
    UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 40, 44)];
    levelLabel.text = @"级别";
    levelLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    levelLabel.font = [UIFont systemFontOfSize:16];
    levelLabel.textAlignment = NSTextAlignmentLeft;
    [_unitView addSubview:levelLabel];
    
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, kScreen_Width - 141, 44)];
    detailLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    detailLabel.font = [UIFont systemFontOfSize:16];
    detailLabel.textAlignment = NSTextAlignmentLeft;
    [_unitView addSubview:detailLabel];
    self.detailLabel = detailLabel;
    if ([self.type isEqualToString:@"隐藏删除按钮"]) {
        detailLabel.text = [NSString stringWithFormat:@"%ld级单元",[self.superRanks integerValue] + 1];
        
    }
    else {
        detailLabel.text = [NSString stringWithFormat:@"%ld级单元",(long)[self.ranks integerValue]];
        
    }

    UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width - 40, 0, 40, 44)];
    [imageButton setImage:[UIImage imageNamed:@"samelevel_blue"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(pushView) forControlEvents:UIControlEventTouchUpInside];
    [_unitView addSubview:imageButton];
    
    _labelLineDown = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreen_Height - 49 - 64, kScreen_Width, 0.5)];
    _labelLineDown.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [self.view addSubview:_labelLineDown];
    
    _downButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreen_Height - 49 - 64, kScreen_Width, 49)];
    _downButton.backgroundColor = [UIColor whiteColor];
    [_downButton setTitle:@"删除单元" forState:UIControlStateNormal];
    [_downButton addTarget:self action:@selector(deleteUnitAction) forControlEvents:UIControlEventTouchUpInside];
    [_downButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:_downButton];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chooseLeaderShip {
    SelectUnitVC *selectUnitVC = [[SelectUnitVC alloc]init];
    selectUnitVC.superRanks = self.superRanks;
//    selectUnitVC.superTitle = self.superTitle;
    selectUnitVC.ParentID = self.ParentID;
    selectUnitVC.DepartmentId = self.DepartmentId;// 无法设置子单元为父单元
    selectUnitVC.comanyName = [UserInfo getcompanyName];
//    selectUnitVC.departments = self.departments;
    selectUnitVC.title = @"选择上级单元";
    [self.navigationController pushViewController:selectUnitVC animated:YES];
    selectUnitVC.sendUnitBlock = ^(DepartmentModel *model)
    {
//        self.model = model;
        _ParentID = model.ParentID;
        _superRanks = model.superRanks;
        _leaderUnitLabel.text = [NSString stringWithFormat:@"%@级单元",model.superRanks];
        _departmentLabel.text = model.superTitle;
        _detailLabel.text = [NSString stringWithFormat:@"%ld级单元",model.superRanks.integerValue+1];
        
    };
}

- (void)chooseUnit {
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    self.departments = arr;
    
    __weak typeof(self) weakSelf = self;
    
    _maxRank = @0;
    for (NSDictionary *dic in self.departments) {
        
        
        if ([dic[@"Ranks"] integerValue] > [_maxRank integerValue]) {
            _maxRank = dic[@"Ranks"];
        }
    }
    
    SelectRankVC *selectRankVC  = [[SelectRankVC alloc] init];
    selectRankVC.minRank = self.superRanks.integerValue + 1;
    selectRankVC.maxRank = _maxRank.integerValue + 1;
    selectRankVC.clickBlock = ^(NSInteger indexRow) {
        weakSelf.detailLabel.text = [NSString stringWithFormat:@"%ld级单元",(long)indexRow];

    };
    selectRankVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    selectRankVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    selectRankVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self presentViewController:selectRankVC animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [_unitV removeFromSuperview];
    [self.messageTextfield resignFirstResponder];
}

//- (void)editChangeAction:(UITextField *)textField
//{
//    
//    if (textField.text.length > 10) {
//        textField.text = [textField.text substringToIndex:10];
//    }
//    
//    
//}

#pragma mark - Notification Method
-(void)textFieldEditChanged:(NSNotification *)obj
{
    
    UITextField *tf = (UITextField *)obj.object;
    
    if ([tf.text containsString:@"\n"]) {
        
        [self.view endEditing:YES];
        return;
    }
    
    [self.view computeWordCountWithTextField:_messageTextfield warningLabel:nil maxNumber:10];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
