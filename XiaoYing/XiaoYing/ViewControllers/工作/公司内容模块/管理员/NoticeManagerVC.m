//
//  NoticeManagerVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "NoticeManagerVC.h"
#import "NoticeManagerViewCell.h"
//#import "AdverPowerVC.h"
//#import "NoticeCell.h"
#import "showWarningVC.h"
#import "CellDetail.h"
#import "WangUrlHelp.h"
#import "CompanyDetailModel.h"
#import "UITableView+showMessageView.h"
#import "BirthdayController.h"
#import "DatepickerView.h"
#import "CellDetail.h"
#import "MSDepartmentViewController.h"


@interface NoticeManagerVC ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UIView *lastView;
//@property (nonatomic,strong) XYSearchBar *m_searchBar;//查找控件
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) UIButton *belowBtn;  //下层遮盖
@property (nonatomic,strong) UIView *screenrView;  //筛选视图
@property (nonatomic) BOOL isClick;  //标记多选按钮是否被点击
@property (nonatomic) BOOL isClickAll;  //标记全选按钮是否被点击
@property(nonatomic,assign)BOOL isClickToSelect;//标记
@property (nonatomic) BOOL isClickCancle;  //标记取消按钮是否被点击
@property(nonatomic,assign)NSInteger currentPage;//当前的页数
@property(nonatomic,assign)NSInteger pageSize;//每页显示条数
@property(nonatomic,assign)NSInteger searchCurrentPage;//搜索当前的页数
@property(nonatomic,strong)UISearchBar *searchBar;//搜索
@property(nonatomic,strong)UITableView *searchResultView;//点击搜索按钮之后出现的搜索界面
@property(nonatomic,strong)UIView *ViewForSearch;//当搜索时的背景图
@property(nonatomic,strong)NSString *startDate;//查询的起始时间
@property(nonatomic,strong)NSString *endDate;//查询的终止时间
@property(nonatomic,strong)NSString *key;//查询关键字
@property(nonatomic,strong)NSMutableArray *searchArray;//搜索得到的数组
@property(nonatomic,strong)NSMutableArray *dataArray;//装载公告的数组
@property(nonatomic,strong)MBProgressHUD *hud;//菊花
@property(nonatomic,strong)UIButton *selectStartTimeButton;// 筛选中开始的时间按钮
@property(nonatomic,strong)UIButton *selectEndTimeButton;   // 筛选中结束的时间按钮
@property(nonatomic,strong)NSMutableArray *selectToDeleteArray;//选中的要删除的数组
@property(nonatomic,strong)UIButton *deleteButton;//删除按钮
@end

@implementation NoticeManagerVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"公告管理";
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
   
    //初始化数组
    self.searchArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.selectToDeleteArray = [NSMutableArray array];
    //初始化一些页数相关
    _pageSize = 20;
    _currentPage = 1;
    _searchCurrentPage = 1;
    _startDate = @"";
    _endDate = @"";
    _key = @"";
    [self getMyPermission];
//    [self getAfficheWithStart:_startDate andEnd:_endDate andKey:_key andCurrentPage:_currentPage andPageSize:_pageSize andIsSearch:NO];
    [self initUI];
    self.tableview.rowHeight = 80;
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载中";
}

-(void) initUI{
    
    //tableView的设置
    [self setTable];
    
    //searchBar的设置
    [self setSearch];
    
    //BottomView设置
    [self initBottomView];
}

#pragma mark - 搜索框设置 methods
-(void)setSearch{
    // 搜索公告
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"查找公告";
    _searchBar.showsCancelButton = NO;
    _searchBar.tintColor = [UIColor colorWithHexString:@"#f99740"];// 取消字体颜色和光标颜色
    [_searchBar setBackgroundImage:[UIImage new]];
    _searchBar.barTintColor = [UIColor colorWithHexString:@"#efeff4"];
    [self.view addSubview:_searchBar];

}

