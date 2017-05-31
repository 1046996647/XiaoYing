//
//  ComfirmMoveController.m
//  XiaoYing
//
//  Created by ZWL on 16/1/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DeleteViewController.h"

@interface DeleteViewController()
{
    UIView *_baseView;
    UIView *overView;
}

@end

@implementation DeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //初始化视图
    [self initView];
}

- (void)initView
{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    overView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    overView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [window addSubview:overView];
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-(540/2))/2, (kScreen_Height-100)/2, 540/2, 100)];
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.layer.cornerRadius = 6;
    _baseView.clipsToBounds = YES;
    [overView addSubview:_baseView];
    
    UILabel *remindLab = [[UILabel alloc] initWithFrame:CGRectMake(12, (_baseView.height-44-40)/2, _baseView.width-12*2, 40)];
    remindLab.font = [UIFont systemFontOfSize:16];
    remindLab.textColor = [UIColor colorWithHexString:@"#333333"];
    remindLab.numberOfLines = 2;
//    remindLab.text = @"文件正在下载，是否确定取消下载?";
    remindLab.text = self.titleStr;

    remindLab.textAlignment = NSTextAlignmentCenter;
    [_baseView addSubview:remindLab];
    
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, _baseView.height-44, _baseView.width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [_baseView addSubview:baseView];
    
    //顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _baseView.width, .5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:topView];
    
    
    NSArray *titleArr = @[@"确定",@"取消"];
    
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(_baseView.width/2.0), 0, _baseView.width/2.0, 44);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
        
    }
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(baseView.width/2.0, (44-20)/2, .5, 20)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView];
    
}


- (void)btnAction:(UIButton *)btn
{
    
    [overView removeFromSuperview];
    overView = nil;
    if (btn.tag == 0) {
    
        if (self.fileDeleteBlock) {
            _fileDeleteBlock();
        }
    }
        
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
