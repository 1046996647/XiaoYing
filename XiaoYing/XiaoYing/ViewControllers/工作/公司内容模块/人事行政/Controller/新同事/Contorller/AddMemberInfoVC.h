//
//  MemberInfoVC.h
//  XiaoYing
//
//  Created by MengFanBiao on 16/6/13.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "BaseSettingViewController.h"

typedef void(^BlockKeepYON)(NSString *str);


@interface AddMemberInfoVC : BaseSettingViewController

@property (nonatomic,strong) NSString *titleStr;

@property (nonatomic,strong) NSString *Nick;
@property (nonatomic,strong) NSString *XiaoYinCode;
@property (nonatomic,strong) NSString *Singer;
@property (nonatomic,strong) NSString *region;
@property (nonatomic,strong) NSString *FaceUrl;

@property (nonatomic,strong) NSString *JoinID;

@property (nonatomic,strong) BlockKeepYON blockKeepYON;;

@end
