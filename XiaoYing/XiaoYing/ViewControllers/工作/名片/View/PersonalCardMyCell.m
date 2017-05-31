//
//  PersonalCardMyCell.m
//  
//
//  Created by GZH on 2016/12/22.
//
//

#import "PersonalCardMyCell.h"
#import "PersonalCardModel.h"
#import "InfoModel.h"
@interface PersonalCardMyCell ()

@property (nonatomic, strong)UILabel *label1;
@property (nonatomic, strong)UILabel *label2;
@property (nonatomic, strong)UIImageView *logo;
@property (nonatomic, strong)NSMutableArray *arrayOfData;
@property (nonatomic, strong)NSMutableArray *arrayOfCompanyCard;

@end

@implementation PersonalCardMyCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //个人名片
        if ([reuseIdentifier isEqualToString:@"PersonalCardCell"]) {
            [self.contentView addSubview:self.label1];
            [self.contentView addSubview:self.label2];
            [self.contentView addSubview:self.logo];
            _arrayOfData = [NSMutableArray arrayWithObjects:@"电话 :",@"邮箱 :", @"传真 :", @"公司名称 :", @"公司logo :", @"网址 :",@"地址 :", nil];
        }else {
            
            //企业名片
            [self.contentView addSubview:self.label1];
            [self.contentView addSubview:self.label2];

            _arrayOfCompanyCard = [NSMutableArray arrayWithObjects:@"股东 :",@"电话 :", @"备用电话 :", @"公司传真 :", @"网址 :", @"地址 :", nil];
        }
        

    }
    return self;
}



- (UILabel *)label1 {
    if (!_label1) {
        _label1 = [[UILabel alloc]initWithFrame:CGRectMake(12, 15, 0, 14)];
        _label1.font = [UIFont systemFontOfSize:14];
        _label1.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _label1;
}

- (UILabel *)label2 {
    if (!_label2) {
        _label2 = [[UILabel alloc]init];
        _label2.font = [UIFont systemFontOfSize:14];
        _label2.numberOfLines = 0;
        _label2.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _label2;
}

- (UIImageView *)logo {
    if (!_logo) {
        _logo = [[UIImageView alloc]init];
    }
    return _logo;
}

- (void)getModel:(PersonalCardModel *)model andIndex:(NSInteger)index{
    NSString *str = _arrayOfData[index];
    _label1.width = [str boundingRectWithSize:CGSizeMake(kScreen_Width - 24, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |
              NSStringDrawingUsesLineFragmentOrigin |
              NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    _label1.text = _arrayOfData[index];
    
  
    if (index == 4) {
        
        _logo.frame = CGRectMake(_label1.right + 7, 9.5, 25, 25);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(makeThePictureBigAction)];
         _logo.userInteractionEnabled = YES;
        [_logo addGestureRecognizer:tap];

        NSString *strUrl = [NSString replaceString:model.lOGFormatUrl Withstr1:@"300" str2:@"300" str3:@"c"];
        [_logo sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"LOGO"]];

    }else {
        

    _label2.frame = CGRectMake(_label1.right + 7, 15, kScreen_Width - _label1.right - 12, 16);
    switch (index) {
        case 0:
            if ([model.Mobile isEqualToString:@""] || model.Mobile == NULL) {
                _label2.text = @"(空)";
            }else {
                _label2.text = model.Mobile;
            }
            break;
        case 1:
            if ([model.Email isEqualToString:@""] || model.Email == NULL) {
                _label2.text = @"(空)";
            }else {
                _label2.text = model.Email;
            }
            break;
        case 2:
            if ([model.Fax isEqualToString:@""] || model.Fax == NULL) {
                _label2.text = @"(空)";
            }else {
                _label2.text = model.Fax;
            }
            break;
        case 3:
            if ([model.CompanyName isEqualToString:@""] || model.CompanyName == NULL) {
                _label2.text = @"(空)";
            }else {
                _label2.text = model.CompanyName;
            }
            
            break;
     
        case 5:
            if ([model.Url isEqualToString:@""] || model.Url == NULL) {
                _label2.text = @"(空)";
            }else {
                _label2.text = model.Url;
            }
            
            break;
        case 6:
            if ([model.Address isEqualToString:@""] || model.Address == NULL) {
                _label2.text = @"(空)";
            }else {
                _label2.text = model.Address;
            }
            
            break;
            
        default:
            break;
    }
    }
}

- (void)makeThePictureBigAction {
    
    ImageBrowseVC *browserVC = [ImageBrowseVC new];
    browserVC.sizeType = @"1";
    browserVC.tempImage = _logo.image;
    [self.viewController presentViewController:browserVC animated:YES completion:nil];
}



- (void)getModelOfCompanyCard:(InfoModel *)model andIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        NSString *str = _arrayOfCompanyCard[indexPath.row];
        _label1.width = [str boundingRectWithSize:CGSizeMake(kScreen_Width - 24, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |
                         NSStringDrawingUsesLineFragmentOrigin |
                         NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
        
        _label1.text = _arrayOfCompanyCard[indexPath.row];
        _label2.frame = CGRectMake(_label1.right + 7, 15, kScreen_Width - _label1.right - 12, 14);
    
        
        //1，5cell自适应
        if (indexPath.row == 0 || indexPath.row == 5) {
            NSString *str = nil;
            switch (indexPath.row) {
                case 0:
                    str = model.Stockholders;
                    break;
                case 5:
                    str = model.Address;
                    break;
                default:
                    break;
            }

        CGFloat tepHeight = [str boundingRectWithSize:CGSizeMake(kScreen_Width - _label1.right - 12, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |
                             NSStringDrawingUsesLineFragmentOrigin |
                             NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
            if (tepHeight > 17) {
                _label2.frame = CGRectMake(_label1.right + 7, 15, kScreen_Width - _label1.right - 12, tepHeight);
            }
        }
        switch (indexPath.row) {
            case 0:
                if (model.Stockholders == NULL || [model.Stockholders isEqualToString:@""]) {
                    _label2.text = @"(空)";
                }else {
                    _label2.text = model.Stockholders;
                }
                
                break;
            case 1:
                if (model.MastPhones == NULL || [model.MastPhones isEqualToString:@""]) {
                    _label2.text = @"(空)";
                }else {
                    _label2.text = model.MastPhones;
                }
                
                break;
            case 2:
                if (model.ReservePhones == NULL || [model.ReservePhones isEqualToString:@""]) {
                    _label2.text = @"(空)";
                }else {
                    _label2.text = model.ReservePhones;
                }
               
                break;
            case 3:
                if (model.Fax == NULL || [model.Fax isEqualToString:@""]) {
                    _label2.text = @"(空)";
                }else {
                    _label2.text = model.Fax;
                }
                
                break;
            case 4:
                if (model.Url == NULL || [model.Url isEqualToString:@""]) {
                    _label2.text = @"(空)";
                }else {
                    _label2.text = model.Url;
                }
                
                break;
            case 5:
                if (model.Address == NULL || [model.Address isEqualToString:@""]) {
                    _label2.text = @"(空)";
                }else {
                    _label2.text = model.Address;
                }
                
                break;
      
            default:
                break;
        }
    }else {
        
        
        
        
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
