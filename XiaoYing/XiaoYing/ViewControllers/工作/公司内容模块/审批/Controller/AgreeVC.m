
//
//  OpinionVC.m
//  XiaoYing
//
//  Created by ZWL on 16/5/31.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AgreeVC.h"
#import "RecordView.h"
#import <AssetsLibrary/ALAsset.h>
#import "XMNPhotoPickerFramework.h"
#import "ImagePlayerViewController.h"
#import "WangUrlHelp.h"

@interface AgreeVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIView *_baseView;//整体的视图
    UIImageView *_imgView;//图片视图
    UIButton *_maskButton;//图片上面的遮罩
    UILabel *_remindLab;//输入框的placeholder
    UILabel *_textLengthLab;//还剩的字数长度label
    MBProgressHUD *_hud;//菊花
    NSString *_postURL;//同意或者拒绝URL
}

@property (nonatomic,strong) UITextView *tv;

@end

@implementation AgreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.picturesArray = [NSMutableArray array];
    self.pictureIDArray = [NSMutableArray array];
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-(540/2))/2, (kScreen_Height-(806/2))/2, 540/2, 806/2)];
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.layer.cornerRadius = 6;
    _baseView.clipsToBounds = YES;
    [self.view addSubview:_baseView];
    
    //输入框
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, _baseView.width-20, 208)];
    tv.delegate = self;
    tv.tag = 100;
    tv.font = [UIFont systemFontOfSize:14];
//    tv.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
//    tv.layer.borderWidth = .5;
    [_baseView addSubview:tv];
    self.tv = tv;
    
    _remindLab = [[UILabel alloc] initWithFrame:CGRectMake(2, 8, tv.width, 12)];
    _remindLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    _remindLab.text = @"请输入审批意见，限字140个，非必填";
    _remindLab.font = [UIFont systemFontOfSize:14];
    [tv addSubview:_remindLab];
    
    _textLengthLab = [[UILabel alloc]initWithFrame:CGRectMake(_tv.width - 50, _tv.height - 20, 50, 20)];
    _textLengthLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    _textLengthLab.textAlignment = NSTextAlignmentRight;
    _textLengthLab.text = @"140";
    _textLengthLab.font = [UIFont systemFontOfSize:14];
    [tv addSubview:_textLengthLab];
    
    //输入框底部的线
    UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, tv.bottom, _baseView.width, 1)];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [_baseView addSubview:bottomLineView];
    
