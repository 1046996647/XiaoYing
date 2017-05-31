//
//  HandleApplyVc.m
//  XiaoYing
//
//  Created by ZWL on 16/5/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "HandleApplyVC.h"
#import "PlayView.h"
#import "RejectVC.h"
#import "TurnToVC.h"

@interface HandleApplyVC ()
{
    UIView *_baseView;
}

@property (nonatomic,strong) UIImageView *userImg;
@property (nonatomic,strong) UILabel *personalLab;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *applyTypeLab;

@end

@implementation HandleApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-(540/2))/2, (kScreen_Height-(736/2))/2, 540/2, 736/2)];
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.layer.cornerRadius = 6;
    _baseView.clipsToBounds = YES;
    [self.view addSubview:_baseView];
    
    _userImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 76/2.0, 76/2.0)];
    //    _userImg.image = [UIImage imageNamed:@"ying"];
    _userImg.layer.cornerRadius = 5;
    _userImg.clipsToBounds = YES;
    [_userImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.ZWL.com/%@",@"etregfgfg/ere"]] placeholderImage:[UIImage imageNamed:@"newfriends"]];
    [_baseView addSubview:_userImg];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(_userImg.right + 6, _userImg.top+2, 200, 16)];
    _nameLab.font = [UIFont systemFontOfSize:16];
    _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _nameLab.text = @"张伟良";
    [_baseView addSubview:_nameLab];
    
    
    _personalLab = [[UILabel alloc] initWithFrame:CGRectMake(_nameLab.left, _nameLab.bottom + 6, 200, 12)];
    _personalLab.font = [UIFont systemFontOfSize:12];
    _personalLab.textColor = [UIColor colorWithHexString:@"#848484"];
    _personalLab.text = @"科技产业部-UI设计师";
    //    _personalLab.backgroundColor = [UIColor redColor];
    [_baseView addSubview:_personalLab];
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(_baseView.width-12-150, 12, 150, 12)];
    _timeLab.font = [UIFont systemFontOfSize:12];
    _timeLab.textAlignment = NSTextAlignmentRight;
    _timeLab.text = @"2016-02-23 11:03";
    _timeLab.textColor = [UIColor colorWithHexString:@"#848484"];
    //    _personalLab.backgroundColor = [UIColor redColor];
    [_baseView addSubview:_timeLab];
    
    _applyTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(_baseView.width-12-150, _timeLab.bottom+10, 150, 12)];
    _applyTypeLab.textAlignment = NSTextAlignmentRight;
    _applyTypeLab.font = [UIFont systemFontOfSize:12];
    _applyTypeLab.textColor = [UIColor colorWithHexString:@"#848484"];
    _applyTypeLab.text = @"更换执行人申请";
    //    _personalLab.backgroundColor = [UIColor redColor];
    [_baseView addSubview:_applyTypeLab];
    
    UILabel *changeLab = [[UILabel alloc] initWithFrame:CGRectMake(_userImg.left, _userImg.bottom+6, 300, 14)];
    changeLab.font = [UIFont systemFontOfSize:14];
    changeLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_baseView addSubview:changeLab];
    if (self.indexPath.row == 0) {
        changeLab.text = @"申请更换执行人的委派 :";
    } else {
        changeLab.text = @"申请放弃任务的标题 :";
        
    }
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(_userImg.left, changeLab.bottom+6, 300, 14)];
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = [UIColor colorWithHexString:@"#848484"];
    titleLab.text = @"委派的项目标题";
    [_baseView addSubview:titleLab];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(_userImg.left, titleLab.bottom+6, 300, 14)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [UIColor colorWithHexString:@"#333333"];
    label1.text = @"申请理由 :";
    [_baseView addSubview:label1];
    
    UILabel *reasonLab = [[UILabel alloc] initWithFrame:CGRectMake(_userImg.left, label1.bottom+6, 300, 14)];
    reasonLab.font = [UIFont systemFontOfSize:14];
    reasonLab.textColor = [UIColor colorWithHexString:@"#848484"];
    reasonLab.text = @"移交理由移交理由移交理由移交理由";
    [_baseView addSubview:reasonLab];
    
    // 播放语音视图
    PlayView *playView = [[PlayView alloc] initWithFrame:CGRectMake(10, reasonLab.bottom+6, _baseView.width-20, 30)];
    playView.timeStr = @"60";
    //    playView.contentURL = url;
    [_baseView addSubview:playView];
    
    [self initBottomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissAction) name:@"dismissVC" object:nil];

}

- (void)dismissAction
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)initBottomView
{
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, _baseView.height-44, _baseView.width, 44)];
    baseView.backgroundColor = [UIColor whiteColor];
    [_baseView addSubview:baseView];
    
    //顶部横线
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _baseView.width, .5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:topView];
    
    NSArray *titleArr = nil;
    if (self.indexPath.row == 0) {
        titleArr = @[@"更换",@"驳回"];
    } else {
        titleArr = @[@"同意",@"驳回"];

    }
    
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(_baseView.width/2.0), 0, _baseView.width/2.0, 44);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
        
        if (i == 0) {
            
            if (self.indexPath.row == 0) {
                
                [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
              
            } else {
                
                
                [btn setTitleColor:[UIColor colorWithHexString:@"#02bb00"] forState:UIControlStateNormal];

            }
      

        } else {
            [btn setTitleColor:[UIColor colorWithHexString:@"#f94040"] forState:UIControlStateNormal];

        }
    }
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(baseView.width/2.0, (44-20)/2, .5, 20)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnAction:(UIButton *)btn
{
    if (self.indexPath.row == 0 && btn.tag == 0) {
        
        TurnToVC *turnToVC = [[TurnToVC alloc] init];
        turnToVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //淡出淡入
        turnToVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //            self.definesPresentationContext = YES; //不盖住整个屏幕
        turnToVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [self presentViewController:turnToVC animated:NO completion:nil];

    } else {
        RejectVC *rejectVC = [[RejectVC alloc] init];
        rejectVC.indexPath = self.indexPath;
        rejectVC.text = btn.currentTitle;
        rejectVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //淡出淡入
        rejectVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //            self.definesPresentationContext = YES; //不盖住整个屏幕
        rejectVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [self presentViewController:rejectVC animated:NO completion:nil];
    }


}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches anyObject].view == self.view) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}

@end
