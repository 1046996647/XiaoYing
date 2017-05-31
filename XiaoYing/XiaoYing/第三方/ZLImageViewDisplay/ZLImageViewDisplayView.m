//
//  ZLImageViewDisplayView.m
//  ZLImageViewDisplay
//
//  Created by Mr.LuDashi on 15/8/14.
//  Copyright (c) 2015年 ludashi. All rights reserved.
//

#import "ZLImageViewDisplayView.h"
#import "UIImageView+WebCache.h"

@interface ZLImageViewDisplayView ()<UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat widthOfView;
@property (nonatomic, assign) CGFloat heightView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) UIViewContentMode imageViewcontentModel;
@property (nonatomic, strong) UIPageControl *imageViewPageControl;
@property (nonatomic, strong) TapImageViewButtonBlock block;
@end

@implementation ZLImageViewDisplayView

#pragma -- 遍历构造器
+ (instancetype) zlImageViewDisplayViewWithFrame: (CGRect) frame {
    ZLImageViewDisplayView *instance = [[ZLImageViewDisplayView alloc] initWithFrame:frame];
    return instance;
}


#pragma -- mark 遍历初始化方法
- (instancetype)initWithFrame: (CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _widthOfView = frame.size.width;            //获取滚动视图的宽度
        _heightView = frame.size.height;            //获取滚动视图的高度
        _scrollInterval = 3;
        _animationInterVale = 0.7;
        _currentPage = 0;                           //当前显示页面
        _imageViewcontentModel = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)layoutSubviews {
    [self initMainScrollView];                          //初始化滚动视图
    
    [self addImageviewsForMainScroll];    //添加ImageView
    
}


/**
 *  初始化ScrollView
 */
- (void) initMainScrollView{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _widthOfView, _heightView)];
    _mainScrollView.contentSize = CGSizeMake(kScreen_Width * 6, _heightView);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.delegate = self;
 
    [self addSubview:_mainScrollView];
    
    [self addPageControl];
}

/**
 *  添加PageControl
 */
- (void) addPageControl{
    _imageViewPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _heightView - 20, _widthOfView, 20)];
    
    _imageViewPageControl.numberOfPages = 4;
    
    _imageViewPageControl.currentPage = 0;
    
    _imageViewPageControl.tintColor = [UIColor blackColor];
    
    _imageViewPageControl.enabled = NO;
    
    [_imageViewPageControl addTarget:self action:@selector(pageChange) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:_imageViewPageControl];
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_scrollInterval target:self selector:@selector(changeOffset) userInfo:nil repeats:YES];
    }
}


/**
 *  给ScrollView添加ImageView
 */
-(void) addImageviewsForMainScroll{
    if (_imageViewArray != nil) {
        //设置ContentSize
        _mainScrollView.contentSize = CGSizeMake(kScreen_Width * 6, 163);
        [_mainScrollView scrollRectToVisible:CGRectMake(kScreen_Width, 0, kScreen_Width, 163) animated:NO];
        
        
        for ( int i = 0; i < _imageViewArray.count ; i ++) {
            CGRect currentFrame = CGRectMake(_widthOfView * i, 0, _widthOfView, _heightView);
            UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:currentFrame];
            tempImageView.contentMode = _imageViewcontentModel;
            tempImageView.clipsToBounds = YES;
       
             UIImage *imageTemp = [UIImage imageNamed:_imageViewArray[i]];
            
                [tempImageView setImage:imageTemp];
         
            [_mainScrollView addSubview:tempImageView];
        }

        _mainScrollView.contentOffset = CGPointMake(kScreen_Width, 0);
    }
}


-(void)pageChange{
    NSInteger page = _imageViewPageControl.currentPage;
    
    [_mainScrollView scrollRectToVisible:CGRectMake((page+1)*kScreen_Width, 0, kScreen_Width, 163) animated:YES];
}

- (void)changeOffset{
    
    _currentPage ++;
    
    [_mainScrollView scrollRectToVisible:CGRectMake((_currentPage)*kScreen_Width, 0, kScreen_Width, 163) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger currentPage = scrollView.contentOffset.x / kScreen_Width;
    
    if (currentPage == 0) {
        [scrollView scrollRectToVisible:CGRectMake(kScreen_Width * 4, 0, kScreen_Width, 163) animated:NO];
        _imageViewPageControl.currentPage = 4;
    }
    else if (currentPage == 5){
        [scrollView scrollRectToVisible:CGRectMake(kScreen_Width*1, 0, kScreen_Width, 163) animated:NO];        
        _imageViewPageControl.currentPage = 0;
    }
    else{
        _imageViewPageControl.currentPage = currentPage-1;
        _currentPage = currentPage;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x / kScreen_Width;
    if(currentPage == 0)
    {
        [scrollView scrollRectToVisible:CGRectMake(kScreen_Width * 4, 0, kScreen_Width, 165) animated:NO];
        
     _imageViewPageControl.currentPage = 4;
       _currentPage=0;
        
    }
    else if (currentPage == 5)
    {
        [scrollView scrollRectToVisible:CGRectMake(kScreen_Width * 1, 0, kScreen_Width, 165) animated:NO];
        
        _imageViewPageControl.currentPage = 0;
        _currentPage=0;
    }
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self resumeTimer];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self resumeTimer];
}

/**
 *  暂停定时器
 */
-(void)resumeTimer{
    
    if (![_timer isValid]) {
        return ;
    }
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_scrollInterval-_animationInterVale]];
}

@end
