//
//  CardOfTheCompanyView.m
//  XiaoYing
//
//  Created by GZH on 2016/12/21.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "CardOfTheCompanyView.h"
#import "HeadViewOfCard.h"
#import "PersonalCardMyCell.h"
#import "ImageCollectionView.h"
#import "SectionTableCell.h"
#import "DescriptionsModel.h"
@interface CardOfTheCompanyView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) HeadViewOfCard *headView;
@property (nonatomic, strong) ImageCollectionView *pictureCollectonView;
@property (nonatomic, strong) NSMutableArray *urlOfCertificatesArray;  //存储资质证书url的数组
@property (nonatomic, strong) NSMutableArray *arrayOfSection;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) NSMutableArray *arrayOfSectionTitle;
@property (nonatomic, strong) NSMutableArray *arrayOfDescripionAdd;
@property (nonatomic, assign) CGFloat tempWidth;
@property (nonatomic, assign) CGFloat heightOfSectionOne; //1分区的高度
@end

@implementation CardOfTheCompanyView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
    
        self.delegate = self;
        self.dataSource = self;
        
        [self initData];
        [self initBasic];
        [self GetDetailofCompanyCardAction];
        
        
    }
    return self;
}


- (void)GetDetailofCompanyCardAction {
    _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"加载中...";
    NSString *companyID = [UserInfo getCompanyId];
    NSString *urlStr = [GetDetailofCompanyCard stringByAppendingFormat:@"&CompanyCode=%@",companyID];
    [AFNetClient GET_Path:urlStr completed:^(NSData *stringData, id JSONDict) {
        if ([JSONDict[@"Code"] isEqual:@0]) {
NSLog(@"--------00---%@",JSONDict );
            NSDictionary *dic = JSONDict[@"Data"];
            //0分区数据的model
            _model = [[InfoModel alloc]init];
            [_model setValuesForKeysWithDictionary:dic];
           
            //区头上边的数据处理
            _headView.label3.text = [NSString stringWithFormat:@"企业ID : %@", _model.Code];
            NSString *strUrl = [NSString replaceString:_model.LogoFormatUrl Withstr1:@"100" str2:@"100" str3:@"c"];
            [_headView.imageView sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"LOGO"]];
            
            //二维码
            NSDictionary *xiaoyinghaoDic = @{@"CompanyCode":_model.Code};
            NSString *companyCode = [NSString getStringWithDic:xiaoyinghaoDic];
            UIImage *tempImageCodeOfQr = [UIImage getCodeOfQrWithMark:companyCode withSize:300];
            _headView.imageCodeOfQr.image = tempImageCodeOfQr;

            //资质证书和公司介绍的数据处理
            NSMutableArray *arrayOfCertificates = dic[@"Certificates"];
            NSMutableArray *arrayOfDescriptions = dic[@"Descriptions"];
            [self ParserDataOfCertificates:arrayOfCertificates andDataOfDescriptions:arrayOfDescriptions];
            
            
        }
        [_hud setHidden:YES];
    } failed:^(NSError *error) {
        [_hud setHidden:YES];
    }];
}



     
- (void)ParserDataOfCertificates:(NSMutableArray*)array andDataOfDescriptions:(NSMutableArray *)array2{

    //资质证书
    if (![array isKindOfClass:[NSNull class]]) {
        for (NSMutableDictionary *dic in array) {
            [_urlOfCertificatesArray addObject:dic[@"FormatUrl"]];
        }
        [self initPicCollect];
    }else {
        _heightOfSectionOne = 44;
    }
    
    //公司描述
    if (![array2 isKindOfClass:[NSNull class]]) {
        for (NSMutableDictionary *dic in array2) {
            DescriptionsModel *descriptionModel = [[DescriptionsModel alloc]init];
            [descriptionModel setValuesForKeysWithDictionary:dic];
            if ([descriptionModel.Title isEqualToString:@"公司简介"]) {
                [_arrayOfSectionTitle replaceObjectAtIndex:0 withObject:descriptionModel];
                [_tempArray addObject:descriptionModel];
                
            }else
                if ([descriptionModel.Title isEqualToString:@"企业管理团队介绍"]) {
                    [_arrayOfSectionTitle replaceObjectAtIndex:1 withObject:descriptionModel];
                    [_tempArray addObject:descriptionModel];
                    
                }else
                    if ([descriptionModel.Title isEqualToString:@"业务范围介绍"]) {
                        [_arrayOfSectionTitle replaceObjectAtIndex:2 withObject:descriptionModel];
                        [_tempArray addObject:descriptionModel];
                        
                    }else{
                        [_tempArray addObject:descriptionModel];
                        [_arrayOfDescripionAdd addObject:descriptionModel];
                    }
        }
    }
    [self reloadData];
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
    self.pictureCollectonView.imageUrlArray =[_urlOfCertificatesArray copy];
    
    if (_urlOfCertificatesArray.count > 3) {
        _heightOfSectionOne = 160;
    }else {
        _heightOfSectionOne = 80;
    }
}



