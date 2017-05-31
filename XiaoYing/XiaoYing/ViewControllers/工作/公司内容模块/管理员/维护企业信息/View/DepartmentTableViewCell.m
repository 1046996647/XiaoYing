 //
//  DepartmentTableViewCell.m
//  XiaoYing
//
//  Created by GZH on 16/7/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DepartmentTableViewCell.h"
#import "FrameManagerVC.h"
@implementation DepartmentTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //设置分割线距边界的距离
        self.separatorInset = UIEdgeInsetsMake(0, 25, 0, 0);

        
        [self.contentView addSubview:self.companyLabel];
        [self.contentView addSubview:self.unitLabel];
        [self.contentView addSubview:self.btn];
        [self.contentView addSubview:self.selectBtn];
        [self.contentView addSubview:self.upLineLabel];
        [self.contentView addSubview:self.crossLineLabel];
        [self.contentView addSubview:self.downLineLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (UILabel *)upLineLabel {
    if (_upLineLabel == nil) {
        self.upLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 0.5, 22)];
        _upLineLabel.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];

    }
    return _upLineLabel;
}

- (UILabel *)crossLineLabel {
    if (_crossLineLabel == nil) {
        self.crossLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 22, 12, 0.5)];
        _crossLineLabel.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        
    }
    return _crossLineLabel;
}

- (UILabel *)downLineLabel {
    if (_downLineLabel == nil) {
        self.downLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 22, 0.5, 22)];
        _downLineLabel.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        
    }
    return _downLineLabel;
}


- (UILabel *)companyLabel {
    if (_companyLabel == nil) {
        self.companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 6, kScreen_Width - 65, 14)];
//        _companyLabel.text = @"科技产业部";
        _companyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _companyLabel.font = [UIFont systemFontOfSize:14];
        _companyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _companyLabel;
}

- (UILabel *)unitLabel {
    if (_unitLabel == nil) {
        self.unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 26, kScreen_Width / 2, 12)];
//        _unitLabel.text = @"3级单元";
        _unitLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        _unitLabel.font = [UIFont systemFontOfSize:12];
        _unitLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _unitLabel;
}

- (UIButton *)btn {
    if (_btn == nil) {
        self.btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width - 40, 0, 40, 40)];
        [_btn setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(unitSet) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _btn;
}

- (UIButton *)selectBtn {
    if (_selectBtn == nil) {
        self.selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width - 40, 0, 40, 40)];
        [_selectBtn setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(unitSet) forControlEvents:UIControlEventTouchUpInside];

        
    }
    return _selectBtn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.type == 0) {
        _selectBtn.hidden = YES;
    }
    else if (self.type == 1) {
        _btn.hidden = YES;
        
        if (self.model.isSelected) {
            _selectBtn.selected = YES;
        }
        else {
            _selectBtn.selected = NO;

        }
    } else {
        
        _selectBtn.hidden = YES;
        _btn.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
}

- (void)unitSet {
    
    if (self.type == 0) {
        FrameManagerVC *frameVC = [[FrameManagerVC alloc]init];
        frameVC.departments = self.departments;
        frameVC.sendBlock = ^(NSMutableArray *arrM) {
            
            if (_sendBlock) {
                _sendBlock(arrM);
            }
            
        };
        frameVC.ParentID = _model.ParentID;
        frameVC.DepartmentId = _model.DepartmentId;
        frameVC.superTitle = _model.superTitle;
        frameVC.subTitle = _model.Title;
        frameVC.superRanks = _model.superRanks;
        frameVC.ranks = _model.Ranks;
        frameVC.comanyName = _model.comanyName;

        [self.viewController.navigationController pushViewController:frameVC animated:YES];    }
    else if (self.type == 1) {
        
        self.model.isSelected = !self.model.isSelected;
        
//        NSLog(@"%@",_model.DepartmentId);

        if (_sendUnitBlock) {
            _sendUnitBlock(self.model);
        }
    } else {
        
    }

}


//如果没有权限在该部门下发公告，那么拒绝点击
-(void)setAllowChoose:(BOOL)allowChoose{
    _allowChoose = allowChoose;
    if (allowChoose == NO) {
        [_btn removeTarget:self action:@selector(unitSet) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn removeTarget:self action:@selector(unitSet) forControlEvents:UIControlEventTouchUpInside];
        [_btn removeTarget:self action:@selector(showMes:) forControlEvents:UIControlEventTouchUpInside];
         [_selectBtn addTarget:self action:@selector(showMes:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)showMes:(UIButton*)bt{
    if (self.singleChoose == YES) {
        [MBProgressHUD showMessage:@"您只能选择一个审批人"];
    }else{
        [MBProgressHUD showMessage:@"您没有权限在该部门下发公告"];
    }
    bt.selected = NO;
}


@end
