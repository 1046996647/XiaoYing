//
//  UniversalController.m
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/15.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "ChatBackGroundController.h"
#import "ImageBrowseController.h"

@interface ChatBackGroundController()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ImageBrowseControllerDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    NSIndexPath *_indexPath;
}
@end

@implementation ChatBackGroundController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    _titleArray = @[@"从手机相册选择",@"拍一张"];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return _titleArray.count;

    } else {
        return 1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _indexPath = indexPath;
    
    if (indexPath.row == 0) {// 创建相册控制器
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        // 设置类型
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 设置为静态图像类型
        pickerController.mediaTypes = @[@"public.image"];
        // 设置代理对象
        pickerController.delegate = self;
        // 设置选择后的图片可以被编辑
//        pickerController.allowsEditing=YES;
        
        // 跳转到相册页面
        [self presentViewController:pickerController animated:YES completion:nil];
        
        
    } else {
        
        // 判断当前设备是否有摄像头
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            
            // 创建相册控制器
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            // 设置类型
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 设置代理对象
            pickerController.delegate = self;
//            pickerController.allowsEditing=YES;
            // 跳转到相册页面
            [self presentViewController:pickerController animated:YES completion:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打开摄像头失败" message:@"没有检测到摄像头" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

//选取后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"info:%@",info[UIImagePickerControllerOriginalImage]);
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    
    if (_indexPath.row == 0) {
        ImageBrowseController *imageBrowseController = [[ImageBrowseController alloc] init];
        imageBrowseController.img = img;
        imageBrowseController.delegate = self;
        [picker pushViewController:imageBrowseController animated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

//取消后调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - ImageBrowseControllerDelegate
//模态视图消失
- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //自定义分割线
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(16, 49, kScreen_Width - 16, 1)];
    sepView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        //自定义分割线
        [cell.contentView addSubview:sepView];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = _titleArray[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.textLabel.text = @"使用默认背景";

    }
    
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    
    return cell;
}


//组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

//组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
