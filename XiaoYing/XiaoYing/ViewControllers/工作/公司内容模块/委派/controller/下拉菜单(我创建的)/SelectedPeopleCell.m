//
//  SelectedPeopleCell.m
//  XiaoYing
//
//  Created by ZWL on 16/5/23.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "SelectedPeopleCell.h"

@implementation SelectedPeopleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor redColor];
        
        // 标题图片
        _titleImg = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _titleImg.image = [UIImage imageNamed:@"ying"];
        _titleImg.layer.cornerRadius = 6;
        _titleImg.clipsToBounds = YES;
        _titleImg.userInteractionEnabled = YES;
        [self.contentView addSubview:_titleImg];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete_person"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(selected_action:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 13, 13, 0);
        [self.contentView addSubview:_deleteBtn];
//        _deleteBtn.backgroundColor = [UIColor cyanColor];

        
        // 职务
        _dutyLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _dutyLab.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
        _dutyLab.textAlignment = NSTextAlignmentCenter;
        _dutyLab.layer.cornerRadius = 6;
        _dutyLab.clipsToBounds = YES;
        _dutyLab.font = [UIFont systemFontOfSize:11];
        _dutyLab.textColor = [UIColor whiteColor];
        [_titleImg addSubview:_dutyLab];
        
        // 申请人
        _applyPeople = [[UILabel alloc] initWithFrame:CGRectZero];
//        _applyPeople.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
        _applyPeople.textAlignment = NSTextAlignmentCenter;
        _applyPeople.layer.cornerRadius = 6;
        _applyPeople.clipsToBounds = YES;
        _applyPeople.font = [UIFont systemFontOfSize:12];
        _applyPeople.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_applyPeople];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleImg.frame = CGRectMake(0, 8, self.width-8, self.height-8);
    NSString *iconStr = [NSString replaceString:_model.FaceURL Withstr1:@"100" str2:@"100" str3:@"c"];
    [_titleImg sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"newfriends"]];
    
    _deleteBtn.frame = CGRectMake(self.width-30, 0, 30, 30);
    
    _dutyLab.frame = CGRectMake(0, _titleImg.height-15, _titleImg.width, 15);
    
    // 主职
    for (NSDictionary *dic in _model.Jobs) {
        if ([dic[@"IsMastJob"] boolValue]) {
            _dutyLab.text = dic[@"JobName"];
            
        }
    }
    
    _applyPeople.frame = CGRectMake(0, _titleImg.bottom+5, _titleImg.width, 15);
    _applyPeople.text = _model.EmployeeName;

}

- (void)selected_action:(UIButton *)btn
{
    if (_deleteBlock) {
        _deleteBlock(_model);
    }
}

@end
