//
//  XYAddListVc.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/20.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYAddListVc.h"
#import "XYWorkAddPositionVc.h"
#import "XYEditPositionVc.h"
#import "XYJobModel.h"
#import "CompanyJobViewModel.h"
#import "XYSelectJobCell.h"
#import "XYExtend.h"

#import "UITableView+showMessageView.h"

typedef void(^getJobModelSuccess)(XYJobModel *);

@interface XYAddListVc () <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource, XYWorkAddPositionDelegate>

@property (nonatomic, strong) UITableView * positionTabelView;
@property (nonatomic, strong) NSMutableArray *jobMessageMutableArray;

@property (nonatomic, strong) XYJobModel *getModelSuccess;
@property (nonatomic, copy) getJobModelSuccess getModelSuccessBlock;
@property (nonatomic, copy) NSString *selectJobName;

@property (nonatomic, strong) UISearchBar * search;
@property (nonatomic, strong) UITableView *searchResultTableView;
@property (nonatomic, strong) NSMutableArray *searchResultDataArray;
@property (nonatomic, strong) HSSearchTableView *searchTableView;


@end

@implementation XYAddListVc
{
    MBProgressHUD *_waitHUD;  //waitHUD
}

- (NSMutableArray *)jobMessageMutableArray
{
    if (!_jobMessageMutableArray) {
        _jobMessageMutableArray = [[NSMutableArray alloc] init];
    }
    return _jobMessageMutableArray;
}

- (NSMutableArray *)searchResultDataArray
{
    if (!_searchResultDataArray) {
        _searchResultDataArray = [[NSMutableArray alloc] init];
    }
    return _searchResultDataArray;
}

- (UITableView *)searchResultTableView
{
    if (!_searchResultTableView) {
        _searchResultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - self.search.bottom - 64)];
        _searchResultTableView.delegate = self;
        _searchResultTableView.dataSource = self;
        _searchResultTableView.tableFooterView = [UIView new];
        _searchResultTableView.backgroundColor = [UIColor clearColor];
    }
    return _searchResultTableView;
}

- (NSString *)selectJobName
{
    if (!_selectJobName) {
        _selectJobName = @"";
    }
    return _selectJobName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.categoryMessageModel.categoryName;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self setupUI];
    [self setupNav];
    
    [self getJobMessageByCategoryId:self.categoryMessageModel.categoryId];
    
    [self setupNavigationBarWithCenterButton];
}

- (void)getJobMessageByCategoryId:(NSString *)categoryId
{
    //waitHUD
    _waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [CompanyJobViewModel getJobListWithCategoeyId:categoryId keyText:@"" success:^(NSArray *dataList) {
        
        self.jobMessageMutableArray = [XYJobModel getModelArrayFromOriginArray:dataList];
        
        [self.positionTabelView reloadData];
        
        //waitHUD
        [_waitHUD hide:YES];
        
    } failed:^(NSError *error) {
        
        //waitHUD
        [_waitHUD hide:YES];
        
        NSLog(@"%@", error);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*
    if (self.search.showsCancelButton) {
        [self.search becomeFirstResponder];
    }
    */
    
    if (self.search.top != 0) {//如果还在搜索阶段，隐藏导航栏
        self.navigationController.navigationBarHidden = YES;
    }
  
}

//添加UI界面
-(void)setupUI{
    
    //search
    self.searchTableView = [[HSSearchTableView alloc] initWithPreviousViewController:self searchResultTableView:self.searchResultTableView searchResultDataArray:self.searchResultDataArray searchHappenBlock:^{
        
        [CompanyJobViewModel getJobListWithCategoeyId:self.categoryMessageModel.categoryId keyText:self.search.text success:^(NSArray *dataList) {
            
            [self.searchResultDataArray addObjectsFromArray:[XYJobModel getModelArrayFromOriginArray:dataList]];
            
            //如果没有搜索结果的时候，显示没有搜索到结果图片
            [self.searchResultTableView tableViewDisplayNotFoundViewWithRowCount:self.searchResultDataArray.count];
            
            [self.searchResultTableView reloadData];
            
        } failed:^(NSError *error) {
            
            NSLog(@"搜索职位失败:%@", error);
        }];
        
    }];
    
    self.searchTableView.beforeShowSearchBarFrame = CGRectMake(0, 0, kScreen_Width, 44);
    self.search = self.searchTableView.searchBar;
    self.search.frame = CGRectMake(0, 0, kScreen_Width, 44);
    self.search.placeholder = @"找职位";
    [self.view addSubview:self.search];

    
    //UITableView
    self.positionTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.search.bottom, kScreen_Width, kScreen_Height - self.search.bottom - 64)];
    self.positionTabelView.delegate = self;
    self.positionTabelView.dataSource = self;
    self.positionTabelView.tableFooterView = [UIView new];
    self.positionTabelView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.positionTabelView];
    
}

/**
 添加导航栏上的右按钮
 (clickAddButton)
 */
