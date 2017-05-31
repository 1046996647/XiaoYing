//
//  MaintainCompanyinfoVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/21.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "MaintainCompanyInfoVC.h"
#import "CompanyInfoVc.h"
#import "FrameManagerVC.h"
#import "DepartmentTableViewCell.h"
#import "XYSearchBar.h"
#import "DepartmentModel.h"
#import "HXTagsView.h"



@interface MaintainCompanyInfoVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    MBProgressHUD *hud;
    DepartmentModel *_model;
//    NSDictionary *_companyDic;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *baseView;

@property (nonatomic, strong)XYSearchBar *m_searchBar;



@property (nonatomic, strong)UILabel *companyLabel;
@property (nonatomic, strong)UILabel *unitLabel;
//@property (nonatomic, copy)NSString *CompanyId;
//@property (nonatomic, copy)NSString *CompanyName;
//@property (nonatomic, strong)NSNumber *CompanyRanks;

@property (nonatomic, assign)BOOL isCompany;

@property (nonatomic, strong)NSMutableArray *navArr;


@end

@implementation MaintainCompanyInfoVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据
    [self initData];

    [self initBasic];

    [self initBottomView];


}

- (void)initData
{
    _model = [[DepartmentModel alloc] init];
    _model.ParentID = @"";
    _model.superTitle = [UserInfo getcompanyName];
    _model.superRanks = @1;
    // 先加入公司名
    _navArr = [NSMutableArray arrayWithObject:[UserInfo getcompanyName]];
    
    // 所有部门
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    self.departments = arr;
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        if ([dic[@"ParentID"] isEqualToString:@""]) {
            DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
            [arrM addObject:model];
        }
    }
    self.subUnitArray = arrM;

}


- (void)initBasic {
    
    UIView *baseView = [self firstHeaderView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = baseView;
}



#pragma mark --tableViewDelegate--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _subUnitArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 所有部门
    NSArray *arr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];

    // 为每个model上级属性
    DepartmentModel *lastModel = self.subUnitArray[indexPath.row];
    _model.superRanks = lastModel.Ranks;
    _model.superTitle = lastModel.Title;
    _model.ParentID = lastModel.DepartmentId;
    _model.Ranks = lastModel.Ranks;
    _model.comanyName = [UserInfo getcompanyName];
    NSLog(@"%@",lastModel.DepartmentId);

    
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
    
    __weak typeof(self) weakSelf = self;

    DepartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[DepartmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.sendBlock = ^(NSMutableArray *arr) {
            
//            self.departments = arr;

            NSMutableArray *arrM = [NSMutableArray array];
            
            // 公司的
            if ([_model.superRanks integerValue] == 1) {
                for (NSDictionary *dic in arr) {
                    if ([dic[@"ParentID"] isEqualToString:@""]) {
                        DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                        [arrM addObject:model];
                    }
                }
            }
            else {// 部门的
                for (NSDictionary *dic in arr) {
                    
                    // _model.ParentID的ParentID是当前选中的DepartmentId
                    if ([_model.ParentID isEqualToString:dic[@"ParentID"]]) {
                        DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                        [arrM addObject:model];
                    }
                }
            }
            weakSelf.subUnitArray = arrM;
            [weakSelf.tableView reloadData];
            
        };
    }
    
    DepartmentModel *model = _subUnitArray[indexPath.row];
    model.superRanks = _model.superRanks;
    model.superTitle = _model.superTitle;
    model.ParentID = _model.ParentID;
    model.comanyName = [UserInfo getcompanyName];
    
    cell.model = model;
    cell.companyLabel.text = model.Title;
    cell.unitLabel.text = [NSString stringWithFormat:@"%@级单元",model.Ranks];
    cell.type = 0;

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


- (void)initBottomView {
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-64-44, kScreen_Width, 44)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baseView];
    
    //顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_baseView addSubview:topView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    [btn setTitle:@"添加子单元" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(addChildUnitAction) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:btn];
}

- (void)addChildUnitAction {
     NSLog(@"添加子单元");
    
    __weak typeof(self) weakSelf = self;
    
    FrameManagerVC *frameVC = [[FrameManagerVC alloc]init];
    frameVC.type = @"隐藏删除按钮";
    frameVC.departments = self.departments;
    frameVC.sendBlock = ^(NSMutableArray *arr) {
        
        self.departments = arr;

        NSMutableArray *arrM = [NSMutableArray array];
        // 公司的
        if ([_model.superRanks integerValue] == 1) {
            for (NSDictionary *dic in arr) {
                if ([dic[@"ParentID"] isEqualToString:@""]) {
                    DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                    [arrM addObject:model];
                }
            }
        }
        else {// 部门的
            for (NSDictionary *dic in arr) {
                
                // _model.ParentID的ParentID是当前选中的DepartmentId
                if ([_model.ParentID isEqualToString:dic[@"ParentID"]]) {
                    DepartmentModel *model = [[DepartmentModel alloc] initWithContentsOfDic:dic];
                    [arrM addObject:model];
                }
            }
        }
        weakSelf.subUnitArray = arrM;
        [weakSelf.tableView reloadData];
        
    };
//    frameVC.model = _model;
    frameVC.ParentID = _model.ParentID;
    frameVC.DepartmentId = _model.DepartmentId;
    frameVC.superTitle = _model.superTitle;
    frameVC.subTitle = _model.Title;
    frameVC.superRanks = _model.superRanks;
    frameVC.ranks = _model.Ranks;
    frameVC.comanyName = [UserInfo getcompanyName];

    
    [self.navigationController pushViewController:frameVC animated:YES];
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
    
    NSLog(@"tag:%@ index:%ld",sender.titleLabel.text,(long)sender.tag);
    NSInteger index = [_navArr indexOfObject:sender.titleLabel.text];
    NSInteger count = _navArr.count;
    NSString *text = nil;
    if (index > 0) {
        text = [sender.titleLabel.text substringFromIndex:3];
        
    }
    else {
        text = sender.titleLabel.text;
    }
    
    [_navArr removeObjectsInRange:NSMakeRange(index+1, count-(index+1))];
    
    NSMutableArray *arrM = [NSMutableArray array];
    if (index == 0) {
        
        // 切换上级单元
        _model.ParentID = @"";
        _model.superTitle = [UserInfo getcompanyName];
        _model.superRanks = @1;
        
        UIView *baseView = [self firstHeaderView];
        self.unitLabel.text = [NSString stringWithFormat:@"%@级单元",_model.superRanks];
        self.companyLabel.text = _model.superTitle;
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
                _model.superRanks = dic[@"Ranks"];
                _model.superTitle = dic[@"Title"];
                _model.ParentID = dic[@"DepartmentId"];

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
//    [_m_searchBar.searchButton addTarget:self action:@selector(searcgBarClearAction) forControlEvents:UIControlEventTouchUpInside];
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
    self.companyLabel.text = [UserInfo getcompanyName];

    
    UILabel *unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 26, kScreen_Width / 2, 12)];
    //    unitLabel.text = @"4级单元";
    unitLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    unitLabel.font = [UIFont systemFontOfSize:12];
    unitLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:unitLabel];
    self.unitLabel = unitLabel;
    self.unitLabel.text = [NSString stringWithFormat:@"%@级单元",@1];

    return baseView;
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
