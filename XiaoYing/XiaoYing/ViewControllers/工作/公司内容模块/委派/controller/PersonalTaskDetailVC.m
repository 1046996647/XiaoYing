//
//  ShowAndEditTaskVC.m
//  XiaoYing
//
//  Created by ZWL on 16/5/25.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "PersonalTaskDetailVC.h"
#import "PlayView.h"
#import "CheckVC.h"
#import "ImageCollectionView.h"
#import "OpinionVC.h"
#import "RecordVC.h"

@interface PersonalTaskDetailVC ()

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *detailLab;
@property (nonatomic,strong) UILabel *decribeLab;
@property(nonatomic,strong) ImageCollectionView *pictureCollectonView;



@end

@implementation PersonalTaskDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"张伟良";
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 16, kScreen_Width-24, 16)];
    _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLab.font = [UIFont systemFontOfSize:16];
    _titleLab.text = @"任务1:标题标题标题标题标题标题标题标题";
    [self.view addSubview:_titleLab];
    
    _detailLab = [[UILabel alloc] initWithFrame:CGRectMake(12, _titleLab.bottom+6, kScreen_Width-24, 12)];
    _detailLab.textColor = [UIColor colorWithHexString:@"#848484"];
    _detailLab.text = @"未提交";
    _detailLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_detailLab];
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(12, _detailLab.bottom+6, kScreen_Width-24, 12)];
    timeLab.textColor = [UIColor colorWithHexString:@"#848484"];
    timeLab.text = @"2016-02-03 12：32";
    timeLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:timeLab];
    
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.frame = CGRectMake(kScreen_Width-(124/2)-12, 34, 124/2, 30);
    [detailBtn setTitle:@"任务详情" forState:UIControlStateNormal];
    detailBtn.layer.cornerRadius = 6;
    detailBtn.clipsToBounds = YES;
    detailBtn.layer.borderWidth = .5;
    detailBtn.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
    detailBtn.backgroundColor = [UIColor whiteColor];
    [detailBtn setTitleColor:[UIColor colorWithHexString:@"#848484"] forState:UIControlStateNormal];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [detailBtn addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:detailBtn];
    
    
    _decribeLab = [[UILabel alloc] initWithFrame:CGRectMake(12, detailBtn.bottom+10, kScreen_Width-24, 40)];
    _decribeLab.text = @"任务成果任务成果任务成果任务成果任务成果任务成果任务成果任务成果任务成果";
    _decribeLab.numberOfLines = 0;
    _decribeLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _decribeLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_decribeLab];
    
    
    // 声音视图
    // 播放语音视图
    PlayView *playView = [[PlayView alloc] initWithFrame:CGRectMake(10, _decribeLab.bottom+6, kScreen_Width-20, 30)];
    playView.timeStr = @"60";
    //    playView.contentURL = url;
    [self.view addSubview:playView];
    //    self.recordView = recordView;
    
    
    // 获取按钮的宽度
    float itemWidth = (kScreen_Width-(10*4))/3.0;
    for (int i = 0; i < 5; i++) {
        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imgBtn.frame = CGRectMake(10+(i%3)*(itemWidth+10), playView.bottom+6+(i/3)*(itemWidth+6), itemWidth, itemWidth);
        [imgBtn setImage:[UIImage imageNamed:@"003"] forState:UIControlStateNormal];
        //        imgBtn.backgroundColor = [UIColor greenColor];
        [imgBtn addTarget:self action:@selector(imgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:imgBtn];
    }
    
    
    [self initBottomView];
    
    //导航栏的下一步按钮
    [self initRightBtn];
}

//导航栏的下一步按钮
- (void)initRightBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 20);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"记录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightBar];
}

- (void)recordAction
{
    RecordVC *recordVC = [[RecordVC alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)imgBtnAction:(UIButton *)btn
{
    
}

- (void)initBottomView
{
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-44-64, kScreen_Width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    //顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, baseView.width, .5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:topView];
    
    NSArray *titleArr = @[@"成功",@"重做",@"失败"];
    
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(baseView.width/3.0), 0, baseView.width/3.0, 44);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
        
        if (i == 0) {
            
            [btn setTitleColor:[UIColor colorWithHexString:@"#02bb00"] forState:UIControlStateNormal];
            
            
        } else if (i == 1) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
            
        } else {
            [btn setTitleColor:[UIColor colorWithHexString:@"#f94040"] forState:UIControlStateNormal];

        }
    }
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(baseView.width/3.0, (44-20)/2, .5, 20)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(baseView.width/3.0*2, (44-20)/2, .5, 20)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView1];
}

- (void)btnAction:(UIButton *)btn
{
    OpinionVC *opinionVC = [[OpinionVC alloc] init];
    opinionVC.btnText = btn.currentTitle;
    opinionVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    opinionVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    opinionVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:opinionVC animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)detailAction
{
    CheckVC *checkVC = [[CheckVC alloc] init];
    checkVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    checkVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    checkVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:checkVC animated:YES completion:nil];
}

@end
