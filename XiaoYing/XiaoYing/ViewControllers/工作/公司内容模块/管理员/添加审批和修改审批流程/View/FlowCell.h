//
//  FlowCell.h
//  XiaoYing
//
//  Created by ZWL on 16/4/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TypeFlowModel.h"

typedef void(^SendBlock)(TypeFlowModel *);

typedef void(^TextFieldBlock)(UITextField *);

@protocol FlowCellDelegate <NSObject>

- (void)cutCell;

@end



@interface FlowCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *lab;
@property (nonatomic,strong) UITextField *tf;
@property (nonatomic,strong) UIButton *circleView;
@property (nonatomic,strong) UIView *circleView1;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,assign) NSInteger tag;
@property (nonatomic,strong) UILabel *remindLab1;
@property (nonatomic,strong) UILabel *remindLab2;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,weak) id<FlowCellDelegate> delegate;

@property (nonatomic,strong)  TypeFlowModel *model;

@property (nonatomic,copy) SendBlock sendBlock;
@property (nonatomic,copy) TextFieldBlock tfBlock;


@end
