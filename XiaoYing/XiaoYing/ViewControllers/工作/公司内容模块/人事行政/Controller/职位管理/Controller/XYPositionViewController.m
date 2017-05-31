//
//  XYPositionViewController.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/7/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//


//主界面
#import "XYPositionViewController.h"
//#import "XYWorkerCell.h"

#import "XYWorkChooseCateVc.h"
#import "XYWorkSettingBar.h"

#import "XYWorkSettingView.h"

#import "XYPositionSetNewNameVc.h"

//尝试
//#import "XYWorkJobSecondVc.h"


//#import "XYWorkerCell.h"

#import "XYWorkChooseCell.h"
#import "XYPositionAddListVc.h"
#import "XYAddListVc.h"
#import "XYDeleteListVc.h"

//cell
#import "DepartmentTableViewCell.h"
#import "XYPositionEditCell.h"
#import "XYCategoryModel.h"
#import "XYPositionRenameCell.h"

#import "CompanyJobViewModel.h"

#import "XYExtend.h"
#import "XYCategoryAndJobModel.h"
#import "XYEditPositionVc.h"
#import "XYSelectJobCell.h"

#import "UITableView+showMessageView.h"

typedef NS_ENUM(NSUInteger, CategoryShowType) {
    CategoryShowTypeDisplay,
    CategoryShowTypeDelete,
    CategoryShowTypeRename,
};

typedef void(^getJobMessageSuccess)(XYJobModel *);

@interface XYPositionViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, XYPositionAddListDelegate, XYPositionSetNewNameVcDelegate>
{
    NSIndexPath *selectIndex;
    BOOL isOpen;
    
    MBProgressHUD *_waitHUD;  //waitHUD
}


@property (nonatomic, strong) UIButton *redButton;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *positionCategoryTableView;
@property (nonatomic, strong) XYWorkSettingView *settingView;

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *leftBarButton;
@property (nonatomic, strong) UINavigationController *nav;

@property (nonatomic, assign) CategoryShowType categoryShowType;

@property (nonatomic) NSInteger selectSection;

//判断cell是否被点击
@property (nonatomic, assign, setter=isEdit:) BOOL edit;

//删除按钮
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UILabel *titleLabel;

//删除组
@property (nonatomic, strong) NSMutableArray *deleteArray;

@property (nonatomic, strong) UIButton *selectButton;


@property (nonatomic, strong) NSMutableArray *selectArray;


//数据数组
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSIndexPath *lastIndexPath;
@property (nonatomic, strong) NSMutableArray *textArray;

@property (nonatomic, copy) getJobMessageSuccess getJobBlock;
@property (nonatomic, copy) NSString *oldJobNameStr;

//搜索
@property (nonatomic, strong) UISearchBar *search;
@property (nonatomic, strong) UITableView *searchResultTableView;
@property (nonatomic, strong) NSMutableArray *searchResultDataArray;

@end

@implementation XYPositionViewController

/**
//懒加载 职位类别的 假数据的 模型数组
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        NSDictionary *dict1 = @{@"CategroyName":@"行政部", @"Count":@10, @"ID":@(1)};
        NSDictionary *dict2 = @{@"CategroyName":@"软件开发部", @"Count":@20, @"ID":@(2)};
        NSDictionary *dict3 = @{@"CategroyName":@"软件运营部", @"Count":@30, @"ID":@(3)};
        
        NSMutableArray * tempArray = [NSMutableArray array];
        XYCategoryModel * model1 = [[XYCategoryModel alloc]initWithDict:dict1];
        XYCategoryModel * model2 = [[XYCategoryModel alloc]initWithDict:dict2];
        XYCategoryModel * model3 = [[XYCategoryModel alloc]initWithDict:dict3];
        [tempArray addObject:model1];
        [tempArray addObject:model2];
        [tempArray addObject:model3];
        _dataArray = tempArray;
    }
    
    return _dataArray;
}
**/

