//
//  ImageCollectionView.m
//  XiaoYing
//
//  Created by ZWL on 16/5/26.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "ImageCollectionView.h"
#import "ImageAddCell.h"
#import "ImageCollectionViewCell.h"
#import <AssetsLibrary/ALAsset.h>
#import "XMNPhotoPickerFramework.h"
//#import "ImageBrowseVC.h"
#import "PopViewVC.h"
@interface ImageCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UICollectionViewDelegateFlowLayout>
{
    CGFloat _width;
    MBProgressHUD *_hud;
    NSInteger _urlCount;//从企业信息传过来的url数组的元素个数
    NSMutableArray *_fullUrlArray;//Url数组
}

@property (nonatomic, copy) NSArray<XMNAssetModel *> *assets;

@end

@implementation ImageCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.itemsSectionPictureArray = [[NSMutableArray alloc] init];
        
        //初始化存放图片ID的数组
        self.itemsPictureIDArray = [[NSMutableArray alloc]init];
        
        _fullUrlArray = [NSMutableArray array];
        
        self.contentInset = UIEdgeInsetsMake(0, 12, 0, 12);
        [self registerClass:[ImageCollectionViewCell class]forCellWithReuseIdentifier:@"cell"];
        [self registerClass:[ImageAddCell class] forCellWithReuseIdentifier:@"addItemCell"];
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        _uploadCount = 0;
        
        //是否是从企业信息那里跳过来的
        if (self.isCompany == YES) {
             _width = (kScreen_Width-4*12)/3.0;
        }else{
             _width = (kScreen_Width-4*10)/3.0;
        }
       
        
    }
    return self;
}

-(void)setImageUrlArray:(NSArray *)imageUrlArray{
    _imageUrlArray = imageUrlArray;
    _urlCount = imageUrlArray.count;
    [_fullUrlArray addObjectsFromArray:imageUrlArray];
    [self.itemsSectionPictureArray addObjectsFromArray:_imageUrlArray];
}

-(void)setImageIDArray:(NSArray *)imageIDArray{
    _imageIDArray = imageIDArray;
    [self.itemsPictureIDArray addObjectsFromArray:imageIDArray];
}

#pragma mark - collectionView 调用方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    //        for (NSString *picID in self.itemsPictureIDArray) {
    //            NSLog(@"picID:%@",picID);
    //        }
    _model.imagesArr = self.itemsSectionPictureArray;
    if (self.isCompany == YES) {
        if (self.isEditing == YES || self.imageUrlArray.count == 0) {
            if (self.itemsSectionPictureArray.count == 5) {
                return self.itemsSectionPictureArray.count ;
            }else{
                return self.itemsSectionPictureArray.count + 1;
            }
        }else{
            return self.itemsSectionPictureArray.count ;
        }
    }else{
        if (self.itemsSectionPictureArray.count == 9) {
            return self.itemsSectionPictureArray.count;
        }else{
             return self.itemsSectionPictureArray.count + 1;
        }
       
    }

    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.itemsSectionPictureArray.count) {
        static NSString *addItem = @"addItemCell";
        
        ImageAddCell *addItemCell = [collectionView dequeueReusableCellWithReuseIdentifier:addItem forIndexPath:indexPath];
        if (self.isCompany == YES) {
            addItemCell.isCompany = YES;
        }
        
        return addItemCell;
    }else
    {
        static NSString *identify = @"cell";
        ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        cell.index = indexPath.row;
        
        //如果选择隐藏删除按钮
        if (self.deleteButtonHidden == YES) {
            cell.deleteButtonHidden = YES;
        }
        
        //判断是否是从企业信息那边过来的
        if (self.isCompany == YES) {
            if (self.isEditing != YES) {
                cell.deleteButton.hidden = YES;
                if (self.count == 10) {//如果点击了保存之后
                    NSString *url = _fullUrlArray[indexPath.row];
                   // NSLog(@"fullUrl:%@",_fullUrlArray);
                    NSString *imageUrl = [NSString replaceString:url Withstr1:@"1000" str2:@"1000" str3:@"c"];
                    //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_img"]];
                    return  cell;
                }
            }else{
                cell.deleteButton.hidden = NO;
            }
            cell.isCompany = YES;
            if (indexPath.row < _urlCount) {
                NSString *url = self.itemsSectionPictureArray[indexPath.row];
                NSString *imageUrl = [NSString replaceString:url Withstr1:@"1000" str2:@"1000" str3:@"c"];
                //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_img"]];
            }else{
                 cell.imageView.image = self.itemsSectionPictureArray[indexPath.row];
            }
            cell.deleteCompanyBlock = ^(NSInteger index){
                if (index < _urlCount) {
                    _urlCount --;
                }
                [self.itemsSectionPictureArray removeObjectAtIndex:index];
                [self.itemsPictureIDArray removeObjectAtIndex:index];
                [_fullUrlArray removeObjectAtIndex:index];
                [self reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadHeightForSelf];
                });
            };
        }else{
            cell.imageView.image = self.itemsSectionPictureArray[indexPath.row];
            if (self.itemsPictureIDArray.count >= indexPath.row + 1) {
                cell.pictureID = self.itemsPictureIDArray[indexPath.row];
            }
            // cell.pictureID = self.itemsPictureIDArray[indexPath.row];
            cell.deleteBlock = ^(UIImage *image,NSString *pictureID){
                [self.itemsSectionPictureArray removeObject:image];
                [self.itemsPictureIDArray removeObject:pictureID];
                [self reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadHeightForSelf];
                });
            };

        }
        return cell;
    }
}

