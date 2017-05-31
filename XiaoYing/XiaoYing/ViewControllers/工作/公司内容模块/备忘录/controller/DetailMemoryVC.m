//
//  DetailMemoryVC.m
//  XiaoYing
//
//  Created by 王思齐 on 16/12/6.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "DetailMemoryVC.h"
#import "NewMemoryCell.h"
#import "SendMemoryModel.h"
#import "WangUrlHelp.h"

@interface DetailMemoryVC ()<UINavigationControllerDelegate,
UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *_baseView;
    NSMutableArray *_modelArr;
    UITableView *_tableView;
    CGFloat _initialTVHeight;
    BOOL _keyboardIsVisible;
    BOOL _FirstComeIn;
    NSInteger _insertIndex; // 插入图片位置下标
    
    UITextField *_textField; // 只是为了弹出键盘
}

@property (nonatomic,strong) UIButton *saveCreate;

@end


@implementation DetailMemoryVC

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";

    //    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    //    [self.view addSubview:_textField];
    
    // 键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // 数据源
    _modelArr = [NSMutableArray array];
    
    for (NSDictionary *subDic in self.dataArr) {
        NewMemoryModel *model = [[NewMemoryModel alloc] init];
        
        NSInteger num = [subDic[@"type"] integerValue];
        
        if (1 == num) {
            model.text = subDic[@"content"];
            model.dic = subDic[@"content"];
            model.fileType = FileTypeImage;
        }
        else {
            model.text = subDic[@"content"];
            model.fileType = FileTypeText;
        }
        
        
        [_modelArr addObject:model];
    }
    
    if (_modelArr.count > 0) {
        _insertIndex = _modelArr.count-1;
    }
    
    // 创建视图
    [self initSubviews];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initSubviews
{
    
    //列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(12, 0, kScreen_Width - 24, kScreen_Height-44-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    //    _tableView.backgroundColor = [UIColor blueColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyboardAction)];
    [_tableView addGestureRecognizer:tap];
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-44-64, kScreen_Width, 44)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baseView];
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(_baseView.width-44-44, 0, 44, 44);
    [cameraBtn setImage:[UIImage imageNamed:@"orange_camera"] forState:UIControlStateNormal];
    cameraBtn.tag = 0;
    [cameraBtn addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:cameraBtn];
    
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imgBtn.frame = CGRectMake(_baseView.width-44, 0, 44, 44);
    [imgBtn setImage:[UIImage imageNamed:@"orange_picture"] forState:UIControlStateNormal];
    imgBtn.tag = 1;
    [imgBtn addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:imgBtn];
    
    // 提交按钮
    UIButton *newCreate = [UIButton buttonWithType:UIButtonTypeCustom];
    newCreate.frame = CGRectMake(0, 0, 40, 30);
    [newCreate setTitle:@"保存" forState:UIControlStateNormal];
    [newCreate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newCreate setTitleColor:[UIColor colorWithHexString:@"cccccc"] forState:UIControlStateNormal];
    [newCreate setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    newCreate.userInteractionEnabled = NO;
    //    newCreate.selected = YES;
    [newCreate addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newCreate];
    self.saveCreate = newCreate;
}


