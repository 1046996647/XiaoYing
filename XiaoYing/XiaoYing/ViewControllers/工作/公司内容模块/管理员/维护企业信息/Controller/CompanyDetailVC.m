//
//  CompanyDetailVC.m
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//
#import "CompanyDetailVC.h"
#import "EditDetailView.h"
#import "UpTableViewCell.h"
#import "SectionTableCell.h"
#import "CreateMyCompanyView.h"
#import "TableheadView.h"
#import "MakeDeleteAction.h"
#import "NewFileView.h"
#import "InfoModel.h"
#import "CertificatesModel.h"
#import "DescriptionsModel.h"
#import "ImageCollectionView.h"
@interface CompanyDetailVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, DetailViewDelegate>
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic) CGFloat heightOfSectionOne;
@property (nonatomic) int count;
@property (nonatomic, strong) ImageCollectionView *pictureCollectonView;
@property (nonatomic, strong) NSMutableArray *urlArray;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) NSMutableArray *arrSectionTitle; //存储新建介绍的标题
@property (nonatomic, strong) NSMutableArray *arrayTextOfFiveSection;
@property (nonatomic, strong) NSMutableArray *arrayAddDescriptions;
@property (nonatomic, strong) NSMutableArray *arrayOfDescriptionsTotle;
@property (nonatomic, strong) NSMutableArray *arrayOfAllDescriptionTitle;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSMutableArray *arraySection;
@property (nonatomic) BOOL isClick; //标记编辑按钮是否被点击
@property (nonatomic, strong) InfoModel *model;
@property (nonatomic, strong) TableheadView *tableHeadView ;
@property (nonatomic, strong) DescriptionsModel *descriptionModel;
@property (nonatomic, strong) NSString *LOGFormatUrl;  //判断会前一个界面用不用刷新
@property (nonatomic, strong) NSString *tempName;
@end

@implementation CompanyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _heightOfSectionOne = 44;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [self initData];
    [self GetInfoCompanyAction];
    //左上角的返回按钮
    [self setNavigationItem];
    _tableHeadView = [[TableheadView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 110)];
    _tableHeadView.imageView.userInteractionEnabled = NO;
    self.tableView.tableHeaderView = _tableHeadView;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteSectionAndRow:) name:@"deleteSectionAndRow" object:nil];

}

-(void)initPicCollect{
    CGFloat width = (kScreen_Width-4*12)/3;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(width, 76);
    layout.minimumInteritemSpacing = 8;
    layout.minimumLineSpacing = 3; //上下的间距 可以设置0看下效果
    self.pictureCollectonView = [[ImageCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 210) collectionViewLayout:layout];
    self.pictureCollectonView.showsHorizontalScrollIndicator = NO;
    self.pictureCollectonView.scrollEnabled = NO;
    self.pictureCollectonView.isCompany = YES;
    self.pictureCollectonView.imageIDArray = [_cardIDArray copy];
    self.pictureCollectonView.imageUrlArray =[_urlArray copy];
    if (_urlArray.count > 3) {
        _heightOfSectionOne = 160;
    }else {
        _heightOfSectionOne = 80;
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeCollectionHeight:) name:@"imageCountChangedNotificationAction" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeCollectionHeight:) name:@"imageCountNotificationAction" object:nil];
}