-(void)setupNav{
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"add_approva"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(clickAddButton) forControlEvents:UIControlEventTouchUpInside];
    [addBtn sizeToFit];
    
    UIView *btnView1 = [[UIView alloc]initWithFrame:addBtn.frame];
    [btnView1 addSubview:addBtn];
    
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc]initWithCustomView:btnView1];
    
    self.navigationItem.rightBarButtonItem = addButton;
    
}

#pragma tableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == _positionTabelView) {
        return 1;
    } else {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _positionTabelView) {
        return self.jobMessageMutableArray.count;
    } else {
       return self.searchResultDataArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.getModelSuccessBlock) {
        
        if (tableView == _positionTabelView) {
            
            XYSelectJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SELECTJOBCELL"];
            if (cell == nil) {
                
                cell = [[XYSelectJobCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SELECTJOBCELL"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            XYJobModel *jobModel = [self.jobMessageMutableArray objectAtIndex:indexPath.row];
            cell.jobNameStr = jobModel.jobName;
            cell.selectJobNameStr = self.selectJobName;
            
            return cell;
            
        } else {
            
            XYSelectJobCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SELECTJOBCELL"];
            if (cell == nil) {
                
                cell = [[XYSelectJobCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SELECTJOBCELL"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            XYJobModel *jobModel = [self.searchResultDataArray objectAtIndex:indexPath.row];
            cell.jobNameStr = jobModel.jobName;
            cell.selectJobNameStr = self.selectJobName;
            
            return cell;
            
        }
        
    }else {
        
        if (tableView == _positionTabelView) {
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ORIGINCELL"];
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ORIGINCELL"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            XYJobModel *jobModel = [self.jobMessageMutableArray objectAtIndex:indexPath.row];
            cell.textLabel.text = jobModel.jobName;
            
            return cell;
            
        } else {
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ORIGINCELL"];
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ORIGINCELL"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            XYJobModel *jobModel = [self.searchResultDataArray objectAtIndex:indexPath.row];
            cell.textLabel.text = jobModel.jobName;
            
            return cell;
            
        }
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XYEditPositionVc * editPositionVc = [[XYEditPositionVc alloc]init];
    editPositionVc.categoryModel = self.categoryMessageModel;
    
    NSMutableArray *tempMuatbleArray = [NSMutableArray array];
    if (tableView == _positionTabelView) {
        tempMuatbleArray = self.jobMessageMutableArray;
    }else {
        tempMuatbleArray = self.searchResultDataArray;
    }
    
    XYJobModel *jobModel = [tempMuatbleArray objectAtIndex:indexPath.row];
    editPositionVc.jobModel = jobModel;
    
    NSLog(@"%ld", indexPath.row);
    
    
    if (self.getModelSuccessBlock) {
        
        //1.UI确定效果
        self.selectJobName = jobModel.jobName;
        NSLog(@"self.selectJobName~~%@", self.selectJobName);
        [self.searchResultTableView reloadData];
        [self.positionTabelView reloadData];
  
        //2.
        self.getModelSuccess = jobModel;
        
        
    }else {
        
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:editPositionVc animated:YES];
    }
    
}

#pragma mark SEL
-(void)clickAddButton{
    
    XYWorkAddPositionVc *addPosition = [[XYWorkAddPositionVc alloc]init];
    addPosition.delegate = self;
    addPosition.categoryModel = self.categoryMessageModel;
    [self.navigationController pushViewController:addPosition animated:YES];
    
}

- (BOOL)contranstWithJobMessageByJobName:(NSString *)jobName
{
    for (XYJobModel *jobmodel in self.jobMessageMutableArray) {
        
        if ([jobmodel.jobName isEqualToString:jobName]) {
            return YES;
        }
    }
    return NO;
}

- (void)refreshTableViewDataAndUI
{
    [self getJobMessageByCategoryId:self.categoryMessageModel.categoryId];
}

- (void)getJobModelWithOldJobName:(NSString *)oldJobName successBlock: (void(^)(XYJobModel *jobModel))block
{
    if (block) {
        
        //1.
        self.getModelSuccessBlock = block;
        
        //2.
        self.selectJobName = oldJobName;
        
    }
}

- (void)setupNavigationBarWithCenterButton
{
    if (self.getModelSuccessBlock) {
        UIButton * centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [centerButton setTitle:@"确定" forState:UIControlStateNormal];
        [centerButton addTarget:self action:@selector(clickCenterButton) forControlEvents:UIControlEventTouchUpInside];
        [centerButton sizeToFit];
        UIView *centerButtonView = [[UIView alloc]initWithFrame:centerButton.frame];
        [centerButtonView addSubview:centerButton];
        UIBarButtonItem * centerBarButton = [[UIBarButtonItem alloc]initWithCustomView:centerButtonView];
        self.navigationItem.rightBarButtonItem = centerBarButton;
    }
}

- (void)clickCenterButton
{
    if (self.getModelSuccess) {
        [self.navigationController popViewControllerAnimated:NO];
        self.getModelSuccessBlock(self.getModelSuccess);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
