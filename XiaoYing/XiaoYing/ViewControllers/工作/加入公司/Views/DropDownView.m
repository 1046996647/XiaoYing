//
//  DropDownView.m
//  XiaoYing
//
//  Created by GZH on 16/8/11.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "DropDownView.h"
#import "ChilderCompanyModel.h"


@interface DropDownView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, strong)NSMutableArray *array1;
@property (nonatomic, strong)UIWindow *window;
@property (nonatomic, strong)MBProgressHUD *hud;
@end

@implementation DropDownView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self initData];
        [self initUI];
        [self SearchCompanyOfMineAction];
    }
    return self;
}


//获取已加入公司列表
- (void)SearchCompanyOfMineAction {

    _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"添加中...";

    [AFNetClient GET_Path:ListOfMyCompanyURl completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        NSArray *array =JSONDict[@"Data"];
        if ([code isEqual:@0]) {
            NSLog(@"+++++++++++++%lu获取已加入公司列表>>成功%@",array.count , JSONDict);
            
            _blockValue(@"alrigo");
            [self ParserNetData:JSONDict];
        }else {
            [_hud setHidden:YES];
             [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self];
        }
    } failed:^(NSError *error) {
        _blockValue(@"failed");
        [_hud hide:YES];
        NSLog(@"-------------->>>>>>%@",error);
    }];
}

- (void)ParserNetData:(id)respondseData {
    NSMutableArray *array = respondseData[@"Data"];
    for (NSMutableDictionary *Dic in array) {
        ChilderCompanyModel *model = [[ChilderCompanyModel alloc]init];
        [model setValuesForKeysWithDictionary:Dic];
        [_array addObject:model];
        
    }
    [_hud hide:YES];
    
    [self initTableView];
}

- (void)initTableView {
    _tableView = [[UITableView alloc]init];
    if (_array.count > 5) {
        _tableView.frame = CGRectMake(0, 64, kScreen_Width, 44 * 5 + 22);
    }else {
        _tableView.frame = CGRectMake(0, 64, kScreen_Width, 44 * _array.count);
    }
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _coverView.userInteractionEnabled = YES;
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.4;
    
    if ([_window.subviews containsObject:_coverView]) {
        [_window addSubview:_tableView];
    }
    
}

- (void)initData {
    _array = [NSMutableArray array];
    _array1 = [NSMutableArray array];
    _window = [UIApplication sharedApplication].keyWindow;
}

- (void)initUI {
 
    _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height)];
    _coverView.backgroundColor = [UIColor clearColor];
    _coverView.userInteractionEnabled = NO;
    [_window addSubview:_coverView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeCoverView)];
    [_coverView addGestureRecognizer:tap];
    
}

- (void)removeCoverView{

    if ([self.delegate respondsToSelector:@selector(removeCoverView)]) {
        [self.delegate removeCoverView];
    }
}

// 切换公司
- (void)switchCompanyAndsaveinfoOfCompany:(ChilderCompanyModel *)model{
     NSString *strURL = [SwitchCompany stringByAppendingFormat:@"&TargetCompanyId=%@", model.CompanyCode];
    [AFNetClient  POST_Path:strURL completed:^(NSData *stringData, id JSONDict) {
       
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0]) {
            NSMutableArray *array = JSONDict[@"Data"];
            [ZWLCacheData archiveObject:array toFile:PermissionsPath];
            
            // 切换公司从新保存数据
            [UserInfo saveCompanyId:model.CompanyCode];
            [UserInfo savecompanyName:model.CompanyName];
            [UserInfo saveUserRole:model.Role];
            [UserInfo saveTopLeaderOfCompany:model.AdminProfileId];
           
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshHeadView" object:array];
        }else {
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self];
        }
         [self removeCoverView];
    } failed:^(NSError *error) {
        [self removeCoverView];
    }];
}



#pragma mark   --TableViewDelegate--
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChilderCompanyModel *model = _array[indexPath.row];
    [self switchCompanyAndsaveinfoOfCompany:model];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.layer.borderWidth = 0.25;
    cell.layer.borderColor = [[UIColor colorWithHexString:@"#d5d7dc"] CGColor];

    ChilderCompanyModel *model = _array[indexPath.row];
    cell.textLabel.text = model.CompanyName;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}







@end
