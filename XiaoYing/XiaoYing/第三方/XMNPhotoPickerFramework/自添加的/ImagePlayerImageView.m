//
//  ImagePlayerImageView.m
//  XiaoYing
//
//  Created by 王思齐 on 16/12/21.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "ImagePlayerImageView.h"
@interface ImagePlayerImageView() {
    
}
@end
@implementation ImagePlayerImageView
+(ImagePlayerImageView *)showWithUrl:(NSString*)strUrl andView:(UIView*)view{
    ImagePlayerImageView *imageView = [[ImagePlayerImageView alloc]initWithFrame:view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    MBProgressHUD *hud = nil;
    __block MBProgressHUD *hud1 = hud;
    [imageView sd_setImageWithURL:[NSURL URLWithString:strUrl]  placeholderImage:[UIImage imageNamed:@"picture_failed"] options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (hud1 == nil) {
            hud1 = [MBProgressHUD showHUDAddedTo:imageView animated:YES];
            hud1.mode = MBProgressHUDModeAnnularDeterminate;
            hud1.opaque = NO;
            hud1.opacity = 0;
        }
        float currentProgress = (float)receivedSize/(float)expectedSize;
        hud1.progress = currentProgress;

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [hud1 hide:YES];
        hud1 = nil;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (error) {
            UIImage *image = [UIImage imageNamed:@"picture_failed"];
            imageView.image = image;
            CGRect frame = imageView.frame;
            frame.size = image.size;
            imageView.frame = frame;
            CGPoint center1 = imageView.center;
            CGPoint center2 = imageView.superview.center;
            center1 = center2;
            imageView.center = center1;
        }
    }];
    
    return imageView;
}


@end
