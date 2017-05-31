//
//  ManageVC.m
//  XiaoYing
//
//  Created by ZWL on 16/1/13.
//  Copyright © 2016年 ZWL. All rights reserved.

//  Created by ShanWen on 16/7/15.
//  Copyright © 2016年 ShanWen. All rights reserved.
//  更改cell布局，cell添加图片，更改点击跳转逻辑，封装cell设置图片以及更改cell背景颜色的方法

#import "ManageVC.h"
#import "WorkerMessageVC.h"
#import "ManageCollectionViewCell.h"
#import "CompanyFileManageController.h"
#import "NoticeManagerVC.h"
#import "MaintainCompanyInfoVC.h"
#import "ApproveManageVC.h"
#import "CompanyInfoVc.h"
//#import "PermissionOfWork.h"
static NSInteger const cols = 2;
static CGFloat const  margin = 10;
#define itemWH  (kScreen_Width - (cols + 1)*margin) /cols

@interface ManageVC ()

@property (nonatomic,strong) UICollectionView *ManageCollectionView;
@property (nonatomic,strong) NSArray *departments;
@property (nonatomic,strong) NSArray *enableArray;
@end

@implementation ManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"综合管理";
    
    //初始化界面
    [self initUI];
    [self getPermissionsOfManagement];
}



- (void)getPermissionsOfManagement{
    
    NSMutableArray * arr1 = [NSMutableArray arrayWithObjects:@"5",@"5", nil];
    NSMutableArray * arr2 = [NSMutableArray arrayWithObjects:@"5",@"5", nil];
    NSMutableArray * arr3 = [NSMutableArray arrayWithObjects:@"0",@"0", nil];
    
    NSMutableArray *array = [ZWLCacheData unarchiveObjectWithFile:PermissionsPath];
    for (NSMutableDictionary *dic in array) {
        if ([dic[@"Name"] isEqualToString:@"企业信息管理"]) {
            [arr1 replaceObjectAtIndex:0 withObject:dic[@"Enable"]];
        }
        if ([dic[@"Name"] isEqualToString:@"组织架构管理"]) {
            [arr1 replaceObjectAtIndex:1 withObject:dic[@"Enable"]];
        }
        if ([dic[@"Name"] isEqualToString:@"权限管理"]) {
            [arr2 replaceObjectAtIndex:0 withObject:dic[@"Enable"]];
        }
        if ([dic[@"Name"] isEqualToString:@"审批类型管理"]) {
            [arr2 replaceObjectAtIndex:1 withObject:dic[@"Enable"]];
        }
        if ([dic[@"Name"] isEqualToString:@"公告管理"]) {
            [arr3 replaceObjectAtIndex:0 withObject:dic[@"Enable"]];
        }
        if ([dic[@"Name"] isEqualToString:@"企业文档管理"]) {
            [arr3 replaceObjectAtIndex:1 withObject:dic[@"Enable"]];
        }
        
    }
     _enableArray = [NSArray arrayWithObjects:arr1, arr2, arr3, nil];
}



- (void)initUI{
    
    //1.创建layout布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    //2.创建collectionView
    self.ManageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) collectionViewLayout:flowLayout];
    
    //3.设置collectioViewCell的代理和数据源
    self.ManageCollectionView.delegate = self;
    self.ManageCollectionView.dataSource = self;
    [self.ManageCollectionView setBackgroundColor:[UIColor clearColor]];
    
    [self.ManageCollectionView registerClass:[ManageCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    self.ManageCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.ManageCollectionView];
    

}


//collectionView中有多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 3;
}

//collectionView中每组显示多少个item
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 2;
}