- (UITableView *)searchResultTableView
{
    if (!_searchResultTableView) {
        
        _searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64) style:UITableViewStyleGrouped];
        _searchResultTableView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        _searchResultTableView.delegate = self;
        _searchResultTableView.dataSource = self;
        
        if ([_searchResultTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_searchResultTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_searchResultTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_searchResultTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _searchResultTableView;
}

- (NSMutableArray *)searchResultDataArray
{
    if (!_searchResultDataArray) {
        _searchResultDataArray = [NSMutableArray array];
    }
    return _searchResultDataArray;
}

- (NSMutableArray *)deleteArray
{
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

//根据用户Token从服务器端获取所有的职位类别
- (void)getDataFormWeb
{
    //waitHUD
    _waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //发送网络请求,获取类别列表
    [CompanyJobViewModel getCategoryListWithKeyText:@"" success:^(NSArray *categoryList) {
        
        NSLog(@"职位类别信息:%@", categoryList);
        NSMutableArray *tempModelArray = [NSMutableArray array];
        for (NSDictionary *dict in categoryList) {
            
            XYCategoryModel *model = [[XYCategoryModel alloc] initWithDict:dict];
            [tempModelArray addObject:model];
        }
        self.dataArray = tempModelArray;
        [self.positionCategoryTableView reloadData];
        
        //waitHUD
        [_waitHUD hide:YES];
        
    } failed:^(NSError *error) {
        
        //waitHUD
        [_waitHUD hide:YES];
        
        NSLog(@"无法获取职位类别信息:%@", error);
    }];
    
    
}

//根据职位类别ID去服务器端删除对应的职位类别
- (void)deleteCategoryByCategoryId:(NSString *)categoryId
{
    //waitHUD
//    _waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [CompanyJobViewModel deleteCategoryWithCategoryId:categoryId success:^(NSString *deletedCategoryId) {
        
        [self.deleteArray removeObject: deletedCategoryId];
        NSInteger count = self.deleteArray.count;
        [self.deleteButton setTitle:[NSString stringWithFormat:@"删除(%ld)",count] forState:UIControlStateNormal];
        [self getDataFormWeb];
        
        //waitHUD
//        [_waitHUD hide:YES];
        
    } failed:^(NSError *error) {
        
        //waitHUD
//        [_waitHUD hide:YES];
        
        NSLog(@"%@",error);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"职位管理";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];

    [self setupNavigationBarButton];//导航栏按钮的设置
    [self setupUI];//ui界面
    
    self.deleteArray = [NSMutableArray array];

    //设置tableView分割线的偏移量
    if ([self.positionCategoryTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.positionCategoryTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.positionCategoryTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.positionCategoryTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self setupMonitor];
    
    [self setupNavigationBarButtonToNil];
}

/**
 导航栏按钮的设置
 (clickWriteButton:)
 (clickAddButton:)
 */
- (void)setupNavigationBarButton{
    
    // 编辑按钮
    UIButton *writeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [writeBtn setImage:[UIImage imageNamed:@"rename_white"] forState:UIControlStateNormal];
    [writeBtn addTarget:self action:@selector(clickWriteButton:) forControlEvents:UIControlEventTouchUpInside];
    [writeBtn sizeToFit];
    
    UIView *btnView = [[UIView alloc]initWithFrame:writeBtn.frame];
    [btnView addSubview:writeBtn];
    UIBarButtonItem * writeButton = [[UIBarButtonItem alloc]initWithCustomView:btnView];
    
    // 添加按钮
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"add_approva"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn sizeToFit];
    
    UIView *btnView1 = [[UIView alloc]initWithFrame:addBtn.frame];
    [btnView1 addSubview:addBtn];
    
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc]initWithCustomView:btnView1];
    
    // 占位按钮1
    UIBarButtonItem *spaceBarButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceBarButton1.width = -5;
    
    // 占位按钮2
    UIBarButtonItem *spaceBarButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceBarButton2.width = 15;

    
    self.navigationItem.rightBarButtonItems = @[spaceBarButton1, addButton, spaceBarButton2, writeButton];
    
}

/**
 1.search
 2.positionCategoryTableView
 3.tableFooterView
 */
