//
//  GroupListSettingVC.m
//  XiaoYing
//
//  Created by ZWL on 16/8/16.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "GroupListSettingVC.h"
#import "SelectedPeopleCell.h"
#import "GroupNameSettingVC.h"
#import "ConnectModel.h"
#import "RCIM.h"
#import "SelectContactsVC.h"
#import "DeleteViewController.h"

@interface GroupListSettingVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIButton *_baseBtn;
    UILabel *_groupNameLab;
    UICollectionView *_collectionView;
    UIButton *_addBtn;
    UIButton *_dissolveBtn;
    MBProgressHUD *_hud;
    int _i;
}

@property (nonatomic,strong) EmployeeModel *aModel;



@end

@implementation GroupListSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"群设置";
    
    //            从本地读取数据
    NSArray *groupListArr = [ZWLCacheData unarchiveObjectWithFile:GroupPath];
    for (GroupListModel *model in groupListArr) {
        if ([model.RongCloudChatRoomId isEqualToString:self.targetId]) {
            self.model = model;
        }
    }
    
    if (self.memberListArr.count == 0) {
        
        
        for (NSDictionary *dic in self.model.Members) {
            ChatMemberModel *memberModel = [[ChatMemberModel alloc] initWithContentsOfDic:dic];
            [self.iDArr addObject:memberModel.ProfileId];

            NSInteger index = [self.model.Members indexOfObject:dic];
            
            EmployeeModel *model = [[EmployeeModel alloc] init];
            model.FaceURL = memberModel.FaceUrl;
            model.EmployeeName = memberModel.MemberName;
            model.ProfileId = memberModel.ProfileId;
            [self.memberListArr addObject:model];
            
            //群聊创建者信息取出
            if ([memberModel.ProfileId isEqualToString:[UserInfo userID]] && index == 0) {
                model.isMain = YES;

            }
            
        }

    }
    
    if (self.memberListArr.count > 0) {
        // 群主
        EmployeeModel *model = self.memberListArr[0];
        self.aModel = model;
    }


    [self initSubViews];
    

}

// 获取信息
- (void)getMessage:(NSString *)profileId
{
    // 所有员工
    NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];

    // 所有好友
    NSArray *friendArr = [ZWLCacheData unarchiveObjectWithFile:FriendPath];
    
//    NSMutableArray *arrM = [NSMutableArray array];
    
    // 用于判断是否是同一人数组
    NSMutableArray *arrM2 = [NSMutableArray array];
    
    // 好友的
    for (ConnectWithMyFriend *friend in friendArr) {
        if ([profileId isEqualToString:friend.ProfileId]) {
            EmployeeModel *model = [[EmployeeModel alloc] init];
            model.FaceURL = friend.FaceUrl;
            model.EmployeeName = friend.Nick;
            model.ProfileId = friend.ProfileId;
            [self.memberListArr addObject:model];
            
            [arrM2 addObject:friend.ProfileId];
            
        }
    }
    
    // 员工的
    for (NSDictionary *dic in employeesArr) {
        
        
        if ([profileId isEqualToString:dic[@"ProfileId"]]) {
            
            EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
            
            if (![arrM2 containsObject:model.ProfileId]) {
                [self.memberListArr addObject:model];
                
            }
            
        }
        
        
    }


}

