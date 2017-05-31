//
//  CreateCompanyVC.m
//  XiaoYing
//
//  Created by GZH on 16/8/22.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//
#import "CreateCompanyVC.h"
#import "DetailView.h"
#import "UpTableViewCell.h"
#import "SectionTableCell.h"
#import "CreateMyCompanyView.h"
#import "SecurityManageMent.h"
#import "TableheadView.h"
#import "SecurityManageMent.h"
#import "CardView.h"
#import "NewFileView.h"
@interface CreateCompanyVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate , UITableViewDataSource ,DetailViewDelegate,CardViewDelegate>
@property (nonatomic)CGFloat tempheighRow0;
@property (nonatomic)CGFloat tempheighRowFour;
@property (nonatomic)CGFloat tempheightSecTwo; //2分区的高
@property (nonatomic)CGFloat tempheightSecThree; //3分区的高
@property (nonatomic)CGFloat tempheightSecFour; //4分区的高
@property (nonatomic)CGFloat tempheight; //1cell的高
@property (nonatomic)CGFloat tempheightT; //5cell的高
@property (nonatomic, strong) UIImageView *imageviewPicture;
@property (nonatomic, strong) UIImageView *imageviewAdd; //添加的图片
@property (nonatomic, strong) SecurityManageMent *secVC;
@property (nonatomic, strong) TableheadView *tableheadView;
@property (nonatomic, strong) CardView *cardView;
@property (nonatomic, strong) UIButton *DeleteBt;  //添加证书上边删除证书按钮
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrSectionTitle; //存储新建介绍的标题
@property (nonatomic, strong) NSMutableArray *arraySection;
@property (nonatomic, strong) NSMutableArray *arrButton;  //添加证书上边添加证书按钮
@property (nonatomic, strong) NSMutableArray *arrImageview;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, strong) NSMutableArray *arrayAddDescriptions;
@property (nonatomic, strong) NSMutableArray *arrayCreateYesOrNo;
@property (nonatomic, strong) NSMutableArray *arrayDescriptions;
@property (nonatomic, strong) NSMutableArray *arrayD;
@property (nonatomic, strong) NSMutableArray *arrayTextOfFiveSection;
@property (nonatomic, strong) NSMutableArray *tempArrayOfSection;
@property (nonatomic, strong) NSMutableArray *arrayOfSectionTitle;
@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation CreateCompanyVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initBasic];
    [self CreateDescription];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteSectionAndRow:) name:@"deleteSectionAndRow" object:nil];
}

- (void)initBasic {
    self.title = @"创建公司";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64)];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableheadView = [[TableheadView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 110)];
    self.tableView.tableHeaderView = _tableheadView;
    self.tableView.tableFooterView = [self footerViewHidden];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell2"];
    [self.tableView registerClass:[SectionTableCell class] forCellReuseIdentifier:@"cell3"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(gotoNextStepAction)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems = @[backItem];
}

//初始化数据
-(void) initData{
    _arrayCreateYesOrNo = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];
    _arrayDescriptions = [NSMutableArray arrayWithObjects:@"公司简介", @"企业管理团队介绍",@"业务范围介绍", nil];
    _secVC = [[SecurityManageMent alloc]init];
    _backView = [[UIView alloc]init];
    _arrImageview = [[NSMutableArray alloc] init];
    _arrButton = [[NSMutableArray alloc] init];
    _arrayAddDescriptions = [[NSMutableArray alloc] init];
    _messageArray = [NSMutableArray arrayWithObjects:@"名称",@"股东",@"电话", @"备用电话", @"公司网址", @"地址", nil];
    _arraySection = [NSMutableArray arrayWithObjects:@"", @"资质证书", @"公司简介",@"企业管理团队介绍",@"业务范围介绍", nil];
    _imageviewPicture = [[UIImageView alloc]init];
    _arrayDescriptionID = [NSMutableArray array];
    _arrayDescriptionTitle = [NSMutableArray array];
    _cardView = [[CardView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 100)];
    _cardView.delegate = self;
    _arrSectionTitle = [NSMutableArray array];
    _arrayD = [NSMutableArray array];
    _arrayTextOfFiveSection = [NSMutableArray array];
    _tempArrayOfSection = [NSMutableArray arrayWithObjects:@"(空)",@"(空)",@"(空)",nil];
    _arrayOfSectionTitle = [NSMutableArray array];
}
- (void)CreateDescription {
    for (int i = 0; i < _arrayDescriptions.count; i++) {
        [self FileUploadURLAction:_arrayDescriptions[i] BlockStr:^(NSString *strID) {
            _arrayCreateYesOrNo[i] = strID;
            [_arrayDescriptionID addObject:strID];
        }];
    }
}

