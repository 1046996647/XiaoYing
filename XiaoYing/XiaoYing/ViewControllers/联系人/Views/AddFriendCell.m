//
//  FileManangeCell.m
//  XiaoYing
//
//  Created by yinglaijinrong on 16/1/19.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "AddFriendCell.h"

@implementation AddFriendCell

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
    
    
    _emailLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _emailLab.font = [UIFont systemFontOfSize:12];
    _emailLab.textColor = [UIColor colorWithHexString:@"#848484"];
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_emailLab];
    
    
    _sexBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    //    _sexBtn.indexPath = self
    [_sexBtn setImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
    [_sexBtn setImage:[UIImage imageNamed:@"woman"] forState:UIControlStateSelected];
    [self.contentView addSubview:_sexBtn];

    
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

    _emailLab.frame = CGRectMake(_nameLab.left, _nameLab.bottom+4, 150, 14);
    _emailLab.text = _model.Signature;
    
    _sexBtn.frame = CGRectMake(self.width-15-12, 0, 15, self.height);
    if (self.model.Gender.integerValue == 0) {
    }
    else if (self.model.Gender.integerValue == 1) {
        _sexBtn.selected = NO;
    }
    else {
        _sexBtn.selected = YES;
    }
    
}


@end
