//
//  RegionController.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/21.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "RegionController.h"
#import <CoreLocation/CoreLocation.h>
#import "RegionModel.h"

@interface RegionController ()<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
//    CLLocationManager *_locationManager;
    UITableView *_tableView;
    MBProgressHUD *_hud;

}

@end

@implementation RegionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.title = @"地区";
    
//    // 1.创建位置服务对象
//    _locationManager = [[CLLocationManager alloc] init];
//    // 2.设置精确度
//    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    // 3.设置代理对象
//    _locationManager.delegate = self;
//    // 4.设置是否允许使用位置提示
//    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//        [_locationManager requestWhenInUseAuthorization];
//    }
//    // 5.开始定位
//    [_locationManager startUpdatingLocation];
    
    
    //表视图
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

}


//#pragma mark - CLLocationManagerDelegate
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    // 1.停止定位服务
//    [manager stopUpdatingLocation];
//    
//    // 2.获取当前的位置所在的城市
//    // 创建位置反编码对象
//    CLGeocoder *geocoder= [[CLGeocoder alloc] init];
//    CLLocation *location = [locations lastObject];
//        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
////            for (CLPlacemark *placemark in placemarks) {
////    
////                NSLog(@"城市：%@",placemark.addressDictionary);
////            }
//            
//            if (!error && [placemarks count] > 0)
//            {
//                NSDictionary *dict =
//                [[placemarks objectAtIndex:0] addressDictionary];
//                NSArray *keys = [dict allKeys];
//                for (NSString *key in keys) {
//                    NSLog(@"%@",dict[key]);
//                }
//                
//            }
//            else  
//            {  
//                NSLog(@"ERROR: %@", error);
//            }
//            
//            NSLog(@"%@",placemarks);
//        }];
//    
//    
//
//}

/**
 *  获取个人信息
 */
-(void)getMyMessage{
    

    [AFNetClient GET_Path:ProfileMy completed:^(NSData *stringData, id JSONDict) {
        
        _hud.hidden = YES;
        
        ProfileMyModel * model1 = [FirstModel GetProfileMyModel:[JSONDict objectForKey:@"Data"]];
        //获取存储沙盒路径
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        documentPath = [documentPath stringByAppendingPathComponent:@"PersonCentre.plist"];
        //用归档存储数据在plist文件中
        NSLog(@"个人中心存储在PersonCentre.plist文件中%@",documentPath);
        
        [NSKeyedArchiver archiveRootObject:model1 toFile:documentPath];
        
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];

        
    } failed:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}



#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.regions.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RegionModel *lastModel = self.regions[indexPath.row];
    
//    //获取本地文件
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/region.plist"];
//    NSArray *regionArr = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *arrM = [NSMutableArray array];
    
    for (NSDictionary *dic in self.fullRegionArr) {
        if ([lastModel.Id isEqualToString:dic[@"ParentId"]]) {
            RegionModel *model = [[RegionModel alloc] initWithContentsOfDic:dic];
            [arrM addObject:model];
        }
    }
    
//    NSString *regionStr = nil;
//    if (self.fullRegionName.length == 0) {
//        regionStr = [NSString stringWithFormat:@"%@",lastModel.RegionName];
//
//    }
//    else {
//        regionStr = [NSString stringWithFormat:@"%@ %@", self.fullRegionName,lastModel.RegionName];
//
//    }
//    NSLog(@"%@",str);
    
    if (arrM.count != 0) {
        RegionController *regionController = [[RegionController alloc] init];
        regionController.regions = arrM;
        regionController.fullRegionArr = self.fullRegionArr;
//        regionController.fullRegionName = regionStr;
        [self.navigationController pushViewController:regionController animated:YES];
    } else {
        
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"正在加载...";
        
        //修改地区
        NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
        [paramDic  setValue:lastModel.Id forKey:@"RegionId"];
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:Profile parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
            [self getMyMessage];
    
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
   
    }
    RegionModel *model = self.regions[indexPath.row];
    cell.textLabel.text = model.RegionName;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

////组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, 100, 20)];
    title.text = @"全部";
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = [UIColor colorWithHexString:@"#848484"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [view addSubview:title];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
