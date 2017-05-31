//
//  MaintainCompanyinfoVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/21.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "SelectUnitVC.h"
#import "CompanyInfoVc.h"
#import "DepartmentTableViewCell.h"
#import "XYSearchBar.h"
#import "DepartmentModel.h"
#import "HXTagsView.h"



@interface SelectUnitVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    MBProgressHUD *hud;
    DepartmentModel *_model;
    NSDictionary *_companyDic;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *baseView;

@property (nonatomic, strong)XYSearchBar *m_searchBar;



@property (nonatomic, strong)UILabel *companyLabel;
@property (nonatomic, strong)UILabel *unitLabel;
@property (nonatomic, copy)NSString *CompanyId;
//@property (nonatomic, copy)NSString *CompanyName;
//@property (nonatomic, strong)NSNumber *CompanyRanks;
@property (nonatomic, strong)UIButton *selectBtn;


@property (nonatomic, assign)BOOL firstResponde;



@end

@implementation SelectUnitVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _navArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"选择上级单元";
    
    [self initBasic];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(okAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}



- (void)okAction
{
    if (self.superRanks.integerValue > 1) {
        
        _currentModel = [[DepartmentModel alloc] init];
        _currentModel.superRanks = _model.Ranks;
        _currentModel.superTitle = _model.Title;
        _currentModel.ParentID = _model.DepartmentId;
    }
    else {
        _currentModel = [[DepartmentModel alloc] init];
        _currentModel.superRanks = @1;
        _currentModel.superTitle = _comanyName;
        _currentModel.ParentID = @"";
    }
    
    if (_sendUnitBlock) {
        _sendUnitBlock(_currentModel);
        NSLog(@"---------333-------------------------------%@",_currentModel.ParentID );
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBasic {
    
    // 所有部门
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    self.departments = arr;

    
    UIView *baseView = nil;
    NSMutableArray *arrM = [NSMutableArray array];
    
    NSDictionary *superDic = nil;
    for (NSDictionary *dic in self.departments) {
        
        if ([self.ParentID isEqualToString:dic[@"DepartmentId"]]) {
            superDic = dic;
        }
    }
    
    NSDictionary *superDic1 = nil;
    for (NSDictionary *dic in self.departments) {
        
        if ([superDic[@"ParentID"] isEqualToString:dic[@"DepartmentId"]]) {
            superDic1 = dic;
        }
    }
    
    // 公司的
    if (!superDic1) {
//    if (_navArr.count == 1) {

        for (NSDictionary *dic in self.departments) {
            if ([dic[@"ParentID"] isEqualToString:@""]) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                [arrM addObject:model];
            }
        }
        [_navArr addObject:self.comanyName];
        baseView = [self firstHeaderView];
        self.unitLabel.text = [NSString stringWithFormat:@"%@级单元",@1];
        self.companyLabel.text = self.comanyName;
        
        if ([self.superRanks integerValue] == 1) {
            _selectBtn.selected = YES;
        }
    }
    else {// 部门的
        
        
        for (NSDictionary *dic in self.departments) {


            if ([superDic1[@"DepartmentId"] isEqualToString:dic[@"ParentID"]]) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                //            model.superTitle = lastModel.Title;
                //            model.superRanks = lastModel.Ranks;
                [arrM addObject:model];
            }
        }
        
        
        // 查找父单元
        while (superDic) {

            superDic = [self search:superDic];

            if (superDic) {
                
                NSString *tagTitle = [NSString stringWithFormat:@" > %@",superDic[@"Title"]];
                [_navArr addObject:tagTitle];

            }
//            NSLog(@"!!!!!%@",superDic[@"Title"]);

        }
        
        [_navArr addObject:self.comanyName];
        _navArr = [[_navArr reverseObjectEnumerator] allObjects].mutableCopy;
        
        baseView = [self secondHeaderView:_navArr];

    }
    
    self.subUnitArray = arrM;

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = baseView;
}

// 递归遍历
- (NSDictionary *)search:(NSDictionary *)nextDic
{
//    NSDictionary *superDic = nil;
    for (NSDictionary *dic in self.departments) {
        
        if ([nextDic[@"ParentID"] isEqualToString:dic[@"DepartmentId"]]) {
            nextDic = dic;
            
            return nextDic;
        }
    }
    
    return nil;
}