- (void)initData {
    _urlOfCertificatesArray = [NSMutableArray array];
    _tempArray = [NSMutableArray array];
    _arrayOfDescripionAdd = [NSMutableArray array];
    _arrayOfSectionTitle = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];
}


- (void)initBasic {
    _headView = [[HeadViewOfCard alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 156)];
    self.tableHeaderView = _headView;
    self.tableFooterView = [[UIView alloc]init];
    _arrayOfSection = [NSMutableArray arrayWithObjects:@"", @"资质证书",@"公司简介", @"企业管理团队介绍", @"业务范围介绍", nil];
    _tempWidth = [@"股东 :" boundingRectWithSize:CGSizeMake(kScreen_Width - 24, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
}


#pragma mark --tableView的代理方法--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5 + _arrayOfDescripionAdd.count;
//    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSString *str = nil;
        switch (indexPath.row) {
            case 0:
                str = _model.Stockholders;
                break;
            case 5:
                str = _model.Address;
                break;
            default:
                break;
        }
        CGSize size = [str boundingRectWithSize:CGSizeMake(kScreen_Width - 24 - _tempWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if (size.height > 17) {
            return 27 + size.height;
        }
    }
    if (indexPath.section == 1) {
        return _heightOfSectionOne;
    }
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
    if (indexPath.section > 4 && _arrayOfDescripionAdd.count > 0) {
        DescriptionsModel *descriptionModel = _arrayOfDescripionAdd[indexPath.section - 5];
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        CGFloat tempHeight = [descriptionModel.DescContent boundingRectWithSize:CGSizeMake(kScreen_Width - 24, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
        if (tempHeight > 17) {
            return tempHeight + 26;
        }else {
            return 44;
        }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 30;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
    customView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kScreen_Width - 25, 30)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    headerLabel.font = [UIFont boldSystemFontOfSize:12];
    if (section <= 4 ) {
        headerLabel.text = _arrayOfSection[section];
    }else {
        DescriptionsModel *descriptionModel = _arrayOfDescripionAdd[section - 5];
        headerLabel.text = descriptionModel.Title;
    }
    
    [customView addSubview:headerLabel];
    return customView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    if (indexPath.section == 0) {
        PersonalCardMyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[PersonalCardMyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell getModelOfCompanyCard:_model andIndexPath:indexPath];
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
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section >= 2) {
        SectionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (cell == nil) {
            cell = [[SectionTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        }
        if (_tempArray.count > 0) {
            if (indexPath.section < 5) {
                DescriptionsModel *descriptionModel = _arrayOfSectionTitle[indexPath.section - 2];
                [cell getModel:descriptionModel andType:nil];
            }else {
                DescriptionsModel *descriptionModel = _arrayOfDescripionAdd[indexPath.section - 5];
                [cell getModel:descriptionModel andType:nil];
            }
        }
        return cell;
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//tableView上下滑动的范围
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGPoint point = self.contentOffset;
    if (point.y < 0) {
        self.contentOffset = CGPointMake(0, 0);
    }
}



@end
