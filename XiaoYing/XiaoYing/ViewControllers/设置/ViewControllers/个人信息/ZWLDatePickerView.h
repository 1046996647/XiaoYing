//
//  detePickerView.h
//  XiaoYing
//
//  Created by 林颖 on 15/11/30.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWLDatePickerView;

typedef void(^DataBlock)(NSString *str);


@interface ZWLDatePickerView : UIView
{
   
    UIDatePicker *dataPicker;
    UILabel *dateLabel2;
}

-(NSString *)Set_Time_Way;
@property (nonatomic,strong) NSString *dateStr;
@property (nonatomic, copy)DataBlock dataBlock;
@property (nonatomic,assign) NSInteger type;


@end