//    //语音
//    RecordView *recordView = [[RecordView alloc] initWithFrame:CGRectMake(0, tv.bottom, _baseView.width, 44)];
//    recordView.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
//    recordView.layer.borderWidth = .5;
//    [_baseView addSubview:recordView];
    
    //图片展示
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, tv.bottom+10, 130, 130)];
    //_imgView.backgroundColor = [UIColor cyanColor];
    _imgView.image = [UIImage imageNamed:@"default_img"];
    [_baseView addSubview:_imgView];
    
    //图片上面的灰色遮罩
    _maskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _maskButton.frame = CGRectMake(10, tv.bottom+10, 130, 130);
    _maskButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:.5];
    _maskButton.titleLabel.font = [UIFont boldSystemFontOfSize:50];
    [_maskButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_maskButton addTarget:self action:@selector(gotoPhotoBrowser:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:_maskButton];
    
    //同意或拒绝按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, _baseView.height-44, _baseView.width, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    //    btn.layer.cornerRadius = 6;
    //    btn.clipsToBounds = YES;
    [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:self.btnText forState:UIControlStateNormal];
    [_baseView addSubview:btn];
    
    if ([self.btnText isEqualToString:@"同意"]) {
        btn.tag = 200;
        btn.backgroundColor = [UIColor colorWithHexString:@"#02bb00"];
    } else {
        btn.tag = 199;
        btn.backgroundColor = [UIColor colorWithHexString:@"#f94040"];
    }
    
    //拍照按钮
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame = CGRectMake(_imgView.right + 10, btn.top - 10 - 45, 110, 45);
    cameraButton.tag = 99;
    [cameraButton setTitle:@"拍照" forState:UIControlStateNormal];
    [cameraButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    cameraButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cameraButton.layer setBorderWidth:1.0];
    cameraButton.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
    cameraButton.layer.cornerRadius = 6;
    cameraButton.layer.masksToBounds = YES;
    [_baseView addSubview:cameraButton];
    [cameraButton addTarget:self action:@selector(buttonClickedForPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    //相册按钮
    UIButton *photoLibraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoLibraryButton.frame = CGRectMake(_imgView.right + 10, cameraButton.top - 10 - 45, 110, 45);
    photoLibraryButton.tag = 98;
    [photoLibraryButton setTitle:@"相册" forState:UIControlStateNormal];
    [photoLibraryButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    photoLibraryButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [photoLibraryButton.layer setBorderWidth:1.0];
    photoLibraryButton.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
    photoLibraryButton.layer.cornerRadius = 6;
    photoLibraryButton.layer.masksToBounds = YES;
    [_baseView addSubview:photoLibraryButton];
    [photoLibraryButton addTarget:self action:@selector(buttonClickedForPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加图片的文字label
    UILabel *addPhotoLabel = [[UILabel alloc]initWithFrame:CGRectMake(photoLibraryButton.left + 29, photoLibraryButton.top - 8 -21, 52, 21)];
    addPhotoLabel.text = @"添加图片";
    addPhotoLabel.textColor = [UIColor colorWithHexString:@"#f99740"];
    addPhotoLabel.font = [UIFont boldSystemFontOfSize:12];
    [_baseView addSubview:addPhotoLabel];
    
//    //添加图片按钮
//    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cameraBtn.frame = CGRectMake(_imgView.right+12, _imgView.top, 50, _imgView.height);
//    [cameraBtn setTitle:@"添\n加\n照\n片" forState:UIControlStateNormal];
//    cameraBtn.titleLabel.numberOfLines = 0;
//    [cameraBtn setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
//    cameraBtn.layer.masksToBounds = YES;
//    cameraBtn.layer.cornerRadius = 6;
//    //边框宽度
//    [cameraBtn.layer setBorderWidth:1.0];
//    cameraBtn.layer.borderColor = [UIColor colorWithHexString:@"#d5d7dc"].CGColor;
//    [cameraBtn addTarget:self action:@selector(allBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_baseView addSubview:cameraBtn];

    

    
}

#pragma mark - 当用户点击了相册或者拍照按钮后的方法 methods
-(void)buttonClickedForPhoto:(UIButton *)button{
    if (button.tag == 98) {//点击了相册按钮
        NSLog(@"点击了相册按钮选择");
        
        //1.初始化一个XMNPhotoPickerController
        XMNPhotoPickerController *photoPickerC = [[XMNPhotoPickerController alloc] initWithMaxCount:9 andPreviousCount:self.picturesArray.count delegate:nil];
        photoPickerC.pickingVideoEnable = NO;
        photoPickerC.previousCount = self.picturesArray.count;
        //3.取消注释下面代码,使用代理方式回调,代理方法参考XMNPhotoPickerControllerDelegate
        //    photoPickerC.photoPickerDelegate = self;
        
        //3..设置选择完照片的block 回调
        __weak typeof(*&self) wSelf = self;
        [photoPickerC setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> *images, NSArray<XMNAssetModel *> *assets) {
            __weak typeof(*&self) self = wSelf;
            NSLog(@"picker images :%@ \n\n assets:%@",images,assets);
            
            //_midPicIDArray = [NSMutableArray array];
           // [self.picturesArray addObjectsFromArray:images];
//            _imgView.image = self.picturesArray.lastObject;
//            [_maskButton setTitle:[NSString stringWithFormat:@"%ld",self.picturesArray.count] forState:UIControlStateNormal];
            /////////////////多图片上传/////////////////
            NSInteger imageNowCount = 0;
            NSInteger failImageCount = 0;//上传失败的图片数量
            [self uploadPictureWithImageNowCount:imageNowCount images:images failImageCount:failImageCount];
            //XMNPhotoPickerController 确定选择,并不会自己dismiss掉,需要自己dismiss
            [[wSelf activityViewController]dismissViewControllerAnimated:YES completion:nil];
        }];
        
        
        //5.设置用户取消选择的回调 可选
        [photoPickerC setDidCancelPickingBlock:^{
            NSLog(@"photoPickerC did Cancel");
            //此处不需要自己dismiss
        }];
        
        //6. 显示photoPickerC
        [self presentViewController:photoPickerC animated:YES completion:nil];
    }
    
    if (button.tag == 99) {//点击了拍照按钮
        NSLog(@"点击了拍照");
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            //picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            
            [self presentViewController:picker animated:YES completion:nil];
        }else {
            NSLog(@"模拟无效,请真机测试");
        }
    }

}

//#pragma mark - MLCompatibleAlertDelegate
//- (void)compatibleAlert:(MLCompatibleAlert *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        NSLog(@"打开摄像头");
//        // 判断当前设备是否有摄像头
//        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
//            
//            // 创建相册控制器
//            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
//            // 设置类型
//            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//            // 设置代理对象
//            pickerController.delegate = self;
//            pickerController.allowsEditing=YES;
//            // 跳转到相册页面
//            [self presentViewController:pickerController animated:YES completion:nil];
//        } else {
//            
//            
//            MLCompatibleAlert *alert = [[MLCompatibleAlert alloc]
//                                        initWithPreferredStyle: MLAlertStyleAlert //MLAlertStyleActionSheet
//                                        title:@"打开摄像头失败"
//                                        message:@"没有检测到摄像头"
//                                        delegate:nil
//                                        cancelButtonTitle:@"OK"
//                                        destructiveButtonTitle:nil
//                                        otherButtonTitles:nil,nil];
//            
//            [alert showAlertWithParent:self];
//            
//        }
//        
//        
//    } else if (buttonIndex == 1) {
//        
//        // 创建相册控制器
//        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
//        // 设置类型
//        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        // 设置为静态图像类型
//        pickerController.mediaTypes = @[@"public.image"];
//        // 设置代理对象
//        pickerController.delegate = self;
//        // 设置选择后的图片可以被编辑
//        pickerController.allowsEditing=YES;
//        
//        // 跳转到相册页面
//        [self presentViewController:pickerController animated:YES completion:nil];
//        
//        
//    }
//}

#pragma mark - 进入图片浏览方法 methods
-(void)gotoPhotoBrowser:(UIButton*)button{
    ImagePlayerViewController *vc = [ImagePlayerViewController new];
    vc.imageArray = self.picturesArray;
    vc.imageIDArray = self.pictureIDArray;
    vc.isApproal = YES;
    if (self.picturesArray.count > 0) {
        vc.backBlock = ^(NSMutableArray *imageArray,NSMutableArray *imageIDArray){
            self.picturesArray = imageArray;
            self.pictureIDArray = imageIDArray;
              _imgView.image = self.picturesArray.lastObject;
              [_maskButton setTitle:[NSString stringWithFormat:@"%ld",self.picturesArray.count] forState:UIControlStateNormal];
//            for (UIImage *ima in self.picturesArray) {
//                NSLog(@"hello:%@",ima);
//            }
//            for (NSString *ID in self.pictureIDArray) {
//                NSLog(@"helloID:%@",ID);
//            }
            if (self.picturesArray.count == 0) {
                _imgView.image = [UIImage imageNamed:@"default_img"];
                [_maskButton setTitle:@"" forState:UIControlStateNormal];
            }
        };
        [self presentViewController:vc animated:YES completion:nil];
    }
    //[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

//选取后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"info:%@",info[UIImagePickerControllerOriginalImage]);
    
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    [self uploadPictureWithImageNowCount:0 images:@[img] failImageCount:0];
    [[self activityViewController] dismissViewControllerAnimated:YES completion:nil];
    
}

//取消后调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [app.tabvc showCustomTabbar];
    [[self activityViewController] dismissViewControllerAnimated:YES completion:nil];
    
}

//- (void)btnAction:(UIButton *)btn
//{
//    [self dismissViewControllerAnimated:NO completion:nil];
//
//}

//点击了同意或者拒绝按钮之后
-(void)buttonClicked:(UIButton *)button{
    if (button.tag == 200) {//点击了同意按钮
        //self.agreeOrRefuseBlock();
        [self agree];
        //[self dismissViewControllerAnimated:YES completion:nil];
    }else{//点击了拒绝按钮
        [self refuse];
    }
    //[self dismissViewControllerAnimated:NO completion:nil];
    //self.agreeOrRefuseBlock();
    //[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.tv.tag = 101;
    //_remindLab.hidden = YES;
    return YES;
}

//-(void)textViewDidChange:(UITextView *)textView{
//    if (textView.text.length == 0) {
//        _remindLab.hidden = NO;
//    }else{
//        _remindLab.hidden = YES;
//    }
//    
//    NSInteger count = 280 - textView.text.length;
//    [_textLengthLab setText:[NSString stringWithFormat:@"%ld",count]];
//}

#define MAX_LIMIT_NUMS 140
////输入到一定字数,不能编辑
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if(range.location > 280 - 1 && text.length > range.length){
//        
//        return NO;
//    }
//    return YES;
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            _textLengthLab.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        _remindLab.hidden = YES;
    }else{
        _remindLab.hidden = NO;
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    _textLengthLab.text = [NSString stringWithFormat:@"%ld",MAX(0,MAX_LIMIT_NUMS - existTextNum)];
}











- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.tv.tag == 101) {
        [self.tv resignFirstResponder];
        self.tv.tag = 100;
        return;
    }
    
    if ([touches anyObject].view == self.view) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 获取当前处于activity状态的view controller
- (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}

#pragma mark - 请求网络数据相关的方法 methods
-(void)uploadPictureWithImageNowCount:(NSInteger)ImageNowCount images:(NSArray*)images failImageCount:(NSInteger)failImageCount{
    // NSLog(@"imageCount:%ld",ImageNowCount);
    if (ImageNowCount < images.count) {
        if (ImageNowCount == 0) {
            //初始化HUD
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"正在上传图片";
        }
        //根据当前系统时间生成图片名称
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [formatter stringFromDate:date];
        NSString *postPath = [NSString stringWithFormat:@"%@/api/file/FileUpload?Token=%@",BaseUrl1,[UserInfo getToken]];
        NSString *fileName = [NSString stringWithFormat:@"%@%ld.png",dateString,(long)ImageNowCount];
        //图片转字符串Base64Str
        NSString *imgStr = [self imageOrientationAndBase64Str:images[ImageNowCount]];
        NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
        [paramDic  setValue:imgStr forKey:@"data"];
        [paramDic  setValue:fileName forKey:@"fileName"];
        [paramDic  setValue:@(1) forKey:@"category"];
        
        UIImage *img = images[ImageNowCount];
        
        //**********************上传图片**********************/
        __block NSInteger imageNowCount = ImageNowCount;
        __block NSInteger wFailImageCount = failImageCount;
        //请求网络
        [AFNetClient POST_Path:postPath params:paramDic completed:^(NSData *stringData, id JSONDict) {
            NSString *pictureID = JSONDict[@"Data"][@"ID"];
            NSLog(@"pictureID:%@",pictureID);
            [self.pictureIDArray addObject:pictureID];
            [self.picturesArray addObject:img];
//            _imgView.image = self.picturesArray.lastObject;
//            [_maskButton setTitle:[NSString stringWithFormat:@"%ld",self.picturesArray.count] forState:UIControlStateNormal];
            imageNowCount ++;
            //重新调用自己
            [self uploadPictureWithImageNowCount:imageNowCount images:images failImageCount:wFailImageCount];
        } failed:^(NSError *error) {
            NSLog(@"请求失败Error--%ld",(long)error.code);
//            _imgView.image = self.picturesArray.lastObject;
//            [_maskButton setTitle:[NSString stringWithFormat:@"%ld",self.picturesArray.count] forState:UIControlStateNormal];
            imageNowCount ++;
            wFailImageCount ++;
            //重新调用自己
            [self uploadPictureWithImageNowCount:imageNowCount images:images failImageCount:wFailImageCount];
        }];
    }else{
        [_hud hide:YES];
        [_hud removeFromSuperViewOnHide];
//        for (UIImage *ima in self.picturesArray) {
//            NSLog(@"hello:%@\n",ima);
//        }
//        for (NSString *ID in self.pictureIDArray) {
//            NSLog(@"helloID:%@\n",ID);
//        }
        _imgView.image = self.picturesArray.lastObject;
        [_maskButton setTitle:[NSString stringWithFormat:@"%ld",(unsigned long)self.picturesArray.count] forState:UIControlStateNormal];
        if (failImageCount > 0) {
            [MBProgressHUD showMessage:[NSString stringWithFormat:@"有%ld张图片上传失败",(long)failImageCount] toView:self.view];
        }
    }
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

#pragma mark - 同意或者拒绝的网络方法 methods
//同意
-(void)agree{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载中";
    _postURL = APPROVAL_AGREE;
    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
    [paramDic  setValue:self.applyRequestId forKey:@"ApplyRequestId"];
    [paramDic  setValue:self.tv.text forKey:@"Remark"];
    //}
    NSArray *IDsArray = [self.pictureIDArray copy];
    //NSString *IDs = [IDsArray componentsJoinedByString:@","];
    //if (IDsArray.count != 0) {
    NSString *voiceIDs = [[NSString alloc]init];
    [paramDic  setValue:IDsArray forKey:@"PhotoIDs"];
    //}
    [paramDic setValue:voiceIDs forKey:@"VoiceIDs"];
    [AFNetClient POST_Path:_postURL params:paramDic completed:^(NSData *stringData, id JSONDict) {
        NSNumber *codeNumber = JSONDict[@"Code"];
        NSInteger code = [codeNumber integerValue];
        if (code == 0) {
            self.agreeOrRefuseBlock();
            [_hud hide:YES];
            [self dismissViewControllerAnimated:NO completion:nil];
        }else{
            [_hud hide:YES];
            [MBProgressHUD showMessage:JSONDict[@"Message"]];
        }
    } failed:^(NSError *error) {
        [_hud hide:YES];
        [MBProgressHUD showMessage:@"请求失败，请稍后再试" toView:self.view];
        NSLog(@"请求失败Error--%ld",(long)error.code);
    }];
}

//拒绝
-(void)refuse{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载中";
    _postURL = APPROVAL_REFUSE;
    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
    [paramDic  setValue:self.applyRequestId forKey:@"ApplyRequestId"];
    //if (self.tv.text.length != 0) {
    [paramDic  setValue:self.tv.text forKey:@"Remark"];
    //}
    NSArray *IDsArray = [self.pictureIDArray copy];
    //NSString *IDs = [IDsArray componentsJoinedByString:@","];
    //if (IDsArray.count != 0) {
    NSString *voiceIDs = [[NSString alloc]init];
    [paramDic  setValue:IDsArray forKey:@"PhotoIDs"];
    //}
    [paramDic setValue:voiceIDs forKey:@"VoiceIDs"];
    [AFNetClient POST_Path:_postURL params:paramDic completed:^(NSData *stringData, id JSONDict) {
        NSLog(@"Code:%@",JSONDict[@"Code"]);
        NSNumber *codeNumber = JSONDict[@"Code"];
        NSInteger code = [codeNumber integerValue];
        
        // NSLog(@"hahahaha:%@",code);
        if (code == 0) {
            self.agreeOrRefuseBlock();
            [_hud hide:YES];
            [self dismissViewControllerAnimated:NO completion:nil];
        }else{
            [_hud hide:YES];
            [MBProgressHUD showMessage:JSONDict[@"Message"]];
        }

    } failed:^(NSError *error) {
        [_hud hide:YES];
        [MBProgressHUD showMessage:@"请求失败，请稍后再试" toView:self.view];
        NSLog(@"请求失败Error--%ld",(long)error.code);
    }];
}



@end
