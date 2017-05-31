//
//  ImageBrowseVC.m
//  Memory
//
//  Created by ZWL on 16/8/25.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ImageBrowseVC.h"

@interface ImageBrowseVC () <UIScrollViewDelegate>
{
    UIScrollView *_scrollview;
    UIImageView *_imageview;
}
@end

@implementation ImageBrowseVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1添加 UIScrollView
    //设置 UIScrollView的位置与屏幕大小相同
    _scrollview=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_scrollview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_scrollview addGestureRecognizer:tap];
    
    //2添加图片
    //有两种方式
    //(1)一般方式
    //    UIImageView  *imageview=[[UIImageView alloc]init];
    //    UIImage *image=[UIImage imageNamed:@"minion"];
    //    imageview.image=image;
    //    imageview.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    
    //(2)使用构造方法
    _imageview=[[UIImageView alloc] init];

    if ([_sizeType isEqualToString:@"1"]) {
        _imageview.frame = CGRectMake(kScreen_Width/2 - 100, kScreen_Height/2 - 100, 200, 200);
    }else {
        _imageview.frame = self.view.bounds;
    }
    
    
    if (self.tempImage) {
        _imageview.image = self.tempImage;
    }else
        if (self.imgData) {
            UIImage *image = [UIImage imageWithData:self.imgData];
            _imageview.image = image;
        }
        else{
            [_imageview sd_setImageWithURL:[NSURL URLWithString:self.urlStr] placeholderImage:nil];
            _imageview.userInteractionEnabled = YES;
            _imageview.contentMode = UIViewContentModeScaleAspectFit;
        }
    
    //调用initWithImage:方法，它创建出来的imageview的宽高和图片的宽高一样
    [_scrollview addSubview:_imageview];
    
    //设置UIScrollView的滚动范围和图片的真实尺寸一致
    _scrollview.contentSize = CGSizeMake(kScreen_Width, kScreen_Height);
    
    
    //设置实现缩放
    //设置代理scrollview的代理对象
    _scrollview.delegate=self;
    //设置最大伸缩比例
    _scrollview.maximumZoomScale=2.0;
    //设置最小伸缩比例
    _scrollview.minimumZoomScale=0.5;

}

//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageview;
}


- (void)tapAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
