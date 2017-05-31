//
//  ViewController.m
//  MapView03
//
//  Created by 朱思明 on 15/9/11.
//  Copyright (c) 2015年 朱思明. All rights reserved.
//

#import "LocationVC.h"

@interface LocationVC()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    // 位置服务对象
    CLLocationManager *_locationManager;
    MKMapView *_mapView;    // 地图视图

}

@end

@implementation LocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"位置";
    
    // 让用户允许定位服务
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [_locationManager startUpdatingLocation];
    // 1.创建一个地图视图
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    // 设置地图的类型
    _mapView.mapType = MKMapTypeStandard;
    // 设置是否现实自身位置
    _mapView.showsUserLocation = YES;
    // 设置代理对象
//    _mapView.delegate = self;
    
    // 把地图添加到当前视图上
    [self.view addSubview:_mapView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - MKMapViewDelegate
// 创建标注视图
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    
//    // 创建系统的大头针位置
//    // 1.创建表示id
//    static NSString *identifier = @"annotationViewId";
//    // 2.从地图的闲置池里面获取闲置的标注视图
//    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//    // 3.判断是否找到闲置的标注视图
//    if (pinView == nil) {
//        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
//        // 设置标注的颜色
//        pinView.pinColor = MKPinAnnotationColorRed;
//        // 设置从天而降的效果
//        pinView.animatesDrop = YES;
//        // 设置是否可以点击
//        pinView.canShowCallout = YES;
//        // 设置辅助视图
//        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    }
//    // 4.设置标注视图的内容
//    pinView.annotation = annotation;
//    return pinView;
//}


// 获取用户位置成功
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    
//    [_locationManager stopUpdatingLocation];
//    
//    
//    //    MyAnnotation *annotation = [[MyAnnotation alloc] init];
//    //    annotation.coordinate = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);
//    ////    annotation.title = @"领袖大厦B座";
//    ////    annotation.subtitle = @"无限互联";
//    //    [_mapView addAnnotation:annotation];
//    
//    // 将用户的位置显示在地图的中心位置
//    // 设置地图的现实区域
//    // 设置缩放比例
//    MKCoordinateSpan span = MKCoordinateSpanMake(1, 1);
//    MKCoordinateRegion region = MKCoordinateRegionMake(self.location, span);
//    region.center = mapView.region.center;
//    [_mapView setRegion:region animated:YES];
//}

//获取地图中心的位置
//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//    [_locationManager stopUpdatingLocation];
//
//    // 设置地图的现实区域
//    // 设置缩放比例
//    MKCoordinateSpan span = MKCoordinateSpanMake(.1, .1);
//    MKCoordinateRegion region = MKCoordinateRegionMake(self.location, span);
//    region.center = mapView.centerCoordinate;
//    [_mapView setRegion:region animated:YES];
//    NSLog(@"lon:%f,lat:%f",mapView.centerCoordinate.longitude,mapView.centerCoordinate.latitude);
//}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    MKCoordinateSpan span = MKCoordinateSpanMake(.1, .1);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.location, span);
//    region.center = mapView.region.center;
    [_mapView setRegion:region animated:YES];
    
    [_locationManager stopUpdatingLocation];
}

@end
