//
//  PushViewVC.m
//  XiaoYing
//
//  Created by GZH on 16/8/9.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "PushViewVC.h"

@interface PushViewVC ()
//@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation PushViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
    [self initView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeview)];
    [self.view addGestureRecognizer:tap];
}

- (void)removeview {
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)initView {
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectZero];
    baseView.layer.cornerRadius = 5;
    baseView.clipsToBounds = YES;
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 3;
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    [baseView addSubview:lab];
    
    baseView.frame = CGRectMake((kScreen_Width-270)/2.0, (kScreen_Height - 200) / 2, 270, 100);
    lab.frame = CGRectMake(12, 12, baseView.width - 12 * 2, baseView.height - 12 - 44 - .5);
    
    if ([self.maskStr isEqualToString:@"同意"]) {
        lab.text = @"是否同意邀请?";
    }else
        if ([self.maskStr isEqualToString:@"拒绝"]) {
        lab.text = @"是否拒绝邀请?";
    }else
        if ([self.maskStr isEqualToString:@"撤回"]) {
        lab.text = @"是否确定撤回?";
        }else
            if ([self.maskStr isEqualToString:@"删除"]) {
            lab.text = @"是否确定删除?";
        }

    
    
    NSArray *titleArr = @[@"确定", @"取消"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(baseView.width/2.0), baseView.height-44, baseView.width/2.0, 44);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
    }
    
    //竖分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(baseView.width/2 - 0.5, baseView.height - 44, .5, 44)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView2];
    
    //横分割线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, baseView.frame.size.height - 44, baseView.width, .5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView1];
    
}

- (void)btnAction:(UIButton *)sender {
    if (sender.tag == 0) {
//        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        _hud.mode = MBProgressHUDModeIndeterminate;
//        _hud.labelText = @"加载中...";
        if ([self.maskStr isEqualToString:@"同意"]) {
            
            [self AgreeToJoinCompanyAction:sender];
            
        }else
        
            if ([self.maskStr isEqualToString:@"拒绝"]) {
            
                [self RefuseToJoinCompanyAction];
           
          }else
              if ([self.maskStr isEqualToString:@"撤回"]) {
                  [self UndoToJoinCompanyAction];
              }else
                  if ([self.maskStr isEqualToString:@"删除"]) {
                      [self DeleteJoinCompanyURlAction];
                  }

    
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


//拒绝加入公司
- (void)RefuseToJoinCompanyAction {
    
    NSString *URLstr = [RefuseToJoinCompanyURl stringByAppendingFormat:@"&joinqueueid=%@",_queueID];
    [AFNetClient POST_Path:URLstr completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"drawRefreshAction" object:[NSString stringWithFormat:@"%ld", _index]];

        }else {
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
        }
        
    } failed:^(NSError *error) {
        NSLog(@"--------------->>>>>>%@",error);
    }];
}

//同意加入公司
- (void)AgreeToJoinCompanyAction:(UIButton *)sender {
//    NSLog(@"-------------------------------------------------------%ld", (long)sender.tag);
    NSString *URLstr = [AgreeToJoinCompanyURl stringByAppendingFormat:@"&joinqueueid=%@",_queueID];
    [AFNetClient POST_Path:URLstr completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if ([code isEqual:@0]) {

            NSString *str = [NSString stringWithFormat:@"%ld", _index];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeModelOfAgree" object:str];
            if ([self.delegate respondsToSelector:@selector(agreeCompanyAction)]) {
                [self.delegate agreeCompanyAction];
            }
        }else {
           [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
        }
    } failed:^(NSError *error) {
        NSLog(@"--------------->>>>>>%@",error);
    }];
}


//撤回加入公司
- (void)UndoToJoinCompanyAction {
    NSString *URLstr = [UndoToJoinCompanyURl stringByAppendingFormat:@"&JoinQueueId=%@",_queueID];
    [AFNetClient POST_Path:URLstr completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0]) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"drawRefreshAction" object:[NSString stringWithFormat:@"%ld", _index]];
        }else {
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
        }
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//删除对方拒绝加入公司
- (void)DeleteJoinCompanyURlAction {
    NSString *URLstr = [DeleteJoinCompanyURl stringByAppendingFormat:@"&JoinCompanyQueueId=%@",_queueID];
    [AFNetClient POST_Path:URLstr completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0]) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"drawRefreshAction" object:[NSString stringWithFormat:@"%ld", _index]];
        }else {
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
        }
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