#pragma mark --tableViewDelegate-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _subUnitArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 所有部门
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    self.departments = arr;

    
    // 为每个model上级属性
    DepartmentModel *lastModel = self.subUnitArray[indexPath.row];
    NSLog(@"%@",lastModel.DepartmentId);
    
    if ([self.DepartmentId isEqualToString:lastModel.DepartmentId]) {
        
        [MBProgressHUD showMessage:@"无法设置子单元为父单元"];
        return;
    }
//    _model.superRanks = lastModel.Ranks;
//    _model.superTitle = lastModel.Title;
//    _model.ParentID = lastModel.DepartmentId;
    
    NSString *tagTitle = [NSString stringWithFormat:@" > %@",lastModel.Title];
    [_navArr addObject:tagTitle];
    
    UIView *baseView = [self secondHeaderView:_navArr];
    _tableView.tableHeaderView = baseView;
    
    // 下一层数据
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        
        
        
        if ([lastModel.DepartmentId isEqualToString:dic[@"ParentID"]]) {
            DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
            //            model.superTitle = lastModel.Title;
            //            model.superRanks = lastModel.Ranks;
            [arrM addObject:model];
        }
    }
    _subUnitArray = arrM;
    [_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    __weak typeof(self) weakSelf = self;
    
    DepartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[DepartmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.sendUnitBlock = ^(DepartmentModel *model)
        {
            NSLog(@"%@",model.DepartmentId);

            if ([self.DepartmentId isEqualToString:model.DepartmentId]) {
                model.isSelected = NO;
                [MBProgressHUD showMessage:@"无法设置子单元为父单元"];
                return;
            }
            
            _firstResponde = YES;
            _selectBtn.selected = NO;
            self.superRanks = model.Ranks;
            
            if (_model != model) {
                _model.isSelected = NO
                ;
                _model = model;

            }

            [_tableView reloadData];
        };
    }
    
    DepartmentModel *model = _subUnitArray[indexPath.row];
    
    if (!_firstResponde) {
        if ([self.ParentID isEqualToString:model.DepartmentId]) {
            model.isSelected = YES;
            _model = model;
        }
    }

//    model.superRanks = _model.superRanks;
//    model.superTitle = _model.superTitle;
//    model.ParentID = _model.DepartmentId;

    cell.model = model;
    cell.companyLabel.text = model.Title;
    cell.unitLabel.text = [NSString stringWithFormat:@"%@级单元",model.Ranks];
    cell.type = 1;

    cell.departments = self.departments;
    if (indexPath.row == 0) {
        cell.upLineLabel.hidden = YES;
    }
    else {
        cell.upLineLabel.hidden = NO;

    }
    if (indexPath.row == _subUnitArray.count - 1) {
        cell.downLineLabel.hidden = YES;
    }
    else {
        cell.downLineLabel.hidden = NO;
    }
    
    return cell;
}
// 搜索框上的X按钮事件
- (void)searcgBarClearAction {
    _m_searchBar.text = @"";
    [_m_searchBar resignFirstResponder];
    _m_searchBar.searchButton.hidden = YES;
}
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.m_searchBar.searchButton.hidden = NO;
    return YES;
}






#pragma mark HXTagsViewDelegate

/**
 *  tagsView代理方法
 *
 *  @param tagsView tagsView
 *  @param sender   tag:sender.titleLabel.text index:sender.tag
 */
