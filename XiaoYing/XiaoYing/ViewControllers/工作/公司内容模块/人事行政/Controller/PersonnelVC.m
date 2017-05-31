//
//  PersonnelVC.m
//  XiaoYing
//
//  Created by MengFanBiao on 15/11/10.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "PersonnelVC.h"
#import "TabBarItem.h"

/*********************/


#import "NewcolleaguesVC.h"
#import "XYWorkCollectionViewCell.h"
#import "WorkerMessageVC.h"
#import "XYPositionViewController.h"

static NSInteger const cellH = 95;
static NSInteger const cols  = 3;
static CGFloat const margin = 0;

#define itemWH (kScreen_Width - (cols +  1)* margin)/cols

@interface PersonnelVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic, assign)BOOL haveNotification;

@end

@implementation PersonnelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title= @"人事管理";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self collectionIdear];
    
   //有新人申请加入公司请及时处理
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newStudentjoinApplyAction) name:kJoinQueueNotification object:nil];
    
    //撤销了对贵公司的加入申请
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newStudentjoinApplyAction) name:kCanaleJoinApplyNotification object:nil];

}



- (void)newStudentjoinApplyAction  {
    _haveNotification = YES;
    [self.collectionView reloadData];
}

-(void)collectionIdear
{
    //1.创建flowlayout
    UICollectionViewFlowLayout * flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.minimumInteritemSpacing = 0;
    
    //2.创建UICollectionView
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height )collectionViewLayout:flowlayout];
    
    //3.设置UICollectionView的代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //4.设置UICollectionView的属性
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];

    //5.注册UICollectionViewCell
    [self.collectionView registerClass:[XYWorkCollectionViewCell class] forCellWithReuseIdentifier:@"workCell"];
    //6.设置UICollectionView属性自适应
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    //7.添加UICollectionView
    [self.view addSubview:self.collectionView];
    
  
    
}

#pragma mark datasource
//一个collectionView里面有多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 3;

}
//每组有多少个item
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 2) {
        
        return 1;
    }
    return 3;
    
}

//设置每个item的size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(itemWH, 95);
}

//设置每个item之间的间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//设置每个cell显示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //1.cell的ID
    static NSString * ID = @"workCell";
    //2.创建cell
    XYWorkCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    //3.判断每个cell添加什么
    
    //    verLine 竖线
    //    horLine 横线
    
    //第一组
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.title = @"员工基本信息管理";
            cell.imageView.image = [UIImage imageNamed:@"information"];
            
            UIView * verLine = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width)/3-.5, (95 -20)/2, .5, 20)];
            verLine.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
            [cell.contentView addSubview:verLine];
            
            UIView  * horline = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width/3 -20)/2 , cellH -.5, 20, .5)];
            
            horline.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
            [cell.contentView addSubview:horline];

        }
        if (indexPath.row == 1) {
            cell.title = @"职位管理";
            cell.imageView.image = [UIImage imageNamed:@"position"];
            
            UIView * verLine = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width)/3-.5, (95 -20)/2, .5, 20)];
            verLine.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
            [cell.contentView addSubview:verLine];
            
            UIView  * horline = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width/3 -20)/2 , cellH -.5, 20, .5)];
            horline.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
            [cell.contentView addSubview:horline];

        }
        if (indexPath.row == 2) {
            cell.title = @"新同事";
            cell.imageView.image = [UIImage imageNamed:@"new"];

            if (_haveNotification == YES) {
                cell.padgeView.hidden = NO;
            }else {
                cell.padgeView.hidden = YES;
            }
            
            UIView  * horline = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width/3 -20)/2 , cellH -.5, 20, .5)];
            horline.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
            [cell.contentView addSubview:horline];
        
        }
    }
    
    //第二组
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            cell.title = @"员工合同管理";
            cell.imageView.image = [UIImage imageNamed:@"contract"];
            UIView * verLine = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width)/3-.5, (95 -20)/2, .5, 20)];
            verLine.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
            [cell.contentView addSubview:verLine];
            
            UIView  * horline = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width/3 -20)/2 , cellH -.5, 20, .5)];
            horline.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
            [cell.contentView addSubview:horline];

        }
        if (indexPath.row == 1) {
            
            cell.title = @"人事提醒";
            cell.imageView.image = [UIImage imageNamed:@"remind"];
            UIView * verLine = [[UIView alloc]initWithFrame:CGRectMake((kScreen_Width)/3-.5, (95 -20)/2, .5, 20)];
            verLine.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
            [cell.contentView addSubview:verLine];
        }
        if (indexPath.row == 2) {
            
            cell.title = @"招聘信息";
            cell.imageView.image = [UIImage imageNamed:@"recruitment"];

        }
    }
    
    //第三组
    if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            cell.title = @"数据备份";
            cell.imageView.image = [UIImage imageNamed:@"backup"];

        }
    }
   
    return  cell;
      
}

//点击cell进行控制器跳转
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            WorkerMessageVC * workerMessageVC = [[WorkerMessageVC alloc]init];
            workerMessageVC.title = @"员工基本信息管理";
            [self.navigationController pushViewController:workerMessageVC animated:YES];
        }
        
        if (indexPath.row == 1) {
            
            XYPositionViewController * positionVC = [[XYPositionViewController alloc]init];
            positionVC.title = @"职位管理";
            [self.navigationController pushViewController:positionVC animated:YES];
        }
        
        if (indexPath.row == 2) {
            
            NewcolleaguesVC * newWorkerVc = [[NewcolleaguesVC alloc]init];
            newWorkerVc.title = @"新同事";
            newWorkerVc.haveNotification = _haveNotification;
            if (_haveNotification == YES) {
                newWorkerVc.blockNotification = ^(NSString *str) {
                    NSLog(@"-------------------------------------------------------%@", str);
                        _haveNotification = NO;
                        [self.collectionView reloadData];
                };
            }

            [self.navigationController pushViewController:newWorkerVc animated:YES];
            
            
        }
    }
}


//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}


@end
