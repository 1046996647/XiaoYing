//
//  EmployeeCell.m
//  XiaoYing
//
//  Created by ZWL on 16/9/23.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "EmployeeCell.h"

@implementation EmployeeCell

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
    
    _userImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    //    _userImg.image = [UIImage imageNamed:@"ying"];
    _userImg.layer.cornerRadius = 5;
    _userImg.layer.masksToBounds = YES;
    [self.contentView addSubview:_userImg];
    
    UIImageView *labelView = [[UIImageView alloc]initWithFrame:CGRectZero];
    labelView.image = [UIImage imageNamed:@"appointer2"];
    labelView.hidden = YES;
    [_userImg addSubview:labelView];
    self.labelView = labelView;
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLab.font = [UIFont systemFontOfSize:16];
    _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_nameLab];
    
    
    _mastJobNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _mastJobNameLab.font = [UIFont systemFontOfSize:12];
    _mastJobNameLab.textColor = [UIColor colorWithHexString:@"#848484"];
    _mastJobNameLab.textAlignment = NSTextAlignmentRight;
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_mastJobNameLab];
    
    _selectedControl = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectedControl addTarget:self action:@selector(selected_action:) forControlEvents:UIControlEventTouchUpInside];
    [_selectedControl setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
    [_selectedControl setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    [self.contentView addSubview:_selectedControl];
    
    _managerMark = [[UIButton alloc] initWithFrame:CGRectZero];
    [_managerMark setImage:[UIImage imageNamed:@"administrator_gray"] forState:UIControlStateNormal];
    [_managerMark setImage:[UIImage imageNamed:@"administrator"] forState:UIControlStateSelected];
    [self.contentView addSubview:_managerMark];

    
    
}


- (void)setModel:(EmployeeModel *)model
{
    _model = model;
    
    _userImg.frame = CGRectMake(12, (self.height-76/2.0)/2.0, 76/2.0, 76/2.0);
    
    NSString *iconURL = [NSString replaceString:_model.FaceURL Withstr1:@"100" str2:@"100" str3:@"c"];
    [_userImg sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"newfriends"]];
    
    _labelView.frame = CGRectMake(_userImg.width - 15, _userImg.height - 15, 15, 15);
    
    
    _nameLab.frame = CGRectMake(_userImg.right + 12, (self.height-16)/2, 165, 18);
    //    _nameLab.backgroundColor = [UIColor cyanColor];
    _nameLab.text = _model.EmployeeName;
    
    _selectedControl.frame = CGRectMake(kScreen_Width-45, 0, 45, self.height);
    _managerMark.frame = CGRectMake(kScreen_Width-45, 0, 45, self.height);
    
    
    if (self.type == 0) {// 选择的
        _mastJobNameLab.frame = CGRectMake(_nameLab.right-30, (self.height-12)/2, kScreen_Width - _nameLab.right - 12, 12);
        _managerMark.hidden = YES;
        
    }
    else if (self.type == 1) {
        _mastJobNameLab.frame = CGRectMake(_nameLab.right, (self.height-12)/2, kScreen_Width - _nameLab.right - 12, 12);
        //        _mastJobNameLab.backgroundColor = [UIColor blackColor];
        _selectedControl.hidden = YES;
        _managerMark.hidden = YES;
        
    } else {// 管理员
        _mastJobNameLab.frame = CGRectMake(_nameLab.right-30, (self.height-12)/2, kScreen_Width - _nameLab.right - 12, 12);
        //        _mastJobNameLab.backgroundColor = [UIColor blackColor];
        _selectedControl.hidden = YES;
    }
    
    // 是否是管理员（创建者也是）
    if (![_model.RoleType isEqual:@2]) {
        
        _managerMark.selected = YES;

    }else {
        
        _managerMark.selected = NO;
    }
    
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
            _mastJobNameLab.text = dic[@"JobName"];
        }
    }
    
    // 兼职
    if (_model.isConcurrentLeader) {
        for (NSDictionary *dic in _model.Jobs) {
            if ([_currentDepartmentId isEqualToString:dic[@"DepartmentId"]]) {
                _mastJobNameLab.text = [NSString stringWithFormat:@"(兼)%@",dic[@"JobName"]];
                
            }
        }
    }
    
    
    if (self.model.isSelected) {
        _selectedControl.selected = YES;
    }
    else {
        _selectedControl.selected = NO;
        
    }
}

- (void)selected_action:(UIButton *)btn
{
    _model.isSelected = !_model.isSelected;
    
    if (_sendEmployeeBlock) {
        _sendEmployeeBlock(_model);
    }
}

@end
