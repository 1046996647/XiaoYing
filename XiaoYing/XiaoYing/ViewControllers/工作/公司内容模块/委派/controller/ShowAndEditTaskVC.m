//
//  ShowAndEditTaskVC.m
//  XiaoYing
//
//  Created by ZWL on 16/5/25.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "ShowAndEditTaskVC.h"
#import "RecordView.h"
#import "CheckVC.h"
#import "ImageCollectionView.h"


@interface ShowAndEditTaskVC ()

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *detailLab;
@property (nonatomic,strong) UITextView *tv;
@property (nonatomic,strong) UILabel *decribeLab;
@property(nonatomic,strong) ImageCollectionView *pictureCollectonView;



@end

@implementation ShowAndEditTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 16, kScreen_Width-24, 16)];
    _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLab.font = [UIFont systemFontOfSize:16];
    _titleLab.text = @"任务:标题标题标题标题标题标题标题标题";
    [self.view addSubview:_titleLab];
    
    _detailLab = [[UILabel alloc] initWithFrame:CGRectMake(12, _titleLab.bottom+6, kScreen_Width-24, 12)];
    _detailLab.textColor = [UIColor colorWithHexString:@"#848484"];
    _detailLab.text = @"未提交";
    _detailLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_detailLab];
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(12, _detailLab.bottom+6, kScreen_Width-24, 12)];
    timeLab.textColor = [UIColor colorWithHexString:@"#848484"];
    timeLab.text = @"-:-";
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
    
    _tv = [[UITextView alloc] initWithFrame:CGRectMake(12, timeLab.bottom+16, kScreen_Width-24, 312/2.0)];
    _tv.layer.borderWidth = .5;
    _tv.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
    _tv.textColor = [UIColor colorWithHexString:@"#333333"];
    _tv.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_tv];
    
    _decribeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, kScreen_Width-24, 14)];
    _decribeLab.text = @"描述";
    _decribeLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    _decribeLab.font = [UIFont systemFontOfSize:14];
    [_tv addSubview:_decribeLab];
    
    
    // 声音视图
    RecordView *recordView = [[RecordView alloc] initWithFrame:CGRectMake(12, _tv.bottom-.5, _tv.width, 44)];
    //            recordView.delegate = self;
    recordView.layer.borderWidth = .6;
    recordView.layer.borderColor = [[UIColor colorWithHexString:@"#d5d7dc"] CGColor];
    [self.view addSubview:recordView];
//    self.recordView = recordView;
    
    CGFloat width = (kScreen_Width-5*12)/4.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumInteritemSpacing = 12;
    layout.minimumLineSpacing = 12; //上下的间距 可以设置0看下效果
    //创建 UICollectionView
    self.pictureCollectonView = [[ImageCollectionView alloc] initWithFrame:CGRectMake(0, recordView.bottom+12, self.view.width, width) collectionViewLayout:layout];
    //            self.pictureCollectonView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:self.pictureCollectonView];

    
    
    // 提交按钮
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(0, kScreen_Height-44-64, kScreen_Width, 44);
    [okBtn setTitle:@"提交" forState:UIControlStateNormal];
    okBtn.backgroundColor = [UIColor whiteColor];
    [okBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:okBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [okBtn addSubview:lineView];

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
