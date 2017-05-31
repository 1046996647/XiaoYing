//
//  unitcView.m
//  XiaoYing
//
//  Created by GZH on 16/7/22.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "unitcView.h"

@implementation UnitcView




- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        [self initBasic];
        
        
        
        
        self.delegate = self;
        self.dataSource = self;

        
    }
    return self;
}

- (void)initBasic {
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.7;
}


#pragma mark --tableViewDelegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];;
    cell.layer.borderWidth = 0.5;
    cell.layer.cornerRadius = 0.9;
    cell.layer.borderColor=[[UIColor whiteColor]CGColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld级单元", 5-indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
