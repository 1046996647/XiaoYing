//
//  FileTypeCollectionViewCell.m
//  XiaoYing
//
//  Created by ZWL on 16/7/13.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "FileTypeCollectionViewCell.h"
#import "SortedDownLoadFileVC.h"
@implementation FileTypeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor redColor];
        
        // 初始化视图
        [self initsubViews];
        
    }
    return self;
}

- (void)initsubViews
{
    _imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _imgBtn.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.width);
//    [_imgBtn setBackgroundImage:[UIImage imageNamed:@"downloading"] forState:UIControlStateNormal];
    [_imgBtn addTarget:self action:@selector(buttonCli) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_imgBtn];
    
    _typeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _imgBtn.bottom+7, _imgBtn.width, 14)];
    _typeLab.font = [UIFont systemFontOfSize:14];
    _typeLab.textAlignment = NSTextAlignmentCenter;
    _typeLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_typeLab];
    
    
    _countLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _typeLab.bottom+5, _imgBtn.width, 12)];
    _countLab.font = [UIFont systemFontOfSize:12];
    _countLab.textAlignment = NSTextAlignmentCenter;
    _countLab.textColor = [UIColor colorWithHexString:@"#848484"];
    //    _personalLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_countLab];

}

-(void)buttonCli{
    SortedDownLoadFileVC *vc = [SortedDownLoadFileVC new];
    vc.title = _typeLab.text;
    vc.modelsArray = self.modelArray.mutableCopy;
    [self.viewController.navigationController pushViewController:vc animated:YES];

}


@end
