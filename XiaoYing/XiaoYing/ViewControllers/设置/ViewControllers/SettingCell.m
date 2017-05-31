//
//  SettingCell.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/14.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "SettingCell.h"
#import "ScanQRCodeVC.h"

@implementation SettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
        
        //初始化子视图
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    _userImg = [[UIImageView alloc] initWithFrame:CGRectZero];
//    _userImg.image = [UIImage imageNamed:@"ying"];
    _userImg.layer.cornerRadius = 5;
    _userImg.clipsToBounds = YES;
    [self.contentView addSubview:_userImg];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLab.font = [UIFont systemFontOfSize:16];
    _nameLab.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_nameLab];
    
    _codeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_codeBtn setImage:[UIImage imageNamed:@"code"] forState:UIControlStateNormal];
//    _codeBtn.backgroundColor = [UIColor cyanColor];
    [_codeBtn addTarget:self action:@selector(codeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_codeBtn];
    
//    _markImg = [[UIImageView alloc] initWithFrame:CGRectZero];
//    _markImg.image = [UIImage imageNamed:@"sign"];
//    [self.contentView addSubview:_markImg];

    
    _personalLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _personalLab.font = [UIFont systemFontOfSize:14];
    _personalLab.numberOfLines = 2;
    _personalLab.textColor = [UIColor whiteColor];
//    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_personalLab];
    
}

- (void)codeAction
{
    [self.viewController.navigationController pushViewController:[[ScanQRCodeVC alloc] init] animated:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _userImg.frame = CGRectMake(12, 10, 60, 60);
    
    NSString *iconURL = [NSString replaceString:self.profileModel.FaceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [_userImg sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@""]];
    
    _nameLab.frame = CGRectMake(_userImg.right + 12, (80 - 16 - 7 - 24) / 2.0 - 2, 200, 18);
    _nameLab.text = self.profileModel.Nick;
    
    _codeBtn.frame = CGRectMake(self.width-45-12, 0, 45, self.height);
    
//    _markImg.frame = CGRectMake(_nameLab.left, _nameLab.bottom + 7, 12, 12);
    
    _personalLab.frame = CGRectMake(_nameLab.left, _nameLab.bottom + 7, self.width - _userImg.right - 12 - 24, 30);
    _personalLab.text = self.profileModel.Signature;
    
    
}










@end
