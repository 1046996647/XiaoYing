//
//  UITableView+showMessageView.m
//  XiaoYing
//
//  Created by YL20071 on 16/11/10.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "UITableView+showMessageView.h"

@implementation UITableView (showMessageView)
-(void)tableViewDisplayNotFoundViewWithRowCount:(NSInteger)rowCount{
    if (rowCount == 0) {
        UIView *showMessageView = [[UIView alloc]initWithFrame:self.bounds];
        showMessageView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
        
        //添加图片
        UIImageView *notFoundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        UIImage *failImage = [UIImage imageNamed:@"search-failed"];
        notFoundImageView.top = 170;
        notFoundImageView.width = failImage.size.width;
        notFoundImageView.height = failImage.size.height;
        notFoundImageView.image = failImage;
        CGPoint center = notFoundImageView.center;
        center.x = showMessageView.center.x;
        notFoundImageView.center = center;
        [showMessageView addSubview:notFoundImageView];
        
        self.backgroundView = showMessageView;
    }else{
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}
@end
