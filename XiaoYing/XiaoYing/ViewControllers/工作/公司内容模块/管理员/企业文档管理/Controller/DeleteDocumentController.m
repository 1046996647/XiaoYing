//
//  DeleteDocumentController.m
//  XiaoYing
//
//  Created by ZWL on 16/1/20.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DeleteDocumentController.h"
#import "DocumentViewModel.h"

@interface DeleteDocumentController ()

@end

@implementation DeleteDocumentController

- (NSArray *)folderIdsArray
{
    if (!_folderIdsArray) {
        _folderIdsArray = [[NSArray alloc] init];
    }
    return _folderIdsArray;
}

- (NSArray *)fileIdsArray
{
    if (!_fileIdsArray) {
        _fileIdsArray = [[NSArray alloc] init];
    }
    return _fileIdsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     
    //初始化视图
    [self setupView];
}

- (void)setupView
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectZero];
    baseView.layer.cornerRadius = 5;
    baseView.clipsToBounds = YES;
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    [baseView addSubview:lab];
    
    baseView.frame = CGRectMake((kScreen_Width-270)/2.0, (kScreen_Height - 90) / 2, 270,(90+88)/2);
    lab.frame = CGRectMake(16, 15, baseView.width-16*2, 20);
    lab.text = @"确认删除 ?";
    
    NSArray *titleArr = @[@"确定", @"取消"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(baseView.width/2.0), baseView.height-44, baseView.width/2.0, 44);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
    }
    
    //横分割线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, baseView.frame.size.height - 44, baseView.width, .5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView1];
    
    //竖分割线
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(baseView.width/2 - 0.5, lineView1.bottom, .5, 44)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [baseView addSubview:lineView2];
    
    
}

- (void)btnAction:(UIButton *)btn {
    
    if ([btn.titleLabel.text isEqualToString:@"确定"]) {
        
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpLoadView" object:nil];//不考虑用通知，待删除
        NSLog(@"self.folderIdsArray~~%@", self.folderIdsArray);
        NSLog(@"self.fileIdsArray~~%@", self.fileIdsArray);
        
        [DocumentViewModel deleteDocumentWithFolderIds:self.folderIdsArray fileIds:self.fileIdsArray success:^(NSDictionary *dataList) {
            
            NSLog(@"删除文件夹成功:%@", dataList);
            [self dismissViewControllerAnimated:YES completion:nil];

            
        } failed:^(NSError *error) {
            
            NSLog(@"删除文件夹失败:%@", error);
        }];
        
    }else {
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}

@end
