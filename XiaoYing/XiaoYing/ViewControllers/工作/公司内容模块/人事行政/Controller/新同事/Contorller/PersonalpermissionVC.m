//
//  PersonalpermissionVC.m
//  XiaoYing
//
//  Created by GZH on 16/9/22.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//
#define place kScreen_Width / 4

#import "PersonalpermissionVC.h"
#import "PersonalpermissionCe.h"
#import "PermissionModel.h"


@interface PersonalpermissionVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *viewOfAlready;
@property (nonatomic, strong)NSMutableArray *viewOfFuture;

@property (nonatomic, strong)NSMutableArray *labelOfFuture;
@property (nonatomic, strong)NSMutableArray *imageOfFuture;
@property (nonatomic, strong)NSMutableArray *imageOfFutureT;

@property (nonatomic, strong)NSMutableArray *persissionAlreadyArray;

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *backViewT;

@end

@implementation PersonalpermissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBasic];
    [self initData];
    [self initUI];
    
    
}

- (void)initBasic {
//    self.title = @"人事管理权限";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    [self.backButton setImage:nil forState:UIControlStateNormal];
    [self.backButton setTitle:@"取消" forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(keepActiton)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)initData {
    _array = [NSMutableArray arrayWithObjects:@"获得的权限", @"未获得的权限", nil];

    if ([self.title isEqualToString:@"人事管理权限"]) {
        
        _labelOfFuture = [NSMutableArray arrayWithObjects:@"员工基本信息管理",@"职位管理",@"新同事",@"员工合同管理",@"人事提醒",@"招聘信息",@"数据备份", nil];
        _imageOfFuture = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"information_grey"],[UIImage imageNamed:@"position_grey"],[UIImage imageNamed:@"new_grey"],[UIImage imageNamed:@"contract_grey"],[UIImage imageNamed:@"remind_grey"],[UIImage imageNamed:@"recruitment_grey"],[UIImage imageNamed:@"backup_grey"], nil];
        _imageOfFutureT = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"information"],[UIImage imageNamed:@"position"],[UIImage imageNamed:@"new"],[UIImage imageNamed:@"contract"],[UIImage imageNamed:@"remind"],[UIImage imageNamed:@"recruitment"],[UIImage imageNamed:@"backup"], nil];
    }else {
        
        _labelOfFuture = [NSMutableArray arrayWithObjects:@"企业信息管理", @"组织架构管理", @"权限管理", @"审批类型管理", @"公告管理", @"企业文档", nil];
        _imageOfFuture = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"information_m_grey"],[UIImage imageNamed:@"organization_m_grey"],[UIImage imageNamed:@"permissions_m_grey"],[UIImage imageNamed:@"approval_m_grey"],[UIImage imageNamed:@"notice_m_grey"],[UIImage imageNamed:@"file_m_grey"], nil];
        _imageOfFutureT = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"information_m_color"],[UIImage imageNamed:@"organization_m_color"],[UIImage imageNamed:@"permissions_m_color"],[UIImage imageNamed:@"approval_m_color"],[UIImage imageNamed:@"notice_m_color"],[UIImage imageNamed:@"file_m_color"], nil];
    }
    
    _persissionAlreadyArray = [NSMutableArray arrayWithArray:_modelOfAlreadyArray];
    _persissionNetArray = [NSMutableArray arrayWithArray:_persissionNetArray];
    _idOfAlreadyarray = [NSMutableArray array];
}

