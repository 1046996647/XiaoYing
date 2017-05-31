//
//  CustomKnownView.h
//  XiaoYing
//
//  Created by GZH on 2016/11/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomKnownViewDelegate <NSObject>

- (void)referBehindResign;

- (void)removeCustonViewFromSuperView;

@end


@interface CustomKnownView : UIView

@property (nonatomic, strong)UIView *coverView;
@property (nonatomic, strong)UIView *littleView;

@property (nonatomic, strong) NSString *tempDepartmentId;
@property (nonatomic, strong) NSString *ManagerProfileId;

@property (nonatomic, strong)UILabel *upLabel;

@property (nonatomic, strong)NSDictionary *dic;

//有新员工加入或者离职时候的刷新
@property (nonatomic, assign)id<CustomKnownViewDelegate> delegate;
@end
