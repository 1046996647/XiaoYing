//
//  ApprovalProgressTableView.h
//  XiaoYing
//
//  Created by ZWL on 15/12/24.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApplyProgressTableViewDelegate <NSObject>

- (void)scroll;

@end

@interface ApplyProgressTableView : UITableView

@property (nonatomic,strong) id<ApplyProgressTableViewDelegate> applyProgressDelegate;

@property (nonatomic,strong) NSArray *approvalNodeModelArray;

@end
