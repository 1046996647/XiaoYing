//
//  XYNoteViewController.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/8.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYNoteViewController.h"
#import "XYNoteCell.h"
#import "XYAddNewNoteVc.h"
#import "XYNoteCountViewController.h"
#import "XYNoteTool.h"

@interface XYNoteViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIButton * _addNoteButton;
    UIImageView * _addImageView;
    UILabel * _titleLabel;
    UITableView * _tableView;
    UILabel * _iconLabel;
    
    UIView * _addView;
    UIView * _iconView;
    
}
@property (nonatomic, strong) NSMutableArray *modalsArrM;

@end

@implementation XYNoteViewController
- (NSMutableArray *)modalsArrM {
    if (!_modalsArrM) {
        _modalsArrM = [[NSMutableArray alloc] init];
    }
    return _modalsArrM;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initNoteData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.navigationItem.title = @"小赢计划";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
//    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    
    
    //设置导航栏的背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:0];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
    @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self initUI];
    
    
    //调整UITbaleView底部的分割线
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)initUI{
    
    
    _addView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreen_Width - 10, 44)];
    [self.view addSubview:_addView];
    
    _addView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _addView.userInteractionEnabled = YES;
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_addView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _addView.bounds;
    maskLayer.path = maskPath.CGPath;
    _addView.layer.mask = maskLayer;
    
    UITapGestureRecognizer * labelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLabel)];
    [_addView addGestureRecognizer:labelTap];
    
    
#warning 待会要进行记录 这方法很不错我很喜欢 哈哈哈哈!!!
 
    //Label里面的subViews
    _addImageView = [[UIImageView alloc]init];
    [_addView addSubview:_addImageView];
    [_addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_addView.mas_left).offset(12);
        make.centerY.equalTo(_addView.mas_centerY);
        make.width.height.equalTo(@20);
        
    }];
    _addImageView.image = [UIImage imageNamed:@"add_orange"];
    
    _titleLabel = [[UILabel alloc]init];
    [_addView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_addImageView.mas_right).offset(12);
        make.centerY.equalTo(_addView.mas_centerY);
        
    }];
    
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    _titleLabel.text = @"添加便签";
    [_titleLabel sizeToFit];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _addView.bottom + 10, kScreen_Width-10,kScreen_Height -74 - _addView.bottom - 49)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor clearColor];

    
    
   

}

#pragma mark dataSource
//多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.modalsArrM.count;
}

//每行cell展示什么内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
/*
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = @"标签";
    cell.detailTextLabel.text = @"17:00";
    
    
    return cell;

  */

    
    XYNoteCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[XYNoteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setNoteData:self.modalsArrM[indexPath.row]];
//    cell.iconView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];

    return cell;

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    
}

//选中cell跳转的界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",indexPath.row);
    
    XYNoteCountViewController * noteCountVc = [[XYNoteCountViewController alloc]init];
    
    noteCountVc.title = @"编辑便签";
    noteCountVc.model = self.modalsArrM[indexPath.row];
    [self.navigationController pushViewController:noteCountVc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(void)clickLabel{
    
    NSLog(@"添加标签");
    XYAddNewNoteVc * addNewNoteVc = [[XYAddNewNoteVc alloc]init];
    addNewNoteVc.title = @"新建便签";
    [self.navigationController pushViewController:addNewNoteVc animated:YES];
    
    
}


//自定义左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle == UITableViewCellEditingStyleDelete){ //删除模式
        
        [XYNoteTool deleteData:self.modalsArrM[indexPath.row]];
    }
    [self initNoteData]; // 重新查询数据刷新表格

}

- (void)initNoteData
{
    [self.modalsArrM removeAllObjects];
    NSArray *modals = [XYNoteTool queryData:nil];
    NSArray *tempArr = [[modals reverseObjectEnumerator] allObjects]; // 将数组倒序排列
    [self.modalsArrM addObjectsFromArray:tempArr];
    [_tableView reloadData];
}

//修改删除字体
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
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
