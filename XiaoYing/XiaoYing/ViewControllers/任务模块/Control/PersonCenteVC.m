//
//  PersonCenteVC.m
//  XiaoYing
//
//  Created by ZWL on 15/11/23.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "PersonCenteVC.h"
#import "PersonCenterCell.h"
#import "PersonCenterModel.h"
#import "EditPersonVC.h"
#import "FirstModel.h"
@interface PersonCenteVC ()
{
    UITableView *PersonTab_;
    NSMutableArray *arrData;
    
    NSString *filePath;
    UIAlertController *myActionSheet;
   
}
@end

@implementation PersonCenteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.title=@"个人信息";
    [self.navigationController.navigationBar  setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    
    
    [self initUI];
    [self initData];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeData:) name:@"BackMark" object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *  响应消息通知
 *
 *  @param obj 标记的修改的哪一个cell的值
 */
-(void)ChangeData:(NSNotification *)obj{
    NSString * flag = (NSString*)obj.object;
    NSMutableArray *arr = arrData [2];
    NSInteger i = [flag integerValue];
    if (i == 7) {
        [arr replaceObjectAtIndex:i withObject:_mymodel.Signature];
    }else if (i == 6){
        [arr replaceObjectAtIndex:i withObject:_mymodel.Address];
        
    }else if (i == 5){
        [arr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%ld",(long)_mymodel.RegionId]];
    }
    [PersonTab_ reloadData];
}
-(void)initData{
   
    arrData=[[NSMutableArray alloc]init];
    //公司 部门，职务，公司电话，公司地址，公司电话
    NSArray *arrSection1=@[@"头像",@"姓名",@"性别",@"邮箱",@"手机号码",@"地区",@"我的地址",@"个人签名"];
    NSArray *arrSection2=@[@"公司",@"部门",@"职务",@"公司电话",@"公司地址"];
    
    
    NSMutableArray *arrCompany=[[NSMutableArray alloc]init];
    [arrCompany addObject:_mymodel.FaceUrl];
    [arrCompany addObject:_mymodel.Fullname];
    if (_mymodel.Gender==1) {
        [arrCompany addObject:@"男"];
    }else{
        [arrCompany addObject:@"女"];
    }
    [arrCompany addObject:_mymodel.Email];
    [arrCompany addObject:_mymodel.Mobile];
    [arrCompany addObject:[NSString stringWithFormat:@"%ld",(long)_mymodel.RegionId]];
    [arrCompany addObject:_mymodel.Address];
    [arrCompany addObject:_mymodel.Signature];
    
    NSMutableArray *arrCompany1=[[NSMutableArray alloc]init];
    [arrCompany1 addObject:_companymodel.companyName];
    [arrCompany1 addObject:_companymodel.departmentName];
    [arrCompany1 addObject:_companymodel.positionName];
    [arrCompany1 addObject:_companymodel.companyTelephone];
    [arrCompany1 addObject:_companymodel.companyAddress];
    
    [arrData addObject:arrSection1];
    [arrData addObject:arrSection2];
    [arrData addObject:arrCompany];
    [arrData addObject:arrCompany1];
}
-(void)initUI{
    //uitableview的列表
    
    PersonTab_=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:UITableViewStyleGrouped];
    PersonTab_.dataSource=self;
    PersonTab_.delegate=self;
    
    [self.view addSubview:PersonTab_];
}
#pragma mark --UIActionSheetDelegate


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"取消");
    }else{
        
        
        switch (buttonIndex) {
            case 0:
                [self takePhoto];
                break;
            case 1:
                [self localPhoto];
                break;
                
            default:
                break;
        }
    }
}
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
    //判断是真机还是模拟机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        //设置拍照相片可以被编辑
        picker.allowsEditing=YES;
        picker.sourceType=sourceType;
        
        //6.0之后
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
    }
    else
    {
        NSLog(@"模拟器中无法打开照相机");
    }
}
-(void)localPhoto
{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    //设置选择后的图片可以被编辑
    picker.allowsEditing=YES;
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //为不同的图片命名字
    static int i=1;
    NSString *type=[info objectForKey:@"UIImagePickerControllerMediaType"];
    
    if ([type isEqualToString:@"public.image"]) {
        //image既是所选的图片
        UIImage *image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image)==nil) {
            data=UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data=UIImagePNGRepresentation(image);
        }
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        
        NSString *DocumentsPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager=[NSFileManager defaultManager];
        
        //将刚刚转换的data对象copy到沙盒中并保存为Image.png
        
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSString *str=[NSString stringWithFormat:@"/%dimage.png",i];
        [fileManager removeItemAtPath:[DocumentsPath stringByAppendingString:str] error:nil];
        i++;
        NSString *str1=[NSString stringWithFormat:@"/%dimage.png",i];
        
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:str1] contents:data attributes:nil];
        
        //得到选择后的沙盒中得图片的完整路径
        
        filePath=[[NSString alloc]initWithFormat:@"%@/%d%@",DocumentsPath,i,@"image.png"];
        
      
        
        NSLog(@"%@",filePath);
        
        //关闭相册界面
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
            NSMutableArray *arr=arrData[2];
            [arr replaceObjectAtIndex:0 withObject:filePath];
              _mymodel.FaceUrl = str1;
            [self FixedPlist];
            [PersonTab_ reloadData];
           
        }];
        
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -----//实现点击图片预览功能 滑动放大或缩小，带动画

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"fdaga");
#if 0
    isFullScreen = !isFullScreen;
    
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self.view];
    
    CGPoint imagePoint = self.imageView.frame.origin;
    //touchPoint.x ，touchPoint.y 就是触点的坐标
    
    // 触点在imageView内，点击imageView时 放大,再次点击时缩小
    if(imagePoint.x <= touchPoint.x && imagePoint.x +self.imageView.frame.size.width >=touchPoint.x && imagePoint.y <=  touchPoint.y && imagePoint.y+self.imageView.frame.size.height >= touchPoint.y)
    {
        // 设置图片放大动画
        [UIView beginAnimations:nil context:nil];
        // 动画时间
        [UIView setAnimationDuration:1];
        
        if (isFullScreen) {
            // 放大尺寸
            
            self.imageView.frame = CGRectMake(0, 0, 320, 480);
        }
        else {
            // 缩小尺寸
            self.imageView.frame = CGRectMake(50, 65, 90, 115);
        }
        
        // commit动画
        [UIView commitAnimations];
        
    }
