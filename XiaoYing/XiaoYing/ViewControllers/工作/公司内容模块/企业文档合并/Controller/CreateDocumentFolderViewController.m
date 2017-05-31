//
//  CreateDocumentFolderViewController.m
//  XiaoYing
//
//  Created by chenchanghua on 2017/1/6.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "CreateDocumentFolderViewController.h"
#import "XYExtend.h"
#import "SelectPlaceVC.h"
#import "DocumentVM.h"
#import "AuthorityForDocumentMethod.h"

@interface CreateDocumentFolderViewController ()

@property (nonatomic, strong) UITextField *folderNameField; //输入新建的文件夹名称
@property (nonatomic, strong) UILabel *folderPositionLabel; //显示当前选择的部门与文件夹位置

@end

@implementation CreateDocumentFolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏的设置
    [self setupNavigationItemContent];
    
    //设置self.view上的内容
    [self setupBaseViewContent];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //隐藏标签栏
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabvc hideCustomTabbar];
    
}

- (void)setupNavigationItemContent
{
    __weak typeof(self) weakSelf = self;
    
    //title
    self.navigationItem.title = @"新建文件夹";
    
    //leftBarButton
    HSBlockButton *leftBtn = [HSBlockButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 0, 40, 20);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn addTouchUpInsideBlock:^(UIButton *button) {

        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItems:@[leftBarBtn]];
    
    //rightBarButton
    HSBlockButton *rightBtn = [HSBlockButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(10, 0, 40, 20);
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn addTouchUpInsideBlock:^(UIButton *button) {
        
        if ([weakSelf.folderPositionLabel.text isEqualToString:@""]) {
            [MBProgressHUD showMessage:@"请选择创建的位置"];
            return ;
        }else if ([self.folderNameField.text isEqualToString:@""]) {
            [MBProgressHUD showMessage:@"请输入文件夹名称"];
            return ;
        }else {
            //新建文件夹所需要的数据准备
            NSString *folderName = self.folderNameField.text;
            NSString *departmentId = self.departmentPlaceId;
            NSString *folderId = self.folderPlaceId;
            
            //开始web操作
            
            if ([departmentId isEqualToString:@" "]) {//个人级别的文档
                
                [DocumentVM personCreateFolderWithParentFolderId:folderId newFolderName:folderName departmentId:@"" success:^(NSDictionary *dataList) {
                    
                    // 新建文件夹成功后发送通知！！！
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDocNotification" object:nil];
                    
                    //跳出新建文件夹VC
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    
                } failed:^(NSError *error) {
                    
                    NSLog(@"%@",error);
                }];
                
            }else {
                
                [DocumentVM createFolderWithParentFolderId:folderId newFolderName:folderName departmentId:departmentId success:^(NSDictionary *dataList) {
                    
                    // 新建文件夹成功后发送通知！！！
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDocNotification" object:nil];
                    
                    //跳出新建文件夹VC
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    
                } failed:^(NSError *error) {
                    
                    NSLog(@"%@",error);
                }];
            }
            
        }
        
    }];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];

}

- (void)setupBaseViewContent
{
    __weak typeof(self) weakSelf = self;
    
    //文件夹名称
    UIView *folderNameWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, 45)];
    folderNameWhiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:folderNameWhiteView];
    
    self.folderNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width - 10, 45)];
    self.folderNameField.backgroundColor = [UIColor whiteColor];
    self.folderNameField.placeholder = @"请输入文件夹名称";
    self.folderNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.folderNameField.font = [UIFont systemFontOfSize:16];
    [folderNameWhiteView addSubview:self.folderNameField];
    
    //文件夹的位置
    UIView *folderPositionWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, folderNameWhiteView.bottom + 12, kScreen_Width, 90.5)];
    folderPositionWhiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:folderPositionWhiteView];
    
    //button
    HSBlockButton *folderPositionBtn = [HSBlockButton buttonWithType:UIButtonTypeCustom];
    folderPositionBtn.frame = CGRectMake(12, 0, kScreen_Width - 12, 45);
    folderPositionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [folderPositionBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    folderPositionBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [folderPositionBtn setTitle:@"选择创建位置" forState:UIControlStateNormal];
    [folderPositionBtn setImage:[UIImage imageNamed:@"jiantou_gray_right"] forState:UIControlStateNormal];
    
    CGSize titleLabelSize = [folderPositionBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : folderPositionBtn.titleLabel.font}];
    CGSize imageViewSize = folderPositionBtn.imageView.frame.size;
    
    folderPositionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    folderPositionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageViewSize.width, 0, 0);
    folderPositionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, folderPositionBtn.width-12-imageViewSize.width, 0, 0);
    
    [folderPositionBtn addTouchUpInsideBlock:^(UIButton *button) {
        
        SelectPlaceVC *selectPlaceVC = [[SelectPlaceVC alloc] init];
        selectPlaceVC.navigationItem.title = @"新建文件夹";
        selectPlaceVC.getPlaceBlock = ^(NSString *departmentName, NSString *departmentId, NSString *folderName, NSString *folderId){
        
            NSLog(@"%@,%@,%@,%@", departmentName, departmentId, folderName, folderId);
            weakSelf.departmentPlaceId = departmentId;
            weakSelf.folderPlaceId = folderId;
            
            NSString *tempStr = [NSString stringWithFormat:@"%@\n>%@", departmentName, folderName];
            CGFloat textHeight = [HSMathod getHightForText:tempStr limitWidth:kScreen_Width - 12*2 fontSize:14];
            weakSelf.folderPositionLabel.frame = CGRectMake(12, 46, kScreen_Width - 12*2, textHeight);
            weakSelf.folderPositionLabel.text = tempStr;
            folderPositionWhiteView.frame = CGRectMake(0, folderNameWhiteView.bottom + 12, kScreen_Width, textHeight + 45.5);
        };
        
        [weakSelf.navigationController pushViewController:selectPlaceVC animated:YES];
    }];
    [folderPositionWhiteView addSubview:folderPositionBtn];
    
    //line
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 45, kScreen_Width - 12*2, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [folderPositionWhiteView addSubview:lineView];
    
    //label
    self.folderPositionLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, lineView.bottom, kScreen_Width - 12*2, 45)];
    self.folderPositionLabel.font = [UIFont systemFontOfSize:14];
    self.folderPositionLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
    
    //对初始路径权限判断
    if (![self.departmentPlaceId isEqualToString:@" "]) { //个人文档不需要判断
        
        BOOL originBool = [AuthorityForDocumentMethod JudgeAuthority:^(AuthorityForDocumentMethod *auth) {
            
            auth.regionName(@"新建文件夹").deparmentId(self.departmentPlaceId);
        }];
        
        self.originFolderPath = originBool? self.originFolderPath : @"";
        
    }
    
    CGFloat textHeight = [HSMathod getHightForText:self.originFolderPath limitWidth:self.folderPositionLabel.width fontSize:14];
    if (textHeight <= 45) {
        self.folderPositionLabel.text = self.originFolderPath;
    } else {
        self.folderPositionLabel.frame = CGRectMake(12, 46, kScreen_Width - 12*2, textHeight);
        self.folderPositionLabel.text = self.originFolderPath;
        folderPositionWhiteView.frame = CGRectMake(0, folderNameWhiteView.bottom + 12, kScreen_Width, textHeight + 45.5);
    }
    
    self.folderPositionLabel.numberOfLines = 0;
    [folderPositionWhiteView addSubview:self.folderPositionLabel];
    
}

@end


















