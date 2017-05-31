//
//  SweepBySweepVC.m
//  XiaoYing
//
//  Created by MengFanBiao on 15/12/30.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "SweepBySweepVC.h"
#import "NOFriendDetailMessageVC.h"
#import "WebViewVC.h"

#define Width kScreen_Width-60

@interface SweepBySweepVC ()
{
    CGRect _oldImgCect;
    NSString *stringValue;
    UIActivityIndicatorView*  activityIndicator;
    BOOL  SOS_ON;
    UIButton * SOSButton;
    AVCaptureDevice *deviceC;
    
}

//扫描框
@property (strong,nonatomic) UIImageView *imageView;



@end

@implementation SweepBySweepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扫一扫";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    
    // 扫描框
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 42, Width, Width)];
    imageView.image = [UIImage imageNamed:@"syis_icon_border"];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    // 扫描线
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, 9)];
    _line.image = [UIImage imageNamed:@"syis_icon_line"];
    [imageView addSubview:_line];
    
    // 动画
    CABasicAnimation *scanAnimation = [CABasicAnimation animation];
    scanAnimation.keyPath =@"transform.translation.y";
    scanAnimation.byValue = @(Width);
    scanAnimation.duration = 1.0;
    scanAnimation.repeatCount = MAXFLOAT;
    scanAnimation.removedOnCompletion = NO;
    [_line.layer addAnimation:scanAnimation forKey:nil];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom+42, kScreen_Width, 16)];
    labIntroudction.textColor=[UIColor colorWithHexString:@"b2b2b2"];
    labIntroudction.textAlignment=NSTextAlignmentCenter;
    labIntroudction.text=@"请将二维码对入取景框，即可自动扫描";
    labIntroudction.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:labIntroudction];
    
    //相册
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoButton setImage:[UIImage  imageNamed:@"syis_icon_Photo_nor"] forState:UIControlStateNormal];
    [photoButton setImage:[UIImage  imageNamed:@"syis_icon_Photo_secect"] forState:UIControlStateSelected];
    photoButton.frame = CGRectMake(0, labIntroudction.bottom+30, kScreen_Width / 2, 50);
    [photoButton addTarget:self action:@selector(pressAlumButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoButton];
    
    //闪关灯
    SOSButton = [UIButton buttonWithType:UIButtonTypeCustom];
    SOSButton.frame = CGRectMake(kScreen_Width / 2, photoButton.top, kScreen_Width / 2, 50);
    [SOSButton  setImage:[UIImage  imageNamed:@"syis_icon_lamp_nor"] forState:UIControlStateNormal];
    SOS_ON=NO;
    [SOSButton addTarget:self action:@selector(turnTorchOn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SOSButton];
    
    
//    UIButton * myQrCodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    myQrCodeButton.frame = CGRectMake(kScreen_Width / 1.28, 480-84, 50, 50);
//    [myQrCodeButton  setBackgroundImage:[UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]  pathForResource:@"syis_icon_QrCode_nor" ofType:@"png"]] forState:UIControlStateNormal];
//    [myQrCodeButton  setBackgroundImage:[UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]  pathForResource:@"syis_icon_QrCode_secect" ofType:@"png"]] forState:UIControlStateHighlighted];
//    [myQrCodeButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:myQrCodeButton];
    
    
    NSArray *titleArr = @[@"相册", @"开灯"];
    for (int  i=0; i<titleArr.count; i++)
    {
        UILabel  *CSLabel=[[UILabel  alloc]initWithFrame:CGRectMake((kScreen_Width / 2)*i, SOSButton.bottom+10, kScreen_Width / 2, 25)];
        CSLabel.textAlignment=NSTextAlignmentCenter;
        CSLabel.textColor=[UIColor  whiteColor];
        CSLabel.text = titleArr[i];
        CSLabel.backgroundColor=[UIColor  clearColor];
        CSLabel.font=[UIFont  boldSystemFontOfSize:14];
        [self.view  addSubview:CSLabel];
    }
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self setupCamera];
    }
    else
    {
        NSLog(@"模拟器不支持相机，请在真机上测试");
        
    }


}
-(void)setupCamera{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    //    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    [_output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = CGRectMake(0,0,kScreen_Width,kScreen_Height);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    //中间透明
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0, _preview.bounds.size.width, _preview.bounds.size.height)cornerRadius:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:self.imageView.frame cornerRadius:0];
    
    //    CGRectMake((kScreen_Width-Width)/2,42,Width,Width)
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    // 设置监测区域
    CGFloat x = ((kScreen_Width -Width)/2) / kScreen_Width;
    CGFloat y = 42 / self.view.frame.size.height;
    CGFloat w = Width / self.view.frame.size.width;
    CGFloat h = Width / self.view.frame.size.height;
    self.output.rectOfInterest = CGRectMake(y, x, h, w);
    
    
    // 设置透明
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule =kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity =0.5;
    [_preview addSublayer:fillLayer];
    
    // Start
    [_session startRunning];

}