//tableView的设置
- (void)setTable {
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreen_Width, kScreen_Height - 44 - 44) style:UITableViewStylePlain];
    _tableview.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.tableFooterView = [UIView new];
    _tableview.showsVerticalScrollIndicator = NO;
    //取消cell分割线左边空白
    if ([_tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableview setLayoutMargins:UIEdgeInsetsZero];
    }

    [self.view addSubview:_tableview];
    
}
//多选和筛选操作
- (void)initBottomView
{
    //滑动视图引起的特殊位置，再减64
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-64-44, kScreen_Width, 44)];
    //顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:topView];
    
    NSArray *titleArr = @[@"多选",@"筛选"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            btn.frame = CGRectMake(i*(kScreen_Width/2.0), 0, kScreen_Width/2 - 0.5, 44);
        }else{
            btn.frame = CGRectMake(i*(kScreen_Width/2.0) + 0.5, 0, kScreen_Width/2 - 0.5, 44);
        }
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(toolBarAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
    }
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width/2.0 - 0.5, (44-20)/2, 1, 20)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView];
    
    baseView.backgroundColor = [UIColor whiteColor];
    _lastView = baseView;
    [self.view addSubview:baseView];
    
}

- (void)initBottomViewDelete {
    //滑动视图引起的特殊位置，再减64
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame = CGRectMake(0, kScreen_Height-64-44, kScreen_Width, 44);
    _deleteButton.backgroundColor = [UIColor redColor];
    [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    //顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_deleteButton addSubview:topView];
    [_deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteButton];
    
}

- (void)setNewNavigation {
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllAction:)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(canaleAction:)];
    self.navigationItem.leftBarButtonItems = @[backItem];
}

#pragma mark - 多选时候的删除方法 methods
- (void)deleteAction:(UIButton *)btn {
    if (_selectToDeleteArray.count == 0) {
        [MBProgressHUD showMessage:@"未选中任何公告"];
    }else{
        showWarningVC *warningVC = [[showWarningVC alloc] init];
        //模态
        warningVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        warningVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        warningVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
         __block __weak __typeof(&*self)weakSelf = self;
        NSString *str = @"";
        for (int i = 0; i < _selectToDeleteArray.count; i++) {
            if (i == 0) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@",_selectToDeleteArray[i]]];
            }else{
                str = [str stringByAppendingString:[NSString stringWithFormat:@",%@",_selectToDeleteArray[i]]];
            }
        }
        
        warningVC.sureBlock = ^(){
            [weakSelf deleteAffichWithString:str andMuti:YES];
            };
        [self.navigationController presentViewController:warningVC animated:YES completion:nil];
    }
}


#pragma mark - 下方的按钮点击事件 methods
//按钮点击事件
- (void)toolBarAction:(UIButton *)btn {
    if (btn.tag == 0) {
        [self moreChoice];
    }
    else {
        NSLog(@"筛选");
        [self screenAction];
    }
}




//多选按钮
- (void)moreChoice {
    NSLog(@"多选");
    if (self.isClick == NO) {
    }
    //移除之前控件
    [_lastView removeFromSuperview];
    //重写toolBar
    [self initBottomViewDelete];
    //重写navigation
    [self setNewNavigation];
    [self.tableview reloadData];
    
    self.isClick = YES;
}


- (void)backAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}


