//
//  NextCardView.m
//  XiaoYing
//
//  Created by ZWL on 16/4/12.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "NextCardView.h"
#import "HeadViewOfWork.h"
#import "PersonalCardMyCell.h"
#import "PersonalCardModel.h"
#import "PopViewVC.h"
@interface NextCardView()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) UISwipeGestureRecognizer *up;
@property (nonatomic,strong) UISwipeGestureRecognizer *down;
@property (nonatomic,strong) UIImageView *cardImageview;//正面图片
@property (nonatomic,strong) UIImageView *cardImageview1;//反面图片

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *view1;
@property (nonatomic,strong) UIView *view2;

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) HeadViewOfWork *headView;

@end



@implementation NextCardView


-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initTableView];
        [self GetDetailofPersonalCardAction];
        
    }
    return self;
}


- (void)GetDetailofPersonalCardAction {
    _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
//    _hud.labelText = @"加载中...";
    NSString *companyID = [UserInfo getCompanyId];
    NSString *userID = [UserInfo userID];
    NSString *urlStr = [GetDetailofPersonalCard stringByAppendingFormat:@"&CompanyCode=%@&profileid=%@",companyID,userID];
    [AFNetClient GET_Path:urlStr completed:^(NSData *stringData, id JSONDict) {
        [_hud setHidden:YES];
        if ([JSONDict[@"Code"] isEqual:@0]) {
            NSDictionary *dic = JSONDict[@"Data"];
            
            //0分区数据
            _model = [[PersonalCardModel alloc]init];
            [_model setValuesForKeysWithDictionary:dic];
//            NSLog(@"--------00---%@",JSONDict );
            
            //二维码
            NSDictionary *xiaoyinghaoDic = @{@"XiaoYingCode":_model.xiaoYingHao};
            NSString *Xiaoyinghao = [NSString getStringWithDic:xiaoyinghaoDic];
            UIImage *tempImageCodeOfQr = [UIImage getCodeOfQrWithMark:Xiaoyinghao withSize:300];
            _headView.imageCodeOfQr.image = tempImageCodeOfQr;
            
            //区尾  身份证正反面显示
            NSString *cardFrontUrl = [NSString replaceString:_model.cardFrontUrl Withstr1:@"400" str2:@"200" str3:@"c"];
            [_cardImageview sd_setImageWithURL:[NSURL URLWithString:cardFrontUrl] placeholderImage:[UIImage imageNamed:@"zheng"]];
            
            NSString *cardBackUrl = [NSString replaceString:_model.cardBackUrl Withstr1:@"400" str2:@"200" str3:@"c"];
            [_cardImageview1 sd_setImageWithURL:[NSURL URLWithString:cardBackUrl] placeholderImage:[UIImage imageNamed:@"fan"]];

            [_tableView reloadData];
        }
    } failed:^(NSError *error) {
        [_hud setHidden:YES];
    }];
}




