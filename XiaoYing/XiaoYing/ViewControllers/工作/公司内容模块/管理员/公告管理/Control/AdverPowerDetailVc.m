//
//  AdverPowerDetailVc.m
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/28.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AdverPowerDetailVc.h"
#import "AdverPowerview.h"
#import "MulSelectPeopleVC.h"
#import "WangUrlHelp.h"
//#import "SingleSelectPeopleVC.h"
#import "EmployeeModel.h"
#import "DepartmentModel.h"
#import "SingleSelectVC.h"
@interface AdverPowerDetailVc ()
@property (nonatomic, strong)AdverPowerview *adverpowerView;
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)DepartmentModel *model;
@property(nonatomic,strong)EmployeeModel *empModel;
@end

@implementation AdverPowerDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBasic];
    [self initUI];
    
}

- (void)initBasic {
//    self.title = @"杭州赢莱金融有限公司";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(setKeepActionRight)];
        
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(leftbarButtonbackAction:)];
}





- (void)initUI {
    _adverpowerView = [[AdverPowerview alloc]init];
    _adverpowerView.departmentId = self.departmentID;
    _adverpowerView.frame = self.view.frame;
    [self.view addSubview:_adverpowerView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adverPowerAction:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adverPowerAction:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adverPowerAction:)];
    [self.adverpowerView.OraindryPeople addGestureRecognizer:tap];
    self.adverpowerView.OraindryPeople.tag = 1;
    [self.adverpowerView.powerPeople addGestureRecognizer:tap2];
    self.adverpowerView.powerPeople.tag = 2;
    [self.adverpowerView.CanDeletePeople addGestureRecognizer:tap3];
    self.adverpowerView.CanDeletePeople.tag = 3;
}

#pragma mark - 跳转到选人方法 methods
- (void)adverPowerAction:(UITapGestureRecognizer *)tap {
    NSLog(@"123456");
    MulSelectPeopleVC *mulSelectPeopleVC = [[MulSelectPeopleVC alloc] init];
    if (tap.view.tag == 1) {//允许申请发公告的人
        mulSelectPeopleVC.selectedDepArr = [self.adverpowerView.applyDepArr mutableCopy];
        mulSelectPeopleVC.selectedEmpArr = [self.adverpowerView.applyPeopleArr mutableCopy];
        mulSelectPeopleVC.title = @"选择允许发公告的人";
        mulSelectPeopleVC.sendAllBlock = ^(NSMutableArray *depArr, NSMutableArray *empArr) {
            self.adverpowerView.applyDepArr = depArr;
            self.adverpowerView.applyPeopleArr = empArr;
            self.adverpowerView.applypeopleLab.text = [self.adverpowerView nameStringFromIDArr:self.adverpowerView.applyPeopleArr];
        };
         [self.navigationController pushViewController:mulSelectPeopleVC animated:YES];
    }
    if (tap.view.tag == 2) {//审批公告的人
        self.model = [DepartmentModel new];
        self.model.DepartmentId = @"";
        self.empModel = [EmployeeModel new];
        SingleSelectVC *singleSelectPeopleVC = [[SingleSelectVC alloc] init];
        NSString *profildID = self.adverpowerView.approvalPersonArr.firstObject;
        NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
        for (NSDictionary *subDic in employeesArr) {
            if ([subDic[@"ProfileId"] isEqualToString:profildID]) {
                self.empModel = [[EmployeeModel alloc]initWithContentsOfDic:subDic];
            }
        }
        singleSelectPeopleVC.title = @"选择审批公告的人";
        singleSelectPeopleVC.model = self.model;
        singleSelectPeopleVC.empModel = self.empModel;
        singleSelectPeopleVC.comanyName = [UserInfo getcompanyName];
        
        [self.navigationController pushViewController:singleSelectPeopleVC animated:YES];
        singleSelectPeopleVC.sendEmployeeBlock  = ^(EmployeeModel *model) {
            self.empModel = model;
            [self.adverpowerView.approvalPersonArr removeAllObjects];
            [self.adverpowerView.approvalPersonArr addObject:model.ProfileId];
            self.adverpowerView.approvalPersonLab.text = [self.adverpowerView nameStringFromIDArr:self.adverpowerView.approvalPersonArr];
        };

    }
    if (tap.view.tag == 3) {//允许删除公告的人
        mulSelectPeopleVC.selectedDepArr = [self.adverpowerView.deleteDepArr mutableCopy];
        mulSelectPeopleVC.selectedEmpArr = [self.adverpowerView.deletePeopleArr mutableCopy];
        mulSelectPeopleVC.title = @"选择允许删除公告的人";
        mulSelectPeopleVC.sendAllBlock = ^(NSMutableArray *depArr, NSMutableArray *empArr) {
            self.adverpowerView.deleteDepArr = depArr;
            self.adverpowerView.deletePeopleArr = empArr;
            self.adverpowerView.deletePeopleLab.text = [self.adverpowerView nameStringFromIDArr:self.adverpowerView.deletePeopleArr];
        };
         [self.navigationController pushViewController:mulSelectPeopleVC animated:YES];
    }
    
   

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setKeepActionRight {
    NSLog(@"保存");
    if (self.adverpowerView.deletePeopleArr.count != 0 && self.adverpowerView.applyPeopleArr.count!= 0 && self.adverpowerView.approvalPersonArr.count == 1) {//所有的选项都填写完整了
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"保存中";
        NSString *strUrl = AFFICHE_SETPERMISSION;
        //申请字典
        NSMutableDictionary *applyDic = [NSMutableDictionary dictionary];
        NSNumber *applyType = @(0);
        [applyDic setValue:self.departmentID forKey:@"DepartmentId"];
        [applyDic setValue:applyType forKey:@"Type"];
        [applyDic setValue:[self.adverpowerView.applyPeopleArr copy] forKey:@"ProfileIds"];
        
        //审批字典
        NSMutableDictionary *approvalDic = [NSMutableDictionary dictionary];
        NSNumber *approvalType = @(1);
        [approvalDic setValue:self.departmentID forKey:@"DepartmentId"];
        [approvalDic setValue:approvalType forKey:@"Type"];
        [approvalDic setValue:[self.adverpowerView.approvalPersonArr copy] forKey:@"ProfileIds"];
        
        //删除字典
        NSMutableDictionary *deleteDic = [NSMutableDictionary dictionary];
        NSNumber *deleteType = @(2);
        [deleteDic setValue:self.departmentID forKey:@"DepartmentId"];
        [deleteDic setValue:deleteType forKey:@"Type"];
        [deleteDic setValue:[self.adverpowerView.deletePeopleArr copy] forKey:@"ProfileIds"];
        
        NSArray *paraArr = @[applyDic,approvalDic,deleteDic];
        
        [AFNetClient POST_Path:strUrl params:paraArr completed:^(NSData *stringData, id JSONDict) {
            NSNumber *code = JSONDict[@"Code"];
            if (code.integerValue == 0){
                [_hud hide:YES];
                _hud = nil;
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showMessage:JSONDict[@"Message"]];
                [_hud hide:YES];
                _hud = nil;
            }
        } failed:^(NSError *error) {
            NSLog(@"失败**********=======>>>%@",error);
            [_hud hide:YES];
            _hud = nil;
            [MBProgressHUD showMessage:@"网络错误"];
        }];
    }else{
        [MBProgressHUD showMessage:@"信息不全"];
    }
    

    
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 返回按钮事件
- (void)leftbarButtonbackAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
