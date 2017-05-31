//
//  FlowHeaderView.h
//  XiaoYing
//
//  Created by ZWL on 16/4/27.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowHeaderView : UIView<UITextFieldDelegate>

typedef void(^ClickBlock)(NSInteger);
typedef void(^TextFieldBlock)(UITextField *);


@property (nonatomic, copy)NSString *CompanyName;
@property (nonatomic, strong)NSNumber *CompanyRanks;
@property (nonatomic,strong) NSArray *departments;

@property (nonatomic,strong) NSMutableArray *selectedDepArr;


@property (nonatomic,strong) UILabel *depLab;
@property (nonatomic,strong) UIButton *lastBtn;
@property (nonatomic,strong) UITextField *tf;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UILabel *lab1;


@property (nonatomic,copy) ClickBlock clickBlock;
@property (nonatomic,copy) TextFieldBlock tfBlock;

@property NSUInteger section;

@property (nonatomic, weak) UITableView *tableView;

@end
