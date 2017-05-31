//
//  LocationVC.h
//  XiaoYing
//
//  Created by yinglaijinrong on 16/5/9.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "BaseSettingViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface LocationVC : BaseSettingViewController

/*!
 地理位置的二维坐标
 */
@property(nonatomic, assign) CLLocationCoordinate2D location;

@end
