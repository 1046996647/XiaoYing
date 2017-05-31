//
//  JoinTheCompanyView.h
//  XiaoYing
//
//  Created by GZH on 16/8/9.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApplyforJoinCompanyCell;

@interface JoinTheCompanyView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong)NSMutableArray *arrayOfApplyForCompany;
@property (nonatomic, strong)ApplyforJoinCompanyCell *applyCell;

@end