//全选按钮
- (void)selectAllAction:(UIBarButtonItem *)item {
    NSLog(@"全选");
    if ([item.title isEqualToString:@"全选"]) {
        item.title = @"全不选";
    }else{
        item.title = @"全选";
    }
    self.isClickAll = !self.isClickAll;
    if (self.isClickAll == YES) {
        if (_dataArray.count != 0) {
        for (CompanyDetailModel *model in _dataArray) {
                [_selectToDeleteArray addObject:model.Id];
            }
        [_deleteButton setTitle:[NSString stringWithFormat:@"删除(%ld)",_selectToDeleteArray.count] forState:UIControlStateNormal];
        }
    }else{
        [_selectToDeleteArray removeAllObjects];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    }
    [self.tableview reloadData];
}
//取消按钮
- (void)canaleAction:(UIBarButtonItem *)item {
    NSLog(@"取消");
    _selectToDeleteArray = [NSMutableArray array];
    self.isClick = NO;
    self.isClickAll = NO;
    [self initBottomView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"公告权限" style:UIBarButtonItemStylePlain target:self action:@selector(chooseMoreAction:)];
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 10, 18);
    [backButton setImage:[UIImage imageNamed:@"Arrow-white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //searchBar和tablView位置的改变
//    [self setSearchBar];
    [_tableview setFrame:CGRectMake(0, 44, kScreen_Width, kScreen_Height - 44)];
    [self.tableview reloadData];
}

- (void)chooseMoreAction:(UIBarButtonItem *)item {
    NSLog(@"公告权限");

    MSDepartmentViewController *mulVC = [[MSDepartmentViewController alloc]init];
    mulVC.CompanyName = [UserInfo getcompanyName];
    mulVC.CompanyRanks = @(1);
    mulVC.departments = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    mulVC.title = @"管理公告权限";
    [self.navigationController pushViewController:mulVC animated:YES];
}

#pragma mark - UITableViewDataSource
//每个分区cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _tableview) {//公告
        return _dataArray.count;
    }else{//搜索
        return _searchArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NoticeManagerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NoticeManagerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[NoticeManagerViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (tableView == _tableview) {//公告tableView
        cell.model = _dataArray[indexPath.row];
    }else{
        cell.model = _searchArray[indexPath.row];
    }
    
    [cell.selectbtn setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
    [cell.selectbtn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    cell.selectbtn.tag = indexPath.row;
    //判断多选按钮是否被点击
    if (self.isClick == YES) {
        cell.selectbtn.hidden = NO;
        //判断全选按钮是否被点击
        if (self.isClickAll == YES) {
//            [cell.selectbtn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
            [cell.selectbtn setSelected:YES];
        }else{
            //[cell.selectbtn setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
            [cell.selectbtn setSelected:NO];
        }
    }
    if (self.isClick == NO) {
        cell.selectbtn.hidden = YES;
    }
    
    [cell.selectbtn addTarget:self action:@selector(clickCellSelect:) forControlEvents:UIControlEventTouchUpInside];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor colorWithHexString:@"#d5d7dc"]);
    return cell;
}

#pragma mark - UITableView delegateMethods
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


//cell的删除操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView == _tableview) {//如果不是搜索
            CompanyDetailModel *model = _dataArray[indexPath.row];
            [self deleteAffichWithString:model.Id andMuti:NO];
            [_dataArray removeObjectAtIndex:indexPath.row];
        }else{
            CompanyDetailModel *model = _searchArray[indexPath.row];
            [self deleteAffichWithString:model.Id andMuti:NO];
            [_searchArray removeObjectAtIndex:indexPath.row];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
//单元格将要出现(消除cell左边)
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"您点击了cell%ld", indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CellDetail *detailVC = [[CellDetail alloc]init];
    if (tableView == _tableview) {//公告
        CompanyDetailModel *model = _dataArray[indexPath.row];
        detailVC.afficheid = model.Id;
    }else{//搜索公告
        CompanyDetailModel *model = _searchArray[indexPath.row];
        detailVC.afficheid = model.Id;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

//高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

// 区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

//cell上边选择按钮的点击
- (void)clickCellSelect:(UIButton *)btn {
    btn.selected = !btn.selected;
    CompanyDetailModel *model = _dataArray[btn.tag];
    if (btn.selected == YES) {
        [_selectToDeleteArray addObject:model.Id];
        [_deleteButton setTitle:[NSString stringWithFormat:@"删除(%ld)",_selectToDeleteArray.count] forState:UIControlStateNormal];
    }else{
        [_selectToDeleteArray removeObject:model.Id];
        if (_selectToDeleteArray.count == 0) {
            [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        }else{
            [_deleteButton setTitle:[NSString stringWithFormat:@"删除(%ld)",_selectToDeleteArray.count] forState:UIControlStateNormal];
        }
    }
    NSLog(@"您点击了cell上的button");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 筛选相关方法 methods
//筛选按钮
- (void)screenAction {
    if ( self.isClickToSelect == NO) {
        [self layOutSubView];
    }
    self.isClickToSelect = YES;
}

- (void)layOutSubView {
    //筛选时下层遮盖
    [self backgroundViewa];
    //筛选视图上边控件
    [self subViewOnScreenView];
}

//筛选时下层遮盖
- (void)backgroundViewa {
    _belowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64 + 51, kScreen_Width, kScreen_Height - 64 - 49)];
    _belowBtn.backgroundColor = [UIColor blackColor];
    _belowBtn.alpha = 0.5;
    [_belowBtn addTarget:self action:@selector(belowViewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_belowBtn];
    _screenrView = [[UIView alloc] initWithFrame:CGRectMake(0, 46, kScreen_Width, 30 * 3 + 4 * 12 + 44 - 7)];
    _screenrView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_screenrView];
}

//筛选视图上边控件
- (void)subViewOnScreenView {
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 20, 30)];
    label1.text = @"从";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:16];
    [_screenrView addSubview:label1];
    
    _selectStartTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectStartTimeButton.frame = CGRectMake(60, 12, kScreen_Width - 75, 30);
    _selectStartTimeButton.layer.cornerRadius = 5;
    _selectStartTimeButton.layer.borderWidth = .5;
    _selectStartTimeButton.layer.masksToBounds = YES;
    _selectStartTimeButton.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;

    [_selectStartTimeButton setTitle:@"yyyy-mm-dd" forState:UIControlStateNormal];
    [_selectStartTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selectStartTimeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _selectStartTimeButton.tag = 10;
    [_selectStartTimeButton addTarget:self action:@selector(chooseTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_screenrView addSubview:_selectStartTimeButton];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, _selectStartTimeButton.bottom + 12, 20, 30)];
    label2.text = @"至";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:16];
    [_screenrView addSubview:label2];
    
    _selectEndTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectEndTimeButton.frame = CGRectMake(60, _selectStartTimeButton.bottom + 12,kScreen_Width - 75, 30);
    _selectEndTimeButton.layer.cornerRadius = 5;
    _selectEndTimeButton.layer.borderWidth = .5;
    _selectEndTimeButton.layer.masksToBounds = YES;
    _selectEndTimeButton.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
    [_selectEndTimeButton setTitle:@"yyyy-mm-dd" forState:UIControlStateNormal];
    [_selectEndTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selectEndTimeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _selectEndTimeButton.tag = 11;
    [_selectEndTimeButton addTarget:self action:@selector(chooseTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_screenrView addSubview:_selectEndTimeButton];
    
    if (![_startDate isEqualToString:@""]) {
        [_selectStartTimeButton setTitle:_startDate forState:UIControlStateNormal];
        [_selectEndTimeButton setTitle:_endDate forState:UIControlStateNormal];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, _selectEndTimeButton.bottom + 17, 20, 20)];
    [button setBackgroundImage:[UIImage imageNamed:@"choose2-none"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(screenViewBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_screenrView addSubview:button];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(60, _selectEndTimeButton.bottom + 12, kScreen_Width - 82, 30)];
    label3.text = @"取消筛选";
    label3.textColor = [UIColor colorWithHexString:@"#848484"];
    label3.textAlignment = NSTextAlignmentLeft;
    label3.font = [UIFont systemFontOfSize:14];
    [_screenrView addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 4 * 12 + 3 * 30 - 11, kScreen_Width,0.5)];
    label4.backgroundColor = [UIColor colorWithHexString:@"#d7d5dc"];
    [_screenrView addSubview:label4];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 4 * 12 + 3 * 30 - 11, kScreen_Width,44)];
    [button2 setTitle:@"确定" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    button2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button2 addTarget:self action:@selector(makeSureAction) forControlEvents:UIControlEventTouchUpInside];
    [_screenrView addSubview:button2];
}