//展示每个cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"UICollectionViewCell";
    ManageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *permissionEnable = _enableArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            if ([permissionEnable isEqual:@1]) {

                [cell cellImageName:@"information_m_white" andBackgroundColor:@"#f75b5c"];
            }else {
      
                [cell cellImageName:@"information_m_gray" andBackgroundColor:@"#d6d7dc"];
            }
            
        }else{
    
            if ([permissionEnable isEqual:@1]) {

                [cell cellImageName:@"organization_m_white" andBackgroundColor:@"#ffcc4c"];
            }else {
                [cell cellImageName:@"organization_m_gray" andBackgroundColor:@"#d6d7dc"];
            }
            
        }
    }
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            
            if ([permissionEnable isEqual:@1]) {
                
                [cell cellImageName:@"permissions_m_white" andBackgroundColor:@"#fea700"];
            }else {
                [cell cellImageName:@"quanxian_white" andBackgroundColor:@"#d6d7dc"];
            }

        }else{
          
            if ([permissionEnable isEqual:@1]) {

                [cell cellImageName:@"approval_m_white" andBackgroundColor:@"#60c8f7"];
            }else {
                [cell cellImageName:@"approval_m_gray" andBackgroundColor:@"#d6d7dc"];
            }

        }
    }
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
          
            if ([permissionEnable isEqual:@1]) {
                
                [cell cellImageName:@"notice_m_white" andBackgroundColor:@"#27cd8f"];
            }else {
                [cell cellImageName:@"gonggao_white" andBackgroundColor:@"#d6d7dc"];
            }
            
        }else{
            
            if ([permissionEnable isEqual:@1]) {

                [cell cellImageName:@"file_m_white" andBackgroundColor:@"#808eca"];
            }else {
                 [cell cellImageName:@"qiye_white" andBackgroundColor:@"#d6d7dc"];
            }

        }
    }
    
    return cell;
}

//设置item的尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(itemWH, itemWH);
}

//设置item之间的内边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(margin, margin, 0, margin);
}

//选择item进行跳转
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *permissionEnable = _enableArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {

            if ([permissionEnable isEqual:@1]) {
                CompanyInfoVc *infoVC = [[CompanyInfoVc alloc]init];
                infoVC.title = @"企业信息管理";
                [self.navigationController pushViewController:infoVC animated:YES];
            }else {
                [MBProgressHUD showMessage:@"您无权使用" toView:self.view];
            }
            
        }else
        {
            
            if ([permissionEnable isEqual:@1]) {
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                MaintainCompanyInfoVC *vc = [[MaintainCompanyInfoVC alloc]init];
                vc.title = @"组织架构管理";
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                [MBProgressHUD showMessage:@"您无权使用" toView:self.view];
            }
            
        }
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row ==0) {
            
            if ([permissionEnable isEqual:@1]) {
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                 WorkerMessageVC *vc = [[WorkerMessageVC alloc]init];
                vc.title = @"权限管理";
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                [MBProgressHUD showMessage:@"您无权使用" toView:self.view];
            }
            
        }else {
            
            if ([permissionEnable isEqual:@1]) {
                ApproveManageVC *approveVC = [[ApproveManageVC alloc] init];
                approveVC.title = @"审批类型管理";
                [self.navigationController pushViewController:approveVC animated:YES];
            }else {
                [MBProgressHUD showMessage:@"您无权使用" toView:self.view];
            }
            
        }
    }
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            if ([permissionEnable isEqual:@1]) {
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                NoticeManagerVC *vc = [[NoticeManagerVC alloc]init];
                vc.title = @"公告管理";
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                [MBProgressHUD showMessage:@"您无权使用" toView:self.view];
            }
            
        }else{
            
            if (1 | [permissionEnable isEqual:@1]) {
                CompanyFileManageController *companyFileManageController = [[CompanyFileManageController alloc] init];
                companyFileManageController.title = @"企业文档管理";
                [self.navigationController pushViewController:companyFileManageController animated:YES];

            }else {
                [MBProgressHUD showMessage:@"您无权使用" toView:self.view];
            }
        }
    }

}

- (void)backAction:(UIButton *)button {
    
    if (_differentStr.length > 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GoBackOfCreateCompany" object:nil];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];

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
