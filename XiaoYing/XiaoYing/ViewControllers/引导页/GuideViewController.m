//
//  GuideViewController.m
//  XiaoYing
//
//  Created by ZWL on 15/10/12.
//  Copyright (c) 2015年 ZWL. All rights reserved.
//

#import "GuideViewController.h"
#import "HomeViewController.h"
//#import "LoginViewController.h"

#define PageCOUNT  3
@interface GuideViewController ()<UIScrollViewDelegate>
{
    UIPageControl *pageControl;
    UIScrollView  *dyScrollView;
}
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:100];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self  initGuide];   //加载新用户指导页面
    [self  initpagecontrol];
}
-(void)initpagecontrol
{
//    pageControl = [[UIPageControl alloc] init];
//    pageControl.backgroundColor=[UIColor  clearColor];
//    pageControl.frame=CGRectMake((self.view.frame.size.width-100)/2,self.view.frame.size.height-130, 100, 30) ;
//    pageControl.numberOfPages =PageCOUNT; // 一共显示多少个圆点（多少页）
//    // 设置非选中页的圆点颜色
//    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:100];
//    // 设置选中页的圆点颜色
//    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:37.0/255.0 green:174.0/255.0 blue:96.0/255.0 alpha:100];
//    // 禁止默认的点击功能
//    pageControl.enabled = NO;
//    [self.view addSubview:pageControl];
}


-(void)initGuide
{
    NSArray *iPhoneGarray=@[@"guide_1",@"guide_2",@"guide_3",@"guide_4"];
    //iphone5
//    NSArray *iPhone5Garray2=@[@"1.2.png",@"2.2.png",@"3.2.png"];
//    NSArray *iPhone6Garray3=@[@"1.2.png",@"2.2.png",@"3.2.png"];
    
    dyScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.view.frame.size.height)];
    dyScrollView.delegate=self;
    dyScrollView.backgroundColor=[UIColor clearColor];
    dyScrollView.contentSize=CGSizeMake(kScreen_Width*iPhoneGarray.count, kScreen_Height);
    dyScrollView.showsVerticalScrollIndicator=NO;
    dyScrollView.pagingEnabled=YES;
    //    dyScrollView.bounces=NO;       //取消弹性
    dyScrollView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:dyScrollView];
    for (int i=0; i<[iPhoneGarray  count]; i++)
    {
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(i*kScreen_Width, 0,kScreen_Width , kScreen_Height)];
        
//        if (IS_IPHONE_4) {
//            imgView.image=[UIImage  imageNamed:iPhone4Garray[i]];
//        }else if (IS_IPHONE_5){
//            imgView.image=[UIImage  imageNamed:iPhone5Garray2[i]];
//        }else if (IS_iPhone6){
//            imgView.image=[UIImage  imageNamed:iPhone6Garray3[i]];
//        }
//        else{
//            imgView.image=[UIImage  imageNamed:iPhone5Garray2[i]];
//        }
        imgView.image=[UIImage  imageNamed:iPhoneGarray[i]];
        [imgView setUserInteractionEnabled:YES];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
      
        [dyScrollView addSubview:imgView];
        
        if (i < [iPhoneGarray  count]-1)
        {
            //跳过
            UIButton *UserButton=[UIButton  buttonWithType:UIButtonTypeCustom];
            UserButton.frame=CGRectMake(kScreen_Width-10-40,10,40, 40);
//            UserButton.backgroundColor=[UIColor cyanColor];
//            [UserButton  setTitle:@"立即使用" forState:UIControlStateNormal];
            [UserButton  addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [imgView  addSubview:UserButton];
            
        }
        
        if (i==[iPhoneGarray  count]-1)
        {
            //开始使用
            UIButton   *UserButton=[UIButton  buttonWithType:UIButtonTypeCustom];
            UserButton.frame=CGRectMake((kScreen_Width-200)/2,kScreen_Height-130,200, 92/2);
            UserButton.backgroundColor=[UIColor   clearColor];
            UserButton.tag=1001;
            [UserButton.layer setCornerRadius:92/2/2];
//            [UserButton setImage:[UIImage imageNamed:@"start2"] forState:UIControlStateNormal];
            UserButton.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
            [UserButton  setTitle:@"开始体验" forState:UIControlStateNormal];
            [UserButton  addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [imgView  addSubview:UserButton];
            
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
//    CGPoint offset = scrollView.contentOffset;
//    CGRect bounds = scrollView.frame;
//    [pageControl setCurrentPage:offset.x / bounds.size.width];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat pageWidth = self.view.frame.size.width;
//    // 在滚动超过页面宽度的50%的时候，切换到新的页面
//    int page = floor((dyScrollView.contentOffset.x + pageWidth/2)/pageWidth) ;
//    pageControl.currentPage = page;
}

//点击button跳转到根视图
- (void)firstpressed:(UIButton*)sender
{
    [UIView  animateWithDuration:1.2 animations:^{
        self.view.frame=CGRectMake(0, 0, kScreen_Width*2, kScreen_Height*2);
        self.view.alpha=0.0;
        
    } completion:^(BOOL finished) {
        [self.view  removeFromSuperview];
        
    }];
    //   [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

//按钮点击
-(void)ButtonClick:(UIButton *)sender
{
    NSLog(@"立即使用");
    AppDelegate *app =(AppDelegate*)[UIApplication sharedApplication].delegate;

    CustomTabVC *customTabVC = [[CustomTabVC alloc] init];
    app.window.rootViewController = customTabVC;
    
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.view=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 重载隐藏状态栏的方法
- (BOOL)prefersStatusBarHidden
{
    // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 已经不起作用了
    return YES;
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
