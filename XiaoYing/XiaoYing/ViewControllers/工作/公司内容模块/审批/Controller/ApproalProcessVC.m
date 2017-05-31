//
//  ProcessVC.m
//  XiaoYing
//
//  Created by ZWL on 15/11/15.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "ApproalProcessVC.h"
//#import "ApplyProgressTableView.h"
#import "ApproalPocessTableView.h"
//#import "ApplyHeaderView.h"
#import "ApproalHeaderView.h"
//#import "ApprovalPeopleModel.h"
#import "AgreeVC.h"
#import "ApproalDetailModel.h"
#import "CreatorModel.h"
#import "FlowModel.h"
#import "WangUrlHelp.h"
#import "ApplyRevokeWarningVC.h"

@interface ApproalProcessVC ()<ApproalPocessTableViewDelegate>
{
    ApproalPocessTableView *_ApproalPocessTableView;
    UIView *_bgView;
    UILabel *_progressLab;
    ApproalHeaderView *_headerView;
    NSArray *dataList;
    NSString *_approalDetailURL; //获取审批详情URL
    ApproalDetailModel *_detailModel; //审批详细model
    CreatorModel *_creatorModel; //申请人model
    NSArray *_flowArray; //流程数组
    MBProgressHUD *_hud; //菊花
    NSString *_profileID;//用户的ID
}

@property (nonatomic,strong) UIView *backgroundView;

@end

@implementation ApproalProcessVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的审批";
 
    self.view.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:100];

    //监听是否有新的流程待审核的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newApproval:) name:kCheckApplyRevokeNotification object:nil];
    //获取用户ID
    _profileID = [UserInfo userID];
    
    [self checkIfRevoked];
    //加载网络数据
    [self loadApprovalDetailData];
    
//    if (self.overed == NO) {//如果正在审批或者越级审批，底部视图出现
//        ////同意和拒绝底部视图
//        [self initBottomView];
//    }
//    
//    if (self.isSearching == YES) {//如果是从搜索界面跳转而来
//        <#statements#>
//    }
    
    //显示菊花
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载中";
}

// 顶部视图
- (void)initTopView
{
    UIView *baseView = [[UIView alloc] init];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    // 图像
    UIImageView *imageTitle = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 50, 50)];
    imageTitle.image = [UIImage imageNamed:@"face"];
