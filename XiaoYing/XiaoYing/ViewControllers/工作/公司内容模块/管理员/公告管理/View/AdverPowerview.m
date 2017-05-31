//
//  AdverPowerview.m
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/28.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AdverPowerview.h"
#import "WangUrlHelp.h"
@interface AdverPowerview()
@property(nonatomic,strong)MBProgressHUD *hud;//菊花

@end
@implementation AdverPowerview


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化数组
        self.approvalPersonArr = [NSMutableArray array];
        self.applyPeopleArr = [NSMutableArray array];
        self.deletePeopleArr = [NSMutableArray array];
        self.applyDepArr = [NSMutableArray array];
        self.approvalDepArr = [NSMutableArray array];
        self.deleteDepArr = [NSMutableArray array];
        //允许申请发广告的人
        [self addSubview:self.OraindryPeople];
        [self addSubview:self.lineLabel];
        [self addSubview:self.nameOfpeople];
        
        //审批公告的人
        [self addSubview:self.powerPeople];
        //允许删除广告的人
        [self addSubview:self.CanDeletePeople];
        [self addSubview:self.lineLabelTwo];
        [self addSubview:self.nameOfpeopleTwo];
        
        _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        _hud.labelText = @"正在加载中";
    }
    return self;
}

- (UIView *)OraindryPeople {
    if(_OraindryPeople == nil) {
        self.OraindryPeople = [[UIView alloc]initWithFrame:CGRectMake(0, 12, kScreen_Width, 44)];
        UILabel *peopleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 3, kScreen_Width - 34, 38)];
        peopleLabel.text = @"允许申请发公告的人";
        peopleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        peopleLabel.font = [UIFont systemFontOfSize:16];
        _OraindryPeople.backgroundColor = [UIColor whiteColor];
        _OraindryPeople.userInteractionEnabled = YES;
        [_OraindryPeople addSubview:peopleLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 34, 12, 10, 20)];
        imageView.image = [UIImage imageNamed:@"arrow_set"];
//        imageView.backgroundColor = [UIColor redColor];
        [_OraindryPeople addSubview:imageView];
    }
    return _OraindryPeople;
}


- (UILabel *)lineLabel {
    if(_lineLabel == nil) {
        self.lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _OraindryPeople.bottom, kScreen_Width, .5)];
        _lineLabel.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    }
    return _lineLabel;
}


- (UIView *)nameOfpeople {
    if(_nameOfpeople == nil) {
        self.nameOfpeople = [[UIView alloc]initWithFrame:CGRectMake(0, _lineLabel.bottom, kScreen_Width, 60)];
        _nameOfpeople.backgroundColor = [UIColor whiteColor];
        _applypeopleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 6, kScreen_Width - 20, _nameOfpeople.height - 12)];
        _applypeopleLab.numberOfLines = 2;
//        _applypeopleLab.backgroundColor = [UIColor blueColor];
        _applypeopleLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _applypeopleLab.text = @"";
//        _approvalPersonLab.textAlignment = 
        _applypeopleLab.font = [UIFont systemFontOfSize:14];
        _applypeopleLab.textColor = [UIColor colorWithHexString:@"#848484"];
        [_nameOfpeople addSubview:_applypeopleLab];
    }
    return _nameOfpeople;
}

- (UIView *)powerPeople {
    if(_powerPeople == nil) {
        self.powerPeople = [[UIView alloc]initWithFrame:CGRectMake(0, _nameOfpeople.bottom + 12, kScreen_Width, 44)];
        _powerPeople.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 3, kScreen_Width / 2, 38)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.text = @"审批公告的人";
        titleLabel.font = [UIFont systemFontOfSize:16];
        [_powerPeople addSubview:titleLabel];
        
        _approvalPersonLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 34 - 3 - kScreen_Width / 3, 3, kScreen_Width / 3, 38)];
        _approvalPersonLab.textColor = [UIColor colorWithHexString:@"#848484"];
        _approvalPersonLab.textAlignment = NSTextAlignmentRight;
        _approvalPersonLab.font = [UIFont systemFontOfSize:14];
        _approvalPersonLab.text = @"";
        [_powerPeople addSubview:_approvalPersonLab];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 34, 12, 10, 20)];
         imageView.image = [UIImage imageNamed:@"arrow_set"];
//        imageView.backgroundColor = [UIColor redColor];
        [_powerPeople addSubview:imageView];
    }
    return _powerPeople;
}