-(void)changeCollectionHeight:(NSNotification*)not {
    _count = [not.object intValue];
    if (_count >= 3) {
        _heightOfSectionOne = 160;
    }else {
        _heightOfSectionOne = 80;
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

//获取公司信息
- (void)GetInfoCompanyAction {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
//    _hud.labelText = @"加载中...";
    NSString *strURL = [GetInfoCompanyURl stringByAppendingFormat:@"&companycode=%@", _CompanyCode];
    [AFNetClient GET_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0]) {
            [self ParserNetData:JSONDict];
                        NSLog(@"++++++++++++++++++++获取公司信息>>成功%@", JSONDict);
        }
        [_hud setHidden:YES];
    } failed:^(NSError *error) {
        [_hud setHidden:YES];
    }];
}
//数据解析
- (void)ParserNetData:(id)respondseData {
    NSMutableDictionary *Dic = respondseData[@"Data"];
    [_model setValuesForKeysWithDictionary:Dic];
    _tempName = Dic[@"Name"];
    _tableHeadView.label.text = [NSString stringWithFormat:@"公司ID : %@",Dic[@"Code"]];
    if (![Dic[@"LOGFormatUrl"] isKindOfClass:[NSNull class]]) {
        _LOGFormatUrl = Dic[@"LOGFormatUrl"];
        NSString *iconStr = [NSString replaceString:Dic[@"LOGFormatUrl"] Withstr1:@"100" str2:@"100" str3:@"c"];
        [_tableHeadView.imageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"LOGO"]];
    }
    //资质证书
    NSMutableArray *array = Dic[@"Certificates"];
    [_cardIDArray removeAllObjects];
    [_urlArray removeAllObjects];
    if (![Dic[@"Certificates"] isKindOfClass:[NSNull class]]) {
        for (NSMutableDictionary *dic in array) {
            CertificatesModel *cardModel = [[CertificatesModel alloc]init];
            [cardModel setValuesForKeysWithDictionary:dic];
            [_cardIDArray addObject:dic[@"ID"]];
            [_urlArray addObject:dic[@"FormatUrl"]];
        }
        _count = (int)_cardIDArray.count;
        [self initPicCollect];
    }
    //公司描述
    NSMutableArray *array1 = Dic[@"Descriptions"];
    [_arrSectionTitle removeAllObjects];
    [_arrayAddDescriptions removeAllObjects];
    [_arrayTextOfFiveSection removeAllObjects];
    if (![Dic[@"Descriptions"] isKindOfClass:[NSNull class]]) {
        for (NSMutableDictionary *dic in array1) {
            DescriptionsModel *descriptionModel = [[DescriptionsModel alloc]init];
            [descriptionModel setValuesForKeysWithDictionary:dic];
            if ([descriptionModel.Title isEqualToString:@"公司简介"]) {
                [_arrayOfSectionTitle replaceObjectAtIndex:0 withObject:descriptionModel];
                [_arrayDescriptionID replaceObjectAtIndex:0 withObject:dic[@"ID"]];
                [_tempArray addObject:descriptionModel];

            }else
                if ([descriptionModel.Title isEqualToString:@"企业管理团队介绍"]) {
                    [_arrayOfSectionTitle replaceObjectAtIndex:1 withObject:descriptionModel];
                    [_arrayDescriptionID replaceObjectAtIndex:1 withObject:dic[@"ID"]];
                    [_tempArray addObject:descriptionModel];

                }else
                    if ([descriptionModel.Title isEqualToString:@"业务范围介绍"]) {
                        [_arrayOfSectionTitle replaceObjectAtIndex:2 withObject:descriptionModel];
                        [_arrayDescriptionID replaceObjectAtIndex:2 withObject:dic[@"ID"]];
                        [_tempArray addObject:descriptionModel];
                        
                    }else{
                        [_arrSectionTitle addObject:dic[@"Title"]];
                        [_arrayAddDescriptions addObject:dic[@"ID"]];
                        [_arrayTextOfFiveSection addObject:dic[@"DescContent"]];
                    }
        } 
    }
    [self.tableView reloadData];
}

- (void)rightBarbuttonAction {
    self.isClick = YES;
    self.title = @"编辑企业信息";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(setCancleAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(sendRequestWithURLAction)];
    _tableHeadView.imageView.userInteractionEnabled = YES;
    self.pictureCollectonView.isEditing = YES;
    self.pictureCollectonView.isCompany = YES;
    [self.pictureCollectonView reloadData];
    if (_count >= 3) {
        _heightOfSectionOne = 160;
    }else {
        _heightOfSectionOne = 80;
    }
    //设置区尾
    if (_arrayAddDescriptions.count < 3) {
        self.tableView.tableFooterView = [self footerViewHidden];
    }
    [self.tableView reloadData];
}

- (void)setKeepAction {
    NSLog(@"保存");
//    self.isClicksave = YES;
    self.title = @"企业信息";
    self.isClick = NO;
    [self setNavigationItem];

    self.pictureCollectonView.isEditing = NO;
    self.pictureCollectonView.count = 10;
    [self.pictureCollectonView reloadData];
    _tableHeadView.imageView.userInteractionEnabled = NO;
    if (self.pictureCollectonView.itemsPictureIDArray.count <= 3) {
        _heightOfSectionOne = 80;
    }
    if (self.pictureCollectonView.itemsPictureIDArray.count == 0) {
        _heightOfSectionOne = 44;
    }
    //区尾消失
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectNull];
    [self.tableView reloadData];
}


