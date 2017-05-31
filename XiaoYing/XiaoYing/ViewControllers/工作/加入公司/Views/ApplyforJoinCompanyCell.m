//
//  ApplyforJoinCompanyCell.m
//  XiaoYing
//
//  Created by GZH on 16/8/18.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "ApplyforJoinCompanyCell.h"
#import "PushViewVC.h"
#import "ApplyForJoinTheCompanyModel.h"
#import "JoinTheCompanyView.h"

@interface ApplyforJoinCompanyCell ()<PushViewVCDelegate>

@property (nonatomic, strong)UIImageView *image;
@property (nonatomic, strong)PushViewVC *pushView;
@property (nonatomic, strong)UILabel *companyLabel;
@property (nonatomic, strong)UILabel *companyIDLabel;
@property (nonatomic, strong)UILabel *companyAddressLabel;
@property (nonatomic, strong)NSString *tempStr;

@end

@implementation ApplyforJoinCompanyCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initUI];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)initUI {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width - 24, 154 - 12)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 5;
    [self.contentView addSubview:backView];
    
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 38, 38)];
    _image.layer.masksToBounds = YES;
    _image.layer.cornerRadius = 5;
    [backView addSubview:_image];
    
    _companyLabel = [self Z_createLabelWithTitle:@"杭州赢莱金融信息服务有限公司" buttonFrame:CGRectMake(_image.right + 10, 15, self.width - 20 - 38, 16) textFont:16 colorStr:@"#333333" aligment:NSTextAlignmentLeft];
    [backView addSubview:_companyLabel];
    
    _companyIDLabel = [self Z_createLabelWithTitle:@"公司ID : 123546" buttonFrame:CGRectMake(_image.right + 10, _companyLabel.bottom + 6, self.width - 20 - 38, 12) textFont:12 colorStr:@"#848484" aligment:NSTextAlignmentLeft];
    [backView addSubview:_companyIDLabel];
    
    UIImageView *imagePic = [[UIImageView alloc]initWithFrame:CGRectMake(10, _image.bottom + 10, 10, 12)];
    imagePic.image = [UIImage imageNamed:@"location"];
    [backView addSubview:imagePic];
    
    _companyAddressLabel = [self Z_createLabelWithTitle:@"浙江省杭州市江干区解放东路迪凯银座1301室" buttonFrame:CGRectMake(imagePic.right + 6, _image.bottom + 10, self.width - imagePic.right - 6 -24, 12) textFont:12 colorStr:@"#848484" aligment:NSTextAlignmentLeft];
    [backView addSubview:_companyAddressLabel];
    
    _statusLabel = [self Z_createLabelWithTitle:@"等待HR处理申请" buttonFrame:CGRectMake(10, _companyAddressLabel.bottom + 6, self.width - 20, 12) textFont:12 colorStr:@"#f99740" aligment:NSTextAlignmentLeft];
    [backView addSubview:_statusLabel];
    
    _drawButton = [self Z_createButtonWithTitle:@"撤回" buttonFrame:CGRectMake(0, _statusLabel.bottom + 10, kScreen_Width - 24 , 44) colorStr:@"#f94040"];
    _drawButton.hidden = YES;
    [_drawButton addTarget:self action:@selector(drawAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_drawButton];
    
    _deleteButton = [self Z_createButtonWithTitle:@"删除" buttonFrame:CGRectMake(0, _statusLabel.bottom + 10, kScreen_Width - 24 , 44) colorStr:@"#333333"];
    _deleteButton.hidden = YES;
    [_deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_deleteButton];
    
    
    
    _agreeButton = [self Z_createButtonWithTitle:@"同意" buttonFrame:CGRectMake(0, _statusLabel.bottom + 10, (kScreen_Width - 24) / 2, 44) colorStr:@"#02bb00"];
    [_agreeButton addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_agreeButton];
    
    _refuseButton = [self Z_createButtonWithTitle:@"拒绝" buttonFrame:CGRectMake((kScreen_Width - 24) / 2, _statusLabel.bottom + 10, (kScreen_Width - 24) / 2, 44) colorStr:@"#f94040"];
    [_refuseButton addTarget:self action:@selector(refuseAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_refuseButton];
    
}

- (void)getModel:(ApplyForJoinTheCompanyModel *)model {
    NSString *iconStr = [NSString replaceString:model.CompanyLogUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [_image sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"LOGO"]];
    _companyLabel.text = model.CompanyName;
    _companyIDLabel.text = [NSString stringWithFormat:@"公司ID : %@", model.CompanyCode];
    _companyAddressLabel.text = model.CompanyAddress;
    _statusLabel.text = model.Status;
    
    if ([model.Status isEqualToString:@"等待HR同意"]) {
        _drawButton.hidden = NO;
        _deleteButton.hidden = YES;
        _agreeButton.hidden = YES;
        _refuseButton.hidden = YES;
        _tempStr = model.Id;
    }else
        if ([model.Status isEqualToString:@"HR已拒绝"]) {
            _deleteButton.hidden = NO;
            _drawButton.hidden = YES;
            _agreeButton.hidden = YES;
            _refuseButton.hidden = YES;
            _tempStr = model.Id;
        }else
            if ([model.Status isEqualToString:@"邀请我加入公司"]) {
                _agreeButton.hidden = NO;
                _refuseButton.hidden = NO;
                _deleteButton.hidden = YES;
                _drawButton.hidden = YES;
                _tempStr = model.Id;
            }else
                if ([model.Status isEqualToString:@"等待HR处理"]) {
                    _agreeButton.hidden = YES;
                    _refuseButton.hidden = YES;
                    _deleteButton.hidden = YES;
                    _drawButton.hidden = NO;
                    _tempStr = model.Id;
                }
}


- (void)drawAction:(UIButton *)sender {
    _pushView = [[PushViewVC alloc]init];
    _pushView.delegate = self;
    _pushView.index = sender.tag;
    _pushView.queueID = _tempStr;
    _pushView.maskStr = @"撤回";
    _pushView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    _pushView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    _pushView.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController.navigationController presentViewController:_pushView animated:YES completion:nil];
}

