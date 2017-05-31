//
//  NewcolleaguesVC.m
//  XiaoYing
//
//  Created by MengFanBiao on 16/6/12.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "NewcolleaguesVC.h"
#import "HumanAffairsCell.h"
#import "XYAddNewWorkerView.h"
#import "AddMemberInfoVC.h"
#import "NewWorkersModel.h"
#import "EmptyarrayCell.h"

@interface NewcolleaguesVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *approveTable;
@property (nonatomic,strong) XYSearchBar *humanSearch;//收索框
@property (nonatomic,strong) XYAddNewWorkerView* workView;

@property (nonatomic,strong) NSMutableArray* dateSource;
@property (nonatomic,strong) NSMutableArray* dateSourceOfSearch;
@property (nonatomic, strong)MBProgressHUD *hud;

@end

@implementation NewcolleaguesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"新同事";
    _dateSource = [NSMutableArray array];
    _dateSourceOfSearch = [NSMutableArray array];

    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
    
    
    self.humanSearch = [[XYSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    self.humanSearch.delegate = self;
    self.humanSearch.showsCancelButton = NO;
    self.humanSearch.placeholder = @"找人";
    [baseView addSubview:self.humanSearch];
    [self.humanSearch.searchButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    
    baseView.height = self.humanSearch.bottom;

    
    // 请求数据
    [self requestData];

    // 表视图
    self.approveTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-44-64) style:UITableViewStylePlain];
    self.approveTable.tableHeaderView = baseView;
    self.approveTable.tableFooterView = [UIView new];
    self.approveTable.delegate = self;
    self.approveTable.dataSource = self;
    self.approveTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.approveTable];
    if ([self.approveTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.approveTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.approveTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.approveTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //添加导航栏item
    [self setNav];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"addNewStudent" object:nil];
}

