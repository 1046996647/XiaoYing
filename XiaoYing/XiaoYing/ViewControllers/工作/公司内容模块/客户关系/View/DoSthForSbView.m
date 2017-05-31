//
//  DoSthForSbView.m
//  XiaoYing
//
//  Created by ZWL on 16/1/31.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DoSthForSbView.h"
#import "DoSthCell.h"
@interface DoSthForSbView()
{
    
}
@property (nonatomic,strong)UITableView *table1;

@end

@implementation DoSthForSbView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        //初始化UI控件
        [self initUI];
    }
    return self;
}
- (void)initUI{
    self.table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64)];
    self.table1.delegate = self;
    self.table1.dataSource = self;
    self.table1.backgroundColor = [UIColor clearColor];
    self.table1.showsVerticalScrollIndicator = NO;
    [self addSubview:self.table1];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DoSthCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[DoSthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
