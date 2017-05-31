//
//  NewViewVC.h
//  XiaoYing
//
//  Created by ZWL on 16/11/24.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(NSString *);


@interface NewViewVC : UIViewController

@property (nonatomic,strong) NSString *markText;
@property (nonatomic,strong) NSString *placeholderText;
@property (nonatomic,strong) NSString *content;

@property (nonatomic,copy) ClickBlock clickBlock;


@end