- (void)initUI {
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_persissionAlreadyArray.count == 0) {
            return 44;
        }else {
            return _backView.height;
        }
        
    }
    if (indexPath.section == 1) {
        if (_persissionNetArray.count == 0) {
            return 44;
        }else {
            return _backViewT.height;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalpermissionCe *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[PersonalpermissionCe alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
        if (_persissionAlreadyArray.count == 0) {
            cell = [[PersonalpermissionCe alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }else {
            if (cell == nil) {
                cell = [[PersonalpermissionCe alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            UIView *view = [self powerOfAlreadyView];
            [cell.contentView addSubview:view];
        }
        return cell;
    }
    if (indexPath.section == 1) {
        if (_persissionNetArray.count == 0) {
            cell = [[PersonalpermissionCe alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }else {
            if (cell == nil) {
                cell = [[PersonalpermissionCe alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            UIView *view = [self powerOfFutureView];
            [cell.contentView addSubview:view];
        }
        return cell;
    }
    
    return nil;
}

//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 35)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    //组标题
    UILabel *sectionLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 13, 150, 20)];
    sectionLab.font = [UIFont systemFontOfSize:14];
    sectionLab.textColor = [UIColor colorWithHexString:@"#848484"];
    sectionLab.text = _array[section];
    [view addSubview:sectionLab];
    return view;
}


//获得的权限
- (UIView *)powerOfAlreadyView{
    if (_backView == nil) {
        self.backView = [[UIView alloc]initWithFrame:CGRectZero];
        _backView.backgroundColor = [UIColor whiteColor];
    }else {
        for (UIView *view in _backView.subviews) {
            [view removeFromSuperview];
        }
    }
    if (_idOfAlreadyarray.count > 0) {
        [_idOfAlreadyarray removeAllObjects];
    }
    for (int i = 0; i < _persissionAlreadyArray.count; i++) {
        NSInteger index = i % 4;
        NSInteger page = i / 4;
        UIView *view  = [[UIView alloc]init];
        view.frame = CGRectMake(place * index , 12 + 70 * page, place, 58);
        view.userInteractionEnabled = YES;
        view.tag = i + 70;
        _backView.frame = CGRectMake(0, 0, kScreen_Width, 70 * (page + 1));
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((place - 36) / 2, 0, 33, 30)];
        [view addSubview:imageV];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8 , imageV.bottom + 3, place - 16, 30)];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor colorWithHexString:@"#848484"];
        [view addSubview:label];
        
        PermissionModel *model = _persissionAlreadyArray[i];
        for (int j = 0; j < _labelOfFuture.count; j++) {
        
            if ([model.Name isEqualToString: _labelOfFuture[j]]) {
                label.text = _labelOfFuture[j];
                imageV.image = _imageOfFutureT[j];
                [_idOfAlreadyarray addObject:model.ID];
            }
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [view addGestureRecognizer:tap];
        [_backView addSubview:view];
        
    }
    return _backView;
}

//未获得的权限
- (UIView *)powerOfFutureView {
    if (_backViewT == nil) {
        self.backViewT = [[UIView alloc]initWithFrame:CGRectZero];
        _backViewT.backgroundColor = [UIColor whiteColor];
    }else {
        for (UIView *view in _backViewT.subviews) {
            [view removeFromSuperview];
        }
    }
    
    for (NSObject *tempModel in _persissionAlreadyArray) {
        if ([_persissionNetArray containsObject:tempModel]) {
            [_persissionNetArray removeObject:tempModel];
        }
    }
    
    for (int i = 0; i < _persissionNetArray.count; i++) {
        NSInteger index = i % 4;
        NSInteger page = i / 4;
        UIView *view  = [[UIView alloc]init];
        view.frame = CGRectMake(place * index , 12 + 70 * page, place, 58);
        view.userInteractionEnabled = YES;
        view.tag = i + 50;
        _backViewT.frame = CGRectMake(0, 0, kScreen_Width, 70 * (page + 1));
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((place - 36) / 2, 0, 33, 30)];
        [view addSubview:imageV];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8 , imageV.bottom + 3, place - 16, 25)];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor colorWithHexString:@"#848484"];
        [view addSubview:label];
        
        PermissionModel *model = _persissionNetArray[i];
        for (int j = 0; j < _labelOfFuture.count; j++) {
                if ([model.Name isEqualToString: _labelOfFuture[j]]) {
                    label.text = _labelOfFuture[j];
                    imageV.image = _imageOfFuture[j];
                }
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [view addGestureRecognizer:tap];
        [_backViewT addSubview:view];
    }
    return _backViewT ;
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    UIView *view = (UIView *)sender.view;
    if (view.tag < 65) {
        
        [_persissionAlreadyArray addObject:[_persissionNetArray objectAtIndex:view.tag - 50]];
        [_persissionNetArray removeObjectAtIndex:view.tag - 50];
        
    }else {
        [_persissionNetArray addObject:[_persissionAlreadyArray objectAtIndex:view.tag - 70]];
        
        [_persissionAlreadyArray removeObjectAtIndex:view.tag - 70];
        [_idOfAlreadyarray removeObjectAtIndex:view.tag - 70];

    }
    [_tableView reloadData];
}




- (void)keepActiton {
    self.passWord(_persissionAlreadyArray,_persissionNetArray,_idOfAlreadyarray);
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)backAction {

    [self.navigationController popViewControllerAnimated:YES];
}

@end