- (void)screenViewBtn:(UIButton *)btn{
    NSLog(@"您点击了取消筛选按钮");
    if (self.isClickCancle == NO) {
        [btn setBackgroundImage:[UIImage imageNamed:@"choose2"] forState:UIControlStateNormal];
        self.isClickCancle = YES;
    }else {
        [btn setBackgroundImage:[UIImage imageNamed:@"choose2-none"] forState:UIControlStateNormal];
        self.isClickCancle = NO;
    }
}

//确定筛选
- (void)makeSureAction {
    
    if (self.isClickCancle == NO && ![_selectStartTimeButton.titleLabel.text isEqualToString:@"yyyy-mm-dd"] && ![_selectEndTimeButton.titleLabel.text isEqualToString:@"yyyy-mm-dd"]) {//没有点击取消按钮并且开始和结束的日期也都选上了

        _startDate = _selectStartTimeButton.titleLabel.text;
        _endDate = _selectEndTimeButton.titleLabel.text;
        
        if (![_startDate isEqualToString:@""] && ![_endDate isEqualToString:@""]) {
            NSDate *startDate = [self dateFromString:_startDate];
            NSDate *endDate = [self dateFromString:_endDate];
            
            if ([startDate compare:endDate] == NSOrderedDescending) {//如果开始时间晚于起始时间
                [MBProgressHUD showMessage:@"起始时间不能晚于终止时间"];
            }else{
                [self belowViewAction];
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"正在加载中";
                _key = @"";
                _currentPage = 1;
                _dataArray = [NSMutableArray array];
                
                [self getAfficheWithStart:_startDate andEnd:_endDate andKey:_key andCurrentPage:_currentPage andPageSize:_pageSize andIsSearch:NO];
            }
        }

    }
    if(self.isClickCancle == NO && ([_selectStartTimeButton.titleLabel.text isEqualToString:@"yyyy-mm-dd"] || [_selectEndTimeButton.titleLabel.text isEqualToString:@"yyyy-mm-dd"])){//没有点击取消按钮但是存在有日期没有选上
        [MBProgressHUD showMessage:@"请填完整筛选日期"];
    }
    
    if (self.isClickCancle == YES) {//如果点击了取消筛选按钮
        [self belowViewAction];
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"正在加载中";
        _startDate = @"";
        _endDate = @"";
        _key = @"";
        _currentPage = 1;
        _dataArray = [NSMutableArray array];
       [self getAfficheWithStart:_startDate andEnd:_endDate andKey:_key andCurrentPage:_currentPage andPageSize:_pageSize andIsSearch:NO];
    }
    
    
    NSLog(@"确定");
}

