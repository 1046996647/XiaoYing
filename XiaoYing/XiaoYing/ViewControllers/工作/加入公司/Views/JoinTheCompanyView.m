//
//  JoinTheCompanyView.m
//  XiaoYing
//
//  Created by GZH on 16/8/9.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "JoinTheCompanyView.h"
#import "CompanyOfApplyVC.h"
#import "ApplyforJoinCompanyCell.h"
#import "ApplyForJoinTheCompanyModel.h"
@implementation JoinTheCompanyView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        
        [self initData];
        [self initBasic];
        
        [self registerClass:[ApplyforJoinCompanyCell class] forCellReuseIdentifier:@"cell2"];
        
        [self GetListOfCompanyAction];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawRefreshAction:) name:@"drawRefreshAction" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeModelOfAgree:) name:@"ChangeModelOfAgree" object:nil];


 
    }
    return self;
}


- (void)drawRefreshAction:(NSNotification *)not {
    if ([not.object integerValue] < _arrayOfApplyForCompany.count) {
        [_arrayOfApplyForCompany removeObjectAtIndex:[not.object integerValue]];
        
        if (_arrayOfApplyForCompany.count == 0 && ![UserInfo getJoinCompany_YesOrNo]) {
            [self removeFromSuperview];
        }
    }
    [self reloadData];
}

- (void)ChangeModelOfAgree:(NSNotification *)not {
    NSInteger index = [not.object integerValue];
    ApplyForJoinTheCompanyModel *model = _arrayOfApplyForCompany[index];
    model.Status = @"等待HR处理";
//    [self reloadData];
}

//获取加入公司列表
- (void)GetListOfCompanyAction {
    _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
//    _hud.labelText = @"加载中...";
    [AFNetClient POST_Path:ListOfCompanyURl completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if ([code isEqual:@0]) {
            NSLog(@"获取加入公司列表>> %@", JSONDict);
            [self ParserNetData:JSONDict];
            
        }else {
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self];
        }
        _hud.hidden = YES;
    } failed:^(NSError *error) {
         _hud.hidden = YES;
        NSLog(@"---->>>>>%@",error);
    }];
}

//数据解析
- (void)ParserNetData:(id)respondseData {
    NSMutableArray *array = respondseData[@"Data"];
    for (NSMutableDictionary *dic in array) {
        ApplyForJoinTheCompanyModel *model = [[ApplyForJoinTheCompanyModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [_arrayOfApplyForCompany addObject:model];

    }
//    [_hud hide:YES];
    [self reloadData];
}

- (void)initData {
    _arrayOfApplyForCompany = [NSMutableArray array];
    _applyCell = [[ApplyforJoinCompanyCell alloc]init];
}


- (void)initBasic {
    //tableView的分隔符
    self.separatorStyle = NO;
    

    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
 
}

////返回公司信息
//- (void)InfoOfCompanyAction {
//    NSString *URLstr = [InfoOfCompanyURl stringByAppendingFormat:@"&CompanyCode=%@",@"Unhi"];
//    
//    [AFNetClient GET_Path:URLstr completed:^(NSData *stringData, id JSONDict) {
//        NSNumber *code=[JSONDict objectForKey:@"Code"];
//        NSLog(@"-------------------------------%@",JSONDict);
//        if ([code isEqual:@0]) {
//            NSLog(@"搜索公司ID>>成功>> %@", JSONDict);
//            
//        }else {
//        }
//    } failed:^(NSError *error) {
//        
//    }];
//}


#pragma mark   --TableViewDelegate--
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [self InfoOfCompanyAction];
    
    NSLog(@"%ld<><><><><><><>%ld", indexPath.section, indexPath.row);
    ApplyForJoinTheCompanyModel *model = _arrayOfApplyForCompany[indexPath.row];
    CompanyOfApplyVC *companyVC = [[CompanyOfApplyVC alloc]init];
    companyVC.companyCode = model.CompanyCode;
    if ([model.Status isEqualToString:@"HR已拒绝"] || [model.Status isEqualToString:@"等待HR同意"]
) {
        companyVC.title = @"我申请加入的公司";
    }else {
        companyVC.title = @"邀请我加入的公司";
    }
    [self.viewController.navigationController pushViewController:companyVC animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _arrayOfApplyForCompany.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 154;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

     ApplyforJoinCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
     ApplyForJoinTheCompanyModel *model = _arrayOfApplyForCompany[indexPath.row];
        
    cell.deleteButton.tag = indexPath.row;
    cell.drawButton.tag = indexPath.row;
    cell.agreeButton.tag = indexPath.row;
   
    [cell getModel:model];
    return cell;

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