// 保存
-(void)btnAction:(UIButton *)btn{
    
    // 按钮改变
    self.saveCreate.userInteractionEnabled = NO;
    self.saveCreate.selected = NO;
    
    //保存中
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"保存中...";
    
    [self.view endEditing:YES];
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (NewMemoryModel *model in _modelArr) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        if (model.fileType == FileTypeText) {
            
            if (model.text.length == 0) {
                model.text = @"";
            }
            [dic setObject:@"0" forKey:@"type"];
            [dic setObject:model.text forKey:@"content"];
        }
        else {
            
            [dic setObject:@"1" forKey:@"type"];
            [dic setObject:model.text forKey:@"content"];
        }
        
        
        [arrM addObject:dic];
    }
    NSString *jsonStr = [arrM JSONString];
    
    SendMemoryModel *model = [[SendMemoryModel alloc] init];
    model.Content = jsonStr;
    model.Id = self.Id;
    if (_modelArr.count > 1) {
        model.HasImage = YES;
    }
    else {
        model.HasImage = NO;
        
    }
    
    NSDictionary *dic = [ModelJson getObjectData:model];
    
    [AFNetClient  POST_Path:EditMemory params:dic completed:^(NSData *stringData, id JSONDict) {
        
        [hud hide:YES];
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        
        if (1 == [code integerValue]) {
            
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
            // 是否刷新
            if (self.refreshBlock) {
                _refreshBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failed:^(NSError *error) {
        
        [hud hide:YES];
        
        // 按钮改变
        self.saveCreate.userInteractionEnabled = YES;
        self.saveCreate.selected = YES;
        
        [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
        
    }];
    
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    return;
//}

/**
 @method 获取指定宽度width,字体大小fontSize,字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (float) heightForString:(NSString *)value andWidth:(float)width{
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:attributes        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height + 16.0;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewMemoryModel *model = _modelArr[indexPath.row];
    
    if (model.fileType ==  FileTypeImage) {
        return 200;
    }
    else {
        
        model.cellHeight = [self heightForString:model.text andWidth:kScreen_Width-24];
        
        
        if (model.cellHeight > 36) {
            
            return model.cellHeight;
        }
        return 36;
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];//以indexPath来唯一确定cell
    
    NewMemoryCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[NewMemoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.userInteractionEnabled = NO;
        cell.deleteBlock = ^(NewMemoryModel *model) {
            
            //            NSLog(@"%ld",[_modelArr count]);
            
            
            NSInteger index = [_modelArr indexOfObject:model];
            
            NewMemoryModel *lastModel = [_modelArr objectAtIndex:index-1];
            
            NewMemoryModel *nextModel = [_modelArr objectAtIndex:index+1];
            
            if (nextModel.text.length > 0) {
                
                if (lastModel.text.length > 0) {
                    lastModel.text = [NSString stringWithFormat:@"%@\n%@",lastModel.text,nextModel.text];
                }
                else {
                    lastModel.text = nextModel.text;
                    
                }
                
            }
            
            //            NSLog(@"%ld",[_modelArr indexOfObject:model]);
            [_modelArr removeObject:model];
            [_modelArr removeObject:nextModel];
            //            NSLog(@"%ld",[_modelArr count]);
            
            [_tableView beginUpdates];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
            
            
            _insertIndex = _modelArr.count-1;
            
            // 按钮改变
            self.saveCreate.userInteractionEnabled = YES;
            self.saveCreate.selected = YES;
            
            if (lastModel.text.length == 0 && _modelArr.count == 1) {
                // 按钮改变
                self.saveCreate.userInteractionEnabled = NO;
                self.saveCreate.selected = NO;
            }
            
        };
        cell.sendBlock = ^(NSInteger insertIndex) {
            
            _insertIndex = insertIndex;
            self.title = @"编辑";
            //            [_tableView reloadData];
            
        };
        
        cell.changeBlock = ^(NSString *text) {
            
            if (text.length == 0 && _modelArr.count == 1) {
                // 按钮改变
                self.saveCreate.userInteractionEnabled = NO;
                self.saveCreate.selected = NO;
            }
            else {
                // 按钮改变
                self.saveCreate.userInteractionEnabled = YES;
                self.saveCreate.selected = YES;
            }
        };
        
    }
    
    
    //    cell.insertIndex = _insertIndex;
    cell.title = self.title;
    cell.row = indexPath.row;
    cell.count = _modelArr.count;
    cell.model = _modelArr[indexPath.row];
    
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


// 刷新表视图
- (void)refreshTableview
{
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imageAction:(UIButton *)btn {
    
    if (btn.tag == 0)
    {
        [self p_takePhoto];
        
    }
    else {
        [self p_getLocalPhoto];
        
    }
}

/**
 *  打开本地相册
 */
- (void)p_getLocalPhoto {
    // 本地相册
    UIImagePickerController *pick = [[UIImagePickerController alloc] init];
    pick.delegate = self;
    [self presentViewController:pick animated:YES completion:nil];
}

/**
 *  拍照
 */
- (void)p_takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *pick = [[UIImagePickerController alloc] init];
        pick.delegate = self;
        //        pick.allowsEditing = YES;
        pick.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pick animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
}

#pragma mark - UINavigationControllerDelegate
/**
 *  照片获取完成
 *
 *  @param picker
 *  @param info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //    NSLog(@"%@", info);
    UIImage *img = info[@"UIImagePickerControllerOriginalImage"];
    //    if (img.size.width > 1000) {
    //        img = [self imageCompressForWidth:img targetWidth:600];
    //    }
    NSData *imgData = [self imageData:img];
    
    NSString *fileName = [NSString stringWithFormat:@"%.0f.png",[NSDate timeIntervalSinceReferenceDate] * 1000.0];
    //图片转字符串Base64Str
    NSString *imgStr = [self imageOrientationAndBase64Str:img];
    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
    [paramDic  setValue:imgStr forKey:@"Data"];
    [paramDic  setValue:fileName forKey:@"FileName"];
    [paramDic  setValue:@(1) forKey:@"Category"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在上传...";
    
    // 请求网络
    [AFNetClient  POST_Path:FileUploadURl params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        [hud hide:YES];
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            
            
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self.view];
            
        } else {
            
            
            // 按钮改变
            self.saveCreate.userInteractionEnabled = YES;
            self.saveCreate.selected = YES;
            
            
            _insertIndex = _insertIndex+1;
            
            NewMemoryModel *imgModel = [[NewMemoryModel alloc] init];
            imgModel.imgData = imgData;
            imgModel.text = JSONDict[@"Data"];
            imgModel.dic = JSONDict[@"Data"];
            imgModel.fileType = FileTypeImage;
            //            imgModel.cellHeight = img.size.height;
            [_modelArr insertObject:imgModel atIndex:_insertIndex];
            //    [_modelArr addObject:imgModel];
            
            _insertIndex = _insertIndex+1;
            
            
            NewMemoryModel *textModel = [[NewMemoryModel alloc] init];
            textModel.fileType = FileTypeText;
            //    [_modelArr addObject:textModel];
            [_modelArr insertObject:textModel atIndex:_insertIndex];
            
            [self refreshTableview];
            
            NSIndexPath *path = nil;
            
            //    if (_keyboardIsVisible) {
            //
            //        path = [NSIndexPath indexPathForRow:_insertIndex inSection:0];
            //
            //    }
            //    else {
            //        path = [NSIndexPath indexPathForRow:_modelArr.count-1 inSection:0];
            //
            //    }
            path = [NSIndexPath indexPathForRow:_insertIndex inSection:0];
            
            
            [self scrollToCell:path];
            
        }
        
        
    } failed:^(NSError *error) {
        
        [hud hide:YES];
        
        [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(void) scrollToCell:(NSIndexPath*) path {
    
    
    [_tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


/**
 *  取消获取照片
 *
 *  @param picker
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//图片旋转和转字符串
-(NSString *)imageOrientationAndBase64Str:(UIImage *) image

{
    //    //处理后的图片
    //    UIImage *normalizedImage = nil;
    //
    //    //图片方向处理
    //    if (image.imageOrientation == UIImageOrientationUp) {
    //        normalizedImage = image;
    //    } else {
    //        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    //        [image drawInRect:(CGRect){0, 0, image.size}];
    //        normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    //        UIGraphicsEndImageContext();
    //    }
    
    
    //图片转成Base64Str
    //    NSData *data = UIImagePNGRepresentation(image);
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

/*
 // 等比例压缩
 -(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
 UIImage *newImage = nil;
 CGSize imageSize = sourceImage.size;
 CGFloat width = imageSize.width;
 CGFloat height = imageSize.height;
 CGFloat targetWidth = defineWidth;
 CGFloat targetHeight = height / (width / targetWidth);
 CGSize size = CGSizeMake(targetWidth, targetHeight);
 CGFloat scaleFactor = 0.0;
 CGFloat scaledWidth = targetWidth;
 CGFloat scaledHeight = targetHeight;
 CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
 if(CGSizeEqualToSize(imageSize, size) == NO){
 CGFloat widthFactor = targetWidth / width;
 CGFloat heightFactor = targetHeight / height;
 if(widthFactor > heightFactor){
 scaleFactor = widthFactor;
 }
 else{
 scaleFactor = heightFactor;
 }
 scaledWidth = width * scaleFactor;
 scaledHeight = height * scaleFactor;
 if(widthFactor > heightFactor){
 thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
 }else if(widthFactor < heightFactor){
 thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
 }
 }
 UIGraphicsBeginImageContext(size);
 CGRect thumbnailRect = CGRectZero;
 thumbnailRect.origin = thumbnailPoint;
 thumbnailRect.size.width = scaledWidth;
 thumbnailRect.size.height = scaledHeight;
 
 [sourceImage drawInRect:thumbnailRect];
 
 newImage = UIGraphicsGetImageFromCurrentImageContext();
 if(newImage == nil){
 NSLog(@"scale image fail");
 }
 
 UIGraphicsEndImageContext();
 return newImage;
 }
 
 */


#pragma mark - keyboard
- (void)keyboardWillHide:(NSNotification *)noti {
    
    if (_keyboardIsVisible) {
        
        CGRect tvFrame = _tableView.frame;
        tvFrame.size.height = _initialTVHeight;
        
        
        _tableView.frame = tvFrame;
        
        _keyboardIsVisible = NO;
        
    }
    _baseView.bottom = kScreen_Height-64;
    
    
    //    [UIView animateWithDuration:0.5f animations:^{
    //
    //
    //
    //    }];
    
    
    
    
    
}


- (void)keyboardWillShow:(NSNotification *)noti {
    
    CGRect initialFrame = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (!_keyboardIsVisible) {
        
        _initialTVHeight = _tableView.frame.size.height;
        
        CGRect convertedFrame = [self.view convertRect:initialFrame fromView:nil];
        CGRect tvFrame = _tableView.frame;
        tvFrame.size.height = convertedFrame.origin.y-44;
        _tableView.frame = tvFrame;
        
        _keyboardIsVisible = YES;
    }

    _baseView.top = kScreen_Height - initialFrame.size.height-44-64;
    
}

// 手势事件
- (void)showKeyboardAction
{
    
    NewMemoryCell *cell = [[_tableView visibleCells] lastObject];
    UITextView *textView = (UITextView *)cell.textView;
    [textView becomeFirstResponder];
}


@end
