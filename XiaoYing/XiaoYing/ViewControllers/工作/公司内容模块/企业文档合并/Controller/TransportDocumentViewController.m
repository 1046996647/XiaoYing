//
//  TransportDocumentViewController.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/10.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "TransportDocumentViewController.h"
#import "XYExtend.h"
#import "DownDocumentTableView.h"
#import "UploadDocumentTableView.h"
#import "ZFDownloadManager.h"
#import "DocumentUploadFileModel.h"

// 存储上传文件信息的路径（caches）
#define UploadCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"UploadCache.data"]

@interface TransportDocumentViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *categoryBtnView;
@property (nonatomic, strong) UIButton *downDocumentBtn;
@property (nonatomic, strong) UIButton *uploadDocumentBtn;
@property (nonatomic, strong) UIImageView *redLineView;

@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) DownDocumentTableView *downDocumentTVC;
@property (nonatomic, strong) UploadDocumentTableView *uploadDocumentTVC;

@property (nonatomic, strong) NSMutableArray *downloading;

@end

@implementation TransportDocumentViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (DownDocumentTableView *)downDocumentTVC
{
    if (!_downDocumentTVC) {
        _downDocumentTVC = [[DownDocumentTableView alloc] initWithFrame:CGRectMake(kScreen_Width*0, 0, kScreen_Width, kScreen_Height-40-64) style:UITableViewStylePlain];
        
    }
    return _downDocumentTVC;
}

- (UploadDocumentTableView *)uploadDocumentTVC
{
    if (!_uploadDocumentTVC) {
        _uploadDocumentTVC = [[UploadDocumentTableView alloc] initWithFrame:CGRectMake(kScreen_Width*1, 0, kScreen_Width, kScreen_Height-40-64) style:UITableViewStylePlain];
    }
    return _uploadDocumentTVC;
}

- (void)setupMonitor
{
    //接受广播,代号@"CompanyFileUploadProgressNotification"
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(companyFileUploadProgressAction) name:@"CompanyFileUploadProgressNotification" object:nil];
}

- (void)companyFileUploadProgressAction
{
    DocumentUploadFileModel *tempModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
    self.uploadDocumentTVC.documentUploadFileModel = tempModel;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"传输列表";
        
    [self setupBaseViewContent];
    
    [self setupMonitor];
    
}


- (void)setupBaseViewContent
{
    NSArray *categoryNameArr = @[@"下载", @"上传"];
    
    //放置分类按钮的view
    self.categoryBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
    self.categoryBtnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.categoryBtnView];
    
    //下载按钮
    self.downDocumentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat downBtnW = [HSMathod getWidthForText:[categoryNameArr objectAtIndex:0] limitHight:40 fontSize:16];
    self.downDocumentBtn.frame = CGRectMake(64, 0, downBtnW, 40);
    self.downDocumentBtn.backgroundColor = [UIColor whiteColor];
    [self.downDocumentBtn setTitle:[categoryNameArr objectAtIndex:0] forState:UIControlStateNormal];
    [self.downDocumentBtn setSelected:YES];
    [self.downDocumentBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [self.downDocumentBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateSelected];
    self.downDocumentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.downDocumentBtn addTarget:self action:@selector(categoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryBtnView addSubview:self.downDocumentBtn];
    
    //上传按钮
    self.uploadDocumentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat uploadBtnW = [HSMathod getWidthForText:[categoryNameArr objectAtIndex:1] limitHight:40 fontSize:16];
    self.uploadDocumentBtn.frame = CGRectMake(kScreen_Width/2+64, 0, uploadBtnW, 40);
    self.uploadDocumentBtn.backgroundColor = [UIColor whiteColor];
    [self.uploadDocumentBtn setTitle:[categoryNameArr objectAtIndex:1] forState:UIControlStateNormal];
    [self.uploadDocumentBtn setSelected:NO];
    [self.uploadDocumentBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [self.uploadDocumentBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateSelected];
    self.uploadDocumentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.uploadDocumentBtn addTarget:self action:@selector(categoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryBtnView addSubview:self.uploadDocumentBtn];
    
    //红色一条线
    self.redLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.downDocumentBtn.bottom - 2, kScreen_Width/2, 2)];
    self.redLineView.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [self.categoryBtnView addSubview:self.redLineView];
    
    //scrollView
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kScreen_Width, kScreen_Height - 40 - 64)];
    self.baseScrollView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.baseScrollView.delegate = self;
    self.baseScrollView.contentSize = CGSizeMake(kScreen_Width * 2 , kScreen_Height - 40 - 64);
    self.baseScrollView.pagingEnabled = YES;
    self.baseScrollView.showsVerticalScrollIndicator = NO;
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    self.baseScrollView.bounces = NO;//取消弹簧效果
    self.baseScrollView.scrollEnabled = NO;
    [self.view addSubview:self.baseScrollView];
    
    //tableViews
    [self.baseScrollView addSubview:self.downDocumentTVC];
    [self.baseScrollView addSubview:self.uploadDocumentTVC];
    
}

#pragma buttonAction
- (void)categoryBtnAction:(UIButton *)btn
{
    //按钮字体颜色的变化
    [self.downDocumentBtn setSelected:NO];
    [self.uploadDocumentBtn setSelected:NO];
    
    [btn setSelected:YES];
    
    //_____Animation
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    //改变红线的位置
    [self.redLineView setFrame:CGRectMake(btn.left-64, btn.bottom - 2, kScreen_Width/2, 2)];
    
    //改变scroll的内容偏移
    CGFloat offsetX = [@[@"下载", @"上传"] indexOfObject:btn.titleLabel.text] * kScreen_Width;
    self.baseScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    [UIView commitAnimations];
    
}

@end