- (void)belowViewAction {
    [_belowBtn removeFromSuperview];
    [_screenrView removeFromSuperview];
    
    self.isClickToSelect = NO;
}

-(void)chooseTimeAction:(UIButton*)button{
    DatepickerView *datepickerView = [[DatepickerView alloc] initWithFrame:CGRectMake(0,kScreen_Height - 320, kScreen_Width, 320)];
    if (![button.titleLabel.text isEqualToString:@"yyyy-mm-dd"]) {
        datepickerView.dateStr = button.titleLabel.text;
    }else{
        datepickerView.dateStr = @"";
    }
    
    if (button.tag == 11 && ![_selectStartTimeButton.titleLabel.text isEqualToString:@"yyyy-mm-dd"]) {//如果已经设置了开始时间的话，那么结束时间一定要比这个要大
        datepickerView.minDateStr = _selectStartTimeButton.titleLabel.text;
    }else{
        datepickerView.minDateStr = @"";
    }
    datepickerView.dataBlock = ^(NSString *dateStr){
        [button setTitle:dateStr forState:UIControlStateNormal];
    };
    UIViewController *dateController = [UIViewController new];
    dateController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    self.definesPresentationContext = YES; //不盖住整个屏幕
    dateController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [dateController.view addSubview:datepickerView];
    [self presentViewController:dateController animated:YES completion:nil];
}

#pragma mark - 网络加载方法 methods
-(void)getAfficheWithStart:(NSString *)start andEnd:(NSString*)end andKey:(NSString*)key andCurrentPage:(NSInteger)currentpage andPageSize:(NSInteger)pageSize andIsSearch:(BOOL)isSearch{
    
    NSString *strUrl = AFFICHE_GETALL,key,currentpage,pageSize,start,end];
    
    [AFNetClient GET_Path:strUrl completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        
        if (code.integerValue == 0){
            NSArray *dataArray = JSONDict[@"Data"];
            NSArray *newArray = [CompanyDetailModel getModelArrayFromModelArray:dataArray];
            if (isSearch == YES) {//如果是搜索的话
                [_searchArray addObjectsFromArray:newArray];
                //如果没有搜索结果的时候，显示没有搜索到结果图片
                [_searchResultView tableViewDisplayNotFoundViewWithRowCount:_searchArray.count];
                [_searchResultView reloadData];
            }else{//如果不是搜索的话
                [_dataArray addObjectsFromArray:newArray];
                [_tableview reloadData];
            }
            [_hud hide:YES];
            _hud = nil;
        }else{
            [_hud hide:YES];
            _hud = nil;
            NSString *message = JSONDict[@"Message"];
            [MBProgressHUD showMessage:message];
        }
    } failed:^(NSError *error) {
        NSLog(@"失败**********=======>>>%@",error);
        [_hud hide:YES];
        _hud = nil;
    }];
}

//删除公告
-(void)deleteAffichWithString:(NSString *)str andMuti:(BOOL)muti{
    NSString *strUrl = AFFICHE_DELETE,str] ;
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载中";
    [AFNetClient POST_Path:strUrl completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        
        if (code.integerValue == 0){
            if (muti == YES) {//是多选这边的删除
                _currentPage = 1;
                _key = @"";
                _dataArray = [NSMutableArray array];
                [self canaleAction:self.navigationItem.rightBarButtonItem];
                [self getAfficheWithStart:_startDate andEnd:_endDate andKey:_key andCurrentPage:_currentPage andPageSize:_pageSize andIsSearch:NO];
            }else{
                [_hud hide:YES];
                _hud = nil;
            }
        }else{
            [_hud hide:YES];
            _hud = nil;
            [MBProgressHUD showMessage:@"删除失败"];
        }
    } failed:^(NSError *error) {
        NSLog(@"失败**********=======>>>%@",error);
        [_hud hide:YES];
        _hud = nil;
    }];
}

