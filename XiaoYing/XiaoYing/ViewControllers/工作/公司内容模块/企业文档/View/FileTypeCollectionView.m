//
//  FileTypeCollectionView.m
//  XiaoYing
//
//  Created by ZWL on 16/7/13.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FileTypeCollectionView.h"
#import "FileTypeCollectionViewCell.h"
#import "SortedDownLoadFileVC.h"
@interface FileTypeCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *_imgArr;
    NSArray *_typeArr;
}

@end

@implementation FileTypeCollectionView

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        
        self.contentInset = UIEdgeInsetsMake(15, 15, 15, 15);
        [self registerClass:[FileTypeCollectionViewCell class]forCellWithReuseIdentifier:reuseIdentifier];
        self.delegate = self;
        self.dataSource = self;
        
        _imgArr = @[@"picture_document",@"video",@"music",@"word",
                    @"excel",@"ppt",@"compressed_package",@"others"];
        _typeArr = @[@"图片",@"视频",@"音乐",@"Word",
                     @"Excel",@"PPT",@"压缩包",@"其他"];

        
    }
    return self;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imgArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FileTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell.imgBtn setBackgroundImage:[UIImage imageNamed:_imgArr[indexPath.item]] forState:UIControlStateNormal];
    cell.typeLab.text = _typeArr[indexPath.item];
    NSArray *modelArray = [self.downloadedDic objectForKey:_typeArr[indexPath.item]];
    cell.countLab.text = [NSString stringWithFormat:@"%ld",modelArray.count];
    cell.modelArray = modelArray;
    return cell;
}

//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    SortedDownLoadFileVC *vc = [SortedDownLoadFileVC new];
//    vc.title = _typeArr[indexPath.item];
//    NSArray *modelArray = [self.downloadedDic objectForKey:_typeArr[indexPath.item]];
//    vc.modelsArray = modelArray.mutableCopy;
//    [self.viewController.navigationController pushViewController:vc animated:YES];
//}




@end
