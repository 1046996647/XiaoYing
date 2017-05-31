//
//  NewMemoryTableView.m
//  XiaoYing
//
//  Created by GZH on 16/10/4.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "NewMemoryTableView.h"
#import "NewMemoryCell.h"
#import "SendMemoryModel.h"
#import "ModelJson.h"
#import "IssueNoticeVC.h"

@interface NewMemoryTableView ()<UINavigationControllerDelegate,
UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *_baseView;
   
//    NSMutableArray *_modelArr;
    CGFloat _initialTVHeight;
    
    BOOL _keyboardIsVisible;
    NSInteger _insertIndex; // 插入图片位置下标
    
    UITextField *_textField; // 只是为了弹出键盘
}

@end


@implementation NewMemoryTableView



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initData];

        [self initUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageAction:) name:@"AddPicture" object:nil];
        
        // 键盘
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}


- (void)initUI {
    //列表
    _tableView = [[UITableView alloc] initWithFrame:self.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:_tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyboardAction)];
    [_tableView addGestureRecognizer:tap];

}



- (void)initData {
    _modelArr = [NSMutableArray array];
    
    NewMemoryModel *model = [[NewMemoryModel alloc] init];
    model.fileType = FileTypeText;
    [_modelArr addObject:model];
}

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
         __block __weak __typeof(&*self)weakSelf = self;
        cell.deleteBlock = ^(NewMemoryModel *model) {
            
            //            NSLog(@"%ld",[_modelArr count]);
            
            
            NSInteger index = [weakSelf.modelArr indexOfObject:model];
            
            NewMemoryModel *lastModel = [weakSelf.modelArr objectAtIndex:index-1];
            
            NewMemoryModel *nextModel = [weakSelf.modelArr objectAtIndex:index+1];
            
            if (nextModel.text.length > 0) {
                
                if (lastModel.text.length > 0) {
                    lastModel.text = [NSString stringWithFormat:@"%@\n%@",lastModel.text,nextModel.text];
                }
                else {
                    lastModel.text = nextModel.text;
                    
                }
            }
            
            [weakSelf.modelArr removeObject:model];
            [weakSelf.modelArr removeObject:nextModel];

            _insertIndex = weakSelf.modelArr.count-1;
            weakSelf.tableView.top = 0;
            
            [weakSelf.tableView reloadData];
        };
        cell.sendBlock = ^(NSInteger insertIndex) {
            
            _insertIndex = insertIndex;
        };
        
        cell.changeBlock = ^(NSString *text) {
            

        };
        
    }
    
    
    //    cell.insertIndex = _insertIndex;

    cell.row = indexPath.row;
    cell.count = _modelArr.count;
    cell.model = nil;
    cell.model = _modelArr[indexPath.row];

    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}

// 刷新表视图
- (void)refreshTableview
{
    [_tableView reloadData];
}

- (void)imageAction:(NSNotification *)not {
    NSIndexPath *path = nil;
    
    path = [NSIndexPath indexPathForRow:_insertIndex inSection:0];
    
    [self scrollToCell:path];
    
         if ([not.object isEqualToString:@"0"]) {
        [self p_getLocalPhoto];
        
    }else {
        [self p_takePhoto];
        
    }
}



/**
 *  打开本地相册
 */
- (void)p_getLocalPhoto {
    // 本地相册
    UIImagePickerController *pick = [[UIImagePickerController alloc] init];
    pick.delegate = self;
    [self.viewController.navigationController presentViewController:pick animated:YES completion:nil];
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
        [self.viewController.navigationController presentViewController:pick animated:YES completion:nil];
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
    UIImage *img = info[@"UIImagePickerControllerOriginalImage"];

    NSData *imgData = [self imageData:img];
    
    NSString *fileName = [NSString stringWithFormat:@"%.0f.png",[NSDate timeIntervalSinceReferenceDate] * 1000.0];
    //图片转字符串Base64Str
    NSString *imgStr = [self imageOrientationAndBase64Str:img];
    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
    [paramDic  setValue:imgStr forKey:@"Data"];
    [paramDic  setValue:fileName forKey:@"FileName"];
    [paramDic  setValue:@(1) forKey:@"Category"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = @"正在上传...";
    
    // 请求网络
    [AFNetClient  POST_Path:FileUploadURl params:paramDic completed:^(NSData *stringData, id JSONDict) {
        
        [hud hide:YES];
        
        NSNumber *code=[JSONDict objectForKey:@"Code"];
        
        if (1 == [code integerValue]) {
            
            
            NSString *msg = [JSONDict objectForKey:@"Message"];
            
            [MBProgressHUD showMessage:msg toView:self];
            
        } else {
            
            _insertIndex = _insertIndex+1;
            
            NewMemoryModel *imgModel = [[NewMemoryModel alloc] init];
            imgModel.imgData = imgData;
            imgModel.text = JSONDict[@"Data"];
            imgModel.dic = JSONDict[@"Data"];
            
            imgModel.fileType = FileTypeImage;
            [_modelArr insertObject:imgModel atIndex:_insertIndex];
            
            _insertIndex = _insertIndex+1;
            
            NewMemoryModel *textModel = [[NewMemoryModel alloc] init];
            textModel.fileType = FileTypeText;
            [_modelArr insertObject:textModel atIndex:_insertIndex];
            
            [self refreshTableview];
            
            NSIndexPath *path = nil;

            path = [NSIndexPath indexPathForRow:_insertIndex inSection:0];
            
            [self scrollToCell:path];
            
        }
        
        
    } failed:^(NSError *error) {
        
        [hud hide:YES];
        
        [MBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"] toView:self];
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



- (void)showKeyboardAction
{
    
    NewMemoryCell *cell = [[_tableView visibleCells] lastObject];
    UITextView *textView = (UITextView *)cell.textView;
    [textView becomeFirstResponder];
}

#pragma mark - keyboard
- (void)keyboardWillHide:(NSNotification *)noti {
    
    if (_keyboardIsVisible) {
        
        CGRect tvFrame = _tableView.frame;
        tvFrame.size.height = _initialTVHeight;
        
        
        _tableView.frame = tvFrame;
        
        _keyboardIsVisible = NO;
        
    }
    // _tableView.top = 0;
    
}

- (void)keyboardWillShow:(NSNotification *)noti {
    
    
    CGRect initialFrame = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (!_keyboardIsVisible) {
        
        _initialTVHeight = _tableView.frame.size.height;
        
        CGRect convertedFrame = [self convertRect:initialFrame fromView:nil];
        CGRect tvFrame = _tableView.frame;
        tvFrame.size.height = convertedFrame.origin.y-44;
        _tableView.frame = tvFrame;
        
        _keyboardIsVisible = YES;
    }
    
}




@end
