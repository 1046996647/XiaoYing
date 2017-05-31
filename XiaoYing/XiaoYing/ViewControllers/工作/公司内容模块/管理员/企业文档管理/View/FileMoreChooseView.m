//
//  FileMoreChooseView.m
//  XiaoYing
//
//  Created by GZH on 16/7/5.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FileMoreChooseView.h"
#import "AlertViewVC.h"
#import "MoveController.h"
#import "NotMovieFolderView.h"
#import "XYExtend.h"
#import "DocumentModel.h"

@interface FileMoreChooseView()

@property (nonatomic, strong) NSMutableArray *folderDeleteTempArray; //要删除的文件夹区头的临时数组
@property (nonatomic, strong) NSMutableArray *fileDeleteTempArray; //要删除的文件区头的临时数组

@end

@implementation FileMoreChooseView
@synthesize folderArray = _folderArray, fileArray = _fileArray;

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.folderArray = [NSMutableArray array];
        self.fileArray = [NSMutableArray array];
        
        self.folderDeleteArray = [NSMutableArray array];
        self.fileDeleteArray = [NSMutableArray array];
        
        self.folderDeleteTempArray = [NSMutableArray array];
        self.fileDeleteTempArray = [NSMutableArray array];

        self.delegate = self;
        self.dataSource = self;
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        
        self.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setFolderArray:(NSMutableArray *)folderArray
{
    _folderArray = folderArray;
    
    _selectedArray = [NSMutableArray array];
    for (int i = 0; i < _folderArray.count + _fileArray.count; i++) {
        _selectedArray[i] = @"0";
    }
    
    [self reloadData];
}

- (void)setFileArray:(NSMutableArray *)fileArray
{
    _fileArray = fileArray;
    
    _selectedArray = [NSMutableArray array];
    for (int i = 0; i < _folderArray.count + _fileArray.count; i++) {
        _selectedArray[i] = @"0";
    }
    
    [self reloadData];
}

- (void)selectAllDocument:(BOOL)whether
{
    if (whether) {
        _selectedArray = [NSMutableArray array];
        for (int i = 0; i < _folderArray.count + _fileArray.count; i++) {
            _selectedArray[i] = @"1";
        }
        
        self.folderDeleteArray = self.folderArray.mutableCopy;
        self.fileDeleteArray = self.fileArray.mutableCopy;
        self.folderDeleteTempArray = self.folderArray.mutableCopy;
        self.fileDeleteTempArray = self.fileArray.mutableCopy;
        
    }else {
        _selectedArray = [NSMutableArray array];
        for (int i = 0; i < _folderArray.count + _fileArray.count; i++) {
            _selectedArray[i] = @"0";
        }
        
        self.folderDeleteArray = @[].mutableCopy;
        self.fileDeleteArray = @[].mutableCopy;
        self.folderDeleteTempArray = @[].mutableCopy;
        self.fileDeleteTempArray = @[].mutableCopy;
    }
    [self reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _folderArray.count + _fileArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    //如果文件夹分区为空
    if (_folderArray.count == 0) {
        //已上传的文件
        if (section < _fileArray.count) {
            return [self setCompleteSecionView:section];
        }
    }else {
        //返回文件夹区头
        if (section < _folderArray.count) {
            return [self setSectionView:section];
        }
        
        //已上传的文件
        if (section > _folderArray.count - 1) {
            return [self setCompleteSecionView:section];
        }
    }
    
    return nil;
}

//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//单元格将要出现
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

//文件夹sectionView
- (UIView *)setSectionView:(NSInteger)section
{
    //整个背景view
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    //显示文件夹图标的imageView
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 35, 30)];
    imageView.image = [UIImage imageNamed:@"folder"];
    [sectionView addSubview:imageView];
    
    //文件夹名Lable
    UILabel *titleName = [[UILabel alloc]initWithFrame:CGRectMake(59, 10, (kScreen_Width - 54 - 100), 30)];
    DocumentModel *documentModel = _folderArray[section];
    titleName.text = documentModel.documentName;
    titleName.textColor = [UIColor colorWithHexString:@"#333333"];
    titleName.font = [UIFont systemFontOfSize:14];
    [sectionView addSubview:titleName];
    
    //cell右边的选择小圆点
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(kScreen_Width - 27, 10, 27, 30);
    [_selectBtn addTarget:self action:@selector(selectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _selectBtn.tag = section + 1200;
    //判断是否选择
    if ([_selectedArray[section] isEqualToString:@"0"]) {
        [_selectBtn setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
    }else {
        [_selectBtn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
    }

    [sectionView addSubview:_selectBtn];

    return sectionView;
}

//文件sectionView
- (UIView *)setCompleteSecionView:(NSInteger)section
{
    DocumentModel *documentModel = self.fileArray[section - self.folderArray.count];
    
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

    //cell右边的选择小圆点
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(kScreen_Width - 27, 10, 27, 30);
    [_selectBtn addTarget:self action:@selector(selectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _selectBtn.tag = section + 1200;
    //判断是否选择
    if ([_selectedArray[section] isEqualToString:@"0"]) {
         [_selectBtn setImage:[UIImage imageNamed:@"nochoose"] forState:UIControlStateNormal];
    }else {
       [_selectBtn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
    }
    [completeSectionView addSubview:_selectBtn];
    
    return completeSectionView;
}

- (void)selectionBtnAction:(UIButton *)btn
{
    //改变选择按钮
    if ([_selectedArray[btn.tag - 1200] isEqualToString:@"0"])
    {
        [_selectedArray replaceObjectAtIndex:btn.tag - 1200 withObject:@"1"];
        
        //将选择的cell添加到数组中去
        if (btn.tag - 1200  < _folderArray.count) {
            
            [_folderDeleteTempArray addObject:[_folderArray objectAtIndex:btn.tag - 1200]];
            self.folderDeleteArray = self.folderDeleteTempArray;
            
        }else {
            
            [_fileDeleteTempArray addObject:[_fileArray objectAtIndex:btn.tag - 1200 -_folderArray.count]];
            self.fileDeleteArray = self.fileDeleteTempArray;
            
        }

//        [self reloadSections:[NSIndexSet indexSetWithIndex:btn.tag - 1200] withRowAnimation:UITableViewRowAnimationFade];
        [self reloadData];
        
    }else{
        
        [_selectedArray replaceObjectAtIndex:btn.tag - 1200 withObject:@"0"];
        NSLog(@"btn.tag~~%ld", btn.tag - 1200);
        
        if (btn.tag - 1200  < _folderArray.count) {
            
            [_folderDeleteTempArray removeObject:[_folderArray objectAtIndex:btn.tag - 1200]];
            self.folderDeleteArray = self.folderDeleteTempArray;
            
        }else {
            
            [_fileDeleteTempArray removeObject:[_fileArray objectAtIndex:btn.tag - 1200 -_folderArray.count]];
            self.fileDeleteArray = self.fileDeleteTempArray;
        }
        
//        [self reloadSections:[NSIndexSet indexSetWithIndex:btn.tag - 1200] withRowAnimation:UITableViewRowAnimationFade];
        [self reloadData];
    }
}

@end
