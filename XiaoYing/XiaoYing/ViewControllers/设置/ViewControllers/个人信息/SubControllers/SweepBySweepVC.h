//
//  SweepBySweepVC.h
//  XiaoYing
//
//  Created by MengFanBiao on 15/12/30.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZBarReaderController.h"
#import "BaseSettingViewController.h"

@interface SweepBySweepVC :BaseSettingViewController<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZBarReaderDelegate,UIAlertViewDelegate>
//{
//    int num;
//    BOOL upOrdown;
//    NSTimer *timer;
//}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;
@end
