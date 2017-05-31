//
//  DepartmentCell.m
//  XiaoYing
//
//  Created by ZWL on 16/2/18.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DepartmentCell.h"

@implementation DepartmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化子视图
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    //职务
    self.postLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, 150, 20)];
    self.postLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.postLab.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.postLab];
    
    //人数
    self.countLab = [[UILabel alloc] initWithFrame:CGRectMake(12, self.postLab.bottom-2, 150, 16)];
    self.countLab.textColor = [UIColor colorWithHexString:@"#848484"];
    self.countLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.countLab];
    
    //时间
    self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-150-12, 4, 150, 20)];
    self.timeLab.textAlignment = NSTextAlignmentRight;
    self.timeLab.textColor = [UIColor colorWithHexString:@"#848484"];
    self.timeLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.timeLab];
    
    //部门
    self.departmmentLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-150-12, self.timeLab.bottom-2, 150, 16)];
    self.departmmentLab.textAlignment = NSTextAlignmentRight;
    self.departmmentLab.textColor = [UIColor colorWithHexString:@"#848484"];
    self.departmmentLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.departmmentLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.postLab.text = @"UI设计师";
    
    self.countLab.text = @"2";
    
    self.timeLab.text = @"2016-02-02 15:58";
    
    self.departmmentLab.text = @"科技产业部";
}

@end
