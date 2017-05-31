//
//  ImagePlayerViewController.m
//  XiaoYing
//
//  Created by ZWL on 16/1/8.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "ImagePlayerViewController.h"
#import "ImagePlayerImageView.h"
@interface ImagePlayerViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    UICollectionView *_imageCollectionView;    // 图片播放
    UIView *_topView; //仿导航栏效果
    UILabel *_pickCountLabel; //显示有几张图片，目前正在第几张
    UIButton *_deleteButton; //删除按钮
    NSInteger _page; //当前页
}
@end

@implementation ImagePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //self.title = [NSString stringWithFormat:@"1/%li",(unsigned long)_imageArray.count];
    //self.imageArray = [NSMutableArray array];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(kScreen_Width, kScreen_Height);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) collectionViewLayout:flowLayout];
    _imageCollectionView.delegate = self;
    _imageCollectionView.dataSource = self;
    _imageCollectionView.pagingEnabled = YES;
    _imageCollectionView.bounces = NO;
    _imageCollectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_imageCollectionView];
    _imageCollectionView.contentSize = CGSizeMake(kScreen_Width * 100, kScreen_Height);
    _imageCollectionView.backgroundColor = [UIColor blackColor];
    [_imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imageCell"];
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
    _topView.backgroundColor = [UIColor colorWithHexString:@"f99740"];
    [self.view addSubview:_topView];
    
    _page = 0;
    
    _pickCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    _pickCountLabel.text = [NSString stringWithFormat:@"1/%ld",_imageArray.count];
    _pickCountLabel.font = [UIFont systemFontOfSize:22];
    _pickCountLabel.textColor = [UIColor whiteColor];
    [_pickCountLabel sizeToFit];
    _pickCountLabel.center = _topView.center;
    _pickCountLabel.top = _topView.height - _pickCountLabel.height - 10;
    [_topView addSubview:_pickCountLabel];
    
    //左边的返回按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 20, 40, 40);
    [leftButton setImage:[UIImage imageNamed:@"Arrow-white"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBackToLastVC) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:leftButton];
    
    //右边的删除按钮
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame = CGRectMake(kScreen_Width - 50, 20, 40, 40);
    [_deleteButton setTintColor:[UIColor whiteColor]];
    UIImage *buttonImage = [UIImage imageNamed:@"delete2"];
    buttonImage = [buttonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_deleteButton setImage:buttonImage forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteCell) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_deleteButton];
    if (_isApproal != YES) {
        _deleteButton.hidden = YES;
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
     _pickCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",_page + 1,_imageArray.count];
    [_pickCountLabel sizeToFit];
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    UIImageView *image = [[UIImageView alloc] initWithFrame:cell.bounds];
    image.contentMode = UIViewContentModeScaleAspectFit;
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    [cell.contentView addSubview:image];
    if ([_imageArray.firstObject isKindOfClass:[UIImage class]]) {
        image.image = _imageArray[indexPath.row];
    }else{
        //image.image = [UIImage imageNamed:_imageArray[indexPath.row]];
        if (self.isApproal == YES) {
            image.image = [UIImage imageNamed:_imageArray[indexPath.row]];
        }else{
            for (UIView *subView in cell.contentView.subviews) {
                [subView removeFromSuperview];
            }
            [cell.contentView addSubview:[ImagePlayerImageView showWithUrl:_imageArray[indexPath.row] andView:cell.contentView]];
        }
    }
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"%f", scrollView.contentOffset.x);
//    self.title = [NSString stringWithFormat:@"%i/%li", (int)scrollView.contentOffset.x / (int)kScreen_Width + 2,_imageArray.count];
//    if ((int)scrollView.contentOffset.x / (int)kScreen_Width + 2 == _imageArray.count + 1) {
//        self.title = [NSString stringWithFormat:@"%li/%li", _imageArray.count,_imageArray.count];
//    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f", scrollView.contentOffset.x);
//    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
//    _pickCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",page,_imageArray.count];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //根据偏移量计算页码
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    _page = page;
    _pickCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",page + 1,_imageArray.count];
    [_pickCountLabel sizeToFit];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 回到之前的界面 methods
-(void)goBackToLastVC{
    if (_isApproal == YES) {
        self.backBlock(self.imageArray,self.imageIDArray);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 点击了删除按钮之后 methods
-(void)deleteCell{
    UIImage *image = self.imageArray[_page];
    [self.imageArray removeObject:image];
    NSString *ID = self.imageIDArray[_page];
    [self.imageIDArray removeObject:ID];
    if (_page  == self.imageArray.count ) {
        _page--;
    }
    if (self.imageArray.count == 0) {
        self.backBlock(self.imageArray,self.imageIDArray);
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [_imageCollectionView reloadData];
    }
}

@end
