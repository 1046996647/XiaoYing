//
//  InboxCell.m
//  XiaoYing
//
//  Created by ZWL on 16/2/25.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "InboxCell.h"

@implementation InboxCell

- (void)awakeFromNib {
    // Initialization code
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *imageView = [[UIView alloc]initWithFrame:CGRectMake(5, 7, 40, 40)];
        imageView.backgroundColor = [UIColor lightGrayColor];
        [[imageView layer] setCornerRadius:20];
        [self addSubview:imageView];
        
        UILabel *senderLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+5, 7, 50, 14)];
        senderLabel.text = @"发件人";
        senderLabel.font = [UIFont systemFontOfSize:14];
        senderLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:senderLabel];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+5, senderLabel.bottom+5, 50, 12)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.text = @"标题";
        [self addSubview:titleLabel];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width-22, 7, 7, 12)];
        [self addSubview:imageView];
        imgView.image = [UIImage imageNamed:@"arrow-mail"];
        [self addSubview:imgView];
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width-22-6-22, 7, 30, 12)];
        timeLabel.text = @"昨天";
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
        [self addSubview:timeLabel];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+5, kScreen_Width-80, 35)];
        textLabel.text = @"内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容";
        textLabel.textColor = [UIColor colorWithHexString:@"#848484"];
        textLabel.font = [UIFont systemFontOfSize:12];
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        textLabel.numberOfLines = 2;
        [self addSubview:textLabel];
        
                                                                       
        
        
    }
    return self;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
