//
//  PreviewController.m
//  XiaoYing
//
//  Created by ZWL on 17/2/13.
//  Copyright © 2017年 yinglaijinrong. All rights reserved.
//

#import "PreviewController.h"


@interface PreviewController ()<QLPreviewControllerDataSource>

@end

@implementation PreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置代理
    self.dataSource = self;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- datasource协议方法
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    
    //读取沙盒中的文件
    return [NSURL fileURLWithPath:self.filePath];
    
}

@end
