//
//  FriendRequestCell.m
//  XiaoYing
//
//  Created by ZWL on 16/10/26.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "FriendRequestCell.h"

@implementation FriendRequestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化子视图
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews
{
    
    _headImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headImgView.layer.cornerRadius = 5;
    _headImgView.clipsToBounds = YES;
    [self.contentView addSubview:_headImgView];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLab.font = [UIFont systemFontOfSize:16];
    _nameLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _nameLab.numberOfLines = 0;
    _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_nameLab];
    
    
    _decLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _decLab.font = [UIFont systemFontOfSize:12];
    _decLab.textColor = [UIColor colorWithHexString:@"#848484"];
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_decLab];
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width-124, 0, 124, 50)];
    [self.contentView addSubview:_baseView];
    
    UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, (50-30)/2, 50, 30)];
    agreeBtn.backgroundColor = [UIColor colorWithHexString:@"#02bb00"];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    agreeBtn.layer.cornerRadius = 5;
    agreeBtn.layer.masksToBounds = YES;
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [_baseView addSubview:agreeBtn];
    agreeBtn.tag = 100;
    [agreeBtn addTarget:self action:@selector(requestAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *unAgreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(agreeBtn.right+12, (50-30)/2, 50, 30)];
    unAgreeBtn.backgroundColor = [UIColor colorWithHexString:@"#f94040"];
    unAgreeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    unAgreeBtn.layer.cornerRadius = 5;
    unAgreeBtn.layer.masksToBounds = YES;
    [unAgreeBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [_baseView addSubview:unAgreeBtn];
    unAgreeBtn.tag = 101;
    [unAgreeBtn addTarget:self action:@selector(requestAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _stateBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width-60-12, (50-30)/2, 60, 30)];
    [_stateBtn setTitleColor:[UIColor colorWithHexString:@"#cccccc"] forState:UIControlStateNormal];
    _stateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_stateBtn setTitle:@"已同意" forState:UIControlStateNormal];
    [_stateBtn setTitle:@"已拒绝" forState:UIControlStateSelected];
    [self.contentView addSubview:_stateBtn];
        
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _headImgView.frame = CGRectMake(12, 6, 38, 38);
    //    [_fileControl setImage:[UIImage imageNamed:@"ying"] forState:UIControlStateNormal];
    //    _headImgView.image = [UIImage imageNamed:@"ying"];
    NSString *iconURL = [NSString replaceString:_model.FaceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:iconURL]];
    
    _nameLab.frame = CGRectMake(_headImgView.right + 12, 8, 150, 18);
    _nameLab.text = _model.Nick;
    
    // 0:待处理 1:已同意 2：拒绝
    if (_model.Status.integerValue == 0) {
        _stateBtn.hidden = YES;
        _baseView.hidden = NO;
    }
    else {
        _stateBtn.hidden = NO;
        _baseView.hidden = YES;
        
        if (_model.Status.integerValue == 1) {
            _stateBtn.selected = NO;
        }
        else {
            _stateBtn.selected = YES;

        }
    }
    
    _decLab.frame = CGRectMake(_nameLab.left, _nameLab.bottom+8, 150, 12);
    _decLab.text = _model.Reason;
    
    
}

- (void)requestAction:(UIButton *)btn
{
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    [paramDic  setValue:self.model.ProfileId forKey:@"requestProfileId"];
    NSString *requestStr = nil;

    if (btn.tag == 100) {
        
        requestStr = AgreeUserApply;
    }
    else {
        requestStr = RefuseFriend;

    }
    
    [AFNetClient  POST_Path:requestStr params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg];
            
        } else {
            
            if (btn.tag == 100) {
                
                // 同意成功好友刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:kAgreeFriendSuccessNotification object:nil];
            }

            if (self.requestBlock) {
                self.requestBlock();
            }
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD showMessage:@"网络似乎已断开!"];
        
    }];

}

@end
