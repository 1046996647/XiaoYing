//
//  AccordingToTimeView.m
//  XiaoYing
//
//  Created by ZWL on 16/1/30.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "AccordingToTimeView.h"
#import "StatisticsCell.h"
#import "StatisticHeadView.h"
@interface AccordingToTimeView()
{
    NSInteger cellFlag;
    
    NSInteger countFlag;
    
    NSInteger tapFlag;
}
@property (nonatomic,strong)UIView *headView;//按照时间签到的头
@property (nonatomic,strong)StatisticHeadView *statisHeadView;//下拉框

@property (nonatomic,strong)UITableView *table1;//按照时间签到的列表
@property (nonatomic,strong)UILabel *fromTimeToTimeLab;//从什么时间到什么时间
@property (nonatomic,strong)UILabel *alreadyLab;//已签
@property (nonatomic,strong)UILabel *eailyLab;//早签
@property (nonatomic,strong)UILabel *leakLab;//漏签


//headView下面的控件

@property (nonatomic,strong)UITextView *settextView;



@end
@implementation AccordingToTimeView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        countFlag = -1;
        tapFlag = 0;
        //初始化UI控件
        [self initUI];
    }
    return self;
}
//初始化UI控件
- (void)initUI{
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 70)];
    self.headView.backgroundColor = [UIColor whiteColor];
    self.headView.layer.borderColor = [[UIColor colorWithHexString:@"#d5d7dc"] CGColor];
    self.headView.layer.borderWidth = 1;
    self.headView.userInteractionEnabled = YES;
    [self addSubview:self.headView];
    
    self.statisHeadView = [[StatisticHeadView alloc] initWithFrame:CGRectMake(0, 70, kScreen_Width, 12+30+12+30+12+30+15+0.5+50)];
    self.statisHeadView.backgroundColor = [UIColor whiteColor];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(LowHead)];
    [self.headView addGestureRecognizer:tap];
    
    self.fromTimeToTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, kScreen_Width, 14)];
    self.fromTimeToTimeLab.text = @"2016-01-01~2016-01-21";
    self.fromTimeToTimeLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.fromTimeToTimeLab.font = [UIFont systemFontOfSize:14];
    self.fromTimeToTimeLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.fromTimeToTimeLab];
    
    self.alreadyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 12+14+12, kScreen_Width/2-60, 12)];
    self.alreadyLab.text = @"已签 96";
    self.alreadyLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.alreadyLab.font = [UIFont systemFontOfSize:12];
    self.alreadyLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.alreadyLab];
    
    self.eailyLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2-60, 12+14+12, 120, 12)];
    self.eailyLab.text = @"早签 1";
    self.eailyLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.eailyLab.font = [UIFont systemFontOfSize:12];
    self.eailyLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.eailyLab];
    
    self.leakLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2+60, 12+14+12, kScreen_Width/2-60, 12)];
    self.leakLab.text = @"漏签 1";
    self.leakLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.leakLab.font = [UIFont systemFontOfSize:12];
    self.leakLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.leakLab];
    
    self.table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, kScreen_Width, self.frame.size.height-80)];
    self.table1.delegate = self;
    self.table1.dataSource = self;
    [self addSubview:self.table1];
}
//下拉框
- (void)LowHead{
    if (tapFlag == 0) {
        [self addSubview:self.statisHeadView];
        tapFlag = 1;
    }else{
        [self.statisHeadView removeFromSuperview];
        tapFlag = 0;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatisticsCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[StatisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.arrowHeadImageview.tag = indexPath.section;
    [cell.arrowHeadImageview addTarget:self action:@selector(xuanzhuan:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)xuanzhuan:(UIButton *)ima{
   
    if (cellFlag == 0) {
        [ima setImage:[UIImage imageNamed:@"opinion_reading"] forState:UIControlStateNormal];
        cellFlag = 1;
         countFlag = ima.tag;
    }else{
        [ima setImage:[UIImage imageNamed:@"opinion_read"] forState:UIControlStateNormal];
        cellFlag = 0;
        countFlag = -1;
    }
    [self.table1 reloadData];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == countFlag) {
        return 50;
    }else{
        return 0.5;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView *hederView = nil;
    hederView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (hederView == nil) {
        
        hederView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"headerView"];
       
        self.settextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 0, kScreen_Width-24, 44)];
        self.settextView.textColor = [UIColor colorWithHexString:@"#333333"];
        self.settextView.text = @"因为大雪，箭筒不好，所以迟到了";
        self.settextView.font = [UIFont systemFontOfSize:12];
        self.settextView.editable = NO;
        self.settextView.layer.borderColor = [[UIColor colorWithHexString:@"#d5d7dc"] CGColor];
        self.settextView.layer.borderWidth = 0.5;
        [hederView addSubview:self.settextView];
        
        
        UIView *viewline1 = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, kScreen_Width, 0.5)];
        viewline1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [hederView addSubview:viewline1];
    }
    if (section == countFlag) {
        return hederView;
    }else{
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    
    if (section == countFlag) {
        view.tintColor = [UIColor whiteColor];
    }else{
        view.tintColor = [UIColor colorWithHexString:@"#d5d7dc"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
