//
//  SettingCell.m
//  XiaoYing
//
//  Created by ZWL on 15/12/14.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "DepartManagerAuthorityCell.h"

@interface DepartManagerAuthorityCell ()
@property (nonatomic, strong) UIImageView *labelView;

@end


@implementation DepartManagerAuthorityCell

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
        
        if ([reuseIdentifier isEqualToString:@"cell1"] || [reuseIdentifier isEqualToString:@"cell3"]) {
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
    //    _userImg.image = [UIImage imageNamed:@"ying"];
    _userImg.layer.cornerRadius = 5;
    _userImg.clipsToBounds = YES;
    [self.contentView addSubview:_userImg];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLab.font = [UIFont systemFontOfSize:16];
    _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_nameLab];
    
    
    _personalLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _personalLab.font = [UIFont systemFontOfSize:12];
    _personalLab.textColor = [UIColor colorWithHexString:@"#848484"];
    _personalLab.textAlignment = NSTextAlignmentRight;
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_personalLab];
    
    _selectedControl = [[UIButton alloc] initWithFrame:CGRectZero];
    [_selectedControl addTarget:self action:@selector(selected_action:) forControlEvents:UIControlEventTouchUpInside];
    //    _selectedControl.hidden = YES;
    //    _editControl.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_selectedControl];
    
    _labelView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _labelView.image = [UIImage imageNamed:@"appointer2"];
    _labelView.hidden = YES;
    [_userImg addSubview:_labelView];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
 
    
    if ([self.identifier isEqualToString:@"cell1"] || [self.identifier isEqualToString:@"cell3"]) {
        
        _userImg.frame = CGRectMake(12, (self.height-76/2.0)/2.0, 76/2.0, 76/2.0);
        NSString *iconURL = [NSString replaceString:_model.FaceURL Withstr1:@"100" str2:@"100" str3:@"c"];
        [_userImg sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"newfriends"]];
        //若是领导者，则添加一个标记
        _labelView.frame = CGRectMake(_userImg.width - 15, _userImg.height - 15, 15, 15);


        _nameLab.frame = CGRectMake(_userImg.right + 12, (self.height-16)/2, 135, 16);
        if (![_model.EmployeeName isKindOfClass:[NSNull class]]) {
             _nameLab.text = _model.EmployeeName;
        }
        
        
        _personalLab.frame = CGRectMake(_nameLab.right, (self.height-12)/2, kScreen_Width - _nameLab.right - 45, 12);

        // 是否是领导人
        if (_model.isMastLeader || _model.isConcurrentLeader) {
            
            _labelView.hidden = NO;
        }
        else {
            _labelView.hidden = YES;
            
        }
        
        // 主职
        for (NSDictionary *dic in _model.Jobs) {
            if ([dic[@"IsMastJob"] boolValue]) {
                _personalLab.text = dic[@"JobName"];
            }
        }
        
        // 兼职
        if (_model.isConcurrentLeader) {
            for (NSDictionary *dic in _model.Jobs) {
                if ([_currentDepartmentId isEqualToString:dic[@"DepartmentId"]]) {
                    _personalLab.text = [NSString stringWithFormat:@"(兼)%@",dic[@"JobName"]];
                }
            }
        }

//        _personalLab.text = _model.MastJobName;
//        _personalLab.text = @"科技产业部";
        
        _selectedControl.frame = CGRectMake(kScreen_Width-45, 0, 45, self.height);
        if (![_model.RoleType isEqual:@2]) {
            
            [_selectedControl setImage:[UIImage imageNamed:@"administrator"] forState:UIControlStateNormal];
        }else {
            
            [_selectedControl setImage:[UIImage imageNamed:@"administrator_white"] forState:UIControlStateNormal];
        }
        

        
    } else {
        
//        _selectedControl.frame = CGRectMake(0, 0, 45, self.height);
//        [_selectedControl setImage:[UIImage imageNamed:@"administrator"] forState:UIControlStateNormal];
        
        _nameLab.frame = CGRectMake(12, (self.height-16)/2, 200, 16);
        //    _nameLab.text = self.profileModel.Nick;
        _nameLab.text = self.title;
        
    }
    
    
    
    
    
}

- (void)selected_action:(UIButton *)btn
{
    
}


@end
