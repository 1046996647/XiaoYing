//
//  CellDetail.m
//  XiaoYing
//
//  Created by MengFanBiao on 16/6/21.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "CellDetail.h"
#import "WangUrlHelp.h"
#import "SendMemoryModel.h"
#import "NewMemoryModel.h"
#import "NewMemoryCell.h"
#import "CompanyDetailModel.h"
//#import "ImageBrowseVC.h"
@interface CellDetail ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIScrollView *scrollView;//滚动视图
@property(nonatomic,strong)UILabel *titleLabel;//标题label
@property(nonatomic,strong)UILabel *sectionLabel;//范围label
@property(nonatomic,strong)UILabel *timeLabel;//日期label
@property(nonatomic,strong)UITableView *contentTableView;//内容的表视图
@property(nonatomic,strong)NSMutableArray *dataArray;//装载内容的数组
@property(nonatomic,strong)MBProgressHUD *hud;//菊花
@end

@implementation CellDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self loadData];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"正在加载中";
    
}

- (void)initUI {
    
    self.title = @"公告详情";
    
    _dataArray = [NSMutableArray array];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _scrollView.scrollEnabled = YES;
    [self.view addSubview:_scrollView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(6, 8, kScreen_Width - 30, 16)];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLabel.text = @"标题";
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [_scrollView addSubview:_titleLabel];
    
    
    _sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(6, _titleLabel.bottom + 3, kScreen_Width - 30, 12)];
    _sectionLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    _sectionLabel.text = @"科技产业部";
    _sectionLabel.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:_sectionLabel];
    
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _timeLabel.numberOfLines = 0;
    NSString *string = @"2016-11-17 09:48:27";
    _timeLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.text = string;
    NSDictionary *attr = @{NSFontAttributeName:_timeLabel.font};
    CGFloat Width = [UIScreen mainScreen].bounds.size.width;
    CGSize maxS = CGSizeMake(Width, MAXFLOAT);
    CGSize size1 = [string boundingRectWithSize:maxS options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    _timeLabel.frame = CGRectMake(6, _sectionLabel.bottom + 3, size1.width + 20, size1.height);
    [_scrollView addSubview:_timeLabel];
    
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(6, _timeLabel.bottom + 7, kScreen_Width - 12, _scrollView.height - _timeLabel.bottom - 10) style:UITableViewStylePlain];
    _contentTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    //去除cell的分割线
    _contentTableView.separatorStyle = NO;
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.showsVerticalScrollIndicator = NO;
    _contentTableView.bounces = NO;
    _contentTableView.allowsSelection = YES;
    
    //让contenTableView禁止滚动
    [_scrollView addSubview:_contentTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];//以indexPath来唯一确定cell
    NewMemoryCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NewMemoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.row = indexPath.row;
    cell.count = _dataArray.count;
    cell.model = _dataArray[indexPath.row];
    NSLog(@"model.text:%@",cell.model.text);
    
    cell.allowEditing = NO;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewMemoryModel *model = _dataArray[indexPath.row];
    if (model.fileType == FileTypeImage) {
        ImageBrowseVC *vc = [[ImageBrowseVC alloc]init];
        NSString *formatUrl = model.dic[@"FormatUrl"];
        NSString *subStr = [NSString replaceString:formatUrl Withstr1:@"1000" str2:@"1000" str3:@"c"];
        vc.urlStr = subStr;
        [self presentViewController:vc
                           animated:YES completion:nil];
    }
}

- (float) heightForString:(NSString *)value andWidth:(float)width{
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:attributes        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height + 16.0;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewMemoryModel *model = _dataArray[indexPath.row];
    
    if (model.fileType ==  FileTypeImage) {
        return 200;
    }
    else {
        
        model.cellHeight = [self heightForString:model.text andWidth:kScreen_Width-24];
        
        if (model.cellHeight > 36) {
            
            return model.cellHeight;
        }
        return 36;
        
    }
}

//网络数据加载
-(void)loadData{
    NSString *urlStr = AFFICHE_DETAIL,_afficheid];
    [AFNetClient GET_Path:urlStr completed:^(NSData *stringData, id JSONDict) {
            NSNumber *code = [JSONDict objectForKey:@"Code"];
    if ([code isEqual:@0]) {
        NSLog(@"查看公告详情>>>> 成功----%@", JSONDict);
        CompanyDetailModel *detailModel = [[CompanyDetailModel alloc]initWithDic:JSONDict[@"Data"]];
        _timeLabel.text = detailModel.CreateTime;
        _titleLabel.text = detailModel.Title;
        _sectionLabel.text = [self getNameFromString:detailModel.Creator];
        SendMemoryModel *model = [[SendMemoryModel alloc]initWithContentsOfDic:JSONDict[@"Data"]];
        for (NSDictionary *subDic in model.dataArr) {
            NewMemoryModel *model = [[NewMemoryModel alloc] init];
            
            NSInteger num = [subDic[@"type"] integerValue];
            
            if (1 == num) {
                model.text = subDic[@"content"];
                model.dic = subDic[@"content"];
                model.fileType = FileTypeImage;
            }
            else {
                model.text = subDic[@"content"];
                model.fileType = FileTypeText;
            }
            
            
            [_dataArray addObject:model];
            
            
        }
        [_contentTableView reloadData];
        [_hud hide:YES];
    }else{
        [_hud hide:YES];
        NSString *message = JSONDict[@"Message"];
        [MBProgressHUD showMessage:message];
    }
    } failed:^(NSError *error) {
        NSLog(@"****>>>%@", error);
        [_hud hide:YES];
        [MBProgressHUD showMessage:@"error"];
    }];
}

//获取发布公告的人的名字
-(NSString *)getNameFromString:(NSString *)profieldID{
    NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
    NSString *name = nil;
    for (NSDictionary *dic in employeesArr) {
        if ([profieldID isEqualToString:dic[@"ProfileId"]]) {
            name = dic[@"EmployeeName"];
        }
    }
    return name;
}

//重写返回事件
- (void)backAction:(UIButton *)button{
    if (self.isSearch == YES) {
        self.navigationController.navigationBarHidden = YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
