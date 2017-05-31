//
//  PersonCell.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/15.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "PersonCell.h"

@implementation PersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_titleLab];
        
        _dataLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _dataLab.font = [UIFont systemFontOfSize:16];
        _dataLab.textAlignment = NSTextAlignmentRight;
        _dataLab.numberOfLines = 2;
//        _dataLab.textColor = [UIColor colorWithHexString:@"#848484"];
        [self.contentView addSubview:_dataLab];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    //计算字符串高度
    NSString *str = self.data;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(200, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    _titleLab.frame = CGRectMake(24, self.height / 2 - textSize.height / 2, 100, textSize.height);
    _titleLab.text = self.title;
    
    _dataLab.frame = CGRectMake(kScreen_Width - 200 - 12, self.height / 2 - textSize.height / 2, 200, textSize.height+2);
//    _dataLab.backgroundColor = [UIColor redColor];
    _dataLab.text = str;
    //字体类型
    if (self.cellFontType == CellFontTypeFirst) {
        _dataLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    } else {
        _dataLab.textColor = [UIColor colorWithHexString:@"#848484"];
    }
    
    
}

@end
