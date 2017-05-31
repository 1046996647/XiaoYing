//
//  AlertViewVC.m
//  XiaoYing
//
//  Created by GZH on 16/7/5.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AlertViewVC.h"
#import "XYExtend.h"

@interface AlertViewVC ()

@property (nonatomic, strong) UIView *coverView;  //底层半透明View,占据整个屏幕
@property (nonatomic, strong) UIView *backView;   //用来显示文字的背景View

@property (nonatomic, strong) NSMutableArray *alertNameArray;
@property (nonatomic, strong) NSMutableArray *eventBlockArray;

@end

static const NSInteger kAlertCellHeight = 44;
static const NSInteger kAlertCellGap = 12;

@implementation AlertViewVC

- (NSMutableArray *)alertNameArray
{
    if (!_alertNameArray) {
        _alertNameArray = [NSMutableArray array];
    }
    return _alertNameArray;
}

- (NSMutableArray *)eventBlockArray
{
    if (!_eventBlockArray) {
        _eventBlockArray = [NSMutableArray array];
    }
    return _eventBlockArray;
}

- (void)addAlertMessageWithAlertName:(NSString *)name andEventBlock:(void(^)())block
{
    [self.alertNameArray addObject:name];
    [self.eventBlockArray addObject:block];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    [self setupView];
}

-(void)setupView
{
    //底层半透明View,占据整个屏幕
    _coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.3;
    
    //当点击其他空白部分时
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(canaleBtnAction)];
    [_coverView addGestureRecognizer:tap];
    [self.view addSubview:_coverView];
    
    //用来显示文字的背景View
    CGFloat originX = 0;
    CGFloat originY = kScreen_Height - kAlertCellHeight * self.alertNameArray.count - kAlertCellGap;
    CGFloat fullW = kScreen_Width;
    CGFloat fullH = kAlertCellHeight * self.alertNameArray.count + kAlertCellGap;
    _backView = [[UIView alloc]initWithFrame:CGRectMake(originX, originY, fullW, fullH)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView];
    
    //alertButton的设置
    for (int i = 0; i < self.alertNameArray.count; i ++) {
        
        if (i == self.alertNameArray.count - 1) {
            HSBlockButton *alertButton = [HSBlockButton buttonWithType:UIButtonTypeCustom];
            alertButton.frame = CGRectMake(0, kAlertCellHeight * i + kAlertCellGap, kScreen_Width, kAlertCellHeight);
            [alertButton setTitle:self.alertNameArray[i] forState:UIControlStateNormal];
            [alertButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [alertButton addTouchUpInsideBlock:^(UIButton *button) {
                
                eventBlock eventButtonBlock = self.eventBlockArray[i];
                eventButtonBlock();
            }];
            [_backView addSubview:alertButton];
            
        }else {
            HSBlockButton *alertButton = [HSBlockButton buttonWithType:UIButtonTypeCustom];
            alertButton.frame = CGRectMake(0, kAlertCellHeight * i, kScreen_Width, kAlertCellHeight);
            [alertButton setTitle:self.alertNameArray[i] forState:UIControlStateNormal];
            [alertButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [alertButton addTouchUpInsideBlock:^(UIButton *button) {
                
                eventBlock eventButtonBlock = self.eventBlockArray[i];
                eventButtonBlock();
            }];
            [_backView addSubview:alertButton];
            
        }
        
    }
    
    //alertButton之间的line的设置
    for (int i = 0; i < self.alertNameArray.count; i ++) {
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, kAlertCellHeight * i, kScreen_Width, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [_backView addSubview:lineView];
    }
    
    //alertGap的设置
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kAlertCellHeight * (self.alertNameArray.count - 1), kScreen_Width, kAlertCellGap)];
    view.backgroundColor = [UIColor lightGrayColor];
    [_backView addSubview:view];
    
}

- (void)canaleBtnAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
