//
//  ApplyTurnExcutePeopleVC.m
//  XiaoYing
//
//  Created by ZWL on 16/5/23.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "ApplyTurnExcutePeopleVC.h"

@interface ApplyTurnExcutePeopleVC ()
{
    UIView *_baseView;
}

@end

@implementation ApplyTurnExcutePeopleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-(540/2))/2, (kScreen_Height-((88+360)/2))/2, 540/2, (88+360)/2)];
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.layer.cornerRadius = 6;
    _baseView.clipsToBounds = YES;
    [self.view addSubview:_baseView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
