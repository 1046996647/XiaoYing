//
//  FriendDetailMessageVC.m
//  XiaoYing
//
//  Created by ZWL on 16/8/17.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "EmploeeyDetailMessageVC.h"
#import "EmployeeDetailCell.h"
#import "OverheadInfoVC.h"
#import "ChatViewController.h"

@interface EmploeeyDetailMessageVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArrayOne;
    NSArray *_titleArrayTwo;
    //    ProfileMyModel *_profileMyModel;
}

@end

@implementation EmploeeyDetailMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"详细资料";
    
    _titleArrayOne = @[@[@""],@[@"电话"],@[@"单元",@"职位",@"工号",@"联系地址"],@[@"个性签名"]];

    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 49)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    [self GetDetailOfEmployeeAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)GetDetailOfEmployeeAction {
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _hud.mode = MBProgressHUDModeIndeterminate;
//    _hud.labelText = @"加载中...";
    NSString *urlStr = [GetDetailOfEmployee stringByAppendingFormat:@"&ProfileId=%@",_employeeModel.ProfileId];
    [AFNetClient GET_Path:urlStr completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            [MBProgressHUD showMessage:[JSONDict objectForKey:@"Message"] toView:self.view];
        } else {
            NSDictionary *dic =[JSONDict objectForKey:@"Data"];

            EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
            _employeeModel.FaceURL = model.EmployeeFaceUrl;
    
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
        [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
    }];
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
    
    EmployeeDetailCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
    }
    
    
    if (cell == nil) {
        
        if (indexPath.section == 0) {
            cell = [[EmployeeDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            
        } else {
            cell = [[EmployeeDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
    }
    
    
    if (indexPath.section == 0) {
        
        cell.model = _employeeModel;
    } else {
        
        cell.title = _titleArrayOne[indexPath.section][indexPath.row];
        cell.data = _titleArrayTwo[indexPath.section-1][indexPath.row];
        
    }
    
    if (indexPath.section == 1) {
        cell.dataLab.textColor = [UIColor colorWithHexString:@"#4eabfa"];
    }
    
    return cell;
    
}


//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 12;
}

//组的尾视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (3 == section) {
        
        return 68;
        
    }
    return 0;
}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    return view;
}

//组的尾视图
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (3 == section) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 68)];
        view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.frame = CGRectMake(12, 12, kScreen_Width-24, 44);
        sendBtn.layer.cornerRadius = 5;
        sendBtn.clipsToBounds = YES;
        [sendBtn setTitle:@"发消息" forState:UIControlStateNormal];
        sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        sendBtn.backgroundColor = [UIColor colorWithHexString:@"f99740"];
        [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:sendBtn];
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        addBtn.frame = CGRectMake(12, 12, kScreen_Width-24, 44);
        addBtn.layer.cornerRadius = 5;
        addBtn.clipsToBounds = YES;
        addBtn.hidden = YES;
        [addBtn setTitle:@"加为好友" forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        addBtn.backgroundColor = [UIColor colorWithHexString:@"f99740"];
        [addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:addBtn];
        
        if (!_employeeModel.isFriend) {
            addBtn.hidden = NO;
            CGFloat width = (kScreen_Width-36)/2;
            sendBtn.width = width;
            addBtn.frame = CGRectMake(sendBtn.right+12, 12, width, 44);

        }
        
        return view;
    }
    return nil;
}

- (void)sendAction
{
    ChatViewController *rcVC = [[ChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:_employeeModel.ProfileId];
    rcVC.title = _employeeModel.EmployeeName;
    rcVC.enableContinuousReadUnreadVoice =YES;
    [self.navigationController pushViewController:rcVC animated:YES];
    
}

- (void)addAction
{
    OverheadInfoVC *overheadInfoVC = [[OverheadInfoVC alloc] init];
    //    overheadInfoVC.friendProfileId = self.model.ProfileId;
    overheadInfoVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    overheadInfoVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    overheadInfoVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:overheadInfoVC animated:YES completion:nil];
    overheadInfoVC.clickBlock = ^(NSString *text) {
        
        NSMutableDictionary *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
        [paramDic  setValue:self.employeeModel.ProfileId forKey:@"friendProfileId"];
        [paramDic  setValue:text forKey:@"Reason"];
        
        [AFNetClient  POST_Path:RequestAddFriend params:paramDic completed:^(NSData *stringData, id JSONDict) {
            
            NSNumber *code=[JSONDict objectForKey:@"Code"];
            
            if (1 == [code integerValue]) {
                NSString *msg = [JSONDict objectForKey:@"Message"];
                
                [MBProgressHUD showMessage:msg];
                
            } else {
                
                [MBProgressHUD showMessage:@"已发送"];
                [self performSelector:@selector(popViewController) withObject:nil afterDelay:1];
                
            }
            
        } failed:^(NSError *error) {
            
            NSLog(@"%@",error);
            [MBProgressHUD showError:@"网络似乎已断开!" toView:self.view];
            
        }];
    };

    
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
