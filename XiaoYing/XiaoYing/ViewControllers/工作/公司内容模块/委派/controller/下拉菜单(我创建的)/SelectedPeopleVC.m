//
//  SelectedPeopleVc.m
//  XiaoYing
//
//  Created by ZWL on 16/5/23.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "SelectedPeopleVC.h"
#import "SelectedPeopleCell.h"
#import "ConnectModel.h"

@interface SelectedPeopleVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *arrM;


@end

@implementation SelectedPeopleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64)];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.view addSubview:bgView];
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    if (self.selectedEmpArr.count > 0) {
        for (NSString *employeeId in self.selectedEmpArr) {
            for (NSDictionary *dic in self.employees) {
                if ([employeeId isEqualToString:dic[@"ProfileId"]]) {
                    EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
                    [arrM addObject:model];
                }
            }
        }
    }
    else {
        
        // 用于判断是否是同一人数组
        NSMutableArray *arrM2 = [NSMutableArray array];

        for (NSString *profileId in self.selectedArr) {
            
            // 好友的
            for (ConnectWithMyFriend *friend in self.friends) {
                if ([profileId isEqualToString:friend.ProfileId]) {
                    EmployeeModel *model = [[EmployeeModel alloc] init];
                    model.FaceURL = friend.FaceUrl;
                    model.EmployeeName = friend.Nick;
                    model.ProfileId = friend.ProfileId;
                    [arrM addObject:model];
                    [arrM2 addObject:friend.ProfileId];

                }
            }
            
            // 员工的
            for (NSDictionary *dic in self.employees) {
                
                
                if ([profileId isEqualToString:dic[@"ProfileId"]]) {
                    
                    EmployeeModel *model = [[EmployeeModel alloc] initWithContentsOfDic:dic];
                    
                    if (![arrM2 containsObject:model.ProfileId]) {
                        [arrM addObject:model];

                    }
                    
                }
                

            }
        }
        

    }

    self.arrM = arrM;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 26;
    layout.minimumInteritemSpacing = 6;
    layout.itemSize = CGSizeMake((kScreen_Width-6*6)/5, (kScreen_Width-6*6)/5);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 300) collectionViewLayout:layout];
    [collectionView registerClass:[SelectedPeopleCell class] forCellWithReuseIdentifier:@"identifier"];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.contentInset = UIEdgeInsetsMake(20, 6, 26, 6);
    [bgView addSubview:collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//集合视图的cell数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrM.count;
}

//集合视图的单元格初始化
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"identifier";
    SelectedPeopleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.deleteBlock = ^(EmployeeModel *model) {
        
        if (self.selectedEmpArr.count > 0) {
            
            [_selectedEmpArr removeObject:model.ProfileId];
            [_arrM removeObject:model];
            
            if (_sendBlock) {
                _sendBlock(_selectedEmpArr);
            }
        }
        else {
            [_selectedArr removeObject:model.ProfileId];
            [_arrM removeObject:model];
            // 数据刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kDataRefreshNotification" object:nil];
        }
        
        [collectionView reloadData];

    };

    EmployeeModel *model = _arrM[indexPath.item];
    cell.model = model;
//    NSLog(@"%@",model.EmployeeName);

    if (!self.selectedEmpArr) {
        cell.dutyLab.hidden = YES;
    };
    
    // 调用layoutsubviews（collectionView数据刷新还是重写model的setter方法较好）
    [cell setNeedsLayout];
    
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    if ([touches anyObject].view == self.view) {
//        
//         [self dismissViewControllerAnimated:YES completion:nil];
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
