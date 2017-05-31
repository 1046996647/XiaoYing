//
//  SelectedDepartmentsVC.m
//  XiaoYing
//
//  Created by ZWL on 16/9/22.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "SelectedDepartmentsVC.h"
#import "JCTagListView.h"

@interface SelectedDepartmentsVC ()

@property (nonatomic, strong) JCTagListView *tagsView;
@property (nonatomic, strong) NSMutableArray *arrM;


@end

@implementation SelectedDepartmentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64)];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.view addSubview:bgView];
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString *departmentId in self.selectedArr) {
        
        if ([departmentId isEqualToString:@""]) {// 公司
            [arrM addObject:self.CompanyName];
        }
        else {// 部门
            for (NSDictionary *dic in self.departments) {
                
                if ([departmentId isEqualToString:dic[@"DepartmentId"]]) {
                    [arrM addObject:dic[@"Title"]];
                }
            }
        }

    }
    self.arrM = arrM;
    
    JCTagListView *tagsView = [[JCTagListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    tagsView.backgroundColor = [UIColor whiteColor];
    tagsView.tags = self.arrM;
    [bgView addSubview:tagsView];
    self.tagsView = tagsView;
    
    __weak typeof(self) weakSelf = self;
    [self.tagsView setCompletionBlockWithSelected:^(NSInteger index) {
        NSLog(@"______%ld______", (long)index);
        [weakSelf.arrM removeObjectAtIndex:index];
        [weakSelf.selectedArr removeObjectAtIndex:index];
        
        weakSelf.tagsView.tags = weakSelf.arrM;
        [weakSelf.tagsView.collectionView reloadData];
        
        if (weakSelf.sendBlock) {
            weakSelf.sendBlock(weakSelf.selectedArr);
        }
    }];

    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