//    NSURL *faceURL = [NSURL URLWithString:_creatorModel.faceURL];
//    [imageTitle sd_setImageWithURL:faceURL placeholderImage:[UIImage imageNamed:@"face"]];
    if (![_creatorModel.faceURL isEqualToString:@""]) {//存在头像不存在的现象
        NSString *iconStr = [NSString replaceString:_creatorModel.faceURL Withstr1:@"100" str2:@"100" str3:@"c"];
        NSLog(@"iconStr:%@",iconStr);
        [imageTitle sd_setImageWithURL:[NSURL URLWithString:iconStr]];
    }
    imageTitle.layer.borderColor = [[UIColor whiteColor] CGColor];
    imageTitle.layer.borderWidth = 1;
    imageTitle.layer.cornerRadius = 5;
    imageTitle.clipsToBounds = YES;
    [baseView addSubview:imageTitle];
    
    // 申请人
    UILabel *approvalPeopleLab = [self p_createLabelWithTitle:@"霍建华" andFrame:CGRectMake(imageTitle.right+12, imageTitle.top, 150, 14)];
    if (![_creatorModel.employeeName isEqualToString:@""]) {
        approvalPeopleLab.text = _creatorModel.employeeName;
    }
    approvalPeopleLab.font = [UIFont systemFontOfSize:14];
    approvalPeopleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [baseView addSubview:approvalPeopleLab];
    
    // 是否财务审批
    UILabel *finicialLab = [self p_createLabelWithTitle:@"等待孟凡标审批" andFrame:CGRectMake(kScreen_Width-150-12, 17, 150, 12)];
    finicialLab.text = self.statusDesc;
    finicialLab.font = [UIFont systemFontOfSize:12];
    finicialLab.textAlignment = NSTextAlignmentRight;
    finicialLab.textColor = [UIColor colorWithHexString:@"#848484"];
    [baseView addSubview:finicialLab];
    
    // 等待审批
    UILabel *whoToApprovalLab = [self p_createLabelWithTitle:@"科技产业部-UI设计师" andFrame:CGRectMake(approvalPeopleLab.left, approvalPeopleLab.bottom+6, kScreen_Width - 80, 12)];
    if (![_detailModel.departmentName isEqualToString:@""]) {
        whoToApprovalLab.text = [NSString stringWithFormat:@"%@-%@",_detailModel.departmentName,_creatorModel.mastJobName];
    }else{
        whoToApprovalLab.text = [NSString stringWithFormat:@"%@",_creatorModel.mastJobName];
    }
    
    whoToApprovalLab.font = [UIFont systemFontOfSize:12];
    whoToApprovalLab.textColor = [UIColor colorWithHexString:@"#848484"];
    [baseView addSubview:whoToApprovalLab];
    
    // 种类
    UILabel *kindLab = [self p_createLabelWithTitle:@"报销" andFrame:CGRectMake(whoToApprovalLab.left, whoToApprovalLab.bottom+6, kScreen_Width - 80, 10)];
    kindLab.text = _detailModel.categroyName;
    kindLab.font = [UIFont systemFontOfSize:10];
    kindLab.textColor = [UIColor colorWithHexString:@"#848484"];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:kindLab.text];
    //    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#848484"] range:NSMakeRange(0, 3)];
    //    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"02bb00"] range:NSMakeRange(4, 3)];
    //    _progressLab.attributedText = attribute;
    [baseView addSubview:kindLab];
    
    // 当前时间
    UILabel *currentTimeLab = [self p_createLabelWithTitle:@"2015-12-24 17:56" andFrame:CGRectMake(kScreen_Width - 12 - 150, 53.5, 150, 10)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateTime = [formatter stringFromDate:_detailModel.sendDateTime];
    currentTimeLab.text = dateTime;
    currentTimeLab.font = [UIFont systemFontOfSize:10];
    currentTimeLab.textAlignment = NSTextAlignmentRight;
    currentTimeLab.textColor = [UIColor colorWithHexString:@"#848484"];
    [baseView addSubview:currentTimeLab];
    
    // 进度条
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(12, imageTitle.bottom+10, kScreen_Width - 24, 2)];
    backgroundView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:backgroundView];
    self.backgroundView = backgroundView;
    
    NSArray *strArray = [self.progress componentsSeparatedByString:@"/"];
    float molecule = [strArray[0] floatValue];//分子
    float denominator = [strArray[1] floatValue];//分母
    float progress = molecule/denominator;
    
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(12, 75, (kScreen_Width - 24) * progress, 2)];
    //UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(12, 75, (kScreen_Width - 24) / 2, 2)];
    progressView.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    [baseView addSubview:progressView];
    
    baseView.frame = CGRectMake(0, 0, kScreen_Width, progressView.bottom);
    
    /////////////////////////////////////////////////////
    
    // 完成进度
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, backgroundView.bottom, kScreen_Width, 54/2.0)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.alpha = 0;
    [self.view addSubview:_bgView];
    
    _progressLab = [self p_createLabelWithTitle:@"已完成 2/4" andFrame:CGRectMake(kScreen_Width-100-12, backgroundView.bottom, 100, 54/2.0)];
    _progressLab.text = [NSString stringWithFormat:@"已完成 %@",self.progress];
    _progressLab.font = [UIFont systemFontOfSize:10];
    _progressLab.textAlignment = NSTextAlignmentRight;
    attribute = [[NSMutableAttributedString alloc] initWithString:_progressLab.text];
    _progressLab.textColor = [UIColor colorWithHexString:@"#848484"];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#848484"] range:NSMakeRange(0, 3)];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"02bb00"] range:NSMakeRange(4, 3)];
    _progressLab.attributedText = attribute;
    [self.view addSubview:_progressLab];
    
}




//右上角按钮点击事件
- (void)rightBtnAction:(UIButton *)btn
{
    
}

- (void)_createSubView{
    
    // 头视图
    _headerView = [[ApproalHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0) IsFinicial:YES];
    _headerView.detailModel = _detailModel;
    if (self.isAffiche == YES) {//如果是公告的话
        _headerView.isAffiche = YES;
    }
    //隐藏头视图的语音按钮
    _headerView.voiceBtn.hidden = YES;
    
    
    if (self.overed != YES) {//待审批
        _ApproalPocessTableView = [[ApproalPocessTableView alloc] initWithFrame:CGRectMake(0, self.backgroundView.bottom, kScreen_Width, kScreen_Height - 64 - 44 - self.backgroundView.bottom) style:UITableViewStylePlain];
    }else{
         _ApproalPocessTableView = [[ApproalPocessTableView alloc] initWithFrame:CGRectMake(0, self.backgroundView.bottom, kScreen_Width, kScreen_Height - 64  - self.backgroundView.bottom) style:UITableViewStylePlain];
    }
   
    _ApproalPocessTableView.ApproalPocessTableViewDelegate = self;
    _ApproalPocessTableView.dataList = dataList;
    _ApproalPocessTableView.flows = _flowArray;
    _ApproalPocessTableView.applyTime = _detailModel.sendDateTime;
    _ApproalPocessTableView.bounces = NO;
    _ApproalPocessTableView.tableHeaderView = _headerView;
    [self.view insertSubview:_ApproalPocessTableView atIndex:0];
}

//同意和拒绝底部视图
- (void)initBottomView
{
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-64-44, kScreen_Width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    //顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, .5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:topView];
    
    
    NSArray *titleArr = @[@"同意",@"拒绝"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(kScreen_Width/2.0), 0, kScreen_Width/2.0, 44);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setTitleColor:[UIColor colorWithHexString:@"#02bb00"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
        
        if (i == 1) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#f94040"] forState:UIControlStateNormal];
            
        }
    }
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width/2.0, (44-20)/2, .5, 20)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView];
}


