//
//  WebViewVC.m
//  XiaoYing
//
//  Created by ZWL on 16/12/7.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "WebViewVC.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"


@interface WebViewVC ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    UIWebView *_webView;
}

@end

@implementation WebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.navigationController.navigationBar addSubview:_progressView];
    
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64)];
    _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    _webView.delegate = _progressProxy;
    _webView.backgroundColor=[UIColor  clearColor];
    //    webView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
    NSURL* url;
    if ([self.strValue  hasPrefix:@"www."] )
    {
        url = [NSURL URLWithString:[NSString  stringWithFormat:@"https://%@",self.strValue]];//创建URL
    }
    else
    {
        url = [NSURL URLWithString:self.strValue];//创建URL
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_webView loadRequest:request];//加载
    [self.view  addSubview:_webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - 重写返回按钮事件
- (void)backAction:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [_progressView removeFromSuperview];
}

@end