//用代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isCompany == YES) {
        if (indexPath.row == self.itemsSectionPictureArray.count) {
            if (self.imageUrlArray.count == 0 && self.isEditing != YES) {
                return;
            }
            if (self.itemsSectionPictureArray.count > 4) {
                
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"最多选择 5 张照片！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alertView show];
                
                return;
            }
            //调用相册相机
            PopViewVC *popViewVC  = [[PopViewVC alloc] init];
            popViewVC.titleArr = @[@"相册",@"拍照"];
            popViewVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            //淡出淡入
            popViewVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            //  self.definesPresentationContext = YES; //不盖住整个屏幕
            popViewVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
            [self.viewController presentViewController:popViewVC animated:YES completion:nil];
            popViewVC.clickBlock = ^(NSInteger indexRow) {
                if (indexRow == 0) {
                    
                    NSLog(@"点击了从手机选择");
                    
                    XMNPhotoPickerController *photoPickerC = nil;
                    //1.初始化一个XMNPhotoPickerController
                    if (self.isCompany == YES) {
                        photoPickerC = [[XMNPhotoPickerController alloc] initWithMaxCount:5 andPreviousCount:self.itemsSectionPictureArray.count delegate:nil];
                    }else{
                        photoPickerC = [[XMNPhotoPickerController alloc] initWithMaxCount:9 andPreviousCount:self.itemsSectionPictureArray.count delegate:nil];
                    }
                    photoPickerC.pickingVideoEnable = NO;
                    photoPickerC.previousCount = self.itemsSectionPictureArray.count;
               
                    //3.取消注释下面代码,使用代理方式回调,代理方法参考XMNPhotoPickerControllerDelegate
                    //    photoPickerC.photoPickerDelegate = self;
                    
                    //3..设置选择完照片的block 回调
                    __weak typeof(*&self) wSelf = self;
                    _uploadCount ++;
                    [photoPickerC setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> *images, NSArray<XMNAssetModel *> *assets) {
                        __weak typeof(*&self) self = wSelf;
                        NSLog(@"picker images :%@ \n\n assets:%@",images,assets);
                        
                        //_midPicIDArray = [NSMutableArray array];
                        
                        
                        /////////////////多图片上传/////////////////
                        NSInteger imageNowCount = 0;
                        NSInteger failImageCount = 0;//上传失败的图片数量
                        
                        [self uploadPictureWithImageNowCount:imageNowCount images:images failImageCount:failImageCount];
                        //
                        
                        //XMNPhotoPickerController 确定选择,并不会自己dismiss掉,需要自己dismiss
                        [self.viewController dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    
                    //5.设置用户取消选择的回调 可选
                    [photoPickerC setDidCancelPickingBlock:^{
                        NSLog(@"photoPickerC did Cancel");
                        //此处不需要自己dismiss
                    }];
                    
                    //6. 显示photoPickerC
                    [self.viewController presentViewController:photoPickerC animated:YES completion:nil];
                    
                } else {
                    NSLog(@"点击了拍照");
                    
                    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                        picker.delegate = self;
                        //设置拍照后的图片可被编辑
                        picker.allowsEditing = YES;
                        picker.sourceType = sourceType;
                        
                        [self.viewController presentViewController:picker animated:YES completion:nil];
                    } else {
                        NSLog(@"模拟无效,请真机测试");
                    }
                }
            };
        }else{
            if (self.isEditing != YES) {
                if (self.count == 10) {
                    ImageBrowseVC *browserVC = [ImageBrowseVC new];
                    NSString *url = _fullUrlArray[indexPath.row];
                    NSString *imageUrl = [NSString replaceString:url Withstr1:@"1000" str2:@"1000" str3:@"c"];
                    browserVC.urlStr = imageUrl;
                    [self.viewController presentViewController:browserVC animated:YES completion:nil];
                }else{
                    ImageBrowseVC *browserVC = [ImageBrowseVC new];
                    NSString *url = self.itemsSectionPictureArray[indexPath.row];
                    NSString *imageUrl = [NSString replaceString:url Withstr1:@"1000" str2:@"1000" str3:@"c"];
                    browserVC.urlStr = imageUrl;
                    [self.viewController presentViewController:browserVC animated:YES completion:nil];
                }
            }
        }
    }else{
            if (indexPath.row == self.itemsSectionPictureArray.count) {
                if (self.itemsSectionPictureArray.count > 8) {
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"最多选择 9 张照片！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    return;
                }
              //调用相册相机
                PopViewVC *popViewVC  = [[PopViewVC alloc] init];
                popViewVC.titleArr = @[@"相册",@"拍照"];
                popViewVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                //淡出淡入
                popViewVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                //  self.definesPresentationContext = YES; //不盖住整个屏幕
                popViewVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
                [self.viewController presentViewController:popViewVC animated:YES completion:nil];
                popViewVC.clickBlock = ^(NSInteger indexRow) {
                    if (indexRow == 0) {
                        
                        NSLog(@"点击了从手机选择");
                        
                        XMNPhotoPickerController *photoPickerC = nil;
                        //1.初始化一个XMNPhotoPickerController
                        if (self.isCompany == YES) {
                            photoPickerC = [[XMNPhotoPickerController alloc] initWithMaxCount:5 andPreviousCount:self.itemsSectionPictureArray.count delegate:nil];
                        }else{
                            photoPickerC = [[XMNPhotoPickerController alloc] initWithMaxCount:9 andPreviousCount:self.itemsSectionPictureArray.count delegate:nil];
                        }
                        photoPickerC.pickingVideoEnable = NO;
//                        photoPickerC.previousCount = self.itemsSectionPictureArray.count;
                        //3.取消注释下面代码,使用代理方式回调,代理方法参考XMNPhotoPickerControllerDelegate
                        //    photoPickerC.photoPickerDelegate = self;
                        
                        //3..设置选择完照片的block 回调
                        __weak typeof(*&self) wSelf = self;
                        _uploadCount ++;
                        [photoPickerC setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> *images, NSArray<XMNAssetModel *> *assets) {
                            __weak typeof(*&self) self = wSelf;
                            NSLog(@"picker images :%@ \n\n assets:%@",images,assets);
                            
                            //_midPicIDArray = [NSMutableArray array];
                            
                            
                            /////////////////多图片上传/////////////////
                            NSInteger imageNowCount = 0;
                            NSInteger failImageCount = 0;//上传失败的图片数量
                            
                            [self uploadPictureWithImageNowCount:imageNowCount images:images failImageCount:failImageCount];
                            //
                            
                            //XMNPhotoPickerController 确定选择,并不会自己dismiss掉,需要自己dismiss
                            [self.viewController dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        
                        //5.设置用户取消选择的回调 可选
                        [photoPickerC setDidCancelPickingBlock:^{
                            NSLog(@"photoPickerC did Cancel");
                            //此处不需要自己dismiss
                        }];
                        
                        //6. 显示photoPickerC
                        [self.viewController presentViewController:photoPickerC animated:YES completion:nil];
                        
                    } else {
                        NSLog(@"点击了拍照");
                        
                                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                                if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
                                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                    picker.delegate = self;
                                    //设置拍照后的图片可被编辑
                                    picker.allowsEditing = YES;
                                    picker.sourceType = sourceType;
                                    
                                    [self.viewController presentViewController:picker animated:YES completion:nil];
                                } else {
                                    NSLog(@"模拟无效,请真机测试");
                                }
                            }
                };
            }else
            {
            }
        }
   }



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    _uploadCount ++;
    [self uploadPictureWithImageNowCount:0 images:@[image] failImageCount:0];
    //image = [self imageCompressForWidth:image targetWidth:100];
    
    //[self.itemsSectionPictureArray addObject:image];
    //__weak ImageCollectionView *wself = self;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
    
}

