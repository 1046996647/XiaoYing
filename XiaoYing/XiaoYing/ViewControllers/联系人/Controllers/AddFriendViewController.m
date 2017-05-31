//
//  AddFriendViewController.m
//  XiaoYing
//
//  Created by ZWL on 16/8/17.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "AddFriendViewController.h"
#import "AddFriendCell.h"
#import "NOFriendDetailMessageVC.h"
#import "NotSearchView.h"

@interface AddFriendViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;

}

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *dataList;
@property (nonatomic, strong) NotSearchView *backView;
@property (nonatomic, strong)MBProgressHUD *hud;


@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加好友";
    
    [self.view addSubview:self.searchBar];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.self.searchBar.bottom+.5, kScreen_Width, kScreen_Height-64-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
//    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
    
    _backView = [[NotSearchView alloc] initWithFrame:CGRectMake(0, _searchBar.bottom, kScreen_Width, kScreen_Height - _searchBar.bottom - 100)];
    _backView.hidden = YES;
    [self.view addSubview:_backView];

}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"输入小赢号或者昵称查找对方";
        _searchBar.showsCancelButton = NO;
        _searchBar.tintColor = [UIColor colorWithHexString:@"#f99740"];// 取消字体颜色和光标颜色
        [_searchBar setBackgroundImage:[UIImage new]];
        _searchBar.barTintColor = [UIColor colorWithHexString:@"#efeff4"];
        
    }
    return _searchBar;
}


#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _searchBar.showsCancelButton = YES;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    _hud.backgroundColor = [UIColor redColor];
    _hud.labelText = @"查找中...";
    NSString *strURL = [NSString stringWithFormat:@"%@&keyword=%@",ProfileList, self.searchBar.text];
    
    [AFNetClient  GET_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        
        [_hud hide:YES];
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
            NSMutableArray *arrM = [NSMutableArray array];
            for (NSDictionary *dic in JSONDict[@"Data"]) {
                ConnectWithMyFriend *model = [[ConnectWithMyFriend alloc] initWithContentsOfDic:dic];
                [arrM addObject:model];
            }
            
            self.dataList = arrM;
            [_tableView reloadData];
            
            if (arrM.count > 0) {
                _backView.hidden = YES;

            }
            else {
                _backView.hidden = NO;

            }
            
        }
        
    } failed:^(NSError *error) {
        
        [_hud hide:YES];
        [MBProgressHUD showMessage:@"网络似乎已断开!" toView:self.view];
        NSLog(@"%@",error);
        
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dataList.count > 0) {
        ConnectWithMyFriend *model = _dataList[indexPath.row];
        NOFriendDetailMessageVC *friendDetailMessageVC =[[NOFriendDetailMessageVC alloc] init];
        friendDetailMessageVC.model = model;
        [self.navigationController pushViewController:friendDetailMessageVC animated:YES];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

     AddFriendCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[AddFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    ConnectWithMyFriend *model = _dataList[indexPath.row];
    cell.model = model;
    return cell;
    
    
}

@end
