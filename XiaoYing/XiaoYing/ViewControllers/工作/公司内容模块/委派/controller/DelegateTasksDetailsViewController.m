//
//  DelegateTasksDetailsViewController.m
//  XiaoYing
//
//  Created by Li_Xun on 16/5/12.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DelegateTasksDetailsViewController.h"
#import "performPeopleCollectionViewCell.h"
#import "PersonalTaskDetailVC.h"
//#import "MyTableViewCell.h"
#import "CloseTaskVC.h"

@interface DelegateTasksDetailsViewController ()<UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation DelegateTasksDetailsViewController
@synthesize CV,tabView,tasksTitle,proportionTitle,completePeopleCollection,stateTitle,progressTitle,scalingBtn,taskDetailsTitle,line,taskContent,tailView;

BOOL e[2];
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"任务1";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeCollectionView];
    
    //导航栏的下一步按钮
    [self initRightBtn];
}

//导航栏的下一步按钮
- (void)initRightBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 20);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"关闭任务" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightBar];
}

- (void)closeAction
{
    CloseTaskVC *closeTaskVC = [[CloseTaskVC alloc] init];
    closeTaskVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //淡出淡入
    closeTaskVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //            self.definesPresentationContext = YES; //不盖住整个屏幕
    closeTaskVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self presentViewController:closeTaskVC animated:NO completion:nil];
}

//初始化集合时候与 任务块的表格视图
-(void)initializeCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 6;
    CV = [[UICollectionView alloc]initWithFrame:CGRectMake(12, 0, kScreen_Width-24, 152) collectionViewLayout:layout];
    [CV registerClass:[performPeopleCollectionViewCell class] forCellWithReuseIdentifier:@"identifier1"];
    CV.backgroundColor = [UIColor clearColor];
    CV.scrollEnabled = NO;
    CV.delegate = self;
    CV.dataSource = self;
    
    tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64) style:UITableViewStyleGrouped];
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.separatorStyle = UITableViewCellStyleDefault;
    tabView.sectionFooterHeight = 0;
    tabView.backgroundColor = [UIColor whiteColor];
    tabView.allowsSelection = NO;
    self.edgesForExtendedLayout=NO;
    [self.view addSubview:tabView];
    
    
}

//集合视图的cell数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

//集合视图的单元格初始化
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"identifier1";
    performPeopleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.performPeopleImage.image = [UIImage imageNamed:@"enen2"];
//    [cell.performPeopleImage setImage:[UIImage imageNamed:@"enen2"] forState:UIControlStateNormal];
    cell.statePrompt.backgroundColor = [UIColor colorWithHexString:@"#02bb00"];
    cell.statePrompt.text = @"完成";
    cell.performPeopleName.text = @"顾 倾 城";
    
    return cell;
}

//集合视图 单元格点击
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"集合点击");
    [self.navigationController pushViewController:[[PersonalTaskDetailVC alloc]init] animated:YES];
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

//表格视图分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//表格视图单元格数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL open = e[section];
    if (open == NO) {
        return 1;
    }
    return 0;
}

//表格视图单元格设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellid9";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    if (indexPath.section == 0 &&indexPath.row == 0) {
        cell.backgroundColor = [UIColor whiteColor];
        [cell addSubview:CV];
    }else if(indexPath.section == 1 &&indexPath.row == 0)
    {
//        cell.backgroundColor = [UIColor orangeColor];
        taskContent = [[UILabel alloc]init ];//]WithFrame:CGRectMake(0, 0, 100, 50)];
        taskContent.numberOfLines = 0;
        taskContent.font = [UIFont systemFontOfSize:16];
        taskContent.text = @"任务完成汇报任务完成汇报任务完成汇报任务完成汇报任务完成汇报任务完成汇报";
        NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0]};
        CGSize contentSize1 = [taskContent.text boundingRectWithSize:CGSizeMake(kScreen_Width - 26, MAXFLOAT)
                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                               attributes:attributes
                                                  context:nil].size;
        taskContent.frame = CGRectMake(13, 5, kScreen_Width - 26, contentSize1.height );
        [cell addSubview:taskContent];
        
        
    }
    
    return cell;
}


//表格自定义表头函数;
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    [self tabViewHeadInitialize:headView headerInSection:section];
    return headView;
}

//收起按钮点击事件函数
-(void)scalingEvent:(UIButton *)btn
{
    int sub = (int)btn.tag;
    e[sub] =!e[sub];
    btn.selected =! btn.selected;
    [tabView reloadData];
}