- (void)initSubViews
{
    _baseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _baseBtn.frame = CGRectMake(0, 12, kScreen_Width, 44);
    _baseBtn.backgroundColor = [UIColor whiteColor];
    [_baseBtn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_baseBtn];

    UILabel *namelab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, 44)];
    namelab.text = @"群名称";
    namelab.textColor = [UIColor colorWithHexString:@"#333333"];
    namelab.font = [UIFont systemFontOfSize:16];
    [_baseBtn addSubview:namelab];
    
    _groupNameLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-34-150, 0, 150, 44)];
    _groupNameLab.textColor = [UIColor colorWithHexString:@"#848484"];
    _groupNameLab.text = self.model.Name;
    _groupNameLab.textAlignment = NSTextAlignmentRight;
    _groupNameLab.font = [UIFont systemFontOfSize:16];
    [_baseBtn addSubview:_groupNameLab];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width-12-10, (44-18)/2, 10, 18)];
    imgView.image = [UIImage imageNamed:@"arrow_set"];
    [_baseBtn addSubview:imgView];
    
    if (!self.aModel.isMain) {
        _baseBtn.userInteractionEnabled = NO;
        _groupNameLab.left = kScreen_Width-12-150;
        imgView.hidden = YES;
    }

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 26;
    layout.minimumInteritemSpacing = 6;
    layout.itemSize = CGSizeMake((kScreen_Width-6*6)/5, (kScreen_Width-6*6)/5);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, _baseBtn.bottom+12, kScreen_Width, 300) collectionViewLayout:layout];
    [_collectionView registerClass:[SelectedPeopleCell class] forCellWithReuseIdentifier:@"identifier"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(6, 6, 26, 6);
    [self.view addSubview:_collectionView];
    
    if (self.aModel.isMain) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(12, _collectionView.bottom+12, kScreen_Width-24, 44);
        _addBtn.layer.cornerRadius = 5;
        _addBtn.clipsToBounds = YES;
        [_addBtn setTitle:@"添加联系人" forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _addBtn.backgroundColor = [UIColor colorWithHexString:@"f99740"];
        [_addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addBtn];
        
        _dissolveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _dissolveBtn.frame = CGRectMake(12, _addBtn.bottom+12, kScreen_Width-24, 44);
        _dissolveBtn.layer.cornerRadius = 5;
        _dissolveBtn.clipsToBounds = YES;
        [_dissolveBtn setTitle:@"解散" forState:UIControlStateNormal];
        _dissolveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _dissolveBtn.backgroundColor = [UIColor colorWithHexString:@"f94040"];
        [_dissolveBtn addTarget:self action:@selector(dissolveAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_dissolveBtn];
    }
    else {
        UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        exitBtn.frame = CGRectMake(12, _collectionView.bottom+12, kScreen_Width-24, 44);
        exitBtn.layer.cornerRadius = 5;
        exitBtn.clipsToBounds = YES;
        [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
        exitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        exitBtn.backgroundColor = [UIColor colorWithHexString:@"f94040"];
        [exitBtn addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:exitBtn];
    }
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exitAction
{
    
    DeleteViewController *deleteViewController = [[DeleteViewController alloc] init];
    deleteViewController.titleStr = [NSString stringWithFormat:@"是否确定退出该群?"];
    deleteViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    deleteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    deleteViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:deleteViewController animated:YES completion:nil];
    deleteViewController.fileDeleteBlock = ^(void)
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"正在加载...";
        
        NSString *strUrl = [NSString stringWithFormat:@"%@&roomId=%@",RemoveMember, self.model.RoomId];
        [AFNetClient  POST_Path:strUrl params:@[[UserInfo userID]] completed:^(NSData *stringData, id JSONDict) {
            
            [_hud hide:YES];
            
            
            [[RCIMClient sharedRCIMClient] quitDiscussion:self.model.RongCloudChatRoomId success:^(RCDiscussion *discussion) {
                
            } error:^(RCErrorCode status) {
                
            }];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteConversionNotification object:self.model];
            
            // 刷新讨论组列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDiscussionListNotification" object:nil];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        } failed:^(NSError *error) {
            [_hud hide:YES];
            NSLog(@"请求失败Error--%ld",(long)error.code);
        }];

    };
}

- (void)dissolveAction
{
    DeleteViewController *deleteViewController = [[DeleteViewController alloc] init];
    deleteViewController.titleStr = [NSString stringWithFormat:@"是否确定解散该群?"];
    deleteViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    deleteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    deleteViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:deleteViewController animated:YES completion:nil];
    deleteViewController.fileDeleteBlock = ^(void)
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"正在加载...";
        
        NSString *strUrl = [NSString stringWithFormat:@"%@&roomId=%@",ShieldDiscussion, self.model.RoomId];
        [AFNetClient  POST_Path:strUrl completed:^(NSData *stringData, id JSONDict) {
            
            [_hud hide:YES];
            
            if (self.iDArr.count > 1) {
                // 移除群主
                [self.iDArr removeObjectAtIndex:0];
                
                _i = 0;
                [self removeMember];
                
            }
            else {
                // 删除会话
                [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteConversionNotification object:self.model];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
            
            // 刷新讨论组列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDiscussionListNotification" object:nil];
            
        } failed:^(NSError *error) {
            [_hud hide:YES];
            NSLog(@"请求失败Error--%@",error);
        }];
    };
}

- (void)removeMember
{
    [[RCIMClient sharedRCIMClient] removeMemberFromDiscussion:self.model.RongCloudChatRoomId userId:self.iDArr[_i] success:^(RCDiscussion *discussion) {
        
        _i++;
        if (_i == self.iDArr.count) {
            // 删除会话
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteConversionNotification object:self.model];
            NSLog(@"删除会话------------------------");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];

            });

        }
        if (_i < self.iDArr.count) {
            [self removeMember];
        }
        
        
    } error:^(RCErrorCode status) {
        
        NSLog(@"解散失败Error--");
        
    }];
}