//修改公司信息
- (void)sendRequestWithURLAction {
    [_arrayOfDescriptionsTotle removeAllObjects];
    [_arrayOfDescriptionsTotle addObjectsFromArray:_arrayDescriptionID];
    [_arrayOfDescriptionsTotle addObjectsFromArray:_arrayAddDescriptions];
    if ([_model.Name isEqual:@""] && ![_model.Name isEqualToString:@"空"]) {
        [MBProgressHUD showMessage:@"公司名称不能为空!" toView:self.view];
        return;
    }
    [self setKeepAction];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"保存中...";
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setValue:_CompanyCode forKey:@"code"];
    [paraDic setValue:@"" forKey:@"parentId"];
    if (_tableHeadView.logoURL.length > 0) {
        [paraDic setValue:_tableHeadView.logoURL forKey:@"lOGFormatUrl"];
    }else {
        [paraDic setValue:_LOGFormatUrl forKey:@"lOGFormatUrl"];
    }
    [paraDic setValue:_model.Name forKey:@"name"];
    [paraDic setValue:_model.Stockholders forKey:@"stockholders"];
    [paraDic setValue:_model.MastPhones forKey:@"mastPhones"];
    [paraDic setValue:_model.ReservePhones forKey:@"reservePhones"];
    [paraDic setValue:_model.Url forKey:@"url"];
    [paraDic setValue:_model.Address forKey:@"address"];
    [paraDic setValue:_arrayOfDescriptionsTotle forKey:@"descriptions"];
    [paraDic setValue:self.pictureCollectonView.itemsPictureIDArray forKey:@"certificates"];
    
    [AFNetClient POST_Path:ModifyCompanyURl params:paraDic completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        [_hud setHidden:YES];
        if ([code isEqual:@0]) {
            [MBProgressHUD showMessage:@"修改成功" toView:self.view];
        }else {
            [MBProgressHUD showMessage:@"修改失败" toView:self.view];
        }
    } failed:^(NSError *error) {
        [_hud setHidden:YES];
        NSLog(@"---------------------->>>>>>%@",error);
    }];
}

- (void) setCancleAction{
    NSLog(@"取消");
    self.title = @"企业信息";
    self.isClick = NO;
    [self setNavigationItem];
    self.pictureCollectonView.isEditing = NO;
    [self.pictureCollectonView reloadData];
    [self GetInfoCompanyAction];
    _tableHeadView.imageView.userInteractionEnabled = NO;
    //区尾消失
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectNull];
    [self.tableView reloadData];
}
//初始化数据
-(void) initData{
    _messageArray = [NSMutableArray arrayWithObjects:@"名称",@"股东",@"电话", @"备用电话", @"公司网址", @"地址", nil];
    _arraySection = [NSMutableArray arrayWithObjects:@"", @"资质证书", @"公司简介",@"企业管理团队介绍",@"业务范围介绍", nil];
    _arrSectionTitle = [NSMutableArray array];
    _model = [[InfoModel alloc]init];
    _arrayOfSectionTitle = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];
    _arrayDescriptionID = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];
    _cardIDArray = [NSMutableArray array];
    _arrayDescriptionNet = [NSMutableArray array];
    _arrayOfDescriptionsTotle = [NSMutableArray array];
    _urlArray = [NSMutableArray array];
    _tempArray = [NSMutableArray array];
    _arrayTextOfFiveSection = [NSMutableArray array];
    _arrayAddDescriptions = [[NSMutableArray alloc] init];
    _arrayOfAllDescriptionTitle = [NSMutableArray array];
}

