//
//  DatepickerView.h
//  XiaoYing
//
//  Created by 王思齐 on 16/11/16.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DataBlock)(NSString *str);
@interface DatepickerView : UIView

@property (nonatomic,strong) NSString *dateStr;
@property (nonatomic, copy)DataBlock dataBlock;
@property(nonatomic,strong)UIDatePicker *dataPicker;
@property(nonatomic,strong)UILabel *dateLabel2;
@property(nonatomic,strong)NSString *minDateStr;
@end