// 请求数据
- (void)requestData {
   
    [_dateSource removeAllObjects];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
//    _hud.labelText = @"加载中...";
    [AFNetClient  POST_Path:GetNewColleaguesURL completed:^(NSData *stringData, id JSONDict) {
        
        NSLog(@"-=-=-=-=-=-=%@",JSONDict);
        [self parserNetData:JSONDict];
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

- (void)parserNetData:(id)responder {
    NSMutableArray *array = responder[@"Data"];
    if (array.count == 0) {
        [MBProgressHUD showMessage:@"暂时没有新同事" toView:self.view];
    }
    for (NSMutableDictionary *dic in array) {
        NewWorkersModel *model = [[NewWorkersModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [_dateSource addObject:model];
    }
    [_hud hide:YES];
    [self.approveTable reloadData];
}


-(void)setNav{
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"add_approva"] forState:UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(addNewWorker:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * btnView = [[UIView alloc]initWithFrame:rightButton.bounds];
    [btnView addSubview:rightButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnView];
}

#pragma mark SEL

//添加新同事//那个弹框
-(void)addNewWorker:(UIButton *)button{
    
    if (button.tag == 0) {
        
        if (self.workView == nil) {
            XYAddNewWorkerView *workView = [[XYAddNewWorkerView alloc] initWithFrame:self.view.bounds];
            self.workView = workView;
        }
        
        self.workView.btn = button;
        [self.view addSubview:self.workView];
        button.tag = 1;
    }
    else {
        [self.workView removeFromSuperview];
        button.tag = 0;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
     [self.workView removeFromSuperview];
     self.workView.btn.tag = 0;
    
    [self.humanSearch resignFirstResponder];
    self.humanSearch.searchButton.hidden = YES;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewWorkersModel *model = _dateSource[indexPath.row];
    //添加新同事信息
    if (![model.StatusCN isEqualToString:@"对方已撤消"]) {
        AddMemberInfoVC * addMemberInfoVC = [[AddMemberInfoVC alloc]init];
        addMemberInfoVC.Nick = model.Nick;
        addMemberInfoVC.XiaoYinCode = model.XiaoYingCode;
        addMemberInfoVC.Singer = model.Singer;
        addMemberInfoVC.region = model.region;
        addMemberInfoVC.JoinID = model.Id;
        addMemberInfoVC.FaceUrl = model.FaceUrl;
        addMemberInfoVC.titleStr = @"添加成员信息";
        addMemberInfoVC.blockKeepYON = ^(NSString *str) {
            if ([str isEqualToString:@"YES"]) {
                [self requestData];
            }
        };

        [self.navigationController pushViewController:addMemberInfoVC animated:YES];
    }else {
        [MBProgressHUD showMessage:@"对方已撤销" toView:self.view];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50; 
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HumanAffairsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (cell == nil) {
        
        cell = [[HumanAffairsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    NewWorkersModel *model = nil;
    if (_humanSearch.showsCancelButton == NO) {
        model = _dateSource[indexPath.row];
    }else {
            model = _dateSourceOfSearch[indexPath.row];
    }
    
    [cell getModel:model];
    return cell;
}

//单元格将要出现
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_humanSearch.showsCancelButton == NO) {
        return _dateSource.count;
    }else {
        return _dateSourceOfSearch.count;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.labelText = @"删除中...";
        
        NewWorkersModel *model = _dateSource[indexPath.row];
        //拒绝对方的申请
        if ([model.Status isEqual:@0] || [model.Status isEqual:@1]) {

            [self RefusedApplyForAction:model.Id Location:indexPath.row];
        }else
            //删除对方撤销后的申请
        if ([model.Status isEqual:@3]) {

            [self DeleteNewStuURLAction:model.Id Location:indexPath.row];
        }
      
        
    }
}

//拒绝新同事的加入申请
- (void)RefusedApplyForAction:(NSString *)tempStr Location:(NSInteger )index {
    NSString *strURL = [RefusedApplyFor stringByAppendingFormat:@"&joinqueueid=%@",tempStr];
    [AFNetClient POST_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if ([code isEqual:@0]) {

            [_dateSource removeObjectAtIndex:index];
            [_hud hide:YES];
            [_approveTable reloadData];
        }else {
            [_hud hide:YES];
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
        }
    } failed:^(NSError *error) {
        
    }];
}

//删除新同事撤销之后的申请
- (void)DeleteNewStuURLAction:(NSString *)tempStr Location:(NSInteger )index {
    NSString *strURL = [DeleteNewStuURL stringByAppendingFormat:@"&NewColleagueId=%@",tempStr];
    [AFNetClient POST_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        if ([code isEqual:@0]) {
        
            [_dateSource removeObjectAtIndex:index];
            [_hud hide:YES];
            [_approveTable reloadData];
        }else {
            [_hud hide:YES];
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
        }
    } failed:^(NSError *error) {
        
    }];
}

//修改左滑的按钮的字
-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexpath {
   
    NewWorkersModel *model = _dateSource[indexpath.row];
    if ([model.Status isEqual:@0]) {
      return @"拒绝";
    }else {
        return @"删除";
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


// 搜索框上的X按钮事件
- (void)clearAction
{
    self.humanSearch.text = @"";
    [self.humanSearch resignFirstResponder];
    self.humanSearch.searchButton.hidden = YES;
    
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.humanSearch.showsCancelButton = YES;
//    self.humanSearch.searchButton.hidden = NO;
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.humanSearch.showsCancelButton = NO;
    [self.humanSearch resignFirstResponder];
    self.humanSearch.text = @"";
    [self.approveTable reloadData];
}

//输入框输入字符的时候
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
     NSMutableArray *resultArray = [NSMutableArray array];
    
    for (NewWorkersModel *model in _dateSource) {
        if ([model.Nick containsString:searchText]) {
            [resultArray addObject:model];
        }
    }
    _dateSourceOfSearch = resultArray;
    [self.approveTable reloadData];
 }

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"4");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction:(UIButton *)button {
    if (_haveNotification == YES) {
        _blockNotification(@"YES");
    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
