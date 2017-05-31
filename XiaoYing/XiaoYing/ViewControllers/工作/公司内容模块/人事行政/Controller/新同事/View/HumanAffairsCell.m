//
//  HumanAffairsCell.m
//  XiaoYing
//
//  Created by MengFanBiao on 16/6/12.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "HumanAffairsCell.h"
#import "NewWorkersModel.h"


@implementation HumanAffairsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.identifier = reuseIdentifier;
        
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if ([reuseIdentifier isEqualToString:@"cell1"]) {
            //初始化子视图
            [self initSubViews];
        } else {
    
            
            _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
            _nameLab.font = [UIFont systemFontOfSize:16];
            _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
            [self.contentView addSubview:_nameLab];
            
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        
    }
    return self;
}

- (void)initSubViews
{
    _userImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    _userImg.frame = CGRectMake(12, (self.height-76/2.0)/2.0, 76/2.0, 76/2.0);
     _userImg.image = [UIImage imageNamed:@"ying"];
    _userImg.layer.cornerRadius = 5;
    _userImg.clipsToBounds = YES;
    [self.contentView addSubview:_userImg];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLab.frame = CGRectMake(_userImg.right + 12, self.height / 2 - 18, 80, 16);
    _nameLab.font = [UIFont systemFontOfSize:16];
    _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _nameLab.text = @"张伟良";
//_nameLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_nameLab];
    
    
    _Remark = [[UILabel alloc] initWithFrame:CGRectZero];
    _Remark.frame = CGRectMake(_userImg.right + 12, _nameLab.bottom + 6, 160, 12);
    _Remark.font = [UIFont systemFontOfSize:12];
    _Remark.textColor = [UIColor colorWithHexString:@"#848484"];
    _Remark.text = @"备注";
    [self.contentView addSubview:_Remark];
    
    _personalLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _personalLab.frame = CGRectMake(_nameLab.right + 3, _nameLab.top + 3, kScreen_Width - _nameLab.right - 3 - 12, 12);
    _personalLab.font = [UIFont systemFontOfSize:12];
    _personalLab.textColor = [UIColor colorWithHexString:@"#848484"];
    _personalLab.textAlignment = NSTextAlignmentRight;
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_personalLab];
    
    _StatusCN = [[UILabel alloc] initWithFrame:CGRectZero];
    _StatusCN.frame = CGRectMake(_personalLab.left , _personalLab.bottom + 6, _personalLab.width, 12);
    _StatusCN.font = [UIFont systemFontOfSize:12];
    _StatusCN.textColor = [UIColor colorWithHexString:@"#848484"];
    _StatusCN.textAlignment = NSTextAlignmentRight;
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_StatusCN];
    
}


- (void)getModel:(NewWorkersModel *)model {
    _nameLab.text = model.Nick;
    _Remark.text = model.Remark;
    _personalLab.text = model.Time;
    _StatusCN.text = model.StatusCN;
    NSString *iconStr = [NSString replaceString:model.FaceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [_userImg sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"newfriends"]];

    
}



@end
