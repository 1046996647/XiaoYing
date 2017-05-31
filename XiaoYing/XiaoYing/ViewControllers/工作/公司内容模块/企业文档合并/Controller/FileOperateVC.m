//
//  FileOperateVC.m
//  XiaoYing
//
//  Created by ZWL on 17/1/10.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "FileOperateVC.h"
#import "NewViewVC.h"
#import "DeleteViewController.h"

@interface FileOperateVC ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *view1;

@property (nonatomic, strong) UIButton *downloadBtn;
@property (nonatomic, strong) UILabel *downloadLab;

@property (nonatomic, strong) UIButton *moveBtn;
@property (nonatomic, strong) UILabel *moveLab;

@property (nonatomic, strong) UIButton *renameBtn;
@property (nonatomic, strong) UILabel *renameLab;

@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UILabel *delLab;

@end

@implementation FileOperateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, (152+88+24)/2)];
    [self.view addSubview:baseView];
    self.baseView = baseView;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 152/2)];
    view1.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:view1];
    self.view1 = view1;
    
    CGFloat width = 0;
    if (self.fileType == 0) {
        width = kScreen_Width/4;
        _downloadBtn = [self createBtnWithWidth:width tag:0 imageName:@"xiazai_black"];// xiazai_gray
        [_downloadBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _downloadBtn.enabled = [[self.authForButtnArr objectAtIndex:0] boolValue];

        _downloadLab = [self createLabelWithWidth:width tag:0 titleName:@"下载"];
        _downloadLab.textColor = [[self.authForButtnArr objectAtIndex:0] boolValue] ? [UIColor colorWithHexString:@"#333333"] : [UIColor colorWithHexString:@"#cccccc"];
        
        _moveBtn = [self createBtnWithWidth:width tag:1 imageName:@"yidong_black"];// yidong_gray
        [_moveBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _moveBtn.enabled = [[self.authForButtnArr objectAtIndex:1] boolValue];

        _moveLab = [self createLabelWithWidth:width tag:1 titleName:@"移动"];
        _moveLab.textColor = [[self.authForButtnArr objectAtIndex:1] boolValue] ? [UIColor colorWithHexString:@"#333333"] : [UIColor colorWithHexString:@"#cccccc"];
        
        _renameBtn = [self createBtnWithWidth:width tag:2 imageName:@"chongmm_black"];// chongmm_gray
        [_renameBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _renameBtn.enabled = [[self.authForButtnArr objectAtIndex:2] boolValue];

        _renameLab = [self createLabelWithWidth:width tag:2 titleName:@"重命名"];
        _renameLab.textColor = [[self.authForButtnArr objectAtIndex:2] boolValue] ? [UIColor colorWithHexString:@"#333333"] : [UIColor colorWithHexString:@"#cccccc"];
        
        _delBtn = [self createBtnWithWidth:width tag:3 imageName:@"shanchu_black"];// shanchu_gray
        [_delBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _delBtn.enabled = [[self.authForButtnArr objectAtIndex:3] boolValue];

        _delLab = [self createLabelWithWidth:width tag:3 titleName:@"删除"];
        _delLab.textColor = [[self.authForButtnArr objectAtIndex:3] boolValue] ? [UIColor colorWithHexString:@"#333333"] : [UIColor colorWithHexString:@"#cccccc"];
    }
    else {
        width = kScreen_Width/2;
        _renameBtn = [self createBtnWithWidth:width tag:0 imageName:@"chongmm_black"];// chongmm_gray
        [_renameBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _renameBtn.enabled = [[self.authForButtnArr objectAtIndex:0] boolValue];

        _renameLab = [self createLabelWithWidth:width tag:0 titleName:@"重命名"];
        _renameLab.textColor = [[self.authForButtnArr objectAtIndex:0] boolValue] ? [UIColor colorWithHexString:@"#333333"] : [UIColor colorWithHexString:@"#cccccc"];
        
        _delBtn = [self createBtnWithWidth:width tag:1 imageName:@"shanchu_black"];// shanchu_gray
        [_delBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _delBtn.enabled = [[self.authForButtnArr objectAtIndex:1] boolValue];
        
        _delLab = [self createLabelWithWidth:width tag:1 titleName:@"删除"];
        _delLab.textColor = [[self.authForButtnArr objectAtIndex:1] boolValue] ? [UIColor colorWithHexString:@"#333333"] : [UIColor colorWithHexString:@"#cccccc"];
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, view1.bottom+12, kScreen_Width, 44);
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:cancelBtn];
    
    //延迟1秒执行这个方法
    [self performSelector:@selector(delayAction) withObject:nil afterDelay:.1];
    
}

- (void)delayAction
{
    [UIView animateWithDuration:.5 animations:^{
        self.baseView.top = kScreen_Height-(152+88+24)/2;
    }];
}

- (void)cancelAction
{
    [UIView animateWithDuration:.35 animations:^{
        self.baseView.top = kScreen_Height;
        
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }];
}

//点击蒙版 蒙版退下
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if ([touches anyObject].view == self.view) {
        
        [UIView animateWithDuration:.35 animations:^{
            self.baseView.top = kScreen_Height;
        } completion:^(BOOL finished) {
            
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }
    
}

- (void)btnAction:(UIButton *)btn
{
//    NewViewVC *newViewVC = [[NewViewVC alloc] init];
//    newViewVC.markText = @"重命名";
//    newViewVC.placeholderText = @"请输入";
////    newViewVC.content = [NSString stringWithFormat:@"%ld人群",(unsigned long)_selectedArr.count];
//    newViewVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//    //淡出淡入
//    newViewVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    newViewVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
//    [self presentViewController:newViewVC animated:YES completion:nil];
//    newViewVC.clickBlock = ^(NSString *text) {
//    };
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if (self.fileOperateBlock) {
        self.fileOperateBlock(self.fileType, btn.tag);
    }

}

//// 删除
//- (void)delAction
//{
//    DeleteViewController *deleteViewController = [[DeleteViewController alloc] init];
//    deleteViewController.titleStr = @"是否确定删除该文件?";
//    deleteViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//    //淡出淡入
//    deleteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    //            self.definesPresentationContext = YES; //不盖住整个屏幕
//    deleteViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
//    [self presentViewController:deleteViewController animated:YES completion:nil];
//    deleteViewController.fileDeleteBlock = ^(void)
//    {
////        DownloadManagerController *vc = (DownloadManagerController *)self.viewController;
////        [vc deleteFile:self.sessionModel];
//    };
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (UIButton *)createBtnWithWidth:(CGFloat)width tag:(NSInteger)tag imageName:(NSString *)imageName
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(width*tag, 15, width, 22);
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.tag = tag;
    [self.view1 addSubview:btn];
    return btn;
}

- (UILabel *)createLabelWithWidth:(CGFloat)width tag:(NSInteger)tag titleName:(NSString *)titleName
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width*tag, 15+22+10, width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = titleName;
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.font = [UIFont systemFontOfSize:14];
    [self.view1 addSubview:label];
    return label;
}

@end