// 重写setter
- (void)setModel:(LocalTaskModel *)model
{
    _model = model;
    self.itemsSectionPictureArray = model.imagesArr;
    
    // 调整集合视图的高度
    if (self.itemsSectionPictureArray.count <4) {
        self.height = _width ;
    }else if (self.itemsSectionPictureArray.count <8)
    {
        self.height = _width*2+12 ;// 2：图片的行数，12：图片的间距
    }else
    {
        self.height = _width*3+12*2 ;
    }
    
    [self reloadData];
}

//图片旋转和转字符串
-(NSString *)imageOrientationAndBase64Str:(UIImage *) image

{
    NSData *data = [self imageData:image];
    //    UIImage *img = [UIImage imageWithData:data];
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encodedImageStr;
    
}
//压缩图片，任意大小的图片压缩到100K以内
-(NSData *)imageData:(UIImage *)myimage
{
    //处理后的图片
    UIImage *normalizedImage = nil;
    
    //图片方向处理
    if (myimage.imageOrientation == UIImageOrientationUp) {
        normalizedImage = myimage;
    } else {
        UIGraphicsBeginImageContextWithOptions(myimage.size, NO, myimage.scale);
        [myimage drawInRect:(CGRect){0, 0, myimage.size}];
        normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    NSData *data=UIImageJPEGRepresentation(normalizedImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(normalizedImage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(normalizedImage, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(normalizedImage, 0.9);
        }
    }
    return data;
}

// 图片压缩
-(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 重新调整collection的高度 delegateMethods
//按了删除按钮之后，重新调整collection的高度
-(void)reloadHeightForSelf{
    
    if (self.isCompany == YES) {
        if (self.itemsSectionPictureArray.count <3) {
            self.height = _width ;
        }else if (self.itemsSectionPictureArray.count <6)
        {
            self.height = _width*2+12 ;// 2：图片的行数，12：图片的间距
        }else
        {
            self.height = _width*3+12*2 ;
        }
    }else{
        if (self.itemsSectionPictureArray.count <3) {
            self.height = _width ;
        }else if (self.itemsSectionPictureArray.count <6)
        {
            self.height = _width*2+8 ;// 2：图片的行数，12：图片的间距
        }else
        {
            self.height = _width*3+8*2 ;
        }
    }
    NSNumber *count = @(self.itemsSectionPictureArray.count);
    //由于image的数量发生了变化，所以发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageCountChangedNotificationAction" object:count];
}

#pragma mark - 请求网络数据相关的方法 methods
-(void)uploadPictureWithImageNowCount:(NSInteger)ImageNowCount images:(NSArray*)images failImageCount:(NSInteger)failImageCount{
   // NSLog(@"imageCount:%ld",ImageNowCount);
    if (ImageNowCount < images.count) {
        if (ImageNowCount == 0) {
            //初始化HUD
            _hud = [MBProgressHUD showHUDAddedTo:[self viewController].view animated:YES];
            _hud.labelText = @"正在上传图片";
        }
        //根据当前系统时间生成图片名称
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [formatter stringFromDate:date];
        NSString *postPath = [NSString stringWithFormat:@"%@/api/file/FileUpload?Token=%@",BaseUrl1,[UserInfo getToken]];
        NSString *fileName = [NSString stringWithFormat:@"%@%ld.png",dateString,ImageNowCount];
        //图片转字符串Base64Str'
        NSString *imgStr = [self imageOrientationAndBase64Str:images[ImageNowCount]];
        NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
        [paramDic  setValue:imgStr forKey:@"data"];
        [paramDic  setValue:fileName forKey:@"fileName"];
        [paramDic  setValue:@(1) forKey:@"category"];
        
        UIImage *img = images[ImageNowCount];
        //压缩后的图片
        UIImage *imgCompressed = [self imageCompressForWidth:img targetWidth:200];
        
        //**********************上传图片**********************/
        __block NSInteger imageNowCount = ImageNowCount;
        __block NSInteger wFailImageCount = failImageCount;
        //请求网络
        [AFNetClient POST_Path:postPath params:paramDic completed:^(NSData *stringData, id JSONDict) {
            NSString *pictureID = JSONDict[@"Data"][@"ID"];
            NSString *formatUrl = JSONDict[@"Data"][@"FormatUrl"];
            [self.itemsPictureIDArray addObject:pictureID];
            [self.itemsSectionPictureArray addObject:imgCompressed];
       
            [_fullUrlArray addObject:formatUrl];
            imageNowCount ++;
            //重新调用自己
            [self uploadPictureWithImageNowCount:imageNowCount images:images failImageCount:wFailImageCount];
        } failed:^(NSError *error) {
            NSLog(@"请求失败Error--%ld",(long)error.code);
            
            imageNowCount ++;
            wFailImageCount ++;
            //重新调用自己
            [self uploadPictureWithImageNowCount:imageNowCount images:images failImageCount:wFailImageCount];
        }];
    }else{
        [_hud hide:YES];
        if (failImageCount > 0) {
            [MBProgressHUD showMessage:[NSString stringWithFormat:@"有%ld张图片上传失败",failImageCount] toView:[self viewController].view];
        }
        __weak ImageCollectionView *wself = self;
        // 调整集合视图的高度
        if (self.isCompany == YES) {
            if (self.itemsSectionPictureArray.count <3) {
                self.height = _width ;
            }else if (self.itemsSectionPictureArray.count <6)
            {
                self.height = _width*2+12 ;// 2：图片的行数，12：图片的间距
            }else
            {
                self.height = _width*3+12*2 ;
            }
        }else{
            if (self.itemsSectionPictureArray.count <3) {
                self.height = _width ;
            }else if (self.itemsSectionPictureArray.count <6)
            {
                self.height = _width*2+8 ;// 2：图片的行数，12：图片的间距
            }else
            {
                self.height = _width*3+8*2 ;
            }
        }
        NSNumber *count = @(self.itemsSectionPictureArray.count);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageCountNotificationAction" object:count];
        [wself reloadData];
    }
}

@end