//NavigationItem的设置
- (void)setNavigationItem {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 10, 18);
    [backButton setImage:[UIImage imageNamed:@"Arrow-white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarbuttonAction)];
}
- (void)backAction:(UIButton *)button {
    if (![_LOGFormatUrl isEqualToString:_tableHeadView.logoURL] || ![_tempName isEqualToString:_model.Name]) {
        self.blockChange(_tempName);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _messageArray.count;
    }
    if (section == 5) {
        return _arrSectionTitle.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 12;
    }
    if (section == 5) {
        return 0;
    }
    return 30;
}

//cell高度的返回
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //0分区cell自适应
    if (indexPath.section == 0) {
        if (indexPath.row == 2|| indexPath.row == 3) {
            return 44;
        }else {
            NSString *sr = [[NSString alloc]init];
            switch (indexPath.row) {
                case 0:
                    sr = _model.Name;
                    break;
                case 1:
                    sr = _model.Stockholders;
                    break;
                case 4:
                    sr = _model.Url;
                    break;
                case 5:
                    sr = _model.Address;
                    break;
                default:
                    break;
            }
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
            CGFloat tempHeight = [sr boundingRectWithSize:CGSizeMake(kScreen_Width - 85 - 20, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            if (tempHeight > 17) {
                return tempHeight + 26;
            }else {
                return 44;
            }
        }
    }
  
    //2,3,4分区cell自适应
    if (_tempArray.count > 0 && indexPath.section >= 2 && indexPath.section <= 4) {
        DescriptionsModel *descriptionModel = _arrayOfSectionTitle[indexPath.section - 2];
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        CGFloat tempHeight = [descriptionModel.DescContent boundingRectWithSize:CGSizeMake(kScreen_Width - 24, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;

        if (tempHeight > 17) {
            return tempHeight + 26;
        }else {
            return 44;
        }
    }
    //1分区cell自适应
    if (indexPath.section == 1) {
        return _heightOfSectionOne;
    }
    if (indexPath.section == 5) {
        NSString *str = _arrayTextOfFiveSection[indexPath.row];
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        CGFloat tempHeight = [str boundingRectWithSize:CGSizeMake(kScreen_Width - 24, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
        return tempHeight + 30 + 27;
    }
    return 44;
}
//区头标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section < 5) {
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
    return nil;
}
//cell上边内容的传值
- (void)passvalue:(NSString *)text {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
     if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                _model.Name = text;
                break;
            case 1:
                _model.Stockholders = text;
                break;
            case 2:
                _model.MastPhones = text;
                break;
            case 3:
                _model.ReservePhones = text;
                break;
            case 4:
                _model.Url = text;
                break;
            case 5:
                _model.Address = text;
                break;
            default:
                break;
        }
      }
    if (indexPath.section == 2) {
        DescriptionsModel *descriptionModel = _arrayOfSectionTitle[0];
        descriptionModel.DescContent = text;
    }
    if (indexPath.section == 3) {
        DescriptionsModel *descriptionModel = _arrayOfSectionTitle[1];
        descriptionModel.DescContent = text;
    }
    if (indexPath.section == 4) {
        DescriptionsModel *descriptionModel = _arrayOfSectionTitle[2];
        descriptionModel.DescContent = text;
    }
    if (indexPath.section == 5) {
        switch (indexPath.row) {
            case 0:
                _arrayTextOfFiveSection[0] = text;
                break;
            case 1:
                _arrayTextOfFiveSection[1] = text;
                break;
            case 2:
                _arrayTextOfFiveSection[2] = text;
                break;
            default:
                break;
        }
    }

    NSIndexSet *indexSet =[[NSIndexSet alloc]initWithIndex:indexPath.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    EditDetailView *detailV = [[EditDetailView alloc]init];
    detailV.delegate = self;
    if (self.isClick == YES && indexPath.section != 1) {
        //第0分区
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                    detailV.type = 1;
                    detailV.text = _model.Name;
                    break;
                case 1:
                    detailV.type = 2;
                    detailV.text = _model.Stockholders;
                    break;
                case 2:
                    detailV.type = 3;
                    detailV.text = _model.MastPhones;
                    break;
                case 3:
                    detailV.type = 4;
                    detailV.text = _model.ReservePhones;
                    break;
                case 4:
                    detailV.type = 5;
                    detailV.text = _model.Url;
                    break;
                case 5:
                    detailV.type = 6;
                    detailV.text = _model.Address;
                    break;
                default:
                    break;
            }
            [self.navigationController pushViewController:detailV animated:YES];
        }
        if (indexPath.section >= 2 && indexPath.section < 5) {
            DescriptionsModel *descriptionModel = _arrayOfSectionTitle[indexPath.section - 2];
            if (indexPath.section == 2) {
                detailV.text = descriptionModel.DescContent;
                detailV.type = 7;
                detailV.blockDescriptionId = ^(NSString *descriptionID) {
                    _arrayDescriptionID[0] = descriptionID;
                };
            }
            if (indexPath.section == 3) {
                detailV.text = descriptionModel.DescContent;
                detailV.type = 8;
                detailV.blockDescriptionId = ^(NSString *descriptionID) {
                    _arrayDescriptionID[1] = descriptionID;
                };
            }
            if (indexPath.section == 4) {
                detailV.text = descriptionModel.DescContent;
                detailV.type = 9;
                detailV.blockDescriptionId = ^(NSString *descriptionID) {
                    _arrayDescriptionID[2] = descriptionID;
                };
            }
            [self.navigationController pushViewController:detailV animated:YES];
    }
    if (indexPath.section == 5) {
        NSString *strText = _arrayTextOfFiveSection[indexPath.row];
        detailV.title = _arrSectionTitle[indexPath.row];
        detailV.text = strText;
        detailV.type = 10;
        detailV.blockDescriptionId = ^(NSString *descriptionID) {
            _arrayAddDescriptions[indexPath.row] = descriptionID;
        };
        [self.navigationController pushViewController:detailV animated:YES];
    }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    if (indexPath.section == 0) {
        UpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UpTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.tag = indexPath.row;
        //判断点击编辑,cell上出现 >
        if (_isClick == YES) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.messageLabel.text = _messageArray[indexPath.row];
        [cell getModel:_model];
        return cell;
    }
    if (indexPath.section == 1) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        if (_heightOfSectionOne > 44) {
            [cell.contentView addSubview:self.pictureCollectonView];
        }else {
            cell.textLabel.text = @"(空)";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4) {
        SectionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (cell == nil) {
            cell = [[SectionTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        }
        if (_tempArray.count > 0) {
            _descriptionModel = _arrayOfSectionTitle[indexPath.section - 2];
            [cell getModel:_descriptionModel andType:@"CompanyInfo"];
        }
        return cell;
    }
    if (indexPath.section == 5) {
        SectionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellAdd"];
        if (!cell) {
            cell = [[SectionTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellAdd"];
        }
        if (_isClick == YES) {
            cell.deleteBtn.hidden = NO;
        }else {
            cell.deleteBtn.hidden = YES;
        }
        [cell getModelOfSection:_arrSectionTitle[indexPath.row] AndDetailOfCell:_arrayTextOfFiveSection[indexPath.row]];
       
        return cell;
    }else{
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell.textLabel.text = @"(空)";
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

#pragma mark --CardDelegate--
- (void)addIntroduce {

    [_arrayOfAllDescriptionTitle removeAllObjects];
    [_arrayOfAllDescriptionTitle addObjectsFromArray:_arrayOfSectionTitle];
    [_arrayOfAllDescriptionTitle addObjectsFromArray:_arrSectionTitle];
    NewFileView *fileNew = [[NewFileView alloc] init];
    fileNew.arrayOfSectionTitle = _arrayOfAllDescriptionTitle;
    fileNew.passTitle = ^(NSString *title) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.labelText = @"添加中...";
        [self FileUploadURLAction:title BlockStr:^(NSString *strID) {
            [_hud setHidden:YES];
            [_arrayAddDescriptions addObject:strID];
            [_arrSectionTitle addObject:title];
            [_arrayTextOfFiveSection addObject:@"(空)"];
            
            [self.tableView beginUpdates];
            NSArray *tempIndexPathArr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.arrSectionTitle.count -1 inSection:5]];
            [self.tableView insertRowsAtIndexPaths:tempIndexPathArr withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            
            if (_arrSectionTitle.count == 3) {
                self.tableView.tableFooterView = nil;
            }
            
        }];
    };
    fileNew.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    fileNew.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    fileNew.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:fileNew animated:YES completion:nil];
}

//创建介绍
- (void)FileUploadURLAction:(NSString *)title BlockStr:(BlockValue)blockValue{
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:title forKey:@"title"];
    [paraDic setObject:@"" forKey:@"content"];
    
    [AFNetClient POST_Path:AdddescriptionURl params:paraDic completed:^(NSData *stringData, id JSONDict) {
        
        blockValue(JSONDict[@"Data"]);
    } failed:^(NSError *error) {
        NSLog(@"---------------------->>>>>>%@",error);
    }];
}

- (void)deleteSectionAndRow:(NSNotification *)not {
    for (int i = 0; i < _arrSectionTitle.count; i++) {
        if ( [_arrSectionTitle[i] isEqual:not.object]) {
            [_arrayTextOfFiveSection removeObjectAtIndex:i];
            [_arrayAddDescriptions removeObjectAtIndex:i];
            [_arrSectionTitle removeObjectAtIndex:i];
        }
    }
    
    if (_arrSectionTitle.count < 3) {
        self.tableView.tableFooterView = [self footerViewHidden];
    }
    [self.tableView reloadData];
}

- (UIView *)footerViewHidden {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 59)];
    UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, kScreen_Width, 44)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    downLabel.backgroundColor = [UIColor whiteColor];
    downLabel.text = @"   添加介绍";
    downLabel.font = [UIFont systemFontOfSize:14];
    downLabel.textColor = [UIColor colorWithHexString:@"#f99740"];
    [footerView addSubview:downLabel];
    downLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *addCell = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addIntroduce)];
    [downLabel addGestureRecognizer:addCell];
    return footerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = self.tableView.contentOffset;
    if (point.y < 0) {
        self.tableView.contentOffset = CGPointMake(0, 0);
    }
}

@end
