//
//  MyCustomerView.m
//  XiaoYing
//
//  Created by ZWL on 16/1/31.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "MyCustomerView.h"
#import "MyCustomerCell.h"
#import "FootView.h"
#import "CustomCommemorationVC.h"
#import "RelationVC.h"
#import "CrowdSendMessageVC.h"
@interface MyCustomerView()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *arrA_Z;
}
@property (nonatomic,strong) UITableView *table2;
@property (nonatomic,strong) FootView *footView;//下面的脚

@end

@implementation MyCustomerView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        arrA_Z = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"G",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
        [self initUI];
        
    }
    return self;
}
- (void)initUI{
    
    self.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
    searchBar.placeholder = @"查找好友";
//    searchBar.translucent = YES;
//    searchBar.barStyle = UIBarStyleBlackTranslucent;
//    searchBar.showsCancelButton = YES;
    [searchBar sizeToFit];
    self.table2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-44)];
    self.table2.delegate = self;
    self.table2.dataSource = self;
    [self.table2 setTableHeaderView:searchBar];
    self.table2.backgroundColor = [UIColor clearColor];
    self.table2.sectionIndexColor = [UIColor colorWithHexString:@"#848484"];
    [self addSubview:self.table2];
    
    self.footView = [[FootView alloc] initWithFrame:CGRectMake(0, kScreen_Height-44-64, kScreen_Width, 44)];
    self.footView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.footView];
    
    [self.footView.leftbt setTitle:@"客户纪念日" forState:UIControlStateNormal];
    [self.footView.leftbt setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    [self.footView.leftbt addTarget:self action:@selector(customMemorationWay:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footView.rightbt setTitle:@"群发消息" forState:UIControlStateNormal];
    [self.footView.rightbt setTitleColor:[UIColor colorWithHexString:@"#f99740"] forState:UIControlStateNormal];
    [self.footView.rightbt addTarget:self action:@selector(customMemorationWay:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)customMemorationWay:(UIButton *)bt{
    if (bt.tag == 10002) {
        NSLog(@"群发消息");
        CrowdSendMessageVC *CustomVC  =[[CrowdSendMessageVC alloc]init];
        for (UIView *next = [self superview]; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            
            if ([nextResponder isKindOfClass:[RelationVC class]]) {
                RelationVC *vc = (RelationVC *)nextResponder;
                
                CustomVC.title = @"群发短信";
                vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                
                [vc.navigationController pushViewController:CustomVC animated:YES];
            }
        }

    }else if (bt.tag == 10001){
        CustomCommemorationVC *CustomVC  =[[CustomCommemorationVC alloc]init];
        for (UIView *next = [self superview]; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            
            if ([nextResponder isKindOfClass:[RelationVC class]]) {
                RelationVC *vc = (RelationVC *)nextResponder;
                
                CustomVC.title = @"客户纪念日";
                vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                
                [vc.navigationController pushViewController:CustomVC animated:YES];
            }
        }

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return arrA_Z.count;;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 29;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    
    view.tintColor = [UIColor colorWithHexString:@"#efeff4"];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCustomerCell *cell = nil;
    
    cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[MyCustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *key = [arrA_Z objectAtIndex:section];
    
    return key;
    
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    
    return arrA_Z;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
