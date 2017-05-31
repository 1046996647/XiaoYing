//
//  ProcessVC.m
//  XiaoYing
//
//  Created by ZWL on 15/11/15.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "ApplyProcessVC.h"
#import "ApplyProgressTableView.h"
#import "ApplyHeaderView.h"
#import "ApplyViewModel.h"
//#import "NewApplyVC.h"
#import "ReagainApplyVC.h"
#import "AgainApplyVC.h"
#import "ApplyVC.h"
#import "ApplicationCreatorModel.h"
#import "ApplicationMessageModel.h"
#import "ApprovalNodeModel.h"
#import "DeleteViewController.h"
#import "RevokeApplyViewController.h"

@interface ApplyProcessVC ()<ApplyProgressTableViewDelegate>
{
    ApplyProgressTableView *_applyProgressTableView;
    ApplyHeaderView *_headerView; //审批详一栏
    
    //____________________________________________
    UIImageView *_imageTitle; //申请人的头像
    UILabel *_approvalPeopleLab; //申请人的姓名
    UILabel *_finicialLab; //审批状态的描述
    UILabel *_whoToApprovalLab; //申请人的身份
    UILabel *_kindLab; //申请的种类
    UILabel *_currentTimeLab; //申请的时间
    UIProgressView *_applicationProgress; //进度条
    UIView *_progressDescriptionView; //显示“完成2/3”的背景View
    UILabel *_progressDescriptionLabel; //显示“完成2/3”
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    MBProgressHUD *_waitHUD;  //waitHUD
    
}

@property (nonatomic, strong) NSArray *approvalOpinionArray;
@property (nonatomic, strong) UIProgressView *applicationProgress;

@property (nonatomic, strong)ApplicationCreatorModel * applicationcreatorModel;
@property (nonatomic, strong)ApplicationMessageModel *applicationMessageModel;
@property (nonatomic, strong)NSArray *approvalNodeModelArray;

@end

@implementation ApplyProcessVC
@synthesize applicationcreatorModel = _applicationcreatorModel, applicationMessageModel = _applicationMessageModel, approvalNodeModelArray = _approvalNodeModelArray;

- (void)setApplicationcreatorModel:(ApplicationCreatorModel *)applicationcreatorModel
{
    _applicationcreatorModel = applicationcreatorModel;
    
    //-----申请人头像
    [_imageTitle sd_setImageWithURL:[NSURL URLWithString:[UserInfo GetfaceURLofCard]] placeholderImage:[UIImage imageNamed:@"friend"]];
    
    //-----申请人姓名
    _approvalPeopleLab.text = _applicationcreatorModel.employeeName;
    
    //-----审批状态的描述
    _finicialLab.text = _applicationcreatorModel.statusDesc;
    
    //-----申请人的身份
    if ([applicationcreatorModel.departmentName isEqualToString:@""]) {
        
        _whoToApprovalLab.text = _applicationcreatorModel.mastJobName;
    }else {
    
        NSString *tempStr = [NSString stringWithFormat:@"%@-%@", _applicationcreatorModel.departmentName, _applicationcreatorModel.mastJobName];
        _whoToApprovalLab.text = tempStr;
    }
    
    //-----申请的种类
    _kindLab.text = _applicationcreatorModel.categoryName;
    
    //-----申请时的时间
    _currentTimeLab.text = _applicationcreatorModel.sendDateTime;
    
    //-----进度条
    _applicationProgress.progress = [_applicationcreatorModel.progressNumber floatValue];
    _applicationProgress.trackTintColor = [UIColor colorWithHexString:@"#d5d7dc"];
    _applicationProgress.progressTintColor = [UIColor colorWithHexString:@"#02bb00"];
    
    //-----显示“完成2/3”
    _progressDescriptionLabel.text = [NSString stringWithFormat:@"已完成 %@", _applicationcreatorModel.progress];
    NSMutableAttributedString *attributeForProgressDescriptionLabel = [[NSMutableAttributedString alloc] initWithString:_progressDescriptionLabel.text];
    _progressDescriptionLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    [attributeForProgressDescriptionLabel addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#848484"] range:NSMakeRange(0, 3)];
    [attributeForProgressDescriptionLabel addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"02bb00"] range:NSMakeRange(4, 3)];
    _progressDescriptionLabel.attributedText = attributeForProgressDescriptionLabel;

}

