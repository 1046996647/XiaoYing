//
//  SelectPlaceVC.m
//  XiaoYing
//
//  Created by ZWL on 17/1/9.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "SelectPlaceVC.h"
#import "selectPalceCell.h"
#import "AppDelegate.h"
#import "EmployeeViewModel.h"
#import "SelectFolderViewController.h"
#import "AuthorityForDocumentMethod.h"

@interface SelectPlaceVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_sectionArr;
    NSArray *_cellArr;
    NSArray *_cellIdArr;
}

@property (nonatomic, strong) NSArray *companyNameArr;
@property (nonatomic, strong) NSArray *companyIdArr;

@property (nonatomic, strong) NSArray *departmentNameArr;
@property (nonatomic, strong) NSArray *departmentIdArr;

@property (nonatomic, strong) NSArray *personNameArr;
@property (nonatomic, strong) NSArray *personIdArr;

@property (nonatomic, strong) NSIndexPath *selectIndexPath; //被选中的cell

@end

@implementation SelectPlaceVC

- (NSIndexPath *)selectIndexPath
{
    if (!_selectIndexPath) {
        _selectIndexPath = [NSIndexPath indexPathForRow:10000 inSection:10000];
    }
    return _selectIndexPath;
}

- (void)getDataFromWeb
{
    __weak typeof(self) weakSelf = self;
    
    //组标题
    _sectionArr = @[@"公司",@"部门",@"个人"];
    
    //公司
    NSString *companyName = [UserInfo getcompanyName];
    BOOL tempBool = [AuthorityForDocumentMethod JudgeAuthority:^(AuthorityForDocumentMethod *auth) {
        
        auth.regionName(@"新建文件夹").deparmentId(@"");
    }];
    self.companyNameArr = tempBool? @[companyName] : @[];
    
    NSString *companyId = @"";
    self.companyIdArr = @[companyId];
    
    //个人
    NSString *personName = @"个人文档";
    self.personNameArr = @[personName];
    
    NSString *personId = @" ";  //用@" "与公司id@""相区别
    self.personIdArr = @[personId];
    
    //部门
    [EmployeeViewModel getEmployeeMessageSuccess:^(NSArray *identityNameArray, NSArray *departmentIdArray, NSArray *departmentNameArray) {
        
        //筛选两个数组使之只包含部门级别的信息，排除公司级别的信息
        NSMutableArray *tempDepartmentNameArr = [NSMutableArray array];
        for (NSString *tempName in departmentNameArray) {
            if (![tempName isEqualToString:@""]) {
                [tempDepartmentNameArr addObject:tempName];
            }
        }
        weakSelf.departmentNameArr = tempDepartmentNameArr.copy;
        
        NSMutableArray *tempDepartmentIdArr = [NSMutableArray array];
        for (NSString *tempName in departmentIdArray) {
            if (![tempName isEqualToString:@""]) {
                [tempDepartmentIdArr addObject:tempName];
            }
        }
        weakSelf.departmentIdArr = tempDepartmentIdArr.copy;
        
        //权限筛选
        [tempDepartmentIdArr enumerateObjectsUsingBlock:^(NSString *depId, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL tempBool = [AuthorityForDocumentMethod JudgeAuthority:^(AuthorityForDocumentMethod *auth) {
                
                auth.regionName(@"新建文件夹").deparmentId(depId);
            }];
            if (!tempBool) {
                [tempDepartmentIdArr removeObjectAtIndex:idx];
                [tempDepartmentNameArr removeObjectAtIndex:idx];
            }
            weakSelf.departmentNameArr = tempDepartmentNameArr.copy;
            weakSelf.departmentIdArr = tempDepartmentIdArr.copy;
        }];
        
        //单元格内容
        _cellArr = @[weakSelf.companyNameArr, weakSelf.departmentNameArr, weakSelf.personNameArr];
        _cellIdArr = @[weakSelf.companyIdArr, weakSelf.departmentIdArr, weakSelf.personIdArr];
        
        //重新构建_sectionArr、_cellArr、_cellArr
        NSMutableArray *tempSectionArr = [NSMutableArray array];
        NSMutableArray *tempCellArr = [NSMutableArray array];
        NSMutableArray *tempCellIdArr = [NSMutableArray array];
        for (int i = 0; i < _cellArr.count; i ++) {
            if ([_cellArr[i] count] > 0) {
                [tempSectionArr addObject: [_sectionArr objectAtIndex:i]];
                [tempCellArr addObject:[_cellArr objectAtIndex:i]];
                [tempCellIdArr addObject:[_cellIdArr objectAtIndex:i]];
            }
        }
        
        _sectionArr = tempSectionArr.copy;
        _cellArr = tempCellArr.copy;
        _cellIdArr = tempCellIdArr.copy;
        
        [_tableView reloadData];
        
    } failed:^(NSError *error) {
        
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = backItem;
    
    [self getDataFromWeb];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //隐藏标签栏
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabvc hideCustomTabbar];
}

- (void)nextAction
{
    //如果还没有选择部门位置，则不进行跳转
    if ((self.selectIndexPath.section == 10000) && (self.selectIndexPath.row == 10000)) {
        return;
    }
    
    //1.创建文件夹选择VC
    SelectFolderViewController *selectFolderVC = [[SelectFolderViewController alloc] init];
    
    //2.将现在选中的部门id传过去
    selectFolderVC.folderName = @"根目录";
    selectFolderVC.folderId = @"";
    
    selectPalceCell *tempCell = [_tableView cellForRowAtIndexPath:self.selectIndexPath];
    selectFolderVC.departmentId = tempCell.cellDepartmentId;
    
    selectFolderVC.departmentName = tempCell.textLabel.text;
    
    //3.大同block回调的通道
    [selectFolderVC setGetPlaceBlock:self.getPlaceBlock];
    
    //4.跳转
    [self.navigationController pushViewController:selectFolderVC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cellArr[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectPalceCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[selectPalceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _cellArr[indexPath.section][indexPath.row];
    cell.cellDepartmentId = _cellIdArr[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    if ((indexPath.section == self.selectIndexPath.section) && (indexPath.row == self.selectIndexPath.row)) {
        [cell setBtnSelected:YES];
    }else {
        [cell setBtnSelected:NO];
    }
    
    return cell;
}

//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 35)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    //组标题
    UILabel *sectionLab = [[UILabel alloc] initWithFrame:CGRectMake(15, (35-20)/2, 150, 20)];
    sectionLab.font = [UIFont systemFontOfSize:14];
    sectionLab.textColor = [UIColor colorWithHexString:@"#848484"];
    
    sectionLab.text = _sectionArr[section];
    [view addSubview:sectionLab];
    
    return view;
}

//当点击cell时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.取消选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //2.
    self.selectIndexPath = indexPath;
    
    //3.
    [_tableView reloadData];
}

@end
