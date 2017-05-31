//
//  UploadFileVC.m
//  XiaoYing
//
//  Created by ZWL on 17/1/9.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "FileTypeVC.h"
#import "UploadFileVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LocalFileForUpload.h"
#import "ZFSessionModel.h"


@interface FileTypeVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation FileTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(kScreen_Width-40-5, 33, 40, 40);
    [cancelBtn setImage:[UIImage imageNamed:@"guanbi_gray"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreen_Height-85)/2, kScreen_Width, 50+15+20)];
    [self.view addSubview:baseView];
    
    NSArray *imageName = @[@"tupian_blue",@"shipin_yellow",@"wenjian_green"];
    NSArray *titleName = @[@"图片",@"视频",@"文件"];
    CGFloat width = kScreen_Width/3;
    for (int i=0; i<imageName.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width*i, 0, width, 50);
        [btn setImage:[UIImage imageNamed:imageName[i]] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width*i, btn.bottom+15, width, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = titleName[i];
        [baseView addSubview:label];
    }
}

- (void)btnAction:(UIButton *)btn
{
    if (btn.tag == 0) { //点击上传直接进入相册，仅图片
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]){
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            picker.mediaTypes = @[(NSString *)kUTTypeImage];
            [self presentViewController:picker animated:YES completion:nil];

            
        } else {
            NSLog(@"模拟无效,请真机测试");
        }
    }
    if (btn.tag == 1) { //点击上传直接进入相册，仅视频
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]){
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            picker.mediaTypes = @[(NSString *)kUTTypeMovie];
            [self presentViewController:picker animated:YES completion:nil];
            
        } else {
            NSLog(@"模拟无效,请真机测试");
        }
        
    }
    if (btn.tag == 2) { //点击进入本地文件的列表VC
        
        __weak typeof(self)weakSelf = self;

        LocalFileForUpload *localFileVC = [[LocalFileForUpload alloc]init];
        localFileVC.documentIDBlock = ^(ZFSessionModel * localFileModel){
            
            NSLog(@"localFileModel~~%@", localFileModel);
            
            if (localFileModel) {
                //跳转VC
                UploadFileVC *vc = [[UploadFileVC alloc] init];
                vc.localFileModel = localFileModel;
                vc.fileName = localFileModel.fileName;
                vc.fileSize = localFileModel.totalLength;
                
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                [weakSelf presentViewController:nav animated:NO completion:nil];
            }

            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:localFileVC];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
    
}

- (void)cancelAction
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    NSMutableDictionary * dict= [NSMutableDictionary dictionaryWithDictionary:editingInfo];
    [dict setObject:image forKey:@"UIImagePickerControllerEditedImage"];
    [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self cancelAction];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    ALAssetsLibrary *DeviceDataLibrary = [[ALAssetsLibrary alloc] init];
    
    __weak typeof(self)weakSelf = self;
    
    [DeviceDataLibrary assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
    
        //获取图片的等比缩略图
        CGImageRef ratioThum = [asset aspectRatioThumbnail];
        
        //资源图片的详细资源信息
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        
        //资源的类型
        NSString *fileTypeStr = representation.UTI;
        NSLog(@"%@", fileTypeStr);
        
        //文件的名称
        NSString *fileName = [representation filename];
        NSLog(@"%@", fileName);
        
        //文件的大小
        Byte *buffer = (Byte*)malloc((unsigned long)representation.size);
        NSUInteger buffered = [representation getBytes:buffer fromOffset:0.0 length:((unsigned long)representation.size) error:nil];
        NSData *tempData = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        NSInteger fileSize = (unsigned long)tempData.length;
        NSLog(@"%d", fileSize);
        
        //跳转VC
        UploadFileVC *vc = [[UploadFileVC alloc] init];

        //传递选中文件的相关参数
        vc.ratioThum = [UIImage imageWithCGImage:ratioThum];
        vc.fileInfo = info;
        vc.fileName = fileName;
        vc.fileSize = fileSize;
        
        vc.departmentPlaceId = self.departmentPlaceId;
        vc.folderPlaceId = self.folderPlaceId;
        vc.originFolderPath = self.originFolderPath;
 
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [weakSelf presentViewController:nav animated:NO completion:nil];
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
    } failureBlock:^(NSError *error) {
        
        NSLog(@"从相册资源库获取文件失败:%@", error);
    }];
    
}

@end
