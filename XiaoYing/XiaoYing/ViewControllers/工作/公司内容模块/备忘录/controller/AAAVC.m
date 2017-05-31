//
//  ViewController.m
//  UploadDemo
//
//  Created by ZWL on 16/7/26.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AAAVC.h"
#import "AFNetClient.h"
#import "MLCompatibleAlert.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "WLUploadManager.h"
#import "WLUploadManagerVC.h"

#define ZFCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"ZFCache"] // 测试


#define FileCaches [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]


@interface AAAVC ()<MLCompatibleAlertDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,WLUploadDelegate>

@property (nonatomic,strong) UILabel *progressLab;



@end

@implementation AAAVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    
    _progressLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, kScreen_Width, 50)];
    _progressLab.text = @"sdfsdfs";
    [self.view addSubview:_progressLab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 300, kScreen_Width, 100);
    [btn setTitle:@"上传管理" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnAction
{
    [self.navigationController pushViewController:[[WLUploadManagerVC alloc] init] animated:YES];
}

#pragma mark - MLCompatibleAlertDelegate
- (void)compatibleAlert:(MLCompatibleAlert *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"打开摄像头");
        // 判断当前设备是否有摄像头
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            
            // 创建相册控制器
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            // 设置类型
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 设置代理对象
            pickerController.delegate = self;
            pickerController.allowsEditing=YES;
            // 跳转到相册页面
            [self presentViewController:pickerController animated:YES completion:nil];
        } else {
            
            
            MLCompatibleAlert *alert = [[MLCompatibleAlert alloc]
                                        initWithPreferredStyle: MLAlertStyleAlert //MLAlertStyleActionSheet
                                        title:@"打开摄像头失败"
                                        message:@"没有检测到摄像头"
                                        delegate:nil
                                        cancelButtonTitle:@"OK"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles:nil,nil];
            
            [alert showAlertWithParent:self];
            
        }
        
        
    } else if (buttonIndex == 1) {
        
        // 创建相册控制器
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        // 设置类型
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 设置为静态图像类型
        pickerController.mediaTypes = @[@"public.image"];
        
        // 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
        //        NSString *requiredMediaType = ( NSString *)kUTTypeImage;
        //        NSString *requiredMediaType1 = ( NSString *)kUTTypeMovie;
        //        NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType, requiredMediaType1,nil];
        //        [pickerController setMediaTypes:arrMediaTypes];
        
        
        // 设置代理对象
        pickerController.delegate = self;
        // 设置选择后的图片可以被编辑
        //        pickerController.allowsEditing=YES;
        
        // 跳转到相册页面
        [self presentViewController:pickerController animated:YES completion:nil];
        
        
    }
}

#pragma mark - UIImagePickerControllerDelegate

//选取后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"info:%@",info);
    
    //隐藏不了HUD
    //    [MBProgressHUD showMessage:@"正在上传头像"];
    
    //    [MBProgressHUD showMessage:@"正在上传头像" toView:self.view];
    //
    //    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
    //    [paramDic  setValue:imgStr forKey:@"data"];
    //    [paramDic  setValue:@"userFace.png" forKey:@"fileName"];
    //    [paramDic  setValue:@"images" forKey:@"category"];
    
    
    //    __block NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibrary* alLibrary = [[ALAssetsLibrary alloc] init];
    //    __block float fileMB  = 0.0;
    
    [alLibrary assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset)
     {
         
         //         fileMB = ((float)[representation size]/(1024 * 1024));
         //         NSLog(@"size of asset in bytes: %0.2f", fileMB);
         //         NSLog(@"---%ld",(unsigned long)[representation size]);
         [WLUploadManager sharedInstance].delegate = self;
         [[WLUploadManager sharedInstance] upload:asset];
         
         
     }
              failureBlock:^(NSError *error)
     {
     }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


//取消后调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    MLCompatibleAlert *alert = [[MLCompatibleAlert alloc]
                                initWithPreferredStyle: MLAlertStyleActionSheet //MLAlertStyleAlert
                                title:nil
                                message:nil
                                delegate: self
                                cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                otherButtonTitles:@"打开相机",@"从手机相册获得",nil];
    [alert showAlertWithParent:self];
    
}

@end
