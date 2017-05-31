//
//  CardView.m
//  XiaoYing
//
//  Created by GZH on 16/8/19.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "CardView.h"
#import "CompanyDetailVC.h"
#import "MBProgressHUD.h"
#import "PopViewVC.h"
@interface CardView ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imageviewPicture;
@property (nonatomic, strong)UITapGestureRecognizer *tap1;
@property (nonatomic, strong) UIButton *DeleteBt;
@property (nonatomic, strong) UIImageView *imageviewAdd;
@property (nonatomic, strong) NSMutableArray *arrButton;

@end

@implementation CardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initData];
        [self setPhotoAction];
        

    }
    return self;
}


-(void) initData{
    _backView = [[UIView alloc]init];
    _arrImageview = [[NSMutableArray alloc] init];
    _arrButton = [[NSMutableArray alloc] init];
    _imageviewPicture = [[UIImageView alloc]init];
    _cardIDArray = [NSMutableArray array];
  
}

- (void)setPhotoAction {
    _backView.frame = CGRectMake(0, 0, kScreen_Width, 100);
    NSInteger x = _arrImageview.count;
    _imageviewPicture.frame = CGRectMake(12 + (x % 3) * 12 + ((kScreen_Width - 48) / 3) *  (x % 3) , 12 + (x / 3) * 12 + (x / 3) * 76, (kScreen_Width - 48) / 3, 76);
    _imageviewPicture.image = [UIImage imageNamed:@"addpicture"];
    _imageviewPicture.userInteractionEnabled = YES;
    if (_arrImageview.count == 5) {
        _imageviewPicture.hidden = YES;
    }

    [_backView addSubview:_imageviewPicture];

    _tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    [_imageviewPicture addGestureRecognizer:_tap1];
    [self addSubview:_backView];
}

//添加图片的手势
-(void)imageTap:(UITapGestureRecognizer *)tap{

    _imageviewAdd = [[UIImageView alloc] initWithFrame:_imageviewPicture.frame];
    _DeleteBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _DeleteBt.frame = CGRectMake(_imageviewPicture.frame.origin.x+_imageviewPicture.frame.size.width-18, _imageviewPicture.frame.origin.y-18, 36, 36);
    [_DeleteBt setImage:[UIImage imageNamed:@"deletepicyure"] forState:UIControlStateNormal];
    _DeleteBt.hidden = YES;
    [_DeleteBt addTarget:self action:@selector(deleteImageviewWay:) forControlEvents:UIControlEventTouchUpInside];
    
    [self picImageAction];
}
-(void)deleteImageviewWay:(UIButton *)bt{
    NSInteger count = _arrButton.count;
    NSInteger m = 0;
    CGRect rect1;
    CGRect rect2;
    for (NSInteger i =0; i<count; i++) {
        if (_arrButton[i] == bt) {
            m = i;
            UIImageView *ima = [_arrImageview objectAtIndex:i];
            rect1 = ima.frame;
            UIButton *bt1 = [_arrButton objectAtIndex:i];
            rect2 = bt1.frame;
            [bt1 removeFromSuperview];
            [ima removeFromSuperview];
            [_arrImageview removeObjectAtIndex:i];
            [_arrButton removeObjectAtIndex:i];
            [_cardIDArray removeObjectAtIndex:i];
            break;
        }
    }
    for (NSInteger i = m; i<_arrButton.count; i++) {
        UIImageView *ima = [_arrImageview objectAtIndex:i];
        CGRect rectNext1 = ima.frame;
        UIButton *bt1 = [_arrButton objectAtIndex:i];
        CGRect rectNext2 = bt1.frame;
        ima.frame = rect1;
        bt1.frame = rect2;
        rect1 = rectNext1;
        rect2 = rectNext2;
    }
    _imageviewPicture.frame = rect1;
    if (self.arrImageview.count < 5) {
        self.imageviewPicture.hidden = NO;
    }
    if (_arrImageview.count == 2) {
        if ([self.delegate respondsToSelector:@selector(refershTableView)]) {
            [self.delegate refershTableView];
        }
    }
}
#pragma mark ----调用相机

- (void)picImageAction {
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
    _hud.labelText = @"上传中...";
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *data = UIImageJPEGRepresentation(image, 0.5f);

    //图片转字符串Base64Str
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic  setValue:encodedImageStr forKey:@"data"];
    [paraDic  setValue:@"Certificates.png" forKey:@"fileName"];
    [paraDic  setValue:@"1" forKey:@"category"];
    [AFNetClient POST_Path:FileUploadURl params:paraDic completed:^(NSData *stringData, id JSONDict) {
        if ([JSONDict[@"Code"] isEqual:@0]) {
     NSLog(@"-------------------------------------------------------%@", JSONDict);
            //在数组里面添加数据
            [_arrImageview addObject:_imageviewAdd];
            [_arrButton addObject:_DeleteBt];
            //给视图上边添加控件
            [_backView addSubview:_imageviewAdd];
            [_backView addSubview:_DeleteBt];
            
            UIImageView *ima = _arrImageview [_arrImageview.count-1];
            ima.image = [UIImage imageWithData:data];
            for (NSInteger i = 0; i < _arrButton.count; i++) {
                UIButton *bt = _arrButton[i];
                bt.hidden = NO;
            }

            
            NSDictionary *Dic = JSONDict[@"Data"];
            NSString *IDstr = Dic[@"ID"];
            [_cardIDArray addObject:IDstr];
            
            
            NSInteger x = _arrImageview.count;
            _imageviewPicture.frame = CGRectMake(12 + (x % 3) * 12 + ((kScreen_Width - 48) / 3) *  (x % 3) , 12 + (x / 3) * 12 + (x / 3) * 76, (kScreen_Width - 48) / 3, 76);
            if (_arrImageview.count == 5) {
                _imageviewPicture.hidden = YES;
            }
            if (_arrImageview.count == 3) {
                _backView.frame = CGRectMake(0, 0, kScreen_Width, 188);
                if ([self.delegate respondsToSelector:@selector(refershTableView)]) {
                    [self.delegate refershTableView];
                }
            }

        }
        [_hud setHidden:YES];
        NSLog(@"----------%@-------------%lu",_cardIDArray, _cardIDArray.count);
    } failed:^(NSError *error) {
        NSLog(@"---------------------->>>>>>%@",error);
        [_hud setHidden:YES];
    }];
    [picker dismissViewControllerAnimated:YES completion:^{

    }];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}




@end
