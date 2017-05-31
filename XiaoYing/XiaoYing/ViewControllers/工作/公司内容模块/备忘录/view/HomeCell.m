//
//  HomeCell.m
//  XiaoYing
//
//  Created by 王思齐 on 16/12/6.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "HomeCell.h"
#import "DeleteViewController.h"
#import "MemorandumVC.h"
#import "WangUrlHelp.h"

@implementation HomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
        
        _baseView = [[UIView alloc] initWithFrame:CGRectZero];
        _baseView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_baseView];
        
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLab.textColor = [UIColor colorWithHexString:@"#f99740"];
        _timeLab.font = [UIFont systemFontOfSize:15];
        [_baseView addSubview:_timeLab];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectZero;
        [_deleteBtn setImage:[UIImage imageNamed:@"trash-can_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [_baseView addSubview:_deleteBtn];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
        [_baseView addSubview:_lineView];
        
        _contenLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _contenLab.font = [UIFont systemFontOfSize:17];
        _contenLab.numberOfLines = 2;
        [_baseView addSubview:_contenLab];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        //    _imgView.image = [UIImage imageNamed:@"ying"];
        //        _imgView.backgroundColor = [UIColor cyanColor];
        _imgView.hidden = YES;
        //        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [_baseView addSubview:_imgView];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _baseView.frame = CGRectMake(10, 10, kScreen_Width-20, 100);
    
    _timeLab.frame = CGRectMake(10, 10, 150, 12);
    _timeLab.text = self.model.CreateTime;
    
    _deleteBtn.frame = CGRectMake(_baseView.width-10-32, 0, 32, 32);
    
    _lineView.frame = CGRectMake(10, _timeLab.bottom+10, _baseView.width-20, .5);
    
    
    if (self.model.Content.length > 0) {
        _contenLab.text = self.model.Content;
        //        NSLog(@"!!!%@",self.model.Content);
        
    }
    else {
        _contenLab.text = @"图片内容";
        
    }
    
    if (self.model.HasImage == 1) {
        
        _contenLab.frame = CGRectMake(10, _lineView.bottom+10, _baseView.width-10-10-50-10, 45);
        
        _imgView.hidden = NO;
        //        NSLog(@"dsds!!");
        _imgView.frame = CGRectMake(_baseView.width-10-50, _contenLab.top, 50, 50);
        [_imgView sd_setImageWithURL:[NSURL URLWithString:self.model.urlStr]];
        
        
    }
    else {
        _imgView.hidden = YES;
        
        _contenLab.frame = CGRectMake(10, _lineView.bottom+10, _baseView.width-10-10, 45);
        
    }
    
    
}


// 删除
- (void)deleteAction
{
    
    DeleteViewController *deleteViewController = [[DeleteViewController alloc] init];
    //    deleteViewController.urlStr = self.sessionModel.url;
    
    deleteViewController.fileDeleteBlock = ^(void)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
        hud.labelText = @"删除中...";
        
        NSArray *arr = @[@(self.model.Id)];
        
        [AFNetClient  POST_Path:DeleteMemory params:arr completed:^(NSData *stringData, id JSONDict) {
            
            [hud hide:YES];
            
            NSNumber *code=[JSONDict objectForKey:@"Code"];
            
            if (1 == [code integerValue]) {
                
                NSString *msg = [JSONDict objectForKey:@"Message"];
                
                [MBProgressHUD showMessage:msg toView:self.viewController.view];
                
            } else {
                
                if (_deleteBlock) {
                    _deleteBlock(_model);
                }
                
            }
            
        } failed:^(NSError *error) {
            
            [hud hide:YES];
            
            [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.viewController.view];
            
        }];
        
        
    };
    
    deleteViewController.titleStr = @"是否确定删除?";
    deleteViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    deleteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    deleteViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController presentViewController:deleteViewController animated:YES completion:nil];
    
    
    
}


@end