-(void)getMyPermission{
    NSString *strUrl = [NSString stringWithFormat:@"%@/api/auth/myfunc?Token=%@",BaseUrl1,[UserInfo getToken]];
    [AFNetClient GET_Path:strUrl completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        
        if (code.integerValue == 0){
//            NSLog(@"我所拥有的权限:%@",JSONDict[@"Data"]);
            NSArray *dataArr = JSONDict[@"Data"];
            for (NSDictionary *subDic in dataArr) {
                if ([subDic[@"Name"] isEqualToString:@"公告管理"]) {
                     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"公告权限" style:UIBarButtonItemStylePlain target:self action:@selector(chooseMoreAction:)];
                }
            }
            [self getAfficheWithStart:_startDate andEnd:_endDate andKey:_key andCurrentPage:_currentPage andPageSize:_pageSize andIsSearch:NO];
        }else{
            NSLog(@"获取权限失败");
            [MBProgressHUD showMessage:JSONDict[@"Message"]];
        }
    } failed:^(NSError *error) {
         NSLog(@"失败**********=======>>>%@",error);
        [MBProgressHUD showMessage:@"网络发生错误"];
    }];
}

#pragma mark - 懒加载 lazyLoad
-(UITableView*)searchResultView{
    if (_searchResultView == nil) {
        //初始化搜索的数组
        _searchArray = [NSMutableArray array];
        _searchResultView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64) style:UITableViewStylePlain];
        //消除分割线左边的空白
        if ([_searchResultView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_searchResultView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_searchResultView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_searchResultView setLayoutMargins:UIEdgeInsetsZero];
        }
        _searchResultView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        //去除底部分割线
        _searchResultView.tableFooterView = [UIView new];
        _searchResultView.delegate = self;
        _searchResultView.dataSource = self;
    }
    return _searchResultView;
}

-(UIView*)ViewForSearch{
    if (_ViewForSearch == nil) {
        _ViewForSearch = [[UIView alloc]initWithFrame:self.view.bounds];
        _ViewForSearch.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 63.5, kScreen_Width, 1)];
        sepView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [_ViewForSearch addSubview:sepView];
    }
    return _ViewForSearch;
}

#pragma mark - UISearchBar delegateMethods
//当搜索之后
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.35 animations:^{
        
        self.navigationController.navigationBarHidden = YES;
        _searchBar.showsCancelButton = YES;
        _searchBar.top = 20;
        [self.view addSubview:self.ViewForSearch];
        [self.view bringSubviewToFront:_searchBar];
        [self.view addSubview:self.searchResultView];
    }];
}

//当点击了取消按钮之后
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.35 animations:^{
        self.navigationController.navigationBarHidden = NO;
        _searchBar.top = 0;
        [self.searchResultView removeFromSuperview];
        self.searchResultView = nil;
        [self.self.ViewForSearch removeFromSuperview];
        self.self.ViewForSearch = nil;
        _searchBar.showsCancelButton = NO;
        [_searchBar resignFirstResponder];
        _searchBar.text = @"";
    }];
}

//当点击了搜索按钮之后
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchBarResignAndChangeUI];
    [_hud removeFromSuperViewOnHide];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载中";
    NSString *start = @"";
    NSString *end = @"";
    NSString *key = searchBar.text;
    [self getAfficheWithStart:start andEnd:end andKey:key andCurrentPage:1 andPageSize:_pageSize andIsSearch:YES];
//    if (_departmentbt.selected == NO) {//搜索公司公告
//        [self GetCompanyNoticeActionWithStart:start andEnd:end andKey:_key andIsSearch:YES];
//    }else{//搜索部门公告
//        [self GetDepartmentNoticeActionWithStart:start andEnd:end andKey:_key andIsSearch:YES];
//    }
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

//将字符串转换成日期
-(NSDate *)dateFromString:(NSString *)string{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:string];
    return date;
}



@end
