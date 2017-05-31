//
//  CompanyInfoVc.m
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/7.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "CompanyInfoVc.h"
#import "CompanyInfoCell.h"
#import "CompanyDetailVC.h"
#import "AddChildCompanyVC.h"
#import "AppearFullName.h"
#import "ChilderCompanyModel.h"
@interface CompanyInfoVc ()
@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, strong)NSMutableArray *arrayIcon;
@property (nonatomic, strong)UIImageView *littleImage;
@property (nonatomic, strong)AppearFullName *appearView;
@property (nonatomic, strong)MBProgressHUD *hud;

@property (nonatomic, strong)NSString *CompanyName;
@property (nonatomic, strong)NSString *CompanyLOGFormatUrl;

@end

@implementation CompanyInfoVc

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
////    CompanyDetailVC *comVc = [[CompanyDetailVC alloc]init];
////    comVc.blockChange = ^(NSString *str) {
////        if (str.length > 0) {
////            [self GetMyCompanyAction];
////        }
////    };
//  
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
//    [self SearchCompanyOfMineAction];  /************暂时去掉***********/
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.tableView.tableFooterView = [UIView new];
    self.title = @"企业信息";
    self.tableView.rowHeight = 50;
    
    [self.tableView registerClass:[CompanyInfoCell class] forCellReuseIdentifier:@"cell"];
    //返回按钮
    [self setBackAction];
    
    [self GetMyCompanyAction];
}


//获取公司信息
- (void)GetMyCompanyAction {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
//    _hud.labelText = @"加载中...";
    
    NSString *strURL = [GetMyCompanyURl stringByAppendingFormat:@"&companycode=%@",[UserInfo getCompanyId]];
    [AFNetClient GET_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0]) {
            
            _CompanyLOGFormatUrl = JSONDict[@"Data"][@"CompanyLOGFormatUrl"];
            _CompanyName = JSONDict[@"Data"][@"CompanyName"];
            [UserInfo savecompanyName:_CompanyName];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeCompanyName" object:nil];
        }else {
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
        }
        [self.tableView reloadData];
        [_hud setHidden:YES];
    } failed:^(NSError *error) {
        [_hud setHidden:YES];
        NSLog(@"------------->>>>>>%@",error);
    }];
}


- (void)initData {
    _array = [NSMutableArray array];
    _arrayIcon = [NSMutableArray array];
}

//获取已加入公司列表
- (void)SearchCompanyOfMineAction {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
//    _hud.labelText = @"加载中...";
    
    [AFNetClient GET_Path:ListOfMyCompanyURl completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        NSArray *array =JSONDict[@"Data"];
        if ([code isEqual:@0]) {
            NSLog(@"++++++++++++++++++++%lu获取已加入公司列表>>成功%@",array.count , JSONDict);
            [self ParserNetData:JSONDict];
        }else {
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
        }
    } failed:^(NSError *error) {
        NSLog(@"---------------------->>>>>>%@",error);
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
    [self.tableView reloadData];
}

/**
 *左上角的返回按钮
 */
- (void)setBackAction {
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 18)];
    [backButton setImage:[UIImage imageNamed:@"Arrow-white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_approva"] style:UIBarButtonItemStyleDone target:self action:@selector(addChildAction)];
}


- (void)backAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addChildAction {
    NSLog(@"添加子公司");
    AddChildCompanyVC *addCompanyVC = [[AddChildCompanyVC alloc]init];
    [self.navigationController pushViewController:addCompanyVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    return 2;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (section == 0) {
        return 1;
//    }
//    return _array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CompanyInfoCell *cell = nil;
    if (indexPath.section == 0) {
        if (cell == nil) {
            cell = [[CompanyInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
    
        if (![_CompanyLOGFormatUrl isKindOfClass:[NSNull class]]) {
            NSString *iconURL = [NSString replaceString:_CompanyLOGFormatUrl Withstr1:@"100" str2:@"100" str3:@"c"];
            [cell.image sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"LOGO"]];
        }
        cell.label.text = _CompanyName;
     
        return cell;
    }else {
        if (cell == nil) {
            cell = [[CompanyInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        
//        ChilderCompanyModel *model = _array[indexPath.row];
//        [cell getModel:model];
//        
//        //长按显示全名
//        cell.label.tag = indexPath.row;
//        CGSize size = [cell.label.text sizeWithFont:cell.label.font];
//        if (size.width > cell.label.width) {
//            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(appearFullName:)];
//            longPress.numberOfTouchesRequired = 1;
//            longPress.minimumPressDuration = 1.0;
//            cell.label.userInteractionEnabled = YES;
//            [cell.label addGestureRecognizer:longPress];
//        }
//        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyDetailVC *detailvc = [[CompanyDetailVC alloc]init];
//    ChilderCompanyModel *model = _array[indexPath.row];
    detailvc.title = @"企业信息";
//    detailvc.CompanyCode = model.CompanyCode;
    detailvc.CompanyCode = [UserInfo getCompanyId];
    detailvc.blockChange = ^(NSString *str) {
        if (str.length > 0) {
            [self GetMyCompanyAction];
        }
    };
    [self.navigationController pushViewController:detailvc animated:YES];
}

- (void)appearFullName:(UILongPressGestureRecognizer *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.view.tag inSection:1];
    CompanyInfoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    //弹出视图的内容的自适应
    NSString *content = [NSString stringWithFormat:@"%@",cell.label.text];
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:12]};
    CGSize size = [content boundingRectWithSize:CGSizeMake(190, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    _littleImage = [[UIImageView alloc]init];
    _littleImage.image = [UIImage imageNamed:@"allname"];
    
    //计算cell相对于父视图的frame
    CGRect rect = [cell.label convertRect:cell.label.frame fromView:self.view];
    CGFloat littleImageY = 0 - rect.origin.y + 10;
    CGFloat littleImageX = cell.label.origin.x + cell.label.width / 2;
    _littleImage.frame = CGRectMake(littleImageX, littleImageY, 10, 9);
    _appearView = [[AppearFullName alloc]initWithFrame:CGRectMake(littleImageX - size.width / 2, littleImageY - size.height - 20, 190, size.height + 20)];
    _littleImage.tag = 4444;
    _appearView.tag = 4443;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        _appearView.label.text = content;
        [self.view addSubview:_littleImage];
        [self.view addSubview:_appearView];
        
    }else {
        [self performSelector:@selector(removeFullName) withObject:nil afterDelay:1.0];
    }
    
}

- (void)removeFullName {
    UIView *temp = [self.view viewWithTag:4444];
    [temp removeFromSuperview];
    UIView *tempV = [self.view viewWithTag:4443];
    [tempV removeFromSuperview];
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