//表格视图单元格的高度设置
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 152;
    }
    if (indexPath.section == 1) {
        return taskContent.frame.size.height + 150;
    }
    
    return 0;
  
}

//表格视图表头高度设置
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 98;
    }
    if (section == 1) {
        return 44;
    }
    return 0;
}

//表格表头初始化
-(void)tabViewHeadInitialize:(UIView *)headView headerInSection:(NSInteger)section
{
    
    if (section == 0) {
        tasksTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 16, 80, 16)];
        tasksTitle.text = @"标题";
        tasksTitle.font = [UIFont systemFontOfSize:16];
        tasksTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        [headView addSubview:tasksTitle];
        
        proportionTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 38, 140, 12)];
        proportionTitle.text = @"任务比重 : 高";
        proportionTitle.font = [UIFont systemFontOfSize:12];
        NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:proportionTitle.text];
        [attribute1 setAttributes:@{
                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"]
                                    } range:NSMakeRange(0, 5)];
        [attribute1 setAttributes:@{
                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#fc5834"]
                                    } range:NSMakeRange(5, proportionTitle.text.length - 5)];
        proportionTitle.attributedText = attribute1;
        [headView addSubview:proportionTitle];
        
        completePeopleCollection = [[UILabel alloc]initWithFrame:CGRectMake(12, 66, 140, 12)];
        completePeopleCollection.text = @"完成人 : (14)";
        completePeopleCollection.font = [UIFont systemFontOfSize:16];
        NSMutableAttributedString *attribute2 = [[NSMutableAttributedString alloc] initWithString:completePeopleCollection.text];
        [attribute2 setAttributes:@{
                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#333333"]
                                    } range:NSMakeRange(0, 4)];
        [attribute2 setAttributes:@{
                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"]
                                    } range:NSMakeRange(4, completePeopleCollection.text.length - 4)];
        completePeopleCollection.attributedText = attribute2;
        [headView addSubview:completePeopleCollection];
        
        stateTitle = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 112, 20, 100, 12)];
        stateTitle.text = @"进行中";
        stateTitle.font = [UIFont systemFontOfSize:12];
        stateTitle.textAlignment = NSTextAlignmentRight;
        stateTitle.textColor = [UIColor colorWithHexString:@"#f99740"];
        [headView addSubview:stateTitle];
        
        progressTitle = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 112, 38, 100, 12)];
        progressTitle.text = @"完成人数 : 2/14";
        progressTitle.font = [UIFont systemFontOfSize:12];
        progressTitle.textAlignment = NSTextAlignmentRight;
        NSMutableAttributedString *attribute3 = [[NSMutableAttributedString alloc] initWithString:progressTitle.text];
        [attribute3 setAttributes:@{
                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"]
                                    } range:NSMakeRange(0, 6)];
        [attribute3 setAttributes:@{
                                    NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#02bb00"]
                                    } range:NSMakeRange(6, progressTitle.text.length - 6)];
        progressTitle.attributedText = attribute3;
        [headView addSubview:progressTitle];
        
        scalingBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width-52, 70, 40, 12)];
        [scalingBtn setTitleColor:[UIColor colorWithHexString:@"02bb00"] forState:UIControlStateNormal];
        scalingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        scalingBtn.tag = section;
        [scalingBtn setTitle:@"收起" forState:UIControlStateNormal];
        [scalingBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [scalingBtn addTarget:self action:@selector(scalingEvent:) forControlEvents:UIControlEventTouchDown];
        [headView addSubview:scalingBtn];
        if ( e[section]== NO) {
            [scalingBtn setTitle:@"收起" forState:UIControlStateNormal];
            
        }else
        {
            [scalingBtn setTitle:@"展开" forState:UIControlStateNormal];
            
        }
        line = [[UIImageView alloc]initWithFrame:CGRectMake(12, 97.5, kScreen_Width-24, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [headView addSubview:line];
    }
    
    if (section == 1) {
        taskDetailsTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 14, 120, 16)];
        taskDetailsTitle.text = @"任务详情";
        taskDetailsTitle.font = [UIFont systemFontOfSize:16];
        taskDetailsTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        [headView addSubview:taskDetailsTitle];
        
        line = [[UIImageView alloc]initWithFrame:CGRectMake(12, 43.5, kScreen_Width-24, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
        [headView addSubview:line];
//        NSArray *arr = @[@{@"Jian":@"zhangsan",@"Zhi":@"lisi"},@{@"":@"",@"":@""}];
    }
}

@end
