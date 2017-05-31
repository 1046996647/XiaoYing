//
//  FlowCell.m
//  XiaoYing
//
//  Created by ZWL on 16/4/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FlowCell.h"

#define MaxValue 2147483647


@implementation FlowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self initUI];
    }
    return self;
}

- (void)initUI
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    
    UIView *rectView = [[UIView alloc] initWithFrame:CGRectMake(13, 5, 18, 18+3*2)];
    rectView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self.contentView addSubview:rectView];
    
    UIView *circleView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    circleView1.layer.cornerRadius = 18/2.0;
    circleView1.clipsToBounds = YES;
    circleView1.center = rectView.center;
    circleView1.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:circleView1];
    self.circleView1 = circleView1;

    
    // 删除按钮
    UIButton *circleView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [circleView setImage:[UIImage imageNamed:@"delete_approval_red"]forState:UIControlStateNormal];
    [circleView setImage:[UIImage imageNamed:@"delete_type"]forState:UIControlStateSelected];
    circleView.hidden = YES;
    circleView.clipsToBounds = YES;
    circleView.userInteractionEnabled = NO;
    circleView.center = rectView.center;
    [circleView addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:circleView];
    self.circleView = circleView;
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(circleView1.right+12, 0, kScreen_Width-(circleView1.right+12)-12, 70)];
    baseView.backgroundColor = [UIColor whiteColor];
    baseView.layer.cornerRadius = 5;
    baseView.clipsToBounds = YES;
    [self.contentView addSubview:baseView];
    self.baseView = baseView;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, baseView.width, 35)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor colorWithHexString:@"333333"];
    lab.font = [UIFont systemFontOfSize:14];
    [baseView addSubview:lab];
    self.lab = lab;
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, lab.bottom, lab.width, .5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [baseView addSubview:lineView1];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, lineView1.bottom, baseView.width, 35)];
    tf.backgroundColor = [UIColor whiteColor];
    tf.font = [UIFont systemFontOfSize:14];
    tf.delegate = self;
//    tf.keyboardType = UIKeyboardTypeDecimalPad;// 小数点
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.textAlignment = NSTextAlignmentCenter;
    [tf addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [baseView addSubview:tf];
    self.tf = tf;
    
//    UILabel *remindLab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, tf.width, 12)];
//    remindLab1.textAlignment = NSTextAlignmentCenter;
//    remindLab1.text = @"输入审批天数";
//    remindLab1.textColor = [UIColor colorWithHexString:@"cccccc"];
//    remindLab1.font = [UIFont systemFontOfSize:12];
//    [tf addSubview:remindLab1];
//    self.remindLab1 = remindLab1;
//    
//    UILabel *remindLab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, remindLab1.bottom+3, tf.width, 9)];
//    remindLab2.textAlignment = NSTextAlignmentCenter;
//    remindLab2.text = @"(小于等于该天数的审批在此步骤结束)";
//    remindLab2.textColor = [UIColor colorWithHexString:@"cccccc"];
//    remindLab2.font = [UIFont systemFontOfSize:9];
//    [tf addSubview:remindLab2];
//    self.remindLab2 = remindLab2;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_model.Used) {
        _lab.backgroundColor = [UIColor clearColor];

    } else {
        _lab.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];


    }

}

- (void)deleteAction
{
    if ([self.delegate respondsToSelector:@selector(cutCell)]) {
        [self.delegate cutCell];
    }
}

#pragma mark - UITextFieldDelegate
// 刚点击时调用，编辑过程不调用
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (self.tfBlock) {
        self.tfBlock(textField);
    }
    textField.text = @"";
    
    if (_model.unLimit == 1) {
        _model.maxPower = MaxValue;
    } else {
        _model.maxPower = 0;

    }
//    NSIndexPath * path = [NSIndexPath indexPathForRow:self.row inSection:0];
//    [self scrollToCell:path];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (_model.maxPower > 0 && _model.maxPower < MaxValue) {
        
        if (self.tag == 0) {
            textField.text = [NSString stringWithFormat:@"<=%ld元",(long)_model.maxPower];

        }
        else {
            textField.text = [NSString stringWithFormat:@"<=%ld天",(long)_model.maxPower];

        }
    }
    else if (_model.maxPower > MaxValue) {
        
        [MBProgressHUD showMessage:@"数字过大!" toView:self.viewController.view];

        if (_model.unLimit == 1) {
            _model.maxPower = MaxValue;
        } else {
            _model.maxPower = 0;
            
        }
        textField.text = @"";
        
    }

    NSLog(@"结束编辑");
}

- (void)editChangeAction:(UITextField *)textField
{
    
    if (_model.unLimit == 1) {
        
        if (_tf.text.length > 0) {
            _model.maxPower = [_tf.text integerValue];

        } else {
            _model.maxPower = MaxValue;

        }
    } else {
        _model.maxPower = [_tf.text integerValue];
        
    }
}


-(void) scrollToCell:(NSIndexPath*) path {
    
    UITableView *tableView = [self tableView];
    
    [tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

@end