#pragma mark -
#pragma mark 扫描二维码回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    if (results != nil)
    {
        // 是扫描进入的情况
        ZBarSymbol *symbol = nil;
        for(symbol in results)
            break;
        
        [self dismissViewControllerAnimated:YES completion:^{
            //    状态栏颜色
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }];
        stringValue = [NSString stringWithString:symbol.data];
        
    }
    else
    {
        // 选择图片的情况
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self dismissViewControllerAnimated:YES completion:^{
            //    状态栏颜色
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }];
        
        ZBarReaderController* read = [ZBarReaderController new];
        read.readerDelegate = self;
        CGImageRef cgImageRef = image.CGImage;
        
        ZBarSymbol* symbol = nil;
        for(symbol in [read scanImage:cgImageRef]) break;
        stringValue = symbol.data;
        NSLog(@"选择图片的情况扫描结果：%@",stringValue);
        
    }
    
    [self  QrCodeValueRead];//扫描结果处理
     
}

-(void)QrCodeValueRead
{
    //小赢二维码的标记
//    NSString *str = @"xiaoying:";
//    stringValue = [str stringByAppendingString:stringValue];
    
    if (stringValue.length==0||stringValue==nil||stringValue==NULL||[stringValue isKindOfClass:[NSNull class]])
    {
        [self  alertControllerShow];
    }
    else if([stringValue  hasPrefix:@"http"]||[stringValue  hasPrefix:@"www."])
    {
        //[self  playSound];
        [self  loadWebScanView];
        
        // 实际上是识别的了的，因为不作处理所以这么提示
//        [MBProgressHUD showMessage:@"未识别的二维码" toView:self.view];
    }
    else if ([[stringValue objectFromJSONString] isKindOfClass:[NSDictionary class]])
    {
//        [self  playSound];
        NSDictionary *dic = [stringValue objectFromJSONString];
//        NSString *jsonStr = dic[@"XiaoYingCode"];
        
        if ([[[dic allKeys] firstObject] isEqualToString:@"XiaoYingCode"]) {
            stringValue = dic[@"XiaoYingCode"];
            [self initAddFriendUI];

        }
        else {
            stringValue = dic[@"XiaoYingCode"];
            
        }
        
    }
    else {
        [self  loadTextView];
//        [self initAddFriendUI];
    }
}
//添加www类型的网页
-(void)loadWebScanView {
    WebViewVC *vc = [[WebViewVC alloc] init];
    vc.strValue = stringValue;
    [self.navigationController pushViewController:vc animated:YES];
}
//在图片中未发现二维码的时候调用这个函数
-(void)alertControllerShow{
    [MBProgressHUD showError:@"未在图片中发现二维码" toView:self.view];
}
//添加对方为好友
-(void)initAddFriendUI
{
    NOFriendDetailMessageVC *vc = [[NOFriendDetailMessageVC alloc] init];
    vc.strValue = stringValue;
    vc.backNum = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
//扫除二维码字符串
- (void)loadTextView{
        UITextView  *textView=[[UITextView  alloc]initWithFrame:CGRectMake(0,0, kScreen_Width, kScreen_Height-64)];
        textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
        textView.editable=NO;
        textView.font = [UIFont fontWithName:@"Arial" size:14.0];
        textView.backgroundColor = [UIColor whiteColor];
    
        textView.text =[NSString  stringWithFormat:@"%@",stringValue];//设置它显示的内容
        textView.scrollEnabled = YES;//是否可以拖动
        [self.view addSubview: textView];//加入到整个页面中
}


// 扫描结果回调
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    NSLog(@"stringValue===>>%@",stringValue);
    
    if ([stringValue canBeConvertedToEncoding:NSShiftJISStringEncoding])
    {
        
        NSString  *cstring=stringValue;
        cstring = [NSString stringWithCString:[cstring cStringUsingEncoding:
                                               NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        if (cstring.length!=0)
        {
            stringValue=cstring;
        }
    }
    
//    if (stringValue.length!=0)
//    {
//        for (UIView  *subview in self.view.subviews)
//        {
//            [subview  removeFromSuperview];
//        }
//       
//    }
    
    [self  QrCodeValueRead];//二维码扫描结果
}


-(void)backAction{
    [_session stopRunning];
    
    [self.navigationController   popViewControllerAnimated:YES];
}
-(void)turnTorchOn{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil)
    {
        deviceC = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([deviceC hasTorch] && [deviceC hasFlash])
        {
            
            [deviceC lockForConfiguration:nil];
            if (SOS_ON==NO)
            {
                [deviceC setTorchMode:AVCaptureTorchModeOn];
                [deviceC setFlashMode:AVCaptureFlashModeOn];
                
//                [SOSButton  setImage:[UIImage  imageNamed:@"syis_icon_lamp_secect"] forState:UIControlStateSelected];

                
                SOS_ON = YES;
            }
            else
            {
                [deviceC setTorchMode:AVCaptureTorchModeOff];
                [deviceC setFlashMode:AVCaptureFlashModeOff];
                [SOSButton  setImage:[UIImage  imageNamed:@"syis_icon_lamp_nor"] forState:UIControlStateNormal];
                SOS_ON = NO;
            }
            [deviceC unlockForConfiguration];
        }
    }

}
-(void)pressAlumButton:(UIButton *)bt{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
            
        }];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
