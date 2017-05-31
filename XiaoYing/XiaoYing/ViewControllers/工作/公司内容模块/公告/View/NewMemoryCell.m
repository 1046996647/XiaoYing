//
//  NewMemoryCell.m
//  Memory
//
//  Created by ZWL on 16/8/19.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "NewMemoryCell.h"
#import "UIColor+Expend.h"
#import "UIViewExt.h"
#import "UIView+UIViewController.h"

@interface NewMemoryCell ()<UITextViewDelegate>


@end

@implementation NewMemoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        self.backgroundColor = [UIColor redColor];
        
//        // 添加手势
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//        [self addGestureRecognizer:tap];
        
        //文本视图
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width - 24, 36)];
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.delegate = self;
        _textView.hidden = YES;
        _textView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
        _textView.textColor = [UIColor colorWithHexString:@"333333"];
//        [_textView becomeFirstResponder];
        
        [self.contentView addSubview:_textView];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        //    _imgView.image = [UIImage imageNamed:@"ying"];
        _imgView.userInteractionEnabled = YES;
        _imgView.hidden = YES;
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgView];
        
       
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectZero;
        _deleteBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [_deleteBtn setImage:[UIImage imageNamed:@"white_delete"] forState:UIControlStateNormal];
//        _deleteBtn.hidden = YES;
        [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [_imgView addSubview:_deleteBtn];
        
    }
    return self;
}

-(void)setAllowEditing:(BOOL)allowEditing{
    _allowEditing = allowEditing;
    if (allowEditing == NO) {
        _textView.editable = NO;
        _deleteBtn.hidden = YES;
        _textView.left = -2;
        _textView.width = kScreen_Width -12;
        _imgView.width = kScreen_Width - 12;
    }
}

- (void)setModel:(NewMemoryModel *)model
{
    _model = model;

    
    if (model.fileType == FileTypeText) {
        _imgView.hidden = YES;
        _textView.hidden = NO;
        //model.text = _textView.text;
        _textView.text = model.text;
    }
    else {
        _textView.hidden = YES;
        _imgView.hidden = NO;
        _imgView.frame = CGRectMake(0, 0, kScreen_Width-24, 200);
        self.backgroundColor = [UIColor blackColor];
//        NSString *subStr = [NSString stringWithFormat:@"%@/Upload/%@",BaseUrl1,self.model.text];
//        NSString *rowUrl = [self subStringToRowUrl:model.text];
        
        NSString *formatUrl = model.dic[@"FormatUrl"];
        NSString *subStr = [NSString replaceString:formatUrl Withstr1:@"1000" str2:@"1000" str3:@"c"];
        //UIImage *image = [UIImage imageWithData:model.imgData];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.opacity = 0;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:subStr]  placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            float currentProgress = (float)receivedSize/(float)expectedSize;
            hud.progress = currentProgress;
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [hud hide:YES];
        }];

        NSLog(@"imageframe:%f",_imgView.frame.size.width);
//        [_imgView sd_setImageWithURL:[NSURL URLWithString:subStr]];
//        _deleteBtn.backgroundColor = [UIColor cyanColor];
        _deleteBtn.frame = CGRectMake(_imgView.width-30, 0, 30, 30);
    }
    
//    _textView.text = model.text;
    
    if (model.cellHeight > 36) {
        
        _textView.height = model.cellHeight;
    }
}

// 删除
- (void)deleteAction
{
    if (self.deleteBlock) {
        _deleteBlock(_model);
    }
}


#pragma mark - UITextViewDelegate

// 刚点击时调用，编辑过程不调用
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
//    // 记录当前光标所在的单元格
//    self.insertIndex = self.row;
    
    if (self.sendBlock) {
        _sendBlock(self.row);
    }
    
    if (![self.title isEqualToString:@"添加笔记"]) {
        if (self.changeBlock) {
            _changeBlock(textView.text);
        }
    }
    
//    NSLog(@"%ld",self.insertIndex);

    NSIndexPath* path = [NSIndexPath indexPathForRow:self.row inSection:0];
    [self scrollToCell:path];
    
//    NSLog(@"fsdfsdf");

//    [self performSelector:@selector(scrollToCell:) withObject:path afterDelay:0.5f];
}


-(void)textViewDidChange:(UITextView *)textView{
    //    [textView flashScrollIndicators];   // 闪动滚动条
    _model.text = textView.text;
    if (self.changeBlock) {
        _changeBlock(textView.text);
    }
    
//    CGRect frame = textView.frame;
//    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
//    CGSize size = [textView sizeThatFits:constraintSize];
//    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    textView.height = [self heightForString:self.model.text andWidth:kScreen_Width-24];
    
    _model.cellHeight = textView.height+20;
    
    UITableView *tableView = [self tableView];
    //[tableView reloadData];
    NSLog(@"触发了");
    [tableView beginUpdates];
    [tableView endUpdates];
    
    NSIndexPath* path = [NSIndexPath indexPathForRow:self.row inSection:0];
    
    [tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];

}

/**
 @method 获取指定宽度width,字体大小fontSize,字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (float) heightForString:(NSString *)value andWidth:(float)width{
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:attributes        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height + 16.0;
}

-(void) scrollToCell:(NSIndexPath*) path {
    
    UITableView *tableView = [self tableView];
    
    [tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}





//// 点击单元格时截断事件传递
//- (void)tapAction
//{
//    return;
//}

//裁剪出图片的url
-(NSString *)subStringToRowUrl:(NSString *)string{
    NSArray *array = [string componentsSeparatedByString:@";"];
    NSString *str3 = array[2];
    NSArray *anotherArr = [str3 componentsSeparatedByString:@"\""];
    NSString *urlStr = anotherArr[1];
    return urlStr;
}




@end
