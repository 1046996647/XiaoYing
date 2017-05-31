//
//  FileManagerSearchTableView.m
//  XiaoYing
//
//  Created by chenchanghua on 16/12/20.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "FileManagerSearchTableView.h"
#import "FileNameCompleteCell.h"
#import "DocumentModel.h"

@interface FileManagerSearchTableView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *selectedArray;//点击标记数组
@property (nonatomic, strong) UIButton *downActionBtn;//点击的按钮

@property (nonatomic, assign) NSInteger sectionTemp;
@property (nonatomic, assign) CGFloat tempHeight;

@end

@implementation FileManagerSearchTableView
@synthesize fileSearchArray = _fileSearchArray;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if ([super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}

- (NSMutableArray *)fileSearchArray
{
    if (!_fileSearchArray) {
        _fileSearchArray = [NSMutableArray array];
    }
    return _fileSearchArray;
}

- (void)setFileSearchArray:(NSMutableArray *)fileSearchArray
{
    _fileSearchArray = fileSearchArray;
    
    //这个用于判断展开还是缩回当前section的cell
    _selectedArray = [NSMutableArray array];
    for (int i = 0; i < _fileSearchArray.count; i++) {
        _selectedArray[i] = @"0";
    }
    
    [self reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _fileSearchArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //判断section的标记是否为1,如果是说明为展开,就返回1,如果不是就说明是缩回,返回0.
    if ([_selectedArray[section] isEqualToString:@"1"]) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == _sectionTemp && _tempHeight > 14) {
        return _tempHeight + 36;
    }else {
        return 50;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self setupCompleteFileSecionView:section];
}

//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.row:%ld",(long)indexPath.row);
    
    FileNameCompleteCell *completeCell = [tableView dequeueReusableCellWithIdentifier:@"completeCell"];
    
    if (indexPath.section < _fileSearchArray.count) {
        if (completeCell == nil) {
            completeCell = [[FileNameCompleteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"completeCell"];
        }
        
        completeCell.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        completeCell.selectionStyle = UITableViewCellAccessoryNone;
        
        DocumentModel *documentModel = self.fileSearchArray[indexPath.section];
        completeCell.oldFileId = documentModel.documentId;
        completeCell.oldFileName = documentModel.documentName;
        completeCell.departmentIdsArray = documentModel.departmentIds.mutableCopy;
        
        return completeCell;
    }
    
    return nil;
}

//(dropDown:)
- (UIView *)setupCompleteFileSecionView:(NSInteger)section
{
    DocumentModel *documentModel = self.fileSearchArray[section];
    
    //整个背景view
    UIView *completeSectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    completeSectionView.backgroundColor = [UIColor whiteColor];
    
    //显示文件图标的imageView
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 35, 30)];
    imageView.image = [UIImage imageNamed:@"camkk"];
    [completeSectionView addSubview:imageView];
    
    //显示文件的大小
    UILabel *kbLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 44 - 50, 11, 50, 14)];
    kbLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
    kbLabel.font = [UIFont systemFontOfSize:12];
    //大于或等于1M显示“1.0M”，否则“987KB”
    if (documentModel.documentSize < 1024) {
        kbLabel.text = [NSString stringWithFormat:@"%.1fKB", (documentModel.documentSize / 1.0)];
    }else {
        kbLabel.text = [NSString stringWithFormat:@"%.1fM", (documentModel.documentSize / 1024.0)];
    }
    
    [completeSectionView addSubview:kbLabel];
    
    //显示可见范围的标识
    UIImageView *stateImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 44 - 21, kbLabel.bottom + 4, 21, 15)];
    stateImage.image = [UIImage imageNamed:@"part_visible"];
    [completeSectionView addSubview:stateImage];
    
    //显示文件的名称
    UILabel *titleName = [[UILabel alloc]initWithFrame:CGRectMake(59, 10,  (kScreen_Width - 54 - 100), 14)];
    titleName.numberOfLines = 0;
    titleName.textColor = [UIColor colorWithHexString:@"#333333"];
    titleName.font = [UIFont systemFontOfSize:14];
    titleName.text = documentModel.documentName;
    //显示文件的名称的Label高度自适应
    NSDictionary *attrs = @{NSFontAttributeName:titleName.font};
    CGFloat labelWidth = titleName.frame.size.width;
    CGSize maxSize = CGSizeMake(labelWidth, 0);
    CGSize size = [titleName.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    _tempHeight = size.height;
    _sectionTemp = section;
    if (size.height > 14) {
        titleName.frame = CGRectMake(54, imageView.top, size.width, size.height);
    }
    if (size.height > 50) {
        _tempHeight = 50.121094;
        titleName.numberOfLines = 3;
        titleName.lineBreakMode = NSLineBreakByTruncatingMiddle;
        titleName.frame = CGRectMake(54, imageView.top, size.width, 50.121094);
    }
    [completeSectionView addSubview:titleName];
    
    //显示文件上传的时间
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleName.left, titleName.bottom + 3, (kScreen_Width - 200), 10)];
    timeLabel.text = documentModel.documentCreateTime;
    timeLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    timeLabel.font = [UIFont systemFontOfSize:12];
    [completeSectionView addSubview:timeLabel];
    
    //展示更多的按钮
    _downActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _downActionBtn.frame = CGRectMake(kScreen_Width - 42, 5, 40, 40);
    //判断btn的图片为向上还是向下
    if ([_selectedArray[section] isEqualToString:@"0"]) {
        [_downActionBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    }else {
        [_downActionBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    }
    //用tag区分
    _downActionBtn.tag = 1000 + section;
    [_downActionBtn addTarget:self action:@selector(dropDown:) forControlEvents:UIControlEventTouchUpInside];
    [completeSectionView addSubview:_downActionBtn];
    
    return completeSectionView;
}

- (void)dropDown:(UIButton *)button
{
    //改变0/1数组
    if ([_selectedArray[button.tag - 1000] isEqualToString:@"1"]) {
        [_selectedArray replaceObjectAtIndex:button.tag - 1000 withObject:@"0"];
        
    }else {
        for (int i = 0; i < _fileSearchArray.count; i++) {
            _selectedArray[i] = @"0";
        }
        //如果当前点击的section是展开的,那么点击后就需要把它缩回,使_selectedArray对应的值为0,这样当前section返回cell的个数变成0,然后刷新这个section就行了
        [_selectedArray replaceObjectAtIndex:button.tag - 1000 withObject:@"1"];
    }
    
    //2.刷新tableView
    [self reloadData];
}


@end
