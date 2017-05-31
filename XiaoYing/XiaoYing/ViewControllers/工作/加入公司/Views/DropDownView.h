//
//  DropDownView.h
//  XiaoYing
//
//  Created by GZH on 16/8/11.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockValue)(NSString *str);

@protocol DropDownViewDelegate <NSObject>

- (void)removeCoverView;

@end


@interface DropDownView : UIView

@property (nonatomic, strong)UIView *coverView;
@property (nonatomic, strong)UITableView *tableView;


@property (nonatomic, assign)id<DropDownViewDelegate>delegate;


@property (nonatomic, copy)BlockValue blockValue;

@end
