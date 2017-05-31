//
//  HSSearchTableView.m
//  XiaoYing
//
//  Created by chenchanghua on 16/11/14.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "HSSearchTableView.h"

@interface HSSearchTableView() <UISearchBarDelegate>

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) NSMutableArray *searchResultArray;

@property (nonatomic, strong, readwrite) UISearchBar *searchBar;
@property (nonatomic, strong) UIViewController *previousViewController;
@property (nonatomic, strong) UITableView *searchResultTableView;
@property (nonatomic, strong) NSMutableArray *searchResultDataArray;
@property (nonatomic, copy) void(^searchHappenBlock)();

@end

@implementation HSSearchTableView

- (HSSearchTableView *)initWithPreviousViewController:(UIViewController *)previousViewController searchResultTableView:(UITableView *)searchResultTableView searchResultDataArray:(NSMutableArray *)searchResultDataArray searchHappenBlock:(void(^)())block
{
    if (self = [super init]) {
        self.previousViewController = previousViewController;
        self.searchResultTableView = searchResultTableView;
        self.searchResultDataArray = searchResultDataArray;
        self.searchHappenBlock = block;
    }
    return self;
}

- (UISearchBar *)searchBar {

    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"查找申请";
        _searchBar.showsCancelButton = NO;
        _searchBar.tintColor = [UIColor colorWithHexString:@"#f99740"];// 取消字体颜色和光标颜色
        [_searchBar setBackgroundImage:[UIImage new]];
        _searchBar.barTintColor = [UIColor colorWithHexString:@"#efeff4"];
    }
    return _searchBar;
}

-(UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]initWithFrame:self.previousViewController.view.bounds];
        _backGroundView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 63.5, kScreen_Width, 1)];
        sepView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [_backGroundView addSubview:sepView];
    }
    return _backGroundView;
}

#pragma mark - UISearchBar delegateMethods
//当searchBar开始编辑时
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    NSLog(@"当searchBar称为第一响应者时");
    
    //进入搜索界面后，搜索栏的大小
    _searchBar.frame = CGRectMake(0, 0, kScreen_Width, 44);
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.previousViewController.navigationController.navigationBarHidden = YES;
        _searchBar.showsCancelButton = YES;
        _searchBar.top = 20;
        [self.previousViewController.view addSubview:self.backGroundView];
        [self.previousViewController.view bringSubviewToFront:_searchBar];
        [self.previousViewController.view addSubview:self.searchResultTableView];
    }];
}

// 当searchBar文本内容改变时调用
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchBar.text isEqualToString:@""]) {
        [self.searchResultDataArray removeAllObjects];
        [self.searchResultTableView reloadData];
    }
}

//当用户单击取消按钮时激发该方法
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    //退出搜索界面后，搜索栏的大小
    _searchBar.frame = self.beforeShowSearchBarFrame;
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.previousViewController.navigationController.navigationBarHidden = NO;
        
        _searchBar.showsCancelButton = NO;
        _searchBar.top = 0;
        _searchBar.text = @"";
        
        [self.backGroundView removeFromSuperview];
        self.backGroundView = nil;
        
        [self.searchResultTableView removeFromSuperview];
        
        [_searchBar resignFirstResponder];
    }];
}

//当用户单击虚拟键盘上Search按键时激发该方法
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self searchBarResignAndChangeUI];
    
    self.searchHappenBlock();
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    [self searchBarResignAndChangeUI];
}

- (void)searchBarResignAndChangeUI{
    
    [_searchBar resignFirstResponder];//失去第一响应
    
    [self changeSearchBarCancelBtnTitleColor:_searchBar];//改变布局
    
}

#pragma mark - 遍历改变搜索框 取消按钮的文字颜色

- (void)changeSearchBarCancelBtnTitleColor:(UIView *)view{
    
    if (view) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *getBtn = (UIButton *)view;
            
            [getBtn setEnabled:YES];//设置可用
            
            [getBtn setUserInteractionEnabled:YES];
            
            
            [getBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateReserved];
            
            [getBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateDisabled];
            
            return;
            
        }else{
            
            for (UIView *subView in view.subviews) {
                
                [self changeSearchBarCancelBtnTitleColor:subView];
                
            }
            
        }
        
    }else{
        
        return;
        
    }
    
}

@end
