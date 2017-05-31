//
//  TableheadView.m
//  XiaoYing
//
//  Created by GZH on 16/8/18.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "TableheadView.h"
#import "PopViewVC.h"
#import "CreateCompanyVC.h"
@interface TableheadView ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation TableheadView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 110)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreen_Width - 80) / 2, 0, 80, 80)];
    _imageView.image = [UIImage imageNamed:@"LOGO"];
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(picImageAction:)];
    [_imageView addGestureRecognizer:tap];
    
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(12, _imageView.bottom + 6, kScreen_Width - 24, 12)];
    _label.text = @"";
    _label.font = [UIFont systemFontOfSize:12];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;

        [view addSubview:_label];
        [view addSubview:_imageView];
        [self addSubview:view];
    
}

#pragma mark ----调用相机
- (void)picImageAction:(id)sender {
    PopViewVC *popViewVC  = [[PopViewVC alloc] init];
    popViewVC.titleArr = @[@"相册",@"拍照"];
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
            [self.viewController.navigationController presentViewController:pickerController animated:YES completion:nil];
            
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
                [self.viewController.navigationController presentViewController:pickerController animated:YES completion:nil];
            } else {
                
                [self GetCamera];

            }
        }
    };
    popViewVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    popViewVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //  self.definesPresentationContext = YES; //不盖住整个屏幕
    popViewVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.viewController.navigationController presentViewController:popViewVC animated:YES completion:nil];
}



-(void)GetCamera{
    //调用相机的相关功能
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"打开摄像头失败" message:@"没有检测到摄像头" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* OpenPhotoAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action){
    }];
 
    [alertController addAction:OpenPhotoAction];
    [self.viewController.navigationController presentViewController:alertController animated:YES completion:^{
        
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _hud = [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
//    _hud.labelText = @"加载中...";
    
    UIImage *tempImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.5f);
    NSString *strBase64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic  setValue:strBase64 forKey:@"data"];
    [paraDic  setValue:@"LOGO.png" forKey:@"fileName"];
    [paraDic  setValue:@"0" forKey:@"category"];
    [AFNetClient POST_Path:FileUploadURl params:paraDic completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];  
        if ([code isEqual:@0]) {
            NSDictionary *Dic = [JSONDict objectForKey:@"Data"];
            _imageView.image = tempImage;
            _logoURL = [Dic objectForKey:@"FormatUrl"];
            NSLog(@"-_______________%@",JSONDict );
        }
        [_hud setHidden:YES];
    } failed:^(NSError *error) {
        [_hud setHidden:YES];
        NSLog(@"---------------------->>>>>>%@",error);
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}









@end