- (void)changeAction
{
    GroupNameSettingVC *groupNameSettingVC = [[GroupNameSettingVC alloc] init];
    groupNameSettingVC.name = _groupNameLab.text;
    groupNameSettingVC.model = self.model;
    [self.navigationController pushViewController:groupNameSettingVC animated:YES];
    groupNameSettingVC.clickBlock = ^(NSString *name) {
        _groupNameLab.text = name;

    };
}

- (void)addAction
{
    //选择联系人
    SelectContactsVC *contactsVC =[[SelectContactsVC alloc]init];
    contactsVC.iDArr = self.iDArr;
    [self.navigationController pushViewController:contactsVC animated:YES];
    contactsVC.addMember = ^(NSArray *array) {
        
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"正在加载...";

        NSString *strUrl = [NSString stringWithFormat:@"%@&roomId=%@",Addmember, self.model.RoomId];
        [AFNetClient  POST_Path:strUrl params:array completed:^(NSData *stringData, id JSONDict) {
            
            [_hud hide:YES];
            
            for (NSString *profileId in array) {
                [self getMessage:profileId];
                
                [self.iDArr addObject:profileId];

            }
            
            [_collectionView reloadData];
            
            // 刷新讨论组列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDiscussionListNotification" object:nil];
            
            [[RCIMClient sharedRCIMClient] addMemberToDiscussion:self.model.RongCloudChatRoomId userIdList:array success:^(RCDiscussion *discussion) {
                NSLog(@"%@",discussion.discussionName);
                
            } error:^(RCErrorCode status) {
                
//                NSLog(@"加入讨论组失败%ld",status);
            }];
            
            
        } failed:^(NSError *error) {
            [_hud hide:YES];
            NSLog(@"请求失败%@",error);
        }];

        
    };
    
    

}

#pragma mark - UICollectionViewDataSource
//集合视图的cell数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.memberListArr.count;
}

//集合视图的单元格初始化
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"identifier";
    SelectedPeopleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.deleteBlock = ^(EmployeeModel *model) {
        
        DeleteViewController *deleteViewController = [[DeleteViewController alloc] init];
        deleteViewController.titleStr = [NSString stringWithFormat:@"是否确定删除%@?",model.EmployeeName];
        deleteViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //淡出淡入
        deleteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //            self.definesPresentationContext = YES; //不盖住整个屏幕
        deleteViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [self presentViewController:deleteViewController animated:YES completion:nil];
        deleteViewController.fileDeleteBlock = ^(void)
        {
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"正在加载...";
            
            NSString *strUrl = [NSString stringWithFormat:@"%@&roomId=%@",RemoveMember, self.model.RoomId];
            [AFNetClient  POST_Path:strUrl params:@[model.ProfileId] completed:^(NSData *stringData, id JSONDict) {
                
                [_hud hide:YES];
                
                for (NSDictionary *dic in self.model.Members) {
                    ChatMemberModel *memberModel = [[ChatMemberModel alloc] initWithContentsOfDic:dic];
                    if ([memberModel.ProfileId isEqualToString:model.ProfileId]) {
//                        self.model.Members 
                    }
                    
                }
                [self.iDArr removeObject:model.ProfileId];
                [self.memberListArr removeObject:model];
                [_collectionView reloadData];
                
                [[RCIMClient sharedRCIMClient] removeMemberFromDiscussion:self.model.RongCloudChatRoomId userId:model.ProfileId success:^(RCDiscussion *discussion) {
                    
                    
                    // 刷新讨论组列表
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDiscussionListNotification" object:nil];
                    
                } error:^(RCErrorCode status) {

                }];
                
                
            } failed:^(NSError *error) {
                [_hud hide:YES];
                NSLog(@"请求失败Error--%ld",(long)error.code);
            }];
        };
        
    };
    cell.dutyLab.hidden = YES;
    
    EmployeeModel *model = self.memberListArr[indexPath.item];
    cell.model = model;
    
    // 群主
    if (self.aModel.isMain) {
        
        if (model.isMain) {
            
            cell.deleteBtn.hidden = YES;
        }
        else {
            cell.deleteBtn.hidden = NO;

        }
    }
    else {
        cell.deleteBtn.hidden = YES;

    }
    // 调用layoutsubviews（collectionView数据刷新还是重写model的setter方法较好）
    [cell setNeedsLayout];
//    cell.backgroundColor = [UIColor redColor];

    
    return cell;
}


@end
