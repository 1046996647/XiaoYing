//
//  CompanyOfApplyVC.m
//  XiaoYing
//
//  Created by GZH on 16/8/12.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "CompanyOfApplyVC.h"
#import "HeaderView.h"
#import "CompanyOfApplyCell.h"
#import "OtherCompanyInfoModel.h"
#import "OtherCompanyDescriptionModel.h"

@interface CompanyOfApplyVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *arrayBefore;
@property (nonatomic, strong) NSMutableArray *arraySection;
@property (nonatomic, strong)NSMutableArray *arrayDescription;
@property (nonatomic, strong)NSMutableArray *tempArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, strong)OtherCompanyInfoModel *model;
@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic) CGFloat tempHeight;
@end

@implementation CompanyOfApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initBasic];
    [self initData];
    [self initUI];
    
    
    [self GetInfoCompanyAction];
}

//获取公司信息
- (void)GetInfoCompanyAction {

    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
//    _hud.labelText = @"加载中...";

    NSString *strURL = [GetInfoCompanyURl stringByAppendingFormat:@"&companycode=%@", _companyCode];
    [AFNetClient GET_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0]) {
            [self ParserNetData:JSONDict];
            NSLog(@"++++++++++++++++++++获取公司信息>>成功%@", JSONDict);
        }
    } failed:^(NSError *error) {

    }];
}
//数据解析
- (void)ParserNetData:(id)respondseData {
    
    NSMutableDictionary *Dic = respondseData[@"Data"];

    if (![Dic[@"Code"] isKindOfClass:[NSNull class]]) {
        _headerView.label.text = [NSString stringWithFormat:@"公司ID : %@",Dic[@"Code"]];
    }
    if (![Dic[@"LOGFormatUrl"]isKindOfClass:[NSNull class]]) {
        NSString *iconURL = [NSString replaceString:Dic[@"LOGFormatUrl"] Withstr1:@"100" str2:@"100" str3:@"c"];
        [_headerView.imageView sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"LOGO"]];
    }
    
    [_model setValuesForKeysWithDictionary:Dic];
     //公司描述
    NSMutableArray *array = Dic[@"Descriptions"];
    if (![Dic[@"Descriptions"] isKindOfClass:[NSNull class]]) {
        for (NSMutableDictionary *dic in array) {
            OtherCompanyDescriptionModel *descriptionModel = [[OtherCompanyDescriptionModel alloc]init];
            [descriptionModel setValuesForKeysWithDictionary:dic];
            [_tempArray addObject:descriptionModel];
            if ([descriptionModel.Title isEqualToString:@"公司简介"]) {
                [_arrayDescription replaceObjectAtIndex:0 withObject:descriptionModel];
                
            }else
                if ([descriptionModel.Title isEqualToString:@"企业管理团队介绍"]) {
                    [_arrayDescription replaceObjectAtIndex:1 withObject:descriptionModel];
                   
                }else
                    if ([descriptionModel.Title isEqualToString:@"业务范围介绍"]) {
                        [_arrayDescription replaceObjectAtIndex:2 withObject:descriptionModel];
                    }
        }
    }
    [_hud hide:YES];
    [_tableView reloadData];
}

- (void)initBasic {
//    self.title = @"我申请加入的公司";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
}

- (void)initData {
    _arrayBefore = [NSMutableArray arrayWithObjects:@"名称",@"公司网址",@"地址", nil];
    _arraySection = [NSMutableArray arrayWithObjects:@"", @"公司简介",@"企业管理团队介绍",@"业务范围介绍", nil];
    _model = [[OtherCompanyInfoModel alloc]init];
    _arrayDescription = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];
    _tempArray = [NSMutableArray array];
}

- (void)initUI {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UITableViewHeaderFooterView alloc]init];
    _headerView = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 110)];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    _tableView.tableHeaderView = _headerView;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}

#pragma mark   --TableViewDelegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 12;
    }
    return 30;
}

//区头标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kScreen_Width - 25, 30)];
    customView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    headerLabel.font = [UIFont boldSystemFontOfSize:12];
    
    headerLabel.text = _arraySection[section];
    [customView addSubview:headerLabel];
    return customView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 1;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section > 0 && _tempArray.count > 0) {
            OtherCompanyDescriptionModel *descriptionModel = _arrayDescription[indexPath.section - 1];
                NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
                CGFloat height = [descriptionModel.DescContent boundingRectWithSize:CGSizeMake(kScreen_Width - 24, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            if (height > 17) {
                return 20 + height;
            }else {
                return 44;
            }
        }
    if (indexPath.section == 0 && _model.Address != NULL) {
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        CGFloat height = [_model.Address boundingRectWithSize:CGSizeMake(kScreen_Width - 24, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
        if (height > 17) {
            return 20 + height;
        }else {
            return 44;
        }
    }
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CompanyOfApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[CompanyOfApplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell.beforeLabel.text = _arrayBefore[indexPath.row];
        cell.tag = indexPath.row;
        
        [cell getModel:_model];
        return cell;
        
        
    }else {

        CompanyOfApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell = [[CompanyOfApplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        if (_tempArray.count > 0) {
            OtherCompanyDescriptionModel *descriptionModel = _arrayDescription[indexPath.section - 1];
            [cell getModelOfSectionOne:descriptionModel];
        }
        return cell;
    }
    return nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = _tableView.contentOffset;
    if (point.y < 0) {
        _tableView.contentOffset = CGPointMake(0, 0);
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