//同意和拒绝按钮事件
- (void)btnAction:(UIButton *)btn
{
    AgreeVC *agreeVC = [[AgreeVC alloc] init];
    agreeVC.btnText = btn.currentTitle;
    agreeVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    agreeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    agreeVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    agreeVC.applyRequestId = self.applyRequestID;
    agreeVC.agreeOrRefuseBlock = ^(){
        self.approalBlock();
        //[self.navigationController popViewControllerAnimated:YES];
//        [[self activityViewController].navigationController popViewControllerAnimated:YES];
        [self popViewController:@"ApprovalManageVC"];
    };
    [self presentViewController:agreeVC animated:NO completion:nil];
}

- (UILabel *)createLabelWithTitle:(NSString *)str andFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = str;
    label.backgroundColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  创建label
 */
- (UILabel *)p_createLabelWithTitle:(NSString *)str andFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = str;
    //label.backgroundColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:13];
    return label;
}

#pragma mark - ApplyProgressTableViewDelegate
- (void)scroll
{
    if (_ApproalPocessTableView.contentOffset.y >= (_headerView.height - _bgView.height)) {
        _bgView.alpha = 1;
    }
    else {
        _bgView.alpha = 0;
    }
}

- (void)reloadTableView
{
    [_ApproalPocessTableView reloadData];
}

#pragma mark - 获取审批详情的网络加载 methods
-(void)loadApprovalDetailData{
    _approalDetailURL = APPROVAL_GET_DETAILAPPROVAL,_applyRequestID];
    NSLog(@"approalDetailURL:%@",_approalDetailURL);
    [AFNetClient GET_Path:_approalDetailURL completed:^(NSData *stringData, id JSONDict) {
        NSLog(@"jsonDic:%@",JSONDict);
        NSNumber *codeNumber = JSONDict[@"Code"];
        NSInteger code = [codeNumber integerValue];
        if (code == 0) {
            _detailModel = [[ApproalDetailModel alloc]initWithDic:JSONDict[@"Data"]];
            if (![_detailModel.creator isKindOfClass:[NSNull class]]) {
                _creatorModel = [[CreatorModel alloc]initWithDic:_detailModel.creator];
            }else{
                [MBProgressHUD showMessage:@"审批详情数据有部分错误" toView:self.view];
            }
            _flowArray = [FlowModel getModelArrayFromModelArray:_detailModel.flows];
            dataList = _flowArray;
            // 顶部视图
            [self initTopView];
            // 表视图
            [self _createSubView];
            //做判断，判断是未审批状态还是已审批状态
            for (FlowModel * flow in _flowArray) {
                if ([flow.commenterProfileId isEqualToString:_profileID]) {
                    if (flow.status == 1 || flow.status == 3 || flow.status == 0) {//审核中或者是越级审核
                        [self initBottomView];
                    _ApproalPocessTableView.frame = CGRectMake(0, self.backgroundView.bottom, kScreen_Width, kScreen_Height - 64 - 44 - self.backgroundView.bottom);
                    }
                    //注释掉下面这个状态的原因是推送
//                    if (flow.status == 0) {//申请人撤销了申请
//                        [self initBottomView];
//                        [MBProgressHUD showMessage:@"申请人撤销了申请"];
//                        //回到之前的界面，并且刷新
//                        [self performSelector:@selector(goBackByCancled) withObject:nil afterDelay:1.5];
//                    }
                    if (flow.status == 2 || flow.status == 4) {//我这边的审批已经结束
                         _ApproalPocessTableView.frame = CGRectMake(0, self.backgroundView.bottom, kScreen_Width, kScreen_Height - 64  - self.backgroundView.bottom);
                        _headerView.overed = YES;
                        _headerView.useTime = self.useTime;
                    }
                }
            }
             [_hud hide:YES];
        }else{
            [_hud hide:YES];
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
        }
    } failed:^(NSError *error) {
        [_hud hide:YES];
        [MBProgressHUD showMessage:@"网络出错，请稍后再试" toView:self.view];
         NSLog(@"请求失败Error--%ld",(long)error.code);
    }];
    
}

//如果申请撤销了
-(void)goBackByCancled{
    self.approalBlock();
    [self.navigationController popViewControllerAnimated:YES];
}


// 获取当前处于activity状态的view controller
- (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}

//该申请被撤销
-(void)newApproval:(NSNotification *)noti{
    [self showWarningVC];
}

//检查是否该申请被撤销（针对看列表时这条申请被撤销）
-(void)checkIfRevoked{
    for (NSString *applyId in self.applyRevokes) {
        if ([applyId isEqualToString:self.applyRequestID]) {
            [self showWarningVC];
        }
    }
}

//申请被撤销的通知框
-(void)showWarningVC{
    ApplyRevokeWarningVC *warningVC = [[ApplyRevokeWarningVC alloc] init];
    //模态
    warningVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    warningVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    warningVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    warningVC.sureBlock = ^(){
        self.approalBlock();
        [self.navigationController popViewControllerAnimated:YES];
         };
    [self.navigationController presentViewController:warningVC animated:YES completion:nil];
}

@end