- (void)setApplicationMessageModel:(ApplicationMessageModel *)applicationMessageModel
{
    _applicationMessageModel = applicationMessageModel;
    
    __weak ApplyProgressTableView *wProgressTableView = _applyProgressTableView;
    __weak ApplyHeaderView *wapplyHeaderView = _headerView;
    [_headerView setApplicationMessageModel:_applicationMessageModel headerHeight:^(NSInteger headerHeight) {
        
        ApplyProgressTableView *sProgressTableView = wProgressTableView;
        ApplyHeaderView *sapplyHeaderView = wapplyHeaderView;
        
        sapplyHeaderView.frame = CGRectMake(0, 0, kScreen_Width, headerHeight);
        sProgressTableView.tableHeaderView = sapplyHeaderView;
        
    }];
}

- (void)setApprovalNodeModelArray:(NSArray *)approvalNodeModelArray
{
    _approvalNodeModelArray = approvalNodeModelArray;
    
    _applyProgressTableView.approvalNodeModelArray = _approvalNodeModelArray;
}

- (void)setupMonitor
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBackViewController) name:@"ApplyProgressVCGoBackNotification" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的申请";
    self.view.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:100];
    
    // 顶部视图
    [self setupTopView];
    
    // 表视图
    [self setupSubView];
    
    //注册通知
    [self setupMonitor];

    //导航栏的撤销按钮
    if (self.showRevokeView) {
        [self setupNavigationBarButton];
    }
    
    //重新审批和越级审批底部视图
    if (self.showBottomView) {
        [self initBottomView];
    }
    
    //waitHUD
    _waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [ApplyViewModel getApplicationDetailWithApplicationId:self.applyRequestId success:^(NSDictionary *dataList) {
        
        NSLog(@"获取申请详情成功:%@", dataList);
        
        //waitHUD
        [_waitHUD hide:YES];
        
        self.applicationcreatorModel = [ApplicationCreatorModel modelFromDict:dataList statusDesc:self.statusDesc progress:self.progress];
        
        self.applicationMessageModel = [ApplicationMessageModel modelFromDict:dataList];
        
        self.approvalNodeModelArray = [ApprovalNodeModel getModelArrayFromDataDictionary:dataList applicationStatus:self.status];
        
    } failed:^(NSError *error) {
        
        //waitHUD
        [_waitHUD hide:YES];
        
        NSLog(@"获取申请详情失败:%@", error);
    }];
    
}

