//
//  ApplyVoucherCell.m
//  申请凭证
//
//  Created by YL20071 on 16/10/14.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "ApplyVoucherCell.h"
#import "ApplyVoucherDetailVC.h"
@interface ApplyVoucherCell()
{
    UILabel * _contentLabel;
    UILabel * _dayLabel;//这个是具体的日期：几几年几月几日
    UILabel *_titleLabel;//标题label
    UIView *_mainView;//主要的View
    UIImageView *_headerView;//头像
    UILabel *_creatorLabel;//申请人的名字
    UIImageView *_approvalImageView;//申请凭证图片
}
@end

@implementation ApplyVoucherCell

//初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        
        _mainView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreen_Width - 20, 70)];
        _mainView.layer.cornerRadius  = 5;
        _mainView.layer.masksToBounds = YES;
        _mainView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_mainView];
        
        //头像
        _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        _headerView.layer.cornerRadius = 5;
        _headerView.layer.masksToBounds = YES;
        [_mainView addSubview:_headerView];
        
        //申请人
        _creatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, 50, 15)];
        _creatorLabel.backgroundColor = [UIColor blackColor];
        _creatorLabel.alpha = .6;
        _creatorLabel.textColor = [UIColor whiteColor];
        _creatorLabel.font = [UIFont systemFontOfSize:12];
        _creatorLabel.layer.cornerRadius  = 5;
        _creatorLabel.layer.masksToBounds = YES;
        _creatorLabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:_creatorLabel];
        
        //申请凭证图片
        _approvalImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_mainView.width - 30, 10, 20, 20)];
        _approvalImageView.image = [UIImage imageNamed:@"credentials_small"];
        [_mainView addSubview:_approvalImageView];
        
        //标题
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headerView.right + 10, 10, 100, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        [_mainView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headerView.right + 10, _titleLabel.bottom + 5, _mainView.width - _headerView.right - 20, 30)];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        
        [_mainView addSubview:_contentLabel];
        
        _dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(_mainView.width -100 - 35, _contentLabel.top - 20, 100, 12)];
        _dayLabel.font = [UIFont systemFontOfSize:12];
        _dayLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _dayLabel.textAlignment = NSTextAlignmentRight;
        [_mainView addSubview:_dayLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(gotoDetail)];
        [_mainView addGestureRecognizer:tap];
    }
    return self;
}


-(void)setModel:(ApplyVoucherModel *)model{
    _model = model;
    _contentLabel.text = model.applyContent;
    _contentLabel.numberOfLines = 2;
    _titleLabel.text = model.approvalTypeName;
    NSString *day = [model.passingTime substringToIndex:10];
    _dayLabel.text = day;
    _creatorLabel.text = model.createrName;
    NSString *iconStr = [NSString replaceString:model.faceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [_headerView sd_setImageWithURL:[NSURL URLWithString:iconStr]];

}

//跳转到凭证详情界面
-(void)gotoDetail{
    ApplyVoucherDetailVC *vc = [[ApplyVoucherDetailVC alloc]init];
    vc.model = self.model;
    [self.viewController.navigationController pushViewController:vc animated:YES];
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