- (void)setupUI{
    
    //1.search
    HSSearchTableView *searchTableView = [[HSSearchTableView alloc] initWithPreviousViewController:self searchResultTableView:self.searchResultTableView searchResultDataArray:self.searchResultDataArray searchHappenBlock:^{
        
        [CompanyJobViewModel getCategoryListWithKeyText:self.search.text success:^(NSArray *categoryList) {
            
            [self.searchResultDataArray addObjectsFromArray:[XYCategoryAndJobModel getModelArrayFromOriginArray:categoryList]];
            
            //如果没有搜索结果的时候，显示没有搜索到结果图片
            [self.searchResultTableView tableViewDisplayNotFoundViewWithRowCount:self.searchResultDataArray.count];
            
            [self.searchResultTableView reloadData];
            
        } failed:^(NSError *error) {
            
            
        }];
        
    }];
    [self.view addSubview:searchTableView];//只是为了长持有
    searchTableView.beforeShowSearchBarFrame = CGRectMake(0, 0, kScreen_Width, 44);
    
    self.search = searchTableView.searchBar;
    self.search.frame = CGRectMake(0, 0, kScreen_Width, 44);
    self.search.placeholder = @"找职位";
    [self.view addSubview:self.search];
    
    //2.positionCategoryTableView
    self.positionCategoryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.search.bottom, kScreen_Width, kScreen_Height - 64 - self.search.height)];
    self.positionCategoryTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, self.positionCategoryTableView.bottom, kScreen_Width, 30)];
    self.positionCategoryTableView.backgroundColor = [UIColor clearColor];
    self.positionCategoryTableView.delegate = self;
    self.positionCategoryTableView.dataSource = self;
    self.positionCategoryTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.positionCategoryTableView];

    
    //3.tableFooterView
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"当类别里没有职务时,该类别将自动删除!";
    self.titleLabel.text = @"";
    CGSize size = CGSizeMake(kScreen_Width, MAXFLOAT);
    CGSize titleSize = [self.titleLabel sizeThatFits:size];
    self.titleLabel.frame = CGRectMake(0, 12, kScreen_Width, titleSize.height);
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.positionCategoryTableView.tableFooterView addSubview:self.titleLabel];
    
    
}

/**
 点击编辑按钮后的首先进入 类别删除界面
 (clickCancel)点击取消
 (clickSave)点击重命名
 (clickDeleteButton)点击删除
 */
-(void)clickWriteButton:(UIButton *)button{
    
    self.title = @"编辑类别";
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
    
    //leftBarButton
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftButton addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    
    UIView * leftView = [[UIView alloc]initWithFrame:leftButton.frame];
    [leftView addSubview:leftButton];
    
    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    //rightBarButton
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitle:@"重命名" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickSave:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    
    UIView * rightView = [[UIView alloc]initWithFrame:rightButton.frame];
    [rightView addSubview:rightButton];
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
   /********** 删除按钮 *********/
    //点击编辑出现删除按钮
    NSInteger buttonY = (kScreen_Height -44 - 64);
    self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, buttonY, kScreen_Width, 44)];
    [self.view addSubview:self.deleteButton];
    
    //出现删除按钮后，positionCategoryTableView的高度需要减去 删除按钮的高度
    self.positionCategoryTableView.frame = CGRectMake(0, self.search.bottom, kScreen_Width, kScreen_Height - 64 - self.search.height - 44 + self.positionCategoryTableView.tableFooterView.height);
    
    //count 这个到时候要更改
    NSInteger count = 0;
    [self.deleteButton setTitle:[NSString stringWithFormat:@"删除(%ld)",count] forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundColor:[UIColor redColor]];
    [self.deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.hidden = YES;
    
    self.categoryShowType = CategoryShowTypeDelete;
    
    [self.positionCategoryTableView reloadData];
    
}

//添加界面
-(void)clickAddButton:(UIButton *)button{
    
    
    //弹出添加类别窗口
    XYPositionAddListVc * addList = [[XYPositionAddListVc alloc]init];
    addList.delegate = self;
    addList.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    addList.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    addList.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self presentViewController:addList animated:YES completion:nil];
    
    //
    
    
}