// 顶部视图
- (void)setupTopView
{
    UIView *baseView = [[UIView alloc] init];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    // 申请人头像
    _imageTitle = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 50, 50)];
    _imageTitle.layer.borderColor = [[UIColor whiteColor] CGColor];
    _imageTitle.layer.borderWidth = 1;
    _imageTitle.layer.cornerRadius = 5;
    _imageTitle.clipsToBounds = YES;
    [baseView addSubview:_imageTitle];
    
    // 申请人的姓名
    _approvalPeopleLab = [[UILabel alloc] initWithFrame:CGRectMake(_imageTitle.right+12, _imageTitle.top, 150, 14)];
    _approvalPeopleLab.font = [UIFont systemFontOfSize:14];
    _approvalPeopleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [baseView addSubview:_approvalPeopleLab];
    
    // 审批状态的描述
    _finicialLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-150-12, 17, 150, 12)];
    _finicialLab.font = [UIFont systemFontOfSize:12];
    _finicialLab.textAlignment = NSTextAlignmentRight;
    [_finicialLab setTextColor:self.statusDescColor];
    [baseView addSubview:_finicialLab];
    
    // 申请人的身份
    _whoToApprovalLab = [[UILabel alloc] initWithFrame:CGRectMake(_approvalPeopleLab.left, _approvalPeopleLab.bottom+6, kScreen_Width - 80, 12)];
    _whoToApprovalLab.font = [UIFont systemFontOfSize:12];
    _whoToApprovalLab.textColor = [UIColor colorWithHexString:@"#848484"];
    [baseView addSubview:_whoToApprovalLab];
    
    // 申请的种类
    _kindLab = [[UILabel alloc] initWithFrame:CGRectMake(_whoToApprovalLab.left, _whoToApprovalLab.bottom+6, kScreen_Width - 80, 10)];
    _kindLab.font = [UIFont systemFontOfSize:10];
    _kindLab.textColor = [UIColor colorWithHexString:@"#848484"];
    [baseView addSubview:_kindLab];
    
    // 申请时的时间
    _currentTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 12 - 150, 53.5, 150, 10)];
    _currentTimeLab.font = [UIFont systemFontOfSize:10];
    _currentTimeLab.textAlignment = NSTextAlignmentRight;
    _currentTimeLab.textColor = [UIColor colorWithHexString:@"#848484"];
    [baseView addSubview:_currentTimeLab];
    
    // 进度条
    _applicationProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _applicationProgress.frame = CGRectMake(12, _imageTitle.bottom+10, kScreen_Width - 24, 2);
    _applicationProgress.trackTintColor = [UIColor whiteColor];
    _applicationProgress.progressTintColor = [UIColor whiteColor];
    [baseView addSubview:_applicationProgress];
    
    baseView.frame = CGRectMake(0, 0, kScreen_Width, _applicationProgress.bottom);

    // 显示“完成2/3”的背景View
    _progressDescriptionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.applicationProgress.bottom, kScreen_Width, 54/2.0)];
    _progressDescriptionView.backgroundColor = [UIColor whiteColor];
    _progressDescriptionView.alpha = 0;
    [self.view addSubview:_progressDescriptionView];
    
    // 显示“完成2/3”
    _progressDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-100-12, self.applicationProgress.bottom, 100, 54/2.0)];
    _progressDescriptionLabel.font = [UIFont systemFontOfSize:10];
    _progressDescriptionLabel.textAlignment = NSTextAlignmentRight;
    
    [self.view addSubview:_progressDescriptionLabel];

}

//导航栏的撤销按钮
- (void)setupNavigationBarButton
{
    UIButton *revokeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    revokeButton.frame = CGRectMake(0, 0, 30, 30);
    revokeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [revokeButton setTitle:@"撤销" forState:UIControlStateNormal];
    [revokeButton sizeToFit];
    [revokeButton addTarget:self action:@selector(revokeAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *revokeBarButton = [[UIBarButtonItem alloc] initWithCustomView:revokeButton];
    [self.navigationItem setRightBarButtonItem:revokeBarButton];
}

//撤销按钮点击事件
- (void)revokeAction:(UIButton *)btn
{
    RevokeApplyViewController *revokeApplyVC = [[RevokeApplyViewController alloc] init];
    revokeApplyVC.applyRequestId = self.applyRequestId;
    
    revokeApplyVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    revokeApplyVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    revokeApplyVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    [self presentViewController:revokeApplyVC animated:NO completion:nil];
    
}

- (void)setupSubView{
    
    if (self.showBottomView) {
        
        _applyProgressTableView = [[ApplyProgressTableView alloc] initWithFrame:CGRectMake(0, self.applicationProgress.bottom, kScreen_Width, kScreen_Height - 64 - 44 - self.applicationProgress.bottom) style:UITableViewStylePlain];
        
    }else {
        
        _applyProgressTableView = [[ApplyProgressTableView alloc] initWithFrame:CGRectMake(0, self.applicationProgress.bottom, kScreen_Width, kScreen_Height - 64 - self.applicationProgress.bottom) style:UITableViewStylePlain];

    }
    
    _applyProgressTableView.applyProgressDelegate = self;
    _applyProgressTableView.bounces = NO;
    
    // 头视图
    _headerView = [[ApplyHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0) IsFinicial:YES];
    _applyProgressTableView.tableHeaderView = _headerView;
    
    [self.view insertSubview:_applyProgressTableView atIndex:0];
}

//重新审批和越级审批底部视图(bottomButtonAction:)
- (void)initBottomView
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-64-44, kScreen_Width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    //顶部横线
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:topLineView];
    
    
    NSArray *titleArr = @[@"重新申请",@"越级申请"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(kScreen_Width/2.0), 0, kScreen_Width/2.0, 44);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
        
        if (i == 0) {  // 设置第一个按钮的颜色
            [btn setTitleColor:[UIColor colorWithHexString:@"#f94040"] forState:UIControlStateNormal];

        }
    }
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width/2.0, (44-20)/2, .5, 20)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView];
}

