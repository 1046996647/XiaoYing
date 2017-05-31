//
//  DelegateDetailsTableView.m
//  XiaoYing
//
//  Created by Li_Xun on 16/5/11.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DelegateDetailsTableView.h"
#import "performPeopleCollectionViewCell.h"


@interface DelegateDetailsTableView ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation DelegateDetailsTableView
@synthesize CV,cellTasks,delegateTitle,progressTitle,progressImage,delegatePeopleTitle,delegatePeopleName,startTimeTitle,startDetailedTime,endTimeTitle,endDetailedTime,performPeopleCollection,scalingBtn1,scalingBtn2,line;

BOOL d[2];

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.rowHeight = 152;
    self.sectionFooterHeight = 0;
    [self initializeCollectionView];
    return self;
}

//表格视图的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//初始化集合时候与 任务块的表格视图
-(void)initializeCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 6;
    CV = [[UICollectionView alloc]initWithFrame:CGRectMake(12, 0, kScreen_Width-24, 152) collectionViewLayout:layout];
    [CV registerClass:[performPeopleCollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];
    CV.backgroundColor = [UIColor clearColor];
    CV.scrollEnabled = NO;
    CV.delegate = self;
    CV.dataSource = self;
    cellTasks = [[DelegateTasksTableView alloc]initWithFrame:CGRectMake(0, 8.5, kScreen_Width, 500) style:UITableViewStylePlain];
}

//表格视图的单元格数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL open = d[section];
    if (open == NO) {
        return 1;
    }
    return 0;
}

//表格视图单元格初始化
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellid7";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell addSubview:CV];
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        [cell addSubview:cellTasks];
    }
    
    return cell;
}


//表格视图单元格的高度设置
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 152;
    }else
    {
        return 500;
    }
}

//表格cell点击事件函数
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//集合单元格大小设置
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    //每行5个Cell
    CGFloat cellWidth = (screenWith - 10 *8) / 5;
    return CGSizeMake(cellWidth, 63);
}

//集合
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 15, 0);
}

//自定义表头函数;
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    [self tabViewHeadInitialize:headView headerInSection:section];
    
    return headView;
}

//表格视图表头高度设置
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 145;
    }
    if (section == 1) {
        return 44;
    }
    return 0;
}

//收起按钮点击事件函数
-(void)scalingEvent:(UIButton *)btn
{
    int sub = (int)btn.tag;
    d[sub] =!d[sub];
    btn.selected =! btn.selected;
    [self reloadData];
}

//集合视图的cell数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

//集合视图的单元格初始化
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"identifier";
    performPeopleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.performPeopleImage.image = [UIImage imageNamed:@"enen2"];
//    [cell.performPeopleImage setImage:[UIImage imageNamed:@"enen2"] forState:UIControlStateDisabled];
//    cell.performPeopleImage.enabled = NO;
    cell.performPeopleName.text = @"李 先 生";
    
    return cell;
}

