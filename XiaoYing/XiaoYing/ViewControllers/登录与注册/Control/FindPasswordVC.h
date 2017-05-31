//
//  FindPasswordVC.h
//  XiaoYing
//
//  Created by ZWL on 15/10/26.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPasswordVC : BaseSettingViewController<UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic,retain)UIView *RegisterBackView;
@property (nonatomic,strong) NSString *queueId;
@property (nonatomic,strong) NSString *mailText;
@property (nonatomic,strong) NSString *verificationCode;


@end
