//
//  ScanOfNewStuVC.m
//  XiaoYing
//
//  Created by GZH on 16/9/28.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "ScanOfNewStuVC.h"
#import "ZBarReaderController.h"
#import "DetailDataVC.h"

@interface ScanOfNewStuVC ()
{
    CGRect _oldImgCect;
    NSString *stringValue;
    UIActivityIndicatorView*  activityIndicator;
    BOOL  SOS_ON;
    UIButton * SOSButton;
    AVCaptureDevice *deviceC;
}
@end

@implementation ScanOfNewStuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫一扫";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self setupCamera];
        [self  QRCodeUILineAndTimer];
    }else {
        NSLog(@"模拟器不支持相机，请在真机上测试");
    }
    
    [self initUI];
    

    
}


- (void)initUI {
    //相册
    UIButton * photoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [photoButton setImage:[UIImage imageNamed:@"syis_icon_Photo_nor"] forState:UIControlStateDisabled];
    [photoButton setImage:[UIImage imageNamed:@"syis_icon_Photo_secect"] forState:UIControlStateSelected];
    photoButton.frame = CGRectMake((kScreen_Width - 160)/3, 480-84, 50, 50);
    [photoButton addTarget:self action:@selector(pressAlumButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoButton];
//    photoButton.backgroundColor = [UIColor cyanColor];
    
    //    闪关灯
    SOSButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    SOSButton.frame = CGRectMake((kScreen_Width - 160)/3 * 2 + 80, 480-84, 50, 50);
    [SOSButton setImage:[UIImage imageNamed:@"syis_icon_lamp_nor"] forState:UIControlStateDisabled];
    [SOSButton setImage:[UIImage imageNamed:@"syis_icon_lamp_secect"] forState:UIControlStateSelected];
    SOS_ON=NO;
    [SOSButton addTarget:self action:@selector(turnTorchOn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SOSButton];
//    SOSButton.backgroundColor = [UIColor cyanColor];
    
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(18, 400-74, kScreen_Width / 1.11, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor colorWithHexString:@"b2b2b2"];
    labIntroudction.textAlignment=NSTextAlignmentCenter;
    labIntroudction.text=@"请将二维码对入取景框，即可自动扫描";
    labIntroudction.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:labIntroudction];
    
    //扫描框
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreen_Width-260)/2, 106-64, 260, 260 )];
    imageView.image = [UIImage imageNamed:@"syis_icon_border"];
    [self.view addSubview:imageView];
    
    for (int  i=0; i<2; i++)
    {
        UILabel  *CSLabel=[[UILabel  alloc]initWithFrame:CGRectMake((kScreen_Width - 160)/3 + ((kScreen_Width - 160)/3 + 80) * i, 480-30, 50, 25)];
        CSLabel.textAlignment=NSTextAlignmentCenter;
        
        //白色
        CSLabel.textColor=[UIColor  whiteColor];
        CSLabel.backgroundColor=[UIColor  clearColor];
        CSLabel.font=[UIFont  boldSystemFontOfSize:14];
        if (i==0) {
            CSLabel.text = @"相册";
        }else {
            CSLabel.text = @"开灯";
        }
            [self.view  addSubview:CSLabel];
    }
}


-(void)pressAlumButton:(UIButton *)bt{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self dismissViewControllerAnimated:NO completion:^{
            
            
        }];
        [self presentViewController:imagePicker animated:YES completion:^{
            
            
        }];
    }
    
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
                
                [SOSButton  setBackgroundImage:[UIImage  imageNamed:@"syis_icon_lamp_secect"] forState:UIControlStateNormal];
                
                SOS_ON = YES;
            }
            else
            {
                [deviceC setTorchMode:AVCaptureTorchModeOff];
                [deviceC setFlashMode:AVCaptureFlashModeOff];
                [SOSButton  setBackgroundImage:[UIImage  imageNamed:@"syis_icon_lamp_nor"] forState:UIControlStateNormal];
                SOS_ON = NO;
            }
            [deviceC unlockForConfiguration];
        }
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
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((kScreen_Width-260)/2,106-64,260,260)cornerRadius:0];
    
    //    CGRectMake((kScreen_Width-260)/2,106-64,260,260)
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    // 设置监测区域
    CGFloat x = ((kScreen_Width -260)/2) / kScreen_Width;
    CGFloat y = 42 / self.view.frame.size.height;
    CGFloat w = 260 / self.view.frame.size.width;
    CGFloat h = 260 / self.view.frame.size.height;
    self.output.rectOfInterest = CGRectMake(y, x, h, w);
    
    
    //    设置透明
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule =kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity =0.5;
    [_preview addSublayer:fillLayer];
    
    // Start
    [_session startRunning];
}

-(void)QRCodeUILineAndTimer{
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width-260)/2, 110-64, 220, 9)];
    
    _line.image = [UIImage imageNamed:@"syis_icon_line"];
    [self.view addSubview:_line];
    timer = [NSTimer scheduledTimerWithTimeInterval:.02f target:self selector:@selector(animationLine) userInfo:nil repeats:YES];
}

-(void)animationLine {
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake((kScreen_Width-270)/2, 110-64+2*num, 270, 9);
        if (2*num == 230) {
            upOrdown = YES;
        }
    }else {
        num --;
        _line.frame = CGRectMake((kScreen_Width-270)/2, 110-44+2*num, 270, 9);
        if (num == 0)
        {
            upOrdown = NO;
        }
    }
}

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
    }
    else if ([stringValue hasPrefix:@"xiaoying:"])
    {
        //        [self  playSound];
        
        [self initAddFriendUI];
        
    }else{
        [self initAddFriendUI];
        // [self  loadTextView];
    }
}
//添加www类型的网页
-(void)loadWebScanView{
    for (UIView  *subview in self.view.subviews)
    {
        [subview  removeFromSuperview];
        
    }
    
    for (CALayer  *sublay in self.view.layer.sublayers)
    {
        [sublay removeFromSuperlayer];
        
    }
    UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64)];
    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    webView.delegate=self;
    webView.backgroundColor=[UIColor  clearColor];
    //    webView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
    NSURL* url;
    if ([stringValue  hasPrefix:@"www."] )
    {
        url = [NSURL URLWithString:[NSString  stringWithFormat:@"https://%@",stringValue]];//创建URL
    }
    else
    {
        url = [NSURL URLWithString:stringValue];//创建URL
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [webView loadRequest:request];//加载
    
    [self.view  addSubview:webView];
}
//在图片中未发现二维码的时候调用这个函数
-(void)alertControllerShow{
    [MBProgressHUD showMessage:@"未在图片中发现二维码" toView:self.view];
}
//添加对方为好友
-(void)initAddFriendUI {
    [self.navigationController pushViewController:[[DetailDataVC alloc]init] animated:YES];
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
//通过扫描二维码添加好友
- (void)addway{
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    [paramDic  setValue:stringValue forKey:@"code"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [AFNetClient POST_Path:FriendAddByCode params:paramDic completed:^(NSData *stringData, id JSONDict) {
            
            NSLog(@"%@",JSONDict);
            
        } failed:^(NSError *error) {
        }];
    });
    
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    [timer invalidate];
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
    
    if (stringValue.length!=0)
    {
        for (UIView  *subview in self.view.subviews)
        {
            [subview  removeFromSuperview];
        }
        
    }
    
    [self  QrCodeValueRead];//二维码扫描结果
}


-(void)backAction{
    [timer invalidate];
    [_session stopRunning];
    
    [self.navigationController   popViewControllerAnimated:YES];
}



@end
