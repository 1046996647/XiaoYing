//
//  PersonalMessage.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/14.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//



#import "PersonalMessageController.h"
#import "PersonCell.h"
#import "InfoChangeController.h"
#import "BirthdayController.h"
#import "RegionController.h"
#import "SexController.h"
#import "MBProgressHUD+MJ.h"
#import "RegionModel.h"
#import "PopViewVC.h"
#import "NSNumber+RegionName.h"
#import "ZWLDatePickerView.h"
#import "RCIM.h"

//#import "SJAvatarBrowser.h"



@interface PersonalMessageController()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    NSArray *_dataArray;
    UIImageView *_userImg;// 头像
//    NSString *_userImgUrl;// 头像链接
    MBProgressHUD *_hud;
    
    BOOL _isSex;
}
@end

@implementation PersonalMessageController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.title = @"个人信息";
    
//
    _titleArray = @[@[@"头像",@"昵称",@"小赢号"],
                    @[@"性别",@"生日",@"地区"],
                    @[@"个性签名"]];
    
    //头像
    _userImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 12 - 60, (80 - 60) / 2.0, 60, 60)];
    _userImg.layer.cornerRadius = 5;
    _userImg.clipsToBounds = YES;
    _userImg.userInteractionEnabled = YES;
    //添加手势
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
//    [_userImg addGestureRecognizer:tap];
    
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    //生日修改完成后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"birthdayChangeNotification" object:nil];
    
    //获取本地地区文件
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/region.plist"];
    self.fullRegionArr = [NSArray arrayWithContentsOfFile:filePath];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //个人信息
    [self getUserInfo];

}


//浏览头像
//- (void)magnifyImage
//{
//    [SJAvatarBrowser showImage:_userImg];//调用方法
//}

//个人信息
- (void)getUserInfo
{
    
    //个人信息取出
    self.profileMyModel = [[FirstStartData shareFirstStartData] getPersonCentrePlist];
    
//    NSString *fullRegion = [@(self.profileMyModel.RegionId) getRegionName];
//    if (self.profileMyModel.RegionName.length == 0) {
//        fullRegion = @"";
//    }
    
    //性别
    NSString *sex = nil;
    
    if (self.profileMyModel.Gender == 0) {
        sex = @"";
    }
    else if (self.profileMyModel.Gender == 1) {
        sex = @"男";
    }
    else {
        sex = @"女";
    }

    
    //头像
    NSString *iconURL = [NSString replaceString:self.profileMyModel.FaceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [_userImg sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@""]];
    
    
    _dataArray = @[@[@"",self.profileMyModel.Nick,self.profileMyModel.XiaoYingCode],
                   @[sex,self.profileMyModel.Birthday,self.profileMyModel.RegionName],
                   @[self.profileMyModel.Signature]];
    [_tableView reloadData];
}



#pragma mark - UIImagePickerControllerDelegate

//选取后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"info:%@",info[UIImagePickerControllerOriginalImage]);
    
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    
    //图片转字符串Base64Str
    NSString *imgStr = [self imageOrientationAndBase64Str:img];


    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"上传头像中";
