//
//  detePickerView.h
//  XiaoYing
//
//  Created by ZWL on 15/11/30.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface detePickerView : UIView
{
    CGRect rect1;
    CGRect rect2;
    
    CGRect rect4;
   
    UIDatePicker *dataPicker;
    UILabel *dateLabel2;
}

-(NSString *)Set_Time_Way;


@end
