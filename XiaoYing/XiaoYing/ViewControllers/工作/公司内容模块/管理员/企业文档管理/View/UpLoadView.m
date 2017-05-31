//
//  UpLoadView.m
//  XiaoYing
//
//  Created by GZH on 16/7/5.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "UpLoadView.h"
#import "FileNamecell.h"
#import "DeleteDocumentController.h"
#import "CompanyFileManageController.h"
#import "VisibleRangeVC.h"
#import "DocumentUploadFileModel.h"

// 存储上传文件信息的路径（caches）
#define UploadCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"UploadCache.data"]

@interface UpLoadView()

@property (nonatomic, strong) NSMutableArray *selectedArray;//是否被点击的标识数组

@property (nonatomic, strong) NSMutableArray *ongingUploadArray; //未完成的上传数组
@property (nonatomic, strong) NSMutableArray *completeUploadArray; //已完成的上传数组

@property (nonatomic, assign) NSInteger allProgressNum; //所有的进度

@property (nonatomic, strong) UILabel *kbLabel; //显示速度的label
@property (nonatomic, strong) UILabel *timeLabel; //进度显示label

@end

@implementation UpLoadView
@synthesize completeProgressNum = _completeProgressNum;

//未完成的上传数组
- (NSMutableArray *)ongingUploadArray
{
    if (!_ongingUploadArray) {
        _ongingUploadArray = [NSMutableArray array];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:UploadCachesDirectory]) {
        DocumentUploadFileModel *documentUploadFileModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
        NSString *fileName = documentUploadFileModel.fileName;
        _ongingUploadArray = [@[fileName] mutableCopy];
    }
    return _ongingUploadArray;
}

//已完成的上传数组
- (NSMutableArray *)completeUploadArray
{
    if (!_completeUploadArray) {
        _completeUploadArray = [NSMutableArray array];
    }
    return _completeUploadArray;
}

//是否被点击的标识数组
- (NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

//____________________________________
- (NSInteger)completeProgressNum
{
    DocumentUploadFileModel *documentUploadFileModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
    _completeProgressNum = documentUploadFileModel.fileCompleteUploadNum;
    return _completeProgressNum;
}

- (void)setCompleteProgressNum:(NSInteger)completeProgressNum
{
    _completeProgressNum = completeProgressNum;
    self.timeLabel.text = [NSString stringWithFormat:@"%ldKB / %ldKB", (long)self.completeProgressNum, (long)self.allProgressNum];
}

//____________________________________
- (NSInteger)allProgressNum
{
    DocumentUploadFileModel *documentUploadFileModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
    _allProgressNum = documentUploadFileModel.fileSize / 1024;
    return _allProgressNum;
}

//____________________________________
- (void)setUploadPreogressSpeed:(NSInteger)uploadPreogressSpeed
{
    _uploadPreogressSpeed = uploadPreogressSpeed;
    self.kbLabel.text = [NSString stringWithFormat:@"%ld KB/S", (long)self.uploadPreogressSpeed];
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        //去除tableViewCell之间的横线
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        
        self.delegate = self;
        self.dataSource = self;
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        
        for (int i = 0; i < self.ongingUploadArray.count; i ++) {
            
            self.selectedArray[i] = @"0";
        }
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _ongingUploadArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //判断section的标记是否为1,如果是说明为展开,就返回真实个数,如果不是就说明是缩回,返回0.
    if ([_selectedArray[section] isEqualToString:@"1"]) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSLog(@"[self setupOngingFileSecionView:section]");
    return [self setupOngingFileSecionView:section];
}

//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FileNamecell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[FileNamecell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    //_______________
    //1.解档
    DocumentUploadFileModel *documentUploadFileModel = [NSKeyedUnarchiver unarchiveObjectWithFile:UploadCachesDirectory];
    //2.使用
    [cell.upLoadBtn setSelected:(documentUploadFileModel.uploadPause)];
    cell.upLoadLabel.text = (cell.upLoadBtn.selected)? @"开始" : @"暂停";
    //~~~~~~~~~~~~~~~
    
    return cell;
}

//单元格将要出现
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//(dropDown:)
- (UIView *)setupOngingFileSecionView:(NSInteger)section
{
    //整个背景view
    UIView *fileSectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    fileSectionView.backgroundColor = [UIColor whiteColor];
    
    //显示文件图标的imageView
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 35, 30)];
    imageView.backgroundColor = [UIColor grayColor];
    imageView.image = [UIImage imageNamed:@"camkk"];
    [fileSectionView addSubview:imageView];
    
    //显示暂停上传
    self.kbLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 90 - 50, 11, 96, 14)];
    self.kbLabel.text = [NSString stringWithFormat:@"%ld KB/S", (long)self.uploadPreogressSpeed];
    self.kbLabel.textAlignment = NSTextAlignmentRight;
    self.kbLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
    self.kbLabel.font = [UIFont systemFontOfSize:12];
    [fileSectionView addSubview:self.kbLabel];
    
    //显示可见范围的标识
    UIImageView *stateImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 44 - 21, self.kbLabel.bottom + 4, 21, 15)];
    stateImage.image = [UIImage imageNamed:@"part_visible"];
    [fileSectionView addSubview:stateImage];
    
    //显示文件的名称
    UILabel *titleName = [[UILabel alloc]initWithFrame:CGRectMake(59, 10,  (kScreen_Width - 200), 14)];
    titleName.text = self.ongingUploadArray[section];
    titleName.textColor = [UIColor colorWithHexString:@"#333333"];
    titleName.font = [UIFont systemFontOfSize:14];
    [fileSectionView addSubview:titleName];
    
    //显示已经完成的进度
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(59, 30, (kScreen_Width - 200), 10)];
    self.timeLabel.text = [NSString stringWithFormat:@"%ldKB / %ldKB", (long)self.completeProgressNum, (long)self.allProgressNum];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [fileSectionView addSubview:self.timeLabel];
    
    //展示更多的按钮
    UIButton *downActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downActionBtn.frame = CGRectMake(kScreen_Width - 42, 5, 40, 40);
    //判断btn的图片为向上还是向下
    if ([_selectedArray[section] isEqualToString:@"0"])
    {
        [downActionBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    }else {
        [downActionBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    }
    //用tag区分
    downActionBtn.tag = 1000 + section;
    [downActionBtn addTarget:self action:@selector(dropDown:) forControlEvents:UIControlEventTouchUpInside];
    [fileSectionView addSubview:downActionBtn];
    
    return fileSectionView;
}

//点击展示更多按钮
- (void)dropDown:(UIButton *)button
{
    if ([_selectedArray[button.tag - 1000] isEqualToString:@"0"]) {
        for (int i = 0; i < self.ongingUploadArray.count; i++) {
            _selectedArray[i] = @"0";
        }
        [_selectedArray replaceObjectAtIndex:button.tag - 1000 withObject:@"1"];
        
    }else {
        //如果当前点击的section是展开的,那么点击后就需要把它缩回,使_selectedArray对应的值为0,这样当前section返回cell的个数变成0,然后刷新这个section就行了
        [_selectedArray replaceObjectAtIndex:button.tag - 1000 withObject:@"0"];
    }
    
    [self reloadData];
}

@end
