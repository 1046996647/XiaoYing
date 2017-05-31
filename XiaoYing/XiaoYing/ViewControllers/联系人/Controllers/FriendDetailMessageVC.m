//
//  FriendDetailMessageVC.m
//  XiaoYing
//
//  Created by ZWL on 16/8/17.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "FriendDetailMessageVC.h"
#import "FriendDetailCell.h"
#import "OverheadInfoVC.h"
#import "NSNumber+RegionName.h"
#import "ChatViewController.h"
#import "DeleteViewController.h"
#import "EmployeeModel.h"
#import "RemarkVC.h"

@interface FriendDetailMessageVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArrayOne;
    NSArray *_titleArrayTwo;
    MBProgressHUD *_hud;

}

@property (nonatomic,strong) UIView *footerView;


@end

@implementation FriendDetailMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"详细资料";
    
    
    if (_model.isEmployee) {
        _titleArrayOne = @[@[@""],@[@"电话"],@[@"单元",@"职位",@"工号",@"联系地址"],@[@"个性签名"]];
        [self GetDetailOfEmployeeAction];

    }
    else {
        _titleArrayOne = @[@[@""],@[@"生日",@"地区"],@[@"个性签名"]];
        NSString *regionName = [_model.RegionId getRegionName];
        
        if (_model.Birthday.length == 0) {
            _model.Birthday = @"";
        }
        if (_model.Signature.length == 0) {
            _model.Signature = @"";
        }
        if (regionName.length == 0) {
            regionName = @"";
        }
        _titleArrayTwo = @[@[_model.Birthday,regionName],@[_model.Signature]];
        
        UIBarButtonItem *rightBarButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"备注" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
        rightBarButtonItem2.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem2;
        
    }
    

    // 表的尾视图
    [self initFooterView];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = self.footerView;
    [self.view addSubview:_tableView];
}

- (void)rightAction
{
    RemarkVC *vc = [[RemarkVC alloc] init];
    if (_model.RemarkName.length > 0) {
        vc.text = _model.RemarkName;

    }
    else {
        vc.text = _model.Nick;

    }
    vc.profileId = _model.ProfileId;
    [self.navigationController pushViewController:vc animated:YES];
    vc.clickBlock = ^(NSString *name) {
        _model.RemarkName = name;
        [_tableView reloadData];
        
    };
}

- (void)GetDetailOfEmployeeAction {
    //    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    _hud.mode = MBProgressHUDModeIndeterminate;
    //    _hud.labelText = @"加载中...";
    NSString *urlStr = [GetDetailOfEmployee stringByAppendingFormat:@"&ProfileId=%@",_model.ProfileId];
    [AFNetClient GET_Path:urlStr completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            [MBProgressHUD showMessage:[JSONDict objectForKey:@"Message"] toView:self.view];
        } else {
            NSDictionary *dic =[JSONDict objectForKey:@"Data"];
            
            EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
            // 主职
            NSString *jobName = nil;
            for (NSDictionary *dic in model.Jobs) {
                if ([dic[@"IsMastJob"] boolValue]) {
                    jobName = dic[@"JobName"];
                }
            }
            
            _titleArrayTwo = @[@[model.Mobile],@[model.DepartmentName,jobName,model.EmployeeNo,model.RealAddress],@[model.Signer]];
            [_tableView reloadData];
            
        }
        //        [_hud setHidden:YES];
    } failed:^(NSError *error) {
        //        [_hud setHidden:YES];
//        [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = _titleArrayOne[section];
    return arr.count;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArrayOne.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }
    
    //计算字符串高度
    NSString *str = _titleArrayTwo[indexPath.section-1][indexPath.row];
    
    if (str.length > 0) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        CGSize textSize = [str boundingRectWithSize:CGSizeMake(200, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        return textSize.height + 20;
    }
    return 50;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FriendDetailCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
    }
    
    
    if (cell == nil) {
        
        if (indexPath.section == 0) {
            cell = [[FriendDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            
        } else {
            cell = [[FriendDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    if (indexPath.section == 0) {
        
        cell.model = _model;
    } else {
        
        cell.title = _titleArrayOne[indexPath.section][indexPath.row];
        cell.data = _titleArrayTwo[indexPath.section-1][indexPath.row];
        
    }
    
    return cell;
    
}


//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 12;
}

////组的尾视图的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    
//    if (_titleArrayOne.count-1 == section) {
//        
//        return 44*2+12*3;
//        
//    }
//    return 0;
//}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    return view;
}

////组的尾视图
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (_titleArrayOne.count-1 == section) {
//    
//        
//        return view;
//    }
//    return nil;
//}

// 表的尾视图
- (void)initFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44*2+12*3)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.footerView = view;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(12, 12, kScreen_Width-24, 44);
    addBtn.layer.cornerRadius = 5;
    addBtn.clipsToBounds = YES;
    [addBtn setTitle:@"发消息" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    addBtn.backgroundColor = [UIColor colorWithHexString:@"f99740"];
    [addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(12, addBtn.bottom+12, kScreen_Width-24, 44);
    deleteBtn.layer.cornerRadius = 5;
    deleteBtn.clipsToBounds = YES;
    [deleteBtn setTitle:@"删除好友" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    deleteBtn.backgroundColor = [UIColor colorWithHexString:@"f94040"];
    [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleteBtn];
}

- (void)addAction
{
    ChatViewController *rcVC = [[ChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:_model.ProfileId];
    rcVC.enableContinuousReadUnreadVoice =YES;
    [self.navigationController pushViewController:rcVC animated:YES];
    
    if (_model.isEmployee) {

        rcVC.title = _model.Name;

    }
    else {
        rcVC.title = _model.Nick;

    }
    
}
- (void)deleteAction
{
    
    DeleteViewController *deleteViewController = [[DeleteViewController alloc] init];
    //    deleteViewController.urlStr = self.sessionModel.url;
    deleteViewController.titleStr = @"是否确定删除该好友?";
    deleteViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    deleteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    deleteViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:deleteViewController animated:YES completion:nil];
    deleteViewController.fileDeleteBlock = ^(void)
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //    _hud.backgroundColor = [UIColor redColor];
        _hud.labelText = @"删除中...";
        NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
        [paramDic  setValue:self.model.ProfileId forKey:@"friendProfileId"];
        
        [AFNetClient  POST_Path:ReleaseFriend params:paramDic completed:^(NSData *stringData, id JSONDict) {
            
            [_hud hide:YES];
            
            NSNumber *code=[JSONDict objectForKey:@"Code"];
            
            if (1 == [code integerValue]) {
                
                NSString *msg = [JSONDict objectForKey:@"Message"];
                
                [MBProgressHUD showMessage:msg];
                
            } else {
                
                // 删除成功好友刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:kAgreeFriendSuccessNotification object:nil];
                
                // 监听会话好友
                [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteConversionNotification object:self.model];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failed:^(NSError *error) {
            
            [_hud hide:YES];

            [MBProgressHUD showMessage:@"网络似乎已断开!"];
            
        }];
    };
 
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
