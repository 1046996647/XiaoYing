//
//  FileManageTableView.m
//  XiaoYing
//
//  Created by ZWL on 16/1/19.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FileManageTableView.h"
#import "DownloadCompleteCell.h"
#import "FileNameCompleteCell.h"
#import "DeleteDocumentController.h"
#import "CompanyFileManageController.h"
#import "CreateFolderController.h"

#import "DocumentViewModel.h"
#import "DocumentModel.h"
#import "XYExtend.h"

@interface FileManageTableView()

@end

@implementation FileManageTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if ([super initWithFrame:frame style:style]) {
        
        self.folderSectionArray = [NSMutableArray array];
        self.completeFileSectionArray = [NSMutableArray array];
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

- (void)setFolderSectionArray:(NSMutableArray *)folderSectionArray
{
    _folderSectionArray = folderSectionArray;
    
    //这个用于判断展开还是缩回当前section的cell
    _selectedArray = [NSMutableArray array];
    for (int i = 0; i < _folderSectionArray.count + _completeFileSectionArray.count; i++) {
        _selectedArray[i] = @"0";
    }
    
    [self reloadData];
}

- (void)setCompleteFileSectionArray:(NSMutableArray *)completeFileSectionArray
{
    _completeFileSectionArray = completeFileSectionArray;
    
    //这个用于判断展开还是缩回当前section的cell
    _selectedArray = [NSMutableArray array];
    for (int i = 0; i < _folderSectionArray.count + _completeFileSectionArray.count; i++) {
        _selectedArray[i] = @"0";
    }
    
    [self reloadData];
}

- (NSMutableArray *)sortFolderArrayWithNameFromOriginArray:(NSMutableArray *)originArray
{
    NSMutableArray *nameArray = [NSMutableArray array];
    for (DocumentModel *model in originArray) {
        [nameArray addObject:model.documentName];
    }
    return [NSMutableArray SortOfNameWithArray:nameArray AndTargetArray:originArray];
}

- (NSMutableArray *)sortFileArrayWithNameFromOriginArray:(NSMutableArray *)originArray
{
    NSMutableArray *nameArray = [NSMutableArray array];
    for (DocumentModel *model in originArray) {
        [nameArray addObject:model.documentName];
    }
    return [NSMutableArray SortOfNameWithArray:nameArray AndTargetArray:originArray];
}

- (NSMutableArray *)sortFileArrayWithTimeFromOriginArray:(NSMutableArray *)originArray
{
    NSMutableArray *nameArray = [NSMutableArray array];
    for (DocumentModel *model in originArray) {
        [nameArray addObject:model.documentCreateTime];
    }
    return [NSMutableArray SortOfNameWithArray:nameArray AndTargetArray:originArray];
}

//_____________________________________________________________
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _folderSectionArray.count + _completeFileSectionArray.count;
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
    //如果文件夹分区为空
    if (_folderSectionArray.count == 0) {
        //已上传的文件
        if (section < _completeFileSectionArray.count) {
            return [self setupCompleteFileSecionView:section];
        }
    }else {
        //返回文件夹区头
        if (section < _folderSectionArray.count) {
            return [self setupFolderSectionView:section];
        }
        
        //已上传的文件
        if (section > _folderSectionArray.count - 1) {
            return [self setupCompleteFileSecionView:section];
        }
    }
    
    /*
    //如果第一分区为0
    if (_folderSectionArray.count == 0) {
        if (section < _ongingFileSectionArray.count) {
            return [self setupOngingFileSecionView:section];
        }
        if (section > _ongingFileSectionArray.count - 1) {
            return [self setupOngingFileSecionView:section];
        }
    }
    //如果第二分区为0
    if (_ongingFileSectionArray.count == 0) {
        if (section < _folderSectionArray.count ) {
            return [self setupOngingFileSecionView:section];
        }
        if (section > _folderSectionArray.count - 1) {
           return [self setupCompleteFileSecionView:section];
        }
    }
    //如果第一二分区为0
    if (_folderSectionArray.count == 0 && _ongingFileSectionArray.count == 0) {
        if (section < _completeFileSectionArray.count) {
           return [self setupCompleteFileSecionView:section];
        }
    }
    */
    
    return nil;

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
    NSLog(@"indexPath.row:%ld",indexPath.row);
    
    DownloadCompleteCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    FileNameCompleteCell *completeCell = [tableView dequeueReusableCellWithIdentifier:@"completeCell"];
    
    //如果文件夹分区为空
    if (_folderSectionArray.count == 0) {
        if (indexPath.section < _completeFileSectionArray.count) {
            if (completeCell == nil) {
                completeCell = [[FileNameCompleteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"completeCell"];
            }
            
            completeCell.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
            completeCell.selectionStyle = UITableViewCellAccessoryNone;
            
            DocumentModel *documentModel = self.completeFileSectionArray[indexPath.section - self.folderSectionArray.count];
            completeCell.oldFileId = documentModel.documentId;
            completeCell.oldFileName = documentModel.documentName;
            completeCell.departmentIdsArray = documentModel.departmentIds.mutableCopy;
            
            return completeCell;
        }
        
    }else {
    
        //文件夹名称
        if (indexPath.section < _folderSectionArray.count)
        {
            if (firstCell == nil)
            {
                firstCell=[[DownloadCompleteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            firstCell.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
            firstCell.selectionStyle = UITableViewCellAccessoryNone;
            
            DocumentModel *documentModel = self.folderSectionArray[indexPath.section];
            firstCell.oldFolderId = documentModel.documentId;
            firstCell.oldFolderName = documentModel.documentName;
            
            return firstCell;
        }
        
        //下载完成的文件
        if (indexPath.section >  _folderSectionArray.count - 1) {
            if (completeCell == nil) {
                completeCell = [[FileNameCompleteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"completeCell"];
            }
            
            completeCell.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
            completeCell.selectionStyle = UITableViewCellAccessoryNone;
            
            DocumentModel *documentModel = self.completeFileSectionArray[indexPath.section - self.folderSectionArray.count];
            completeCell.oldFileId = documentModel.documentId;
            completeCell.oldFileName = documentModel.documentName;
            completeCell.departmentIdsArray = documentModel.departmentIds.mutableCopy;
            
            return completeCell;
        }
    }
    
    return nil;
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//_________________________________________________________________
//(dropDown:)
- (UIView *)setupFolderSectionView:(NSInteger)section
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
    DocumentModel *documentModel = _folderSectionArray[section];
    titleName.text = documentModel.documentName;
    titleName.textColor = [UIColor colorWithHexString:@"#333333"];
    titleName.font = [UIFont systemFontOfSize:14];
    [sectionView addSubview:titleName];
 
    //展示更多的按钮
    _downActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _downActionBtn.frame = CGRectMake(kScreen_Width - 42, 5, 40, 40);
    //判断btn的图片为向上还是向下
    if ([_selectedArray[section] isEqualToString:@"0"])
    {
        [_downActionBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    }else {
        [_downActionBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    }
    //用tag区分
    _downActionBtn.tag = 1000 + section;
    [_downActionBtn addTarget:self action:@selector(dropDown:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:_downActionBtn];
    
    //如果是文件夹，点击进入该文件夹下的内容
    HSBlockButton *enterFolderButton = [[HSBlockButton alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width - _downActionBtn.width, 50)];
    __weak typeof(self) weakSelf = self;
    [enterFolderButton addTouchUpInsideBlock:^(UIButton *button) {
        CompanyFileManageController *companyFileManagerVC = [[CompanyFileManageController alloc] init];
        companyFileManagerVC.parentFolderId = documentModel.documentId;
        companyFileManagerVC.navigationItem.title = documentModel.documentName;
        [weakSelf.viewController.navigationController pushViewController:companyFileManagerVC animated:YES];
        
    }];
    [sectionView addSubview:enterFolderButton];
    
    return sectionView;
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
    [fileSectionView addSubview:imageView];
    
    //显示暂停上传
    UILabel *kbLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 44 - 50, 11, 50, 14)];
    kbLabel.text = @"暂停上传";
    kbLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
    kbLabel.font = [UIFont systemFontOfSize:12];
    [fileSectionView addSubview:kbLabel];
    
    //显示可见范围的标识
    UIImageView *stateImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 44 - 21, kbLabel.bottom + 4, 21, 15)];
    stateImage.image = [UIImage imageNamed:@"part_visible"];
    [fileSectionView addSubview:stateImage];
    
    //显示文件的名称
    UILabel *titleName = [[UILabel alloc]initWithFrame:CGRectMake(59, 10,  (kScreen_Width - 54 - 100), 14)];
    titleName.text = _ongingFileSectionArray[section - _folderSectionArray.count];
    titleName.textColor = [UIColor colorWithHexString:@"#333333"];
    titleName.font = [UIFont systemFontOfSize:14];
    [fileSectionView addSubview:titleName];
    
    //显示已经完成的进度
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(59, 30, (kScreen_Width - 200), 10)];
    timeLabel.text = @"30KB / 300KB";
    timeLabel.textColor = [UIColor colorWithHexString:@"#848484"];
    timeLabel.font = [UIFont systemFontOfSize:12];
    [fileSectionView addSubview:timeLabel];

    //展示更多的按钮
    _downActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _downActionBtn.frame = CGRectMake(kScreen_Width - 42, 5, 40, 40);
    //判断btn的图片为向上还是向下
    if ([_selectedArray[section] isEqualToString:@"0"])
    {
        [_downActionBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    }else {
        [_downActionBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    }
    //用tag区分
    _downActionBtn.tag = 1000 + section;
    [_downActionBtn addTarget:self action:@selector(dropDown:) forControlEvents:UIControlEventTouchUpInside];
    [fileSectionView addSubview:_downActionBtn];
    
    return fileSectionView;
}

//(dropDown:)
- (UIView *)setupCompleteFileSecionView:(NSInteger)section
{
    DocumentModel *documentModel = self.completeFileSectionArray[section - self.folderSectionArray.count];
    
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
        for (int i = 0; i < _ongingFileSectionArray.count + _folderSectionArray.count + _completeFileSectionArray.count; i++) {
            _selectedArray[i] = @"0";
        }
        //如果当前点击的section是展开的,那么点击后就需要把它缩回,使_selectedArray对应的值为0,这样当前section返回cell的个数变成0,然后刷新这个section就行了
        [_selectedArray replaceObjectAtIndex:button.tag - 1000 withObject:@"1"];
    }
    
    //2.刷新tableView
    [self reloadData];
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//view取消第一响应
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
