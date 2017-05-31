//
//  InboxVC.h
//  XiaoYing
//
//  Created by ZWL on 16/2/25.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    InBox =0,
    StarBox =1,
    SendedBox =2,
    DraftsBox = 3,
    TrashBox = 4,
}ENUM_MailBoxStyle;

@interface InboxVC : BaseSettingViewController

@property (nonatomic,assign)ENUM_MailBoxStyle emailBoxStyle;
@end