- (void)tagsViewButtonAction:(HXTagsView *)tagsView button:(UIButton *)sender {
    
    // 所有部门
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    self.departments = arr;

    
    NSLog(@"tag:%@ index:%ld",sender.titleLabel.text,(long)sender.tag);
    NSInteger index = [_navArr indexOfObject:sender.titleLabel.text];
    NSInteger count = _navArr.count;
    NSString *text = [sender.titleLabel.text substringFromIndex:3];
    
    [_navArr removeObjectsInRange:NSMakeRange(index+1, count-(index+1))];
    
    NSMutableArray *arrM = [NSMutableArray array];
    if (index == 0) {
        
        // 切换上级单元
//        _model.ParentID = @"";
//        _model.superTitle = _companyDic[@"CompanyName"];
//        _model.superRanks = _companyDic[@"CompanyRanks"];
        
        UIView *baseView = [self firstHeaderView];
        self.unitLabel.text = [NSString stringWithFormat:@"%@级单元",@1];
        self.companyLabel.text = self.comanyName;
        _tableView.tableHeaderView = baseView;
        
        for (NSDictionary *dic in arr) {
            if ([dic[@"ParentID"] isEqualToString:@""]) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                [arrM addObject:model];
            }
        }
    }
    else {
        
        UIView *baseView = [self secondHeaderView:_navArr];
        _tableView.tableHeaderView = baseView;
        
        NSDictionary *superDic = nil;
        for (NSDictionary *dic in arr) {
            
            if ([text isEqualToString:dic[@"Title"]]) {
                superDic = dic;
                
                // 切换上级单元
//                _model.superRanks = dic[@"Ranks"];
//                _model.superTitle = dic[@"Title"];
//                _model.ParentID = dic[@"DepartmentId"];
                
            }
        }
        for (NSDictionary *dic in arr) {
            
            
            if ([superDic[@"DepartmentId"] isEqualToString:dic[@"ParentID"]]) {
                DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                //            model.superTitle = lastModel.Title;
                //            model.superRanks = lastModel.Ranks;
                [arrM addObject:model];
            }
        }
        
    }
    
    _subUnitArray = arrM;
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)firstHeaderView
{
    // 头视图
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 56)];
    //搜索框
//    _m_searchBar = [[XYSearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
//    //    _m_searchBar.showsCancelButton = NO;
//    //    _m_searchBar.barStyle = UIBarStyleDefault;
//    _m_searchBar.placeholder = @"找单元";
//    _m_searchBar.delegate = self;
////    [_m_searchBar.searchButton addTarget:self action:@selector(searcgBarClearAction) forControlEvents:UIControlEventTouchUpInside];
//    [baseView addSubview:_m_searchBar];
    
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:whiteView];
    
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 6, kScreen_Width - 56, 16)];
    //    companyLabel.text = @"杭州赢莱金融服务有限公司";
    companyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    companyLabel.font = [UIFont systemFontOfSize:14];
    companyLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:companyLabel];
    self.companyLabel = companyLabel;
    
    
    UILabel *unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 26, kScreen_Width / 2, 12)];
    //    unitLabel.text = @"4级单元";
    unitLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    unitLabel.font = [UIFont systemFontOfSize:12];
    unitLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:unitLabel];
    self.unitLabel = unitLabel;
    
    _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width - 40, 0, 40, 40)];
    [_selectBtn setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:_selectBtn];
    
    return baseView;
}

- (void)selectAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    self.superRanks = @1;
    _currentModel = [[DepartmentModel alloc] init];
    _currentModel.superRanks = @1;
    _currentModel.superTitle = _comanyName;
    _currentModel.ParentID = @"";
    
    _firstResponde = YES;
    _model.isSelected = NO;


    [_tableView reloadData];
}

- (UIView *)secondHeaderView:(NSMutableArray *)arrM
{
    // 更换头视图
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
    
    //搜索框
//    _m_searchBar = [[XYSearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
//    //    _m_searchBar.showsCancelButton = NO;
//    //    _m_searchBar.barStyle = UIBarStyleDefault;
//    _m_searchBar.placeholder = @"找单元";
//    _m_searchBar.delegate = self;
//    [_m_searchBar.searchButton addTarget:self action:@selector(searcgBarClearAction) forControlEvents:UIControlEventTouchUpInside];
//    [baseView addSubview:_m_searchBar];
    
    //多行不滚动,则计算出全部展示的高度,让maxHeight等于计算出的高度即可,初始化不需要设置高度
    HXTagsView *tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    tagsView.type = 0;
    [tagsView setTagAry:arrM delegate:self];
    [baseView addSubview:tagsView];
    baseView.height = tagsView.bottom;
    return baseView;
    
}

@end