- (void)initTableView {
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15 + 10 + 154 + 27)];
    
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];
    upView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [baseView addSubview:upView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, upView.bottom + 10, kScreen_Width, 154)];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    [baseView addSubview:scrollView];
    
    _cardImageview = [[UIImageView alloc] initWithFrame:CGRectMake(34, 0, kScreen_Width - 68, 154)];
    _cardImageview.tag = 100;
    _cardImageview.image = [UIImage imageNamed:@"zheng"];
    _cardImageview.userInteractionEnabled = YES;
    [scrollView addSubview:_cardImageview];
    
    _cardImageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(34 +kScreen_Width*1, 0, _cardImageview.width, _cardImageview.height)];
    _cardImageview1.tag = 101;
    _cardImageview1.image = [UIImage imageNamed:@"fan"];
    _cardImageview1.userInteractionEnabled = YES;
    [scrollView addSubview:_cardImageview1];
    
    scrollView.contentSize = CGSizeMake(kScreen_Width*2, scrollView.height);
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picImageAction:)];
    [_cardImageview addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picImageAction:)];
    [_cardImageview1 addGestureRecognizer:tap2];
    
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width / 2 - 3.5 - 7, scrollView.bottom + 10, 7, 7)];
    _view1.layer.masksToBounds = YES;
    _view1.layer.cornerRadius = _view1.width / 2;
    _view1.backgroundColor = [UIColor colorWithHexString:@"f99740"];
    [baseView addSubview:_view1];
    
    _view2 = [[UIView alloc] initWithFrame:CGRectMake(_view1.right + 7, _view1.top, 7, 7)];
    _view2.layer.masksToBounds = YES;
    _view2.layer.cornerRadius = _view2.width / 2;
    _view2.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [baseView addSubview:_view2];
    

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _headView = [[HeadViewOfWork alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 156)];
    _headView.imageCodeOfQr.hidden = NO;
    _tableView.tableHeaderView = _headView;
    _tableView.tableFooterView = baseView;
    [self addSubview:_tableView];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalCardMyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalCardCell"];
    if (cell== nil) {
        cell = [[PersonalCardMyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonalCardCell"];
    }

    [cell getModel:_model andIndex:indexPath.row];
    return cell;
}

#pragma mark ----调用相机
- (void)picImageAction:(UITapGestureRecognizer *)sender {
    self.imgView = (UIImageView *)sender.view;

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

#pragma mark - UIImagePickerControllerDelegate

//选取后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"上传中...";
    
    NSLog(@"info:%@",info[UIImagePickerControllerOriginalImage]);
    
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(img, 0.5f);
    NSString *strBase64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic  setValue:strBase64 forKey:@"data"];
    [paraDic  setValue:@"LOGO.png" forKey:@"fileName"];
    [paraDic  setValue:@"0" forKey:@"category"];
    [AFNetClient POST_Path:FileUploadURl params:paraDic completed:^(NSData *stringData, id JSONDict) {
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        if ([code isEqual:@0]) {
//            NSLog(@"---------------------%@-----%@", JSONDict, JSONDict[@"Data"][@"FormatUrl"]);
            //上传图片成功，返回的图片地址
            NSString *cardUrl = JSONDict[@"Data"][@"FormatUrl"];
            NSString *uploadUrl = nil;
            
            if (self.imgView.tag == 100) {
                uploadUrl = [UploadUrlOfCardFron stringByAppendingFormat:@"&fronturl=%@",cardUrl];
            } else {
                uploadUrl = [UploadUrlOfCardBack stringByAppendingFormat:@"&backurl=%@",cardUrl];
            }

            [self uploadUrlOfCardActtion:uploadUrl andImmage:img];
        }else {
            [_hud setHidden:YES];
        }
    } failed:^(NSError *error) {
        [_hud setHidden:YES];
    }];
//    [app.tabvc showCustomTabbar];
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark -- 上传身份证 --
- (void)uploadUrlOfCardActtion:(NSString *)cardUrl andImmage:(UIImage *)image {
    [AFNetClient POST_Path:cardUrl completed:^(NSData *stringData, id JSONDict) {

         if ([JSONDict[@"Code"] isEqual:@0]) {
             
             if (self.imgView.tag == 100) {
                _cardImageview.image = image;
            }else {
                _cardImageview1.image = image;
            }
         }
        [_hud setHidden:YES];
    } failed:^(NSError *error) {
        [_hud setHidden:YES];
    }];
}

//取消后调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    [app.tabvc showCustomTabbar];
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger x = (NSInteger)scrollView.contentOffset.x/kScreen_Width;
    if (x == 0) {
        _view2.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
        _view1.backgroundColor = [UIColor colorWithHexString:@"f99740"];
    } else {
        _view2.backgroundColor = [UIColor colorWithHexString:@"f99740"];
        _view1.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    }
    
    CGPoint point = _tableView.contentOffset;
    if (point.y < 0) {
        _tableView.contentOffset = CGPointMake(0, 0);
    }
}

@end
