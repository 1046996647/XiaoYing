//
//  ScanOfNewStuVC.h
//  XiaoYing
//
//  Created by GZH on 16/9/28.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "BaseSettingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZBarReaderController.h"



@interface ScanOfNewStuVC : BaseSettingViewController<AVCaptureMetadataOutputObjectsDelegate,UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZBarReaderDelegate,UIAlertViewDelegate>


{
    int num;
    BOOL upOrdown;
    NSTimer *timer;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;

@end