- (void)deleteAction:(UIButton *)sender {
    _pushView = [[PushViewVC alloc]init];
    _pushView.delegate = self;
    _pushView.index = sender.tag;
    _pushView.queueID = _tempStr;
    _pushView.maskStr = @"删除";
    _pushView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    _pushView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    _pushView.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController.navigationController presentViewController:_pushView animated:YES completion:nil];
}

- (void)agreeAction:(UIButton *)sender {
    _pushView = [[PushViewVC alloc]init];
    _pushView.delegate = self;
    _pushView.index = sender.tag;
    _pushView.queueID = _tempStr;
    _pushView.maskStr = @"同意";
    _pushView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    _pushView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    _pushView.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController.navigationController presentViewController:_pushView animated:YES completion:nil];
    
    
}

- (void)refuseAction:(UIButton *)sender {
    _pushView = [[PushViewVC alloc]init];
    _pushView.delegate = self;
    _pushView.index = sender.tag;
    _pushView.queueID = _tempStr;
    _pushView.maskStr = @"拒绝";
    _pushView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    _pushView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    _pushView.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController.navigationController presentViewController:_pushView animated:YES completion:nil];
}

- (void)agreeCompanyAction {
    _agreeButton.hidden = YES;
    _refuseButton.hidden = YES;
    _deleteButton.hidden = YES;
    _drawButton.hidden = NO;
}

#pragma mark --button--  --label--
- (UILabel *)Z_createLabelWithTitle:(NSString *)title
                        buttonFrame:(CGRect)frame
                           textFont:(CGFloat)font
                           colorStr:(NSString *)colorStr
                           aligment:(NSTextAlignment)aligment {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = [UIColor colorWithHexString:colorStr];
    label.textAlignment = aligment;
    return label;
}

- (UIButton *)Z_createButtonWithTitle:(NSString *)title
                          buttonFrame:(CGRect)frame
                             colorStr:(NSString *)colorStr{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setFrame:frame];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.textColor = [UIColor whiteColor];
    button.backgroundColor = [UIColor colorWithHexString:colorStr];
    return button;
}



@end