#pragma mark 点击下面的删除按钮
-(void)clickDeleteButton{
    
    NSLog(@"删除");
    
    //waitHUD
    _waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self getEmployeeCountInsideCategoryByCategoryId:self.deleteArray finish:^(NSInteger empolyeeCount) {
        
        //waitHUD
        [_waitHUD hide:YES];
        
        if (empolyeeCount) {
            
            [MBProgressHUD showError:@"有成员存在,不能删除!" toView:self.navigationController.view];
        }else {
        
            XYDeleteListVc * deleteListVc = [[XYDeleteListVc alloc]init];
            deleteListVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            deleteListVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            deleteListVc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            [self presentViewController:deleteListVc animated:YES completion:nil];
        
        }
        
    }];
    
}

//点击取消
-(void)clickCancel{
    
    self.deleteArray = nil;
    [self resetPositionviewController];
}

//点击编辑按钮
-(void)clickSave:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"重命名"]) {
        
        self.deleteArray = nil;
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        
        NSInteger count = self.deleteArray.count;
        [self.deleteButton setTitle:[NSString stringWithFormat:@"删除(%ld)",count] forState:UIControlStateNormal];
        
        [self.deleteButton setHidden:YES];
        self.categoryShowType = CategoryShowTypeRename;
        [self.positionCategoryTableView reloadData];
    }else {
        [btn setTitle:@"重命名" forState:UIControlStateNormal];
        [self.deleteButton setHidden:NO];
        self.categoryShowType = CategoryShowTypeDelete;
        [self.positionCategoryTableView reloadData];
    }
    
}

//刷回原有的positionVC界面
- (void)resetPositionviewController
{
    self.title  = @"职位管理";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [self setupNavigationBarButton];
    
    //重新设置回去
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"Arrow-white"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 40, 30);
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *leftView = [[UIView alloc] initWithFrame:leftBtn.frame];// 加这个view为了限制点击的范围
    [leftView addSubview:leftBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
    
    self.categoryShowType = CategoryShowTypeDisplay;
    self.deleteButton.hidden = YES;
    self.titleLabel.hidden = !self.deleteButton.hidden;
    
    self.positionCategoryTableView.frame = CGRectMake(0, self.search.bottom, kScreen_Width, kScreen_Height - 64 - self.search.height);
    
    [self.positionCategoryTableView reloadData];
}

#pragma mark 即将将试图加载到窗口
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    XYWorkChooseCell * cell = [[XYWorkChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellJob"];
    cell.backgroundColor = [UIColor whiteColor];
    
    //发送网络请求,获取类别列表
    [self getDataFormWeb];
    
    /*
    if (self.search.showsCancelButton) {
        [self.search becomeFirstResponder];
    }
    */
    
    if (self.search.top != 0) {//如果还在搜索阶段，隐藏导航栏
        self.navigationController.navigationBarHidden = YES;
    }
    
}

//设置本类需要监听的广播
- (void)setupMonitor
{
    //注册通知中心删除
    NSNotificationCenter *delete = [NSNotificationCenter defaultCenter];
    [delete addObserver:self selector:@selector(deleteList) name:@"delete" object:nil];
    
    //通知中心添加
    NSNotificationCenter *addData = [NSNotificationCenter defaultCenter];
    [addData addObserver:self selector:@selector(addDataButton:) name:@"add" object:nil];
    
    //通知中心移除
    NSNotificationCenter *moveData = [NSNotificationCenter defaultCenter];
    [moveData addObserver:self selector:@selector(removeDataButton:) name:@"remove" object:nil];
}

#pragma mark 通知中心方法

//cell->add->addDataButton
-(void)addDataButton:(NSNotification*)notification{

    NSString *categoryIdStr = notification.userInfo[@"categoryId"];
    [self.deleteArray addObject: categoryIdStr];
    
    NSInteger count = self.deleteArray.count;
    [self.deleteButton setTitle:[NSString stringWithFormat:@"删除(%ld)",count] forState:UIControlStateNormal];

    NSLog(@"self.deleteArray~~~%@", self.deleteArray);
    
}

//cell->remove->removeDataButton
-(void)removeDataButton:(NSNotification*)notification{

    NSString *categoryIdStr = notification.userInfo[@"categoryId"];
    [self.deleteArray removeObject: categoryIdStr];
    
    NSInteger count = self.deleteArray.count;
    [self.deleteButton setTitle:[NSString stringWithFormat:@"删除(%ld)",count] forState:UIControlStateNormal];
    
     NSLog(@"self.deleteArray~~~%@", self.deleteArray);
}

//view->delete->deleteList
-(void)deleteList{
    
    //1.遍历deleteArray数组，通过数组里面的categoryId属性，逐条在服务器删除职位类别
    for (NSString *str in self.deleteArray) {

        [self deleteCategoryByCategoryId: str];

    }

}

#pragma mark 返回
-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark UITableView数据源的设置

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == _positionCategoryTableView) {
        return 1;
    }else {
        return self.searchResultDataArray.count;
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView == _positionCategoryTableView) {
        return self.dataArray.count;
    }else {
        
        XYCategoryAndJobModel *categoryAndJobModel = [self.searchResultDataArray objectAtIndex:section];
        return categoryAndJobModel.jobModelArray.count;
    }
}