//    [MBProgressHUD showMessage:@"正在上传头像" toView:self.view];
    
    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
    [paramDic  setValue:imgStr forKey:@"data"];
    [paramDic  setValue:@"userFace.png" forKey:@"fileName"];
    [paramDic  setValue:@"images" forKey:@"category"];
    
    [AFNetClient  POST_Path:Userface params:paramDic completed:^(NSData *stringData, id JSONDict) {

        
        /**
         *  获取个人信息
         */
        [self getMyMessage];
        
        
    } failed:^(NSError *error) {
        NSLog(@"请求失败Error--%ld",(long)error.code);
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//取消后调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/**
 *  获取个人信息
 */
-(void)getMyMessage{
    
    
    [AFNetClient GET_Path:ProfileMy completed:^(NSData *stringData, id JSONDict) {
        
        [_hud hide:YES];
        
        if (!_isSex) {
            [MBProgressHUD showSuccess:@"上传成功" toView:self.view];

        }
        
        ProfileMyModel * model1 = [FirstModel GetProfileMyModel:[JSONDict objectForKey:@"Data"]];
        // 当前登录的用户的用户信息
        RCUserInfo * user =[[RCUserInfo alloc]init];
        user.name = model1.Nick;
        user.userId = model1.ProfileId;
        NSString *iconURL = [NSString replaceString:model1.FaceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
        user.portraitUri = iconURL;
        [[RCIM sharedRCIM] refreshUserInfoCache:user
                                     withUserId:user.userId];
        
        //设置头像
        [_userImg sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@""]];
        
        //获取存储沙盒路径
        NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        documentPath = [documentPath stringByAppendingPathComponent:@"PersonCentre.plist"];
        //用归档存储数据在plist文件中
        NSLog(@"个人中心存储在PersonCentre.plist文件中%@",documentPath);
        
        [NSKeyedArchiver archiveRootObject:model1 toFile:documentPath];
        
        [self getUserInfo];
//        [self.navigationController popViewControllerAnimated:YES];
        
    } failed:^(NSError *error) {
        
        [_hud hide:YES];
        NSLog(@"%@",error);
        
    }];
}



//图片旋转和转字符串
-(NSString *)imageOrientationAndBase64Str:(UIImage *) image

{
    //处理后的图片
    UIImage *normalizedImage = nil;
    
    //图片方向处理
    if (image.imageOrientation == UIImageOrientationUp) {
        normalizedImage = image;
    } else {
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        [image drawInRect:(CGRect){0, 0, image.size}];
        normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
    //图片转成Base64Str
//    NSData *data = UIImagePNGRepresentation(image);
    NSData *data = UIImageJPEGRepresentation(normalizedImage, .5);
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encodedImageStr;
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titleArray[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }
    if (indexPath.section == 2) {
        //计算字符串高度
        NSString *str = _dataArray[indexPath.section][indexPath.row];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGSize textSize = [str boundingRectWithSize:CGSizeMake(200, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        return textSize.height + 34;
    }

    return 50;
}

//选中单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ((indexPath.section == 0 && indexPath.row == 1) || (indexPath.section == 2)) {
        
        PersonCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        InfoChangeController *infoChangeController = [[InfoChangeController alloc] init];
        infoChangeController.title = cell.titleLab.text;
        infoChangeController.text = cell.dataLab.text;
        infoChangeController.indexPath = indexPath;
        [self.navigationController pushViewController:infoChangeController animated:YES];
    }
    
    //打开相册
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        _isSex = NO;
     
        PopViewVC *popViewVC  = [[PopViewVC alloc] init];
        popViewVC.titleArr = @[@"相册",@"拍照"];
        popViewVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        //淡出淡入
        popViewVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //  self.definesPresentationContext = YES; //不盖住整个屏幕
        popViewVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [self presentViewController:popViewVC animated:YES completion:nil];
        popViewVC.clickBlock = ^(NSInteger indexRow) {
            if (indexRow == 0) {
                
                // 创建相册控制器
                UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
                // 设置类型
                pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                // 设置为静态图像类型
                pickerController.mediaTypes = @[@"public.image"];
                // 设置代理对象
                pickerController.delegate = self;
                // 设置选择后的图片可以被编辑
                //            pickerController.allowsEditing=YES;
                
                // 跳转到相册页面
                [self presentViewController:pickerController animated:YES completion:nil];
                
            } else {
                NSLog(@"打开摄像头");
                // 判断当前设备是否有摄像头
                if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                    
                    // 创建相册控制器
                    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
                    // 设置类型
                    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    // 设置代理对象
                    pickerController.delegate = self;
                    //                pickerController.allowsEditing=YES;
                    // 跳转到相册页面
                    [self presentViewController:pickerController animated:YES completion:nil];
                } else {
                    
                    
                    MLCompatibleAlert *alert = [[MLCompatibleAlert alloc]
                                                initWithPreferredStyle: MLAlertStyleAlert //MLAlertStyleActionSheet
                                                title:@"打开摄像头失败"
                                                message:@"没有检测到摄像头"
                                                delegate:nil
                                                cancelButtonTitle:@"确定"
                                                destructiveButtonTitle:nil
                                                otherButtonTitles:nil,nil];
                    [alert showAlertWithParent:self];
                }
            }
        };

        
    }
    
    
    if (indexPath.section == 1) {
        
        //性别
        if (indexPath.row == 0) {

            _isSex = YES;

            PopViewVC *popViewVC  = [[PopViewVC alloc] init];
            popViewVC.titleArr = @[@"男",@"女"];
            popViewVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            //淡出淡入
            popViewVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            //  self.definesPresentationContext = YES; //不盖住整个屏幕
            popViewVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
            [self presentViewController:popViewVC animated:YES completion:nil];
            popViewVC.clickBlock = ^(NSInteger indexRow) {
                
                _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                _hud.labelText = @"正在加载...";
                NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
                if (indexRow == 0) {
                    [paramDic  setValue:@1 forKey:@"gender"];

                    
                } else {
                    [paramDic  setValue:@2 forKey:@"gender"];

                }
                [AFNetClient  POST_Path:Profile params:paramDic completed:^(NSData *stringData, id JSONDict) {
                    
                    [self getMyMessage];
                    
                } failed:^(NSError *error) {
                    NSLog(@"请求失败Error--%ld",(long)error.code);
                }];
            };


        }

        
        //生日
        if (indexPath.row == 1) {
            
            //获取单元格
            PersonCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            ZWLDatePickerView *datepickerView = [[ZWLDatePickerView alloc] initWithFrame:CGRectMake(0,kScreen_Height - 270, kScreen_Width, 270)];
            datepickerView.type = 1;
            datepickerView.dateStr = cell.dataLab.text;
            
            BirthdayController *birthdayCtrl = [[BirthdayController alloc] init];
            birthdayCtrl.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            //淡出淡入
            birthdayCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            self.definesPresentationContext = YES; //不盖住整个屏幕
//            birthdayCtrl.dateStr = cell.dataLab.text;
            birthdayCtrl.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
            [birthdayCtrl.view addSubview:datepickerView];

            
            [self presentViewController:birthdayCtrl animated:YES completion:nil];
        }
        
        //地区
        if (indexPath.row == 2) {
            
            NSMutableArray *arrM = [NSMutableArray array];
            for (NSDictionary *dic in self.fullRegionArr) {
                if ([dic[@"RegionType"] integerValue] == 2) {
                    RegionModel *model = [[RegionModel alloc] initWithContentsOfDic:dic];
                    [arrM addObject:model];
                }
            }
            
            RegionController *regionController = [[RegionController alloc] init];
            regionController.regions = arrM;
            regionController.fullRegionArr = self.fullRegionArr;
            [self.navigationController pushViewController:regionController animated:YES];                                                                                                                                                                   
            
        }
    }
    

}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[PersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            [cell.contentView addSubview:_userImg];

        }
        
    }
    
    
    //不可修改单元格的字体类型
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.cellFontType = CellFontTypeFirst;
    }
    
    //给单元格数据
    cell.title = _titleArray[indexPath.section][indexPath.row];
    cell.data = _dataArray[indexPath.section][indexPath.row];
    
    return cell;
}


//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 12;
}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 12)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    return view;
}

//去掉最后单元格最下面的线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 生日修改完成后通知方法
- (void)notificationAction:(NSNotification *)not
{
    [self getUserInfo];
}

@end
