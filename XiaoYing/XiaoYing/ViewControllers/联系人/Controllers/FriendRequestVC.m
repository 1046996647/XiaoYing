//
//  FriendRequestVC.m
//  XiaoYing
//
//  Created by ZWL on 16/8/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "FriendRequestVC.h"
#import "FriendRequestCell.h"

@interface FriendRequestVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataList;

}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) MBProgressHUD *hud;


@end

@implementation FriendRequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"好友请求";
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dic in self.requestArray) {
        AddFriendModel *friend = [[AddFriendModel alloc] initWithContentsOfDic:dic];
        [arrM addObject:friend];
    }
    _dataList = arrM;
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    if (_count > 0) {
        
        // 设置待处理请求为已查
        [self setViewed];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setViewed
{
    [AFNetClient GET_Path:SetViewed completed:^(NSData *stringData, id JSONDict) {
        
        if (self.requestBlock) {
            self.requestBlock();
        }
        
    } failed:^(NSError *error) {
        NSLog(@"%@", error);
        
    }];
}

- (void)requestFriend
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _hud.labelText = @"加载中...";
    // 获取接受申请数据
    [AFNetClient GET_Path:FriendRequest completed:^(NSData *stringData, id JSONDict) {
        [_hud hide:YES];
        NSArray *datas = JSONDict[@"Data"];
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dic in datas) {
            AddFriendModel *friend = [[AddFriendModel alloc] initWithContentsOfDic:dic];
            [arrM addObject:friend];
        }
        _dataList = arrM;
        
        [_tableView reloadData];
        
    } failed:^(NSError *error) {
        NSLog(@"%@", error);
        [_hud hide:YES];

    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //    return _titleArray.count;
    return _dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (_dataList.count > 0) {
//        ProfileMyModel *model = _dataList[indexPath.row];
//        FriendDetailMessageVC *friendDetailMessageVC =[[FriendDetailMessageVC alloc] init];
//        friendDetailMessageVC.profileMyModel = model;
//        [self.navigationController pushViewController:friendDetailMessageVC animated:YES];
//    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FriendRequestCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[FriendRequestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.requestBlock = ^(void) {
            [self requestFriend];
            
            if (self.requestBlock) {
                self.requestBlock();
            }
        };
    }
    
    AddFriendModel *model = _dataList[indexPath.row];
    cell.model = model;
    return cell;
    
    
}

// 点击删除触发的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除中
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"删除中...";
    
    AddFriendModel *model = _dataList[indexPath.row];

    NSString *strUrl = [NSString stringWithFormat:@"%@&id=%@",DeleteRequest, model.ProfileId];
    
    [AFNetClient  GET_Path:strUrl completed:^(NSData *stringData, id JSONDict) {
        
        [hud hide:YES];
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {

            [self requestFriend];
            
            if (self.requestBlock) {
                self.requestBlock();
            }
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


@end