//重新审批和越级审批按钮事件
- (void)bottomButtonAction:(UIButton *)btn
{
    if (btn.tag == 0) { //重新申请
        
        for (UIViewController *tempViewController in self.navigationController.viewControllers) {
            
            if ([tempViewController isKindOfClass:[ApplyVC class]]) {
                
                [self.navigationController popViewControllerAnimated:NO];
                
                /*_____________________________________________________________________
                
                ReagainApplyVC *reagainApplyViewController = [[ReagainApplyVC alloc] init];
                
                //将相关数据给他
                reagainApplyViewController.applicationcreatorModel = self.applicationcreatorModel;
                reagainApplyViewController.applicationMessageModel = self.applicationMessageModel;
                
                //传完数据，然后跳转
                [tempViewController.navigationController pushViewController:reagainApplyViewController animated:NO];

                //_____________________________________________________________________*/
                
                //_____________________________________________________________________
                
                AgainApplyVC *againApplyViewController = [[AgainApplyVC alloc] init];
                
                //将相关数据给他
                againApplyViewController.applicationcreatorModel = self.applicationcreatorModel;
                againApplyViewController.applicationMessageModel = self.applicationMessageModel;
                
                //传完数据，然后跳转
                [tempViewController.navigationController pushViewController:againApplyViewController animated:NO];
                
                //_____________________________________________________________________

                
            }
        }
        
    } else { //越级审批
        
        
        DeleteViewController *deleteViewController = [[DeleteViewController alloc] init];
        //    deleteViewController.urlStr = self.sessionModel.url;
        deleteViewController.titleStr = @"下一级审批人将进行审批,是否确定越级审批?";
        deleteViewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //淡出淡入
        deleteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //            self.definesPresentationContext = YES; //不盖住整个屏幕
        deleteViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [self presentViewController:deleteViewController animated:YES completion:nil];
        deleteViewController.fileDeleteBlock = ^(void)
        {
            _waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [ApplyViewModel skipApplicationWithApplicationId:self.applyRequestId success:^(NSDictionary *dataList) {
                
                NSLog(@"申请越级审批时成功:%@", dataList);
                
                //waitHUD
                [_waitHUD hide:YES];
                
                NSArray  *controlArray = self.navigationController.childViewControllers;
                for (UIViewController * vc in controlArray) {
                    
                    if ([vc isKindOfClass:[ApplyVC class]]) {
                        
                        ApplyVC *applyVC = (ApplyVC *)vc;
                        [applyVC loadDataFromWeb];
                    }
                }
                
                [self.navigationController popViewControllerAnimated:NO];
                
            } failed:^(NSError *error) {
                
                NSLog(@"申请越级审批时失败信息:%@", error);
                
                //waitHUD
                [_waitHUD hide:YES];
                
                [self.navigationController popViewControllerAnimated:NO];
                
            }];

        };
        
        
    }
}

// 封装的一个UILabel生成器
- (UILabel *)p_createLabelWithTitle:(NSString *)str andFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = str;
    label.font = [UIFont systemFontOfSize:13];
    return label;
}

#pragma mark - ApplyProgressTableViewDelegate
- (void)scroll
{
    if (_applyProgressTableView.contentOffset.y >= (_headerView.height - _progressDescriptionView.height)) {
        _progressDescriptionView.alpha = 1;
    }
    else {
        _progressDescriptionView.alpha = 0;
    }
}

- (void)reloadTableView
{
    [_applyProgressTableView reloadData];
}

- (void)goBackViewController
{
    NSArray  *controlArray = self.navigationController.childViewControllers;
    for (UIViewController * vc in controlArray) {
        
        if ([vc isKindOfClass:[ApplyVC class]]) {
            
            ApplyVC *applyVC = (ApplyVC *)vc;
            [applyVC loadDataFromWeb];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
