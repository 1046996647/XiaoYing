//
//  FriendDetailMessageVC.m
//  XiaoYing
//
//  Created by ZWL on 16/8/17.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "NOFriendDetailMessageVC.h"
#import "FriendDetailCell.h"
#import "OverheadInfoVC.h"
#import "NSNumber+RegionName.h"
#import "ChatViewController.h"
#import "DeleteViewController.h"


@interface NOFriendDetailMessageVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArrayOne;
    NSArray *_titleArrayTwo;
//    ProfileMyModel *_profileMyModel;
    MBProgressHUD *_hud;

}

@property (nonatomic,strong) UIView *footerView;


@end

@implementation NOFriendDetailMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"详细资料";
    
    _titleArrayOne = @[@[@"生日",@"地区"],@[@"个性签名"]];
    
    if (_model) {
        
        if (_model.RegionName.length > 0) {
            _titleArrayTwo = @[@[_model.Birthday,_model.RegionName],@[_model.Signature]];
        }
        else {
            NSString *regionName = [_model.RegionId getRegionName];
            
            if (regionName.length == 0) {
                regionName = @"";
            }
            _titleArrayTwo = @[@[_model.Birthday,regionName],@[_model.Signature]];
        }

    }
    else {
        [self getProfile];
    }
    
    // 表的尾视图
    [self initFooterView];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 49)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = self.footerView;
    [self.view addSubview:_tableView];
}

- (void)getProfile
{
//    NSString *strUrl = [NSString stringWithFormat:@"%@&code=%@", ProfileByCode, self.strValue];
//    NSString *strUrl = [NSString stringWithFormat:@"%@/api/profile/my?Token=%@", BaseUrl1, self.strValue];
    NSString *strURL = [NSString stringWithFormat:@"%@&keyword=%@",ProfileList, self.strValue];

    [AFNetClient GET_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        
        ConnectWithMyFriend *model = [[ConnectWithMyFriend alloc] initWithContentsOfDic:[JSONDict[@"Data"] firstObject]];
        _model = model;
        _titleArrayTwo = @[@[model.Birthday,model.RegionName],@[model.Signature]];
        [_tableView reloadData];
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
//        [_hud hide:YES];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return _titleArrayOne.count;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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
        
        cell.title = _titleArrayOne[indexPath.section-1][indexPath.row];
        cell.data = _titleArrayTwo[indexPath.section-1][indexPath.row];
        
    }
    
    return cell;
    
}


//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 12;
}


//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
//    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    return view;
}

- (void)initFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44*2+12*3)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.footerView = view;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(12, 12, kScreen_Width-24, 44);
    addBtn.layer.cornerRadius = 5;
    addBtn.clipsToBounds = YES;
    [addBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    addBtn.backgroundColor = [UIColor colorWithHexString:@"f99740"];
    [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];
    
    // 当前用户
    if ([_model.ProfileId isEqualToString:[UserInfo userID]]) {
        addBtn.hidden = YES;
    }
    else {
        
        // 所有好友
        NSArray *friendArr = [ZWLCacheData unarchiveObjectWithFile:FriendPath];
        // 好友的
        for (ConnectWithMyFriend *friend in friendArr) {
            
            if ([_model.ProfileId isEqualToString:friend.ProfileId]) {
                
                view.height = 44*2+12*3;
                
                [addBtn setTitle:@"发消息" forState:UIControlStateNormal];
                NSLog(@"%@%@",_model.ProfileId, friend.ProfileId);
                
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteBtn.frame = CGRectMake(12, addBtn.bottom+12, kScreen_Width-24, 44);
                deleteBtn.layer.cornerRadius = 5;
                deleteBtn.clipsToBounds = YES;
                [deleteBtn setTitle:@"删除好友" forState:UIControlStateNormal];
                deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                deleteBtn.backgroundColor = [UIColor colorWithHexString:@"f94040"];
                [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:deleteBtn];
                
                break;
            }
            
        }
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


- (void)addAction:(UIButton *)btn
{
    
    if ([btn.currentTitle isEqualToString:@"添加好友"]) {
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
            [paramDic  setValue:self.model.ProfileId forKey:@"friendProfileId"];
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
    else {
        ChatViewController *rcVC = [[ChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:_model.ProfileId];
        rcVC.title = _model.Nick;
        rcVC.enableContinuousReadUnreadVoice =YES;
        [self.navigationController pushViewController:rcVC animated:YES];
    }
    
    


}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - 重写返回按钮事件
- (void)backAction:(UIButton *)button
{
    if (self.backNum == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    else {
        [self.navigationController popViewControllerAnimated:YES];

    }
}

@end
