//
//  CardView.h
//  XiaoYing
//
//  Created by GZH on 16/8/19.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardViewDelegate <NSObject>

- (void)refershTableView;

@end

@interface CardView : UIView

@property (nonatomic, strong) NSMutableArray *cardIDArray;
@property (nonatomic, strong) NSMutableArray *arrImageview;

@property (nonatomic, assign)id<CardViewDelegate>delegate;

@end