#endif
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"1");
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"2");
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"3");
}

#pragma mark -- UIAlertViewDelegate
- (void)alertTextFieldDidEndEditing:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField * field = alertController.textFields.firstObject;
        // 不能为空
        if ([self isBlankString:field.text]) {
            return;
        }
        NSMutableArray *arr=arrData[2];
        int i=0;
        if (mark==3) {
            if ([RegexTool validateEmail:field.text]) {
                i=1;
                [arr replaceObjectAtIndex:mark withObject:field.text];
                _mymodel.Email = field.text;
                
            }else{
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"您输入的邮箱有误" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                
                [alter addAction:okAction];
                
                [self presentViewController:alter animated:YES completion:nil];
                
                
            }
        }else if (mark==4){
            if ([RegexTool validateUserPhone:field.text]) {
                i=1;
                [arr replaceObjectAtIndex:mark withObject:field.text];
                _mymodel.Mobile = field.text;
                
            }else{
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"您输入的号码有误" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                
                [alter addAction:okAction];
                
                [self presentViewController:alter animated:YES completion:nil];

                
            }
        }else if (mark==2&&([field.text isEqualToString:@"男"]||[field.text isEqualToString:@"女"])){
            i=1;
            [arr replaceObjectAtIndex:mark withObject:field.text];
            if ([field.text isEqualToString:@"男"]) {
                _mymodel.Gender = 1;
            }else{
                _mymodel.Gender = 0;
            }
            
            
        }else if (mark == 1){
            i=1;
            [arr replaceObjectAtIndex:mark withObject:field.text];
            _mymodel.Fullname = field.text;;
        }
        if (i==1) {
            [self FixedPlist];
            [PersonTab_ reloadData];
        }

    }
}
-(void)FixedPlist{
   
        [[FirstStartData shareFirstStartData] PersonCentrePlist:_mymodel];
}
// 判断字符串为空和只为空格解决办法
- (BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        
        return YES;
        
    }
    
    if (string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}
#pragma mark---UITableViewDataSource

static  int mark=0;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0&&indexPath.row==0) {
        //调用相机的相关功能
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction* OpenPhotoAction = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action){
            [self takePhoto];
        }];
        UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action){
            [self localPhoto];
            
        }];
        [alertController addAction:fromPhotoAction];
        [alertController addAction:OpenPhotoAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
        
    }else if (indexPath.section==0&&(indexPath.row==5||indexPath.row==6||indexPath.row==7)){
        //跳到下一页修改相应的信息
        EditPersonVC *edit=[[EditPersonVC alloc]init];
        edit.title =[[arrData objectAtIndex:0] objectAtIndex:indexPath.row];
        edit.Content=[[arrData objectAtIndex:2] objectAtIndex:indexPath.row];
        edit.mymodel = _mymodel;
        edit.mark = indexPath.row;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:edit animated:YES];
    }else if (indexPath.section==0){
        //跳出弹窗修改相对应的信息
        NSArray *message=[arrData objectAtIndex:0];
        mark=(int)indexPath.row;

        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:message[indexPath.row] message:[NSString stringWithFormat:@"请输入您的%@",message[indexPath.row]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        
        [alter addAction:okAction];
        [alter addAction:cancelAction];
      
        [alter addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:textField];
        }];
        [self presentViewController:alter animated:YES completion:nil];
    }else{
        
    }
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr=arrData[section];
    return arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        return 60;
    }
    else
        return 44;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return (arrData.count-2);
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonCenterCell *cell=nil;
    if (indexPath.section==0&&indexPath.row==0) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"cellHead"];
    }else{
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    if (!cell) {
        if (indexPath.section==0&&indexPath.row==0) {
            cell=[[PersonCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellHead"];
        }else{
            cell=[[PersonCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
    }
    if (cell.headImageView==nil) {
        if (indexPath.section==1) {
            
            NSArray *arr1=arrData[3];
            cell.nameLab.text=arr1[indexPath.row];
        }else{
            NSArray *arr2=arrData[2];
            cell.nameLab.text=arr2[indexPath.row];
        }
        
    }else{
        NSArray *arr=arrData[2];
        cell.headImageView.image=[UIImage imageNamed:arr[0]];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSArray *arr=[arrData objectAtIndex:indexPath.section];
    cell.textLabel.text=arr[indexPath.row];
    if (indexPath.section==1) {
        cell.textLabel.textColor=[UIColor lightGrayColor];
        cell.nameLab.textColor=[UIColor lightGrayColor];
    }else{
        cell.textLabel.textColor=[UIColor colorWithHexString:@"#333333"];
        cell.nameLab.textColor=[UIColor colorWithHexString:@"#333333"];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    return cell;
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