//每个section头部的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (tableView == _positionCategoryTableView) {
        return nil;
        
    }else {
        
        XYCategoryAndJobModel *categoryAndJobModel = [self.searchResultDataArray objectAtIndex:section];
        return categoryAndJobModel.categoryModel.categoryName;
    }
}

//每个section头部标题高度（实现这个代理方法后前面sectionFooterHeight设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _positionCategoryTableView) {
        return 0;
    }else {
        return 25;
    }
}

//每个section底部标题高度（实现这个代理方法后前面sectionHeaderHeight设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _positionCategoryTableView) {
        
        if (self.categoryShowType == CategoryShowTypeDisplay) {
            
            //选择cell（自定义）
            XYWorkChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellJob"];
            
            if (cell == nil) {
                
                cell = [[XYWorkChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellJob"];
            }
            
            if (self.edit == 1) {
                [UIView animateWithDuration:1 animations:^{
                    
                    cell.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
                    
                }];
                
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            XYCategoryModel *categaryModel = self.dataArray[indexPath.row];
            cell.title = categaryModel.categoryName;
            cell.detail = [NSString stringWithFormat:@"%ld", (long)categaryModel.positionCount];
            
            return cell;
        }else if (self.categoryShowType == CategoryShowTypeDelete) {
            
            // 编辑cell（自定义cell）
            XYPositionEditCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EDITCELL"];
            if (cell == nil) {
                
                cell = [[XYPositionEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EDITCELL"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            XYCategoryModel *categaryModel = self.dataArray[indexPath.row];
            cell.model = categaryModel;
            [cell.selectButton setSelected:NO];
            
            return cell;
            
        }else {
            
            XYPositionRenameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RENAMECELL"];
            if (!cell) {
                cell = [[XYPositionRenameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RENAMECELL"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            XYCategoryModel *categaryModel = self.dataArray[indexPath.row];
            cell.categoryModel = categaryModel;
            
            return cell;
  
        }
        
    }else {
        
        if (self.getJobBlock) {
            
            XYSelectJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SELECTJOBCELL"];
            if (cell == nil) {
                
                cell = [[XYSelectJobCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SELECTJOBCELL"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            XYCategoryAndJobModel *categoryAndJobModel = [self.searchResultDataArray objectAtIndex:indexPath.section];
            XYJobModel *jobModel = [categoryAndJobModel.jobModelArray objectAtIndex:indexPath.row];
            cell.jobNameStr = jobModel.jobName;
            cell.selectJobNameStr = self.oldJobNameStr;
            
            return cell;
            
        }else {
        
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ORIGINCELL"];
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ORIGINCELL"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            XYCategoryAndJobModel *categoryAndJobModel = [self.searchResultDataArray objectAtIndex:indexPath.section];
            XYJobModel *jobModel = [categoryAndJobModel.jobModelArray objectAtIndex:indexPath.row];
            cell.textLabel.text = jobModel.jobName;
            
            return cell;
        
        }
        
    }
    
}

//点击任意行类别，跳转到对应类别下的职位
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _positionCategoryTableView) {
        
        if (self.categoryShowType == CategoryShowTypeDisplay) {  //跳转到该职位类别下的职位展示界面
            NSLog(@"Xcel");
            
            XYCategoryModel *categoryModel = [self.dataArray objectAtIndex:indexPath.row];
            
            XYAddListVc *addList = [[XYAddListVc alloc]init];
            
            addList.categoryMessageModel = categoryModel;
            
            if (self.getJobBlock) {
                
                //1.
                [addList getJobModelWithOldJobName:self.oldJobNameStr successBlock:^(XYJobModel *jobModel) {
                    
                    if (jobModel) {
                        self.getJobBlock(jobModel);
                    }
                    [self.navigationController popViewControllerAnimated:NO];
                }];
                [self.navigationController pushViewController:addList animated:YES];
                
            }else {
                
                [self.navigationController pushViewController:addList animated:YES];
            }
            
        }else if (self.categoryShowType == CategoryShowTypeDelete) {
            
            
        }
        
    }else {
        
        XYCategoryAndJobModel *categoryAndJobModel = [self.searchResultDataArray objectAtIndex:indexPath.section];
        
        XYEditPositionVc * editPositionVc = [[XYEditPositionVc alloc]init];
        editPositionVc.categoryModel = categoryAndJobModel.categoryModel;
    
        XYJobModel *jobModel = [categoryAndJobModel.jobModelArray objectAtIndex:indexPath.row];
        editPositionVc.jobModel = jobModel;
        
        if (self.getJobBlock) {
            
            //1.UI确定效果
            self.oldJobNameStr = jobModel.jobName;
            [self.searchResultTableView reloadData];
            [self.positionCategoryTableView reloadData];
            
            //2.调用block
            self.getJobBlock(jobModel);
            
            //3.
            self.search.showsCancelButton = NO;
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popViewControllerAnimated:NO];
            
        }else {
        
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController pushViewController:editPositionVc animated:YES];
        }
        
    }
    
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44;
}

//cell底下的线
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

#pragma mark XYPositionDelegate
- (BOOL)contrastToData:(NSString *)categaryName
{
    for (XYCategoryModel *model in _dataArray) {
        
        NSString *str = model.categoryName;
        if ([categaryName isEqualToString:str]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)refreshDelegationView
{
    [self getDataFormWeb];
}

- (void)getJobMessageWithOldJobName:(NSString *)oldJobName successBlock: (void(^)(XYJobModel *jobModel))block
{
    if (block) {
        
        //1.
        self.getJobBlock = block;
        
        //2.
        self.oldJobNameStr = oldJobName;
        
    }
}

- (void)setupNavigationBarButtonToNil
{
    if (self.getJobBlock) {
        self.navigationItem.rightBarButtonItems = @[];
    }
}

- (void)getEmployeeCountInsideCategoryByCategoryId:(NSArray *)categoryIdArray finish:(void(^)(NSInteger empolyeeCount))finish
{
    __block NSInteger count = 0;
    __block NSInteger number = 0;
    
    for (NSString *categoryId in categoryIdArray) {
            
        [CompanyJobViewModel getEmpolyeeCountWithCategoryId:categoryId success:^(NSInteger empolyeeCount) {
            
            number += empolyeeCount;
            
            if (++count == categoryIdArray.count) {
                
                if (finish) {
                    finish(number);
                }
            }else {
            
                if (number > 0) {
                    
                    if (finish) {
                        finish(number);
                    }
                }
            
            }
            
        } failed:^(NSError *error) {
            
            NSLog(@"获取职位类别下的员工数量失败:%@",error);
        }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
}

@end

