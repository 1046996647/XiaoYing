//
//  NewCreateFormworkVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/23.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "NewCreateFormworkVC.h"
#import "CreatFormworkVC.h"
#import "TypeFlowModel.h"
#import "DetailApproveVC.h"

@interface NewCreateFormworkVC ()

@property (nonatomic,strong) UITableView *formTable;
@property (nonatomic,copy) NSMutableArray *formArr;
//@property (nonatomic,copy) NSMutableArray *tempArr;
@property (nonatomic,strong) UIView *footView;

@end

@implementation NewCreateFormworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishWay)];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self initUI];
    
//    NSLog(@"%@",_flowsArr);
    
//    _ContentTemp = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_formTable reloadData];
}
//创建模板
- (void)initUI{
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-64-44, kScreen_Width, 44)];
    self.footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footView];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.5)];
    viewline.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [self.footView addSubview:viewline];
    
    UIButton *createBt = [UIButton buttonWithType:UIButtonTypeCustom];
    createBt.frame = CGRectMake(0, 0, kScreen_Width, 44);
    [createBt setTitle:@"新建范文" forState:UIControlStateNormal];
    createBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [createBt setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    [createBt addTarget:self action:@selector(creatWay) forControlEvents:UIControlEventTouchUpInside];
    [self.footView addSubview:createBt];
    
    self.formTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-44)];
    self.formTable.delegate = self;
    self.formTable.dataSource = self;
    self.formTable.tableFooterView = [UIView new];
    self.formTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.formTable];
    if ([self.formTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.formTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.formTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.formTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
}
- (void)creatWay{
    CreatFormworkVC *creatVC = [[CreatFormworkVC alloc] init];
    creatVC.title = @"新建范文";
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:creatVC];
    [self presentViewController:nav animated:YES completion:nil];
    creatVC.sendTempBlock = ^(TempModel *model) {
        [_ContentTemp addObject:model];
        [_formTable reloadData];
    };
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _ContentTemp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    TempModel *model = _ContentTemp[indexPath.row];
    cell.textLabel.text = model.Title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//单元格将要出现
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TempModel *model = _ContentTemp[indexPath.row];
    CreatFormworkVC *creatVC = [[CreatFormworkVC alloc] init];
    creatVC.title = @"修改范文";
    creatVC.model = model;
    [self.navigationController pushViewController:creatVC animated:YES];
}

// 点击删除触发的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TempModel *model = _ContentTemp[indexPath.row];
    //删除中
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"删除中...";
    
    NSMutableDictionary *paramDic = [NSMutableDictionary  dictionary];
    [paramDic  setValue:model.Id forKey:@"iD"];
    
    [AFNetClient  POST_Path:DeleteTemp params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        [hud hide:YES];
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            [_ContentTemp removeObject:model];
            [_formTable reloadData];
            
        }
        
    } failed:^(NSError *error) {
        
        [hud hide:YES];
        
        [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
        
    }];
}


#pragma  自定义左滑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//完成的方法
- (void)finishWay{
    
    //上传中
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"上传中...";
    
    NSMutableArray *arrM = [NSMutableArray array];
    NSMutableArray *tempIDs = [NSMutableArray array];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary  dictionary];
    [paramDic  setValue:_TypeName forKey:@"TypeName"];
    [paramDic  setValue:_selectedDepArr forKey:@"DepIDs"];
    [paramDic  setValue:@(_TagType) forKey:@"TagType"];
    [paramDic  setValue:_selectedEmpArr forKey:@"ExcutProfileIDs"];
    [paramDic  setValue:_CategoryID forKey:@"CategoryID"];
    
    for (TypeFlowModel *model in _flowsArr) {
        
        NSDictionary *dic = [ModelJson getObjectData:model];
        [arrM addObject:dic];
    }
    [paramDic  setValue:arrM forKey:@"Flows"];
    
    for (TempModel *model in _ContentTemp) {
        
        [tempIDs addObject:model.Id];
    }
    [paramDic  setValue:tempIDs forKey:@"ContentTemp"];
    
    NSLog(@"");
    
    [AFNetClient  POST_Path:Createtype params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        [hud hide:YES];
//        self.saveCreate.userInteractionEnabled = YES;
        
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
            // 是否刷新
            if (self.refreshBlock) {
                _refreshBlock();
            }
            [self popViewController];
        }
        
    } failed:^(NSError *error) {
        
        // 按钮改变
//        self.saveCreate.userInteractionEnabled = YES;
        
        [hud hide:YES];
        
        [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
        
    }];

}

- (void)popViewController
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[DetailApproveVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];

        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
