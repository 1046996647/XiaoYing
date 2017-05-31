//
//  CreateMyCompanyView.m
//  XiaoYing
//
//  Created by GZH on 16/8/9.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "CreateMyCompanyView.h"
#import "AddAlreadyCompanyVC.h"
#import "JoinTheCompanyView.h"
#import "CreateCompanyVC.h"
@interface CreateMyCompanyView ()

@property (nonatomic, strong)JoinTheCompanyView *joinView;
@property (nonatomic, strong)UIButton *createCompanyBtn;
@property (nonatomic, strong)UIButton *joinCompanyBtn;

@end

@implementation CreateMyCompanyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
        
        self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        
        
    }
    return self;
}


- (void)initUI {
    
    _createCompanyBtn = [self Z_createButtonWithTitle:@"创建我的公司" buttonFrame:CGRectMake(12, 12, (kScreen_Width - 36) / 2, 44)];
    [_createCompanyBtn addTarget:self action:@selector(createMyCompany) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_createCompanyBtn];
    
    _joinCompanyBtn = [self Z_createButtonWithTitle:@"加入已有公司" buttonFrame:CGRectMake(24 + (kScreen_Width - 36) / 2, 12, (kScreen_Width - 36) / 2, 44)];
    [_joinCompanyBtn addTarget:self action:@selector(joinCompany) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_joinCompanyBtn];
    

    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, _createCompanyBtn.bottom, kScreen_Width, kScreen_Height - _createCompanyBtn.bottom)];
//    _backView.backgroundColor = [UIColor redColor];
    [self addSubview:_backView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreen_Width - 185) / 2, 40, 185, 161)];
    imageView.image = [UIImage imageNamed:@"face2"];
    [_backView addSubview:imageView];
    
    UILabel *upLabel = [self Z_createLabelWithTitle:@"未加入公司,请点击上方按钮" buttonFrame:CGRectMake(12,imageView.bottom + 30, kScreen_Width - 24, 16)];
    [_backView addSubview:upLabel];
    
    UILabel *middleLabel = [self Z_createLabelWithTitle:nil buttonFrame:CGRectMake((kScreen_Width - 270) / 2, upLabel.bottom + 12, 270, 0.5)];
    middleLabel.backgroundColor = [UIColor colorWithHexString:@"#848484"];
    [_backView addSubview:middleLabel];
    
    UILabel *downLabel = [self Z_createLabelWithTitle:@"创建自己的公司或者加入现有的公司" buttonFrame:CGRectMake(12, middleLabel.bottom + 12, kScreen_Width - 24, 16)];
    [_backView addSubview:downLabel];

    _joinVC = [[JoinTheCompanyView alloc]init];
    [self addSubview:_joinVC];
   
}

- (void)initTableView {
    
    _joinVC = [[JoinTheCompanyView alloc]initWithFrame:CGRectMake(12, _backView.top + 10, kScreen_Width - 24, kScreen_Height - _backView.top - 64 - 12)];
    [self addSubview:_joinVC];
}


- (void)createMyCompany {
    CreateCompanyVC *comVC = [[CreateCompanyVC alloc]init];
    [self.viewController.navigationController pushViewController:comVC animated:YES];
}

- (void)joinCompany {
    AddAlreadyCompanyVC *addVC = [[AddAlreadyCompanyVC alloc]init];
    if (![UserInfo getJoinCompany_YesOrNo]) {
        addVC.refershOrNo = @"YES";
    }
    //发送请求成功之后，刷新tableView
    addVC.requestSuccess = ^(NSString *str) {
        if (![str isEqualToString:@""]) {
            [_joinVC removeFromSuperview];
            [self initTableView];
        }
    };
    [self.viewController.navigationController pushViewController:addVC animated:YES];
}














#pragma mark --Z_Label--  --Z_Button--
- (UILabel *)Z_createLabelWithTitle:(NSString *)title
                       buttonFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor colorWithHexString:@"#848484"];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UIButton *)Z_createButtonWithTitle:(NSString *)title
                          buttonFrame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setFrame:frame];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    return button;
}


@end