- (UIView *)CanDeletePeople {
    if(_CanDeletePeople == nil) {
        self.CanDeletePeople = [[UIView alloc]initWithFrame:CGRectMake(0,_powerPeople.bottom + 12, kScreen_Width, 44)];
        UILabel *canDeleteLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 3, kScreen_Width - 34, 38)];
        canDeleteLabel.text = @"允许删除公告的人";
        canDeleteLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        canDeleteLabel.textAlignment = NSTextAlignmentLeft;
        canDeleteLabel.font = [UIFont systemFontOfSize:16];
        _CanDeletePeople.backgroundColor = [UIColor whiteColor];
        _CanDeletePeople.userInteractionEnabled = YES;
        [_CanDeletePeople addSubview:canDeleteLabel];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 34, 12, 10, 20)];
         imageView.image = [UIImage imageNamed:@"arrow_set"];
//        imageView.backgroundColor = [UIColor redColor];
        [_CanDeletePeople addSubview:imageView];
        
    }
    return _CanDeletePeople;
}

- (UILabel *)lineLabelTwo {
    if(_lineLabelTwo == nil) {
        self.lineLabelTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, _CanDeletePeople.bottom, kScreen_Width, 1)];
        _lineLabelTwo.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    }
    return _lineLabelTwo;
}

- (UIView *)nameOfpeopleTwo {
    if(_nameOfpeopleTwo == nil) {
        self.nameOfpeopleTwo = [[UIView alloc]initWithFrame:CGRectMake(0, _lineLabelTwo.bottom, kScreen_Width, 60)];
        _nameOfpeopleTwo.backgroundColor = [UIColor whiteColor];
    
        _deletePeopleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 6, kScreen_Width - 20, _nameOfpeopleTwo.height - 12)];
        _deletePeopleLab.numberOfLines = 2;
        _deletePeopleLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _deletePeopleLab.text = @"";
        _deletePeopleLab.font = [UIFont systemFontOfSize:14];
        _deletePeopleLab.textColor = [UIColor colorWithHexString:@"#848484"];
        [_nameOfpeopleTwo addSubview:_deletePeopleLab];
    }
    return _nameOfpeopleTwo;
}

-(void)setDepartmentId:(NSString *)departmentId{
    _departmentId = departmentId;
    [self loadAffichePeopleWithDepartmenId:departmentId];
}

#pragma mark - 网络加载方法 methods
-(void)loadAffichePeopleWithDepartmenId:(NSString*)departmentId{
    NSString *strUrl = AFFICHE_GETPERMISSIONBYDEP,departmentId];
    [AFNetClient POST_Path:strUrl completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code = JSONDict[@"Code"];
        
        if (code.integerValue == 0){
            NSArray *dataArr = JSONDict[@"Data"];
            for (NSDictionary  *subDic in dataArr) {
                NSNumber *ty = subDic[@"Type"];
                NSInteger type = ty.integerValue;
                if (type == 0) {//申请
                    [self.applyPeopleArr addObject:subDic[@"ProfileId"]];
                }
                if (type == 1) {//审批
                    [self.approvalPersonArr addObject:subDic[@"ProfileId"]];
                }
                if (type == 2) {//删除
                    [self.deletePeopleArr addObject:subDic[@"ProfileId"]];
                }
            }
            _applypeopleLab.text = [self nameStringFromIDArr:self.applyPeopleArr];
            _approvalPersonLab.text = [self nameStringFromIDArr:self.approvalPersonArr];
            _deletePeopleLab.text = [self nameStringFromIDArr:self.deletePeopleArr];
            [_hud hide:YES];
            _hud = nil;
        }else{
            [_hud hide:YES];
            _hud = nil;
            [MBProgressHUD showMessage:JSONDict[@"Message"]];
        }
    } failed:^(NSError *error) {
        NSLog(@"失败**********=======>>>%@",error);
        [_hud hide:YES];
        _hud = nil;
        [MBProgressHUD showMessage:@"网络错误"];
        [self.viewController.navigationController popViewControllerAnimated:YES];
    }];
}

-(NSArray *)nameArrFromIDArr:(NSMutableArray*)IDArr{
    NSMutableArray *nameMutableArr = [NSMutableArray array];
    NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
    for (NSDictionary *employeeDic in employeesArr) {
        NSString *approvalName = [employeeDic objectForKey:@"EmployeeName"];
        NSString *profielID = [employeeDic objectForKey:@"ProfileId"];
        for (NSString *dpid in IDArr) {
            if ([dpid isEqualToString:profielID]) {
                [nameMutableArr addObject:approvalName];
            }
        }
    }
    return [nameMutableArr copy];
}

-(NSString *)nameStringFromIDArr:(NSMutableArray *)IDArr{
    NSArray *nameArr = [self nameArrFromIDArr:IDArr];
    NSString *nameString = @"";
    for (int i =0; i<nameArr.count; i++) {
        if (i == 0) {
            nameString = [nameString stringByAppendingString:[NSString stringWithFormat:@"%@",nameArr[i]]];
        }else{
            nameString = [nameString stringByAppendingString:[NSString stringWithFormat:@"、%@",nameArr[i]]];
        }
    }
    return nameString;
}


@end