- (void)backAction:(UIButton *)button {
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
        //需要自适应的cell
        if (self.tempheighRow0 > 17 && indexPath.row == 0) {
            return self.tempheighRow0 + 22;
        }
        if (self.tempheight > 17 && indexPath.row == 1) {
            return self.tempheight + 22;
        }
        if (self.tempheighRowFour > 17 && indexPath.row == 4) {
            return self.tempheighRowFour + 22;
        }
        if (self.tempheightT > 17 && indexPath.row == 5) {
            return self.tempheightT + 22;
        }
        return 44;
    }
    //2分区cell自适应
    if (indexPath.section == 2) {
        if (self.tempheightSecTwo > 17) {
            return self.tempheightSecTwo + 27;
        }
        return 44;
    }
    //3分区cell自适应
    if (indexPath.section == 3) {
        if (self.tempheightSecThree > 17) {
            return self.tempheightSecThree + 27;
        }
        return 44;
    }
    //4分区cell自适应
    if (indexPath.section == 4) {
        if (self.tempheightSecFour > 17) {
            return self.tempheightSecFour + 27;
        }
        return 44;
    }
    //1分区cell自适应
    if (indexPath.section == 1) {
        
        return self.cardView.height;
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
//cell上边内容的传值
- (void)passvalue:(NSString *)text {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath.section == 0) {
        UpTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        switch (indexPath.row) {
            case 2:
                _mastPhones = text;
                break;
            case 3:
                _reservePhones = text;
                break;
            default:
                break;
        }
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 4 || indexPath.row == 5) {
            //如果是1,5cell高度自适应
            NSDictionary *attrs = @{NSFontAttributeName:cell.detailLabel.font};
            CGFloat labelWidth = cell.detailLabel.frame.size.width;
            CGSize maxSize = CGSizeMake(labelWidth, 0);
            CGSize size = [text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
            cell.detailLabel.numberOfLines = 0;
            if (indexPath.row == 0) {
                if (size.height > 17) {
                    self.tempheighRow0 = size.height;
                    cell.detailLabel.frame = CGRectMake(85, 11, kScreen_Width - 85 - 20, size.height + 3);
                }
                _nameTemp = text;
            }else
                if (indexPath.row == 1) {
                    if (size.height > 17) {
                        self.tempheight = size.height;
                        cell.detailLabel.frame = CGRectMake(85, 11, kScreen_Width - 85 - 20, size.height + 3);
                    }
                    _stockholders = text;
                }
            if (indexPath.row == 4) {
                if (size.height > 17) {
                    self.tempheighRowFour = size.height;
                    cell.detailLabel.frame = CGRectMake(85, 11, kScreen_Width - 85 - 20, size.height + 3);
                }
                _url = text;
            }else
                if (indexPath.row == 5)
                {
                    if (size.height > 17) {
                        self.tempheightT = size.height;
                        cell.detailLabel.frame = CGRectMake(85, 11, kScreen_Width - 85 - 20, size.height + 3);
                    }
                    _address = text;
                }
        }
        if (![text isEqualToString:@""]) {
            cell.detailLabel.text = text;
            cell.detailLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        }else {
            cell.detailLabel.text = @"(空)";
            cell.detailLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        }
    }
    if (indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4){
        SectionTableCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (![text isEqualToString:@""]) {
            NSDictionary *attrs = @{NSFontAttributeName:cell.SectionLabel.font};
            CGFloat labelWidth = cell.SectionLabel.frame.size.width;
            CGSize maxSize = CGSizeMake(labelWidth, 0);
            CGSize size = [text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
            switch (indexPath.section) {
                case 2:
                    _tempArrayOfSection[0] = text;
                    self.tempheightSecTwo = size.height;
                    break;
                case 3:
                    _tempArrayOfSection[1] = text;
                    self.tempheightSecThree = size.height;
                    break;
                case 4:
                    _tempArrayOfSection[2] = text;
                    self.tempheightSecFour = size.height;
                    break;
                default:
                    break;
            }
            cell.SectionLabel.frame = CGRectMake(12, 12, size.width, size.height);
            cell.SectionLabel.text  = text;
            cell.SectionLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        }else{
            switch (indexPath.section) {
                case 2:
                    _tempArrayOfSection[0] = text;
                    break;
                case 3:
                    _tempArrayOfSection[1] = text;
                    break;
                case 4:
                    _tempArrayOfSection[2] = text;
                    break;
                default:
                    break;
            }
            cell.SectionLabel.text  = @"(空)";
            cell.SectionLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        }
    }
    if (indexPath.section == 5 && ![text isEqualToString:@""]) {
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
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    DetailView *detailV = [[DetailView alloc]init];
    detailV.delegate = self;
    if (indexPath.section != 1) {
        //第0分区
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                    detailV.type = 1;
                    detailV.text = _nameTemp;
                    break;
                case 1:
                    detailV.type = 2;
                    detailV.text = _stockholders;
                    break;
                case 2:
                    detailV.type = 3;
                    detailV.text = _mastPhones;
                    break;
                case 3:
                    detailV.type = 4;
                    detailV.text = _reservePhones;
                    break;
                case 4:
                    detailV.type = 5;
                    detailV.text = _url;
                    break;
                case 5:
                    detailV.type = 6;
                    detailV.text = _address;
                    break;
                default:
                    break;
            }
        }
        if (indexPath.section == 2) {
            detailV.mdifyDescriptionID = _arrayCreateYesOrNo[0];
            detailV.text = _tempArrayOfSection[0];
            detailV.type = 7;
        }
        if (indexPath.section == 3) {
            detailV.mdifyDescriptionID = _arrayCreateYesOrNo[1];
            detailV.text = _tempArrayOfSection[1];
            detailV.type = 8;
        }
        if (indexPath.section == 4) {
            detailV.mdifyDescriptionID = _arrayCreateYesOrNo[2];
            detailV.text = _tempArrayOfSection[2];
            detailV.type = 9;
        }
        if (indexPath.section == 5) {
            detailV.type = 10;
            detailV.mdifyDescriptionID = [_arrayAddDescriptions objectAtIndex:indexPath.row];
            detailV.title = _arrSectionTitle[indexPath.row];
        }
        [self.navigationController pushViewController:detailV animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UpTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        //判断点击编辑,cell上出现 >
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.messageLabel.text = _messageArray[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        [cell.contentView addSubview:_cardView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4) {
        SectionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        return cell;
    } if (indexPath.section == 5) {
        SectionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellAdd"];
        
        if (!cell) {
            cell = [[SectionTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellAdd"];
        }
        [cell getModelOfSection:_arrSectionTitle[indexPath.row] AndDetailOfCell:_arrayTextOfFiveSection[indexPath.row]];
        return cell;
    } else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.textLabel.text = @"(空)";
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)refershTableView {
    if (_cardView.arrImageview.count == 3) {
        _cardView.frame = CGRectMake(0, 0, kScreen_Width, 188);
    }else {
        _cardView.frame = CGRectMake(0, 0, kScreen_Width, 100);
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark --CardDelegate--

- (void)addIntroduce {
    [_arrayOfSectionTitle removeAllObjects];
    [_arrayOfSectionTitle addObjectsFromArray:_arrayDescriptions];
    [_arrayOfSectionTitle addObjectsFromArray:_arrSectionTitle];
    NSLog(@"-------------------------------------------------------%@",_arrayOfSectionTitle);
    NewFileView *fileNew = [[NewFileView alloc] init];
    fileNew.arrayOfSectionTitle = _arrayOfSectionTitle;
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

- (void)gotoNextStepAction {
    
    if (_nameTemp.length == 0) {
        [MBProgressHUD showMessage:@"公司名称不能为空" toView:self.view];
        
    }else {
        if (_arrayDescriptionID.count != 3) {
            return;
        }
        [_arrayD removeAllObjects];
        [_arrayD addObjectsFromArray:_arrayDescriptionID];
        [_arrayD addObjectsFromArray:_arrayAddDescriptions];
        _secVC.logoURL = _tableheadView.logoURL;
        _secVC.cardIDArray = _cardView.cardIDArray;
        _secVC.arrayDescriptionID = _arrayD;
        _secVC.name = _nameTemp;
        _secVC.stockholders = _stockholders;
        _secVC.mastPhones = _mastPhones;
        _secVC.reservePhones = _reservePhones;
        _secVC.url = _url;
        _secVC.address = _address;
        _secVC.string = @"";
        [self.navigationController pushViewController:_secVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint point = _tableView.contentOffset;
    if (point.y < 0) {
        _tableView.contentOffset = CGPointMake(0, 0);
    }
}



@end
