//
//  NewFileView.h
//  XiaoYing
//
//  Created by GZH on 16/8/25.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PassTitle)(NSString *tempTitle);

@interface NewFileView : UIViewController

@property (nonatomic, copy)PassTitle passTitle;

@property (nonatomic, strong)NSMutableArray *arrayOfSectionTitle;


@end
