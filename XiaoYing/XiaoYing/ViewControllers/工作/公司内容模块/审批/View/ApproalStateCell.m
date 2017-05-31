//
//  ApproalStateCell.m
//  XiaoYing
//
//  Created by YL20071 on 16/10/22.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ApproalStateCell.h"
#import "FlowModel.h"
#define cellHeight 82
@interface ApproalStateCell(){
    UIView *_verticalLine;                       // 连接头像之间的竖线
    UILabel *_agreeOrRefuse;                     // 显示审批通过或者拒绝
}
@end
@implementation ApproalStateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//58+24
-(void)setFlows:(NSArray *)flows{
    _flows = flows;
    // 竖线
    _verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_verticalLine];
    
    _agreeOrRefuse = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 0, 0 )];
    _agreeOrRefuse.text = @"审批通过";
    _agreeOrRefuse.textColor = [UIColor whiteColor];
    _agreeOrRefuse.textAlignment = NSTextAlignmentCenter;
    _agreeOrRefuse.font = [UIFont systemFontOfSize:12];
    CGRect rect = [_agreeOrRefuse.text boundingRectWithSize:CGSizeMake(60, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                                                                                                                                              NSFontAttributeName : [UIFont systemFontOfSize:12]
                                                                                                                        } context:nil];
    
    _agreeOrRefuse.top = cellHeight - rect.size.height - 10;
    _agreeOrRefuse.height = rect.size.height + 10;
    _agreeOrRefuse.width = rect.size.width + 6;
    _agreeOrRefuse.backgroundColor = [UIColor colorWithHexString:@"#848484"];
    _agreeOrRefuse.layer.cornerRadius = 5;
    _agreeOrRefuse.layer.masksToBounds = YES;
    [self.contentView addSubview:_agreeOrRefuse];
    
    _verticalLine.frame = CGRectMake(27.5-1, 0, 2, cellHeight - _agreeOrRefuse.height);
    
    FlowModel *flowModel = flows.lastObject;
    if (flowModel.status == 0||flowModel.status == 1 ||flowModel.status ==3) {//审批中或者待审批
        _agreeOrRefuse.backgroundColor = [UIColor colorWithHexString:@"#848484"];
        _verticalLine.backgroundColor = [UIColor colorWithHexString:@"#848484"];
    }
    if (flowModel.status == 4) {//已审批或者结束
        
        _agreeOrRefuse.backgroundColor = [UIColor colorWithHexString:@"#02bb00"];
        _verticalLine.backgroundColor = [UIColor colorWithHexString:@"#02bb00"];
    }
    
    if (flowModel.status == 2) {//审批拒绝
        _agreeOrRefuse.backgroundColor = [UIColor colorWithHexString:@"#848484"];
        _verticalLine.backgroundColor = [UIColor colorWithHexString:@"#848484"];
    }
    
    for (UIView *subview in self.contentView.superview.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
            subview.hidden = YES;
        }
    }
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