-(void)tabViewHeadInitialize:(UIView *)headView headerInSection:(NSInteger)section
{
    if (section == 0) {
        
        delegateTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 16, 40, 16)];
        delegateTitle.text = @"标题";
        delegateTitle.font = [UIFont systemFontOfSize:16];
        [headView addSubview:delegateTitle];
        
        progressTitle = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width-120-12, 20, 120, 12)];
        progressTitle.text = @"已完成 : 50%";
        progressTitle.textAlignment = NSTextAlignmentRight;
        progressTitle.font = [UIFont systemFontOfSize:12];
        NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:progressTitle.text];
        [attribute1 setAttributes:@{
                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"]
                                    } range:NSMakeRange(0, 5)];
        [attribute1 setAttributes:@{
                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#02bb00"]
                                    } range:NSMakeRange(5, progressTitle.text.length - 5)];
        progressTitle.attributedText = attribute1;
        [headView addSubview:progressTitle];
        
        progressImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 42, (kScreen_Width - 24)/2, 4)];
        progressImage.image = [UIImage imageNamed:@"progress"];
        progressImage.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [headView addSubview:progressImage];
        
        
        delegatePeopleTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 52, 58, 12)];
        delegatePeopleTitle.text = @"委  派  人 :";
        delegatePeopleTitle.textColor = [UIColor colorWithHexString:@"#848484"];
        delegatePeopleTitle.font = [UIFont systemFontOfSize:12];
        [headView addSubview:delegatePeopleTitle];
        
        delegatePeopleName = [[UILabel alloc]initWithFrame:CGRectMake(71, 52, 58, 12)];
        delegatePeopleName.text = @"李先生";
        delegatePeopleName.textColor = [UIColor colorWithHexString:@"#848484"];
        delegatePeopleName.font = [UIFont systemFontOfSize:12];
        [headView addSubview:delegatePeopleName];
        
        startTimeTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 70, 58, 12)];
        startTimeTitle.text = @"开始时间 :";
        startTimeTitle.textColor = [UIColor colorWithHexString:@"#848484"];
        startTimeTitle.font = [UIFont systemFontOfSize:12];
        [headView addSubview:startTimeTitle];
        
        startDetailedTime = [[UILabel alloc]initWithFrame:CGRectMake(71, 70, 90, 12)];
        startDetailedTime.text = @"2016-12-01";
        startDetailedTime.textColor = [UIColor colorWithHexString:@"#848484"];
        startDetailedTime.font = [UIFont systemFontOfSize:12];
        [headView addSubview:startDetailedTime];
        
        endTimeTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 88, 58, 12)];
        endTimeTitle.text = @"结束时间 :";
        endTimeTitle.textColor = [UIColor colorWithHexString:@"#848484"];
        endTimeTitle.font = [UIFont systemFontOfSize:12];
        [headView addSubview:endTimeTitle];
        
        endDetailedTime = [[UILabel alloc]initWithFrame:CGRectMake(71, 88, 90, 12)];
        endDetailedTime.text = @"2017-12-01";
        endDetailedTime.textColor = [UIColor colorWithHexString:@"#848484"];
        endDetailedTime.font = [UIFont systemFontOfSize:12];
        [headView addSubview:endDetailedTime];
        
        performPeopleCollection = [[UILabel alloc]initWithFrame:CGRectMake(12, 115, 120, 16)];
        performPeopleCollection.text = @"执行人 ( 14 )";
        performPeopleCollection.textColor = [UIColor colorWithHexString:@"#848484"];
        performPeopleCollection.font = [UIFont systemFontOfSize:16];
        NSMutableAttributedString *attribute2 = [[NSMutableAttributedString alloc] initWithString:performPeopleCollection.text];
        [attribute2 setAttributes:@{
                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"]
                                    } range:NSMakeRange(0, 4)];
        [attribute2 setAttributes:@{
                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"]
                                    } range:NSMakeRange(4, performPeopleCollection.text.length - 4)];
        performPeopleCollection.attributedText = attribute2;
        [headView addSubview:performPeopleCollection];
        
        scalingBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width-52, 119, 40, 12)];
        [scalingBtn1 setTitleColor:[UIColor colorWithHexString:@"02bb00"] forState:UIControlStateNormal];
        scalingBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
        scalingBtn1.tag = section;

        [scalingBtn1 setTitle:@"收起" forState:UIControlStateNormal];
        [scalingBtn1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [scalingBtn1 addTarget:self action:@selector(scalingEvent:) forControlEvents:UIControlEventTouchDown];
        [headView addSubview:scalingBtn1];
        if (d[section] == NO) {
            [scalingBtn1 setTitle:@"收起" forState:UIControlStateNormal];
            
        }else
        {
            [scalingBtn1 setTitle:@"展开" forState:UIControlStateNormal];
            
        }
        
        line = [[UIImageView alloc]initWithFrame:CGRectMake(12, 144.5, kScreen_Width-24, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [headView addSubview:line];
        
    }
    if (section == 1) {
        
        performPeopleCollection = [[UILabel alloc]initWithFrame:CGRectMake(12, 14, 120, 16)];
        performPeopleCollection.text = @"任务 ( 3 )";
        performPeopleCollection.textColor = [UIColor colorWithHexString:@"#848484"];
        performPeopleCollection.font = [UIFont systemFontOfSize:16];
        NSMutableAttributedString *attribute2 = [[NSMutableAttributedString alloc] initWithString:performPeopleCollection.text];
        [attribute2 setAttributes:@{
                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"]
                                    } range:NSMakeRange(0, 3)];
        [attribute2 setAttributes:@{
                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"]
                                    } range:NSMakeRange(3, performPeopleCollection.text.length - 3)];
        performPeopleCollection.attributedText = attribute2;
        [headView addSubview:performPeopleCollection];
        
        scalingBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width-52, 18, 40, 12)];
        [scalingBtn2 setTitleColor:[UIColor colorWithHexString:@"02bb00"] forState:UIControlStateNormal];
        scalingBtn2.titleLabel.font = [UIFont systemFontOfSize:12];
        scalingBtn2.tag = section;
        [scalingBtn2 setTitle:@"收起" forState:UIControlStateNormal];
        [scalingBtn2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [scalingBtn2 addTarget:self action:@selector(scalingEvent:) forControlEvents:UIControlEventTouchDown];
        [headView addSubview:scalingBtn2];
        if (d[section] == NO) {
            [scalingBtn2 setTitle:@"收起" forState:UIControlStateNormal];
            
        }else
        {
            [scalingBtn2 setTitle:@"展开" forState:UIControlStateNormal];
            
        }
        line = [[UIImageView alloc]initWithFrame:CGRectMake(12, 43.5, kScreen_Width-24, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [headView addSubview:line];
    }
}



@end
