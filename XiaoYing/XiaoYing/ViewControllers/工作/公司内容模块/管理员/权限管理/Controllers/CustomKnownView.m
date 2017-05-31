//
//  CustomKnownView.m
//  XiaoYing
//
//  Created by GZH on 2016/11/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "CustomKnownView.h"
#import "WorkerMessageVC.h"
#import "EmployeeModel.h"
@interface CustomKnownView ()
//@property (nonatomic, strong)UIView *coverView;
//@property (nonatomic, strong)UIView *littleView;

@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, strong)NSString *resignStr;
@end

@implementation CustomKnownView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
    
    }
    return self;
}


- (void)initView {
    _coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.4;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_coverView];
    
    _littleView = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width - 270) / 2, (kScreen_Height - 132) / 2, 270 , 100 + 32)];
    _littleView.backgroundColor = [UIColor whiteColor];
    _littleView.layer.cornerRadius = 5;
    _littleView.clipsToBounds = YES;
    [window addSubview:_littleView];
    
    _upLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, _littleView.width - 12 * 2, _littleView.height - 12 - 44 - .5)];
    _upLabel.numberOfLines = 3;
    _upLabel.font = [UIFont systemFontOfSize:16];
    if ([_upLabel.text isEqual:@""]) {
         _upLabel.text = @"该员工已离职!";
    }else {
        
         _array = [NSMutableArray array];
        [self getListOfCompany];
    }
    _upLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _upLabel.textAlignment = NSTextAlignmentCenter;
    [_littleView addSubview:_upLabel];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100  + 32 - 44, 270, 0.5)];
    label.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_littleView addSubview:label];
    
//    NSArray *titleArr = @[@"确定", @"取消"];
//    for (int i = 0; i < titleArr.count; i++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(i*(_littleView.width/2.0), _littleView.height-44, _littleView.width/2.0, 44);
//        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
//        btn.tag = i;
//        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_littleView addSubview:btn];
//    }

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, _littleView.height-44, _littleView.width, 44);
    [btn setTitle:@"知道了" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(KnowAction) forControlEvents:UIControlEventTouchUpInside];
    [_littleView addSubview:btn];
    
    
    
//    //竖分割线
//    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(_littleView.width/2 - 0.25, _littleView.height - 44, .5, 44)];
//    lineView2.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
//    [_littleView addSubview:lineView2];
    
    //横分割线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _littleView.frame.size.height - 44, _littleView.width, .5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_littleView addSubview:lineView1];
    
}


- (void)getListOfCompany {
    [AFNetClient GET_Path:ListOfMyCompanyURl completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0]) {
            _array = JSONDict[@"Data"];
        
        }else {
            _resignStr = JSONDict[@"Message"];
        }
    } failed:^(NSError *error) {
    }];
}

- (void)KnowAction {
    
    //若员工已经离职，点击保存，刷新数据
    if ([_upLabel.text isEqualToString:@"该员工已离职!"]) {
        
        //某员工已离职，刷新本地数据
        [self getAllEmployeeMessage];
  
    }else {

                //当前0个公司的情况下加入一个公司
                if (_array.count == 1 && [_dic[@"Content"] containsString:@"成功"]) {
                    [self refershDelegateAction];
                    return;
                }
                
                //当前多个公司的情况下加入一个公司
                if (_array.count > 1 && [_dic[@"Content"] containsString:@"成功"]) {
                    if ([_delegate respondsToSelector:@selector(removeCustonViewFromSuperView)]) {
                        [_delegate removeCustonViewFromSuperView];
                    }
                    return;
                }
                
                //当前有多于1个公司，从一个中离职，且是当前公司离职
                if (_array.count > 0 && [_dic[@"Content"] containsString:@"离职"] && [[UserInfo getCompanyId]isEqualToString:_dic[@"CompanyId"]]) {
                    [self refershDelegateAction];
                    return;
                }

                //当前有多于1个公司，从一个中离职，不是当前公司离职
                if (_array.count > 0 && [_dic[@"Content"] containsString:@"离职"] && ![[UserInfo getCompanyId]isEqualToString:_dic[@"CompanyId"]]) {
                    if ([_delegate respondsToSelector:@selector(removeCustonViewFromSuperView)]) {
                        [_delegate removeCustonViewFromSuperView];
                    }
                    return;
                }

                // 一个公司的情况下离职
                if ([_resignStr isEqualToString:@"没有查找到公司"]) {
                    
                    [self refershDelegateAction];
                    
                    [ZWLCacheData archiveObject:@[] toFile:DepartmentsPath];
                    [ZWLCacheData archiveObject:@[] toFile:EmployeesPath];
                    // 刷新部门和员工信息！
                    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshInfoNotification object:nil];
                    return;
                }
            }
}


- (void)refershDelegateAction {
    if ([_delegate respondsToSelector:@selector(referBehindResign)]) {
        [_delegate referBehindResign];
    }
}


- (void)getAllEmployeeMessage {
    NSString *strURL = [GetAllEmployee stringByAppendingFormat:@"&pageIndex=1&PageSize=1000"];
    //获取公司所有职员信息
    [AFNetClient GET_Path:strURL completed:^(NSData *stringData, id JSONDict) {
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            NSString *msg = [JSONDict objectForKey:@"Message"];
            [MBProgressHUD showMessage:msg toView:self];
            
        } else {
            
            NSLog(@"-------------------------------------------------------%@", JSONDict);
            NSMutableArray *array1 = JSONDict[@"Data"];
            [ZWLCacheData archiveObject:array1 toFile:EmployeesPath];
            NSMutableArray *arrM1 = [NSMutableArray array];
            
            for (NSDictionary *dic in array1) {
                if ([_tempDepartmentId isEqualToString:@""]) {
                    if ([dic[@"DepartmentId"] isEqualToString:@""] || [[UserInfo GetTopLeaderOfCompany] isEqualToString:dic[@"ProfileId"]]) {
                        EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
                        [arrM1 addObject:model];
                        
                        if ([dic[@"DepartmentId"] isEqualToString:@""] && [[UserInfo GetTopLeaderOfCompany] isEqualToString:dic[@"ProfileId"]]) {
                            model.isMastLeader = YES;
                        } else if ([[UserInfo GetTopLeaderOfCompany] isEqualToString:dic[@"ProfileId"]])
                        {
                            model.isConcurrentLeader = YES;
                        }
                    }
                }
                else {
                    if ([dic[@"DepartmentId"] isEqualToString:_tempDepartmentId] || [_ManagerProfileId isEqualToString:dic[@"ProfileId"]]) {
                        EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
                        [arrM1 addObject:model];
                        
                        if ([dic[@"DepartmentId"] isEqualToString:_tempDepartmentId] && [_ManagerProfileId isEqualToString:dic[@"ProfileId"]]) {
                            model.isMastLeader = YES;
                        } else if ([_ManagerProfileId isEqualToString:dic[@"ProfileId"]])
                        {
                            model.isConcurrentLeader = YES;
                        }
                    }
                }
            }
            [self btnAction];
        }
    } failed:^(NSError *error) {
    }];
}

- (void)btnAction {
    
    [self coverBackAction];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refershWorkerMessageVC" object:nil];
    WorkerMessageVC *applyVC = [[WorkerMessageVC alloc]init];
    for (UIViewController *viewController in self.viewController.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[applyVC class]]) {
            [self.viewController.navigationController popToViewController:viewController animated:YES];
        }
    }
}



- (void)coverBackAction {
    [_coverView removeFromSuperview];
    [_littleView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    self.upLabel.text = dic[@"Content"];

}


@end
