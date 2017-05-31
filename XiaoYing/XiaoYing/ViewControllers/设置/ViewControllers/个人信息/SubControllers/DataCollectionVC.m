//
//  DataCollectionVC.m
//  XiaoYing
//
//  Created by YL20071 on 16/10/27.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "DataCollectionVC.h"

@interface DataCollectionVC ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *textView;//文本输入框
@property(nonatomic,strong)UILabel *remindLab;//提示label
@property(nonatomic,strong)UILabel *textLengthLab;//字数提示label
@end

@implementation DataCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNavi];
    //设置界面
    [self initUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置导航控制器 methods
-(void)setNavi{
    self.title = @"意见反馈";
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sending)];
    [sendButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = sendButton;
}

-(void)initUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(12, 12, kScreen_Width - 24, kScreen_Height - 24 - 64)];
    if (IS_IPHONE_5) {//如果设备是iphone5或5S
        self.textView.height = kScreen_Height - 12 - 64 - 253;
    }
    if (IS_iPhone6) {
        self.textView.height = kScreen_Height - 12 - 64 - 258;
    }
    if (IS_iPhone6Plus) {
        self.textView.height = kScreen_Height - 12 - 64 - 271;
    }
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.masksToBounds = YES;
    self.textView.delegate = self;
    self.textView.tag = 100;
    self.textView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.textView];
    
    _remindLab = [[UILabel alloc]initWithFrame:CGRectMake(2, 8, self.textView.width - 4, 16)];
    //如果是4英寸设备，由于remindLabel需要占两行，所以需要修改remindlabel的.y和.height
    if (IS_IPHONE_5) {//如果设备是iphone5或5S
        _remindLab.top = 3;
        _remindLab.height = 40;
    }
    _remindLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    _remindLab.text = @"亲，您对我们的意见或建议，我们会认真采纳！";
    //_remindLab.textAlignment = NSTextAlignmentCenter;
    _remindLab.numberOfLines = 0;
    //[_remindLab sizeToFit];
    _remindLab.font = [UIFont systemFontOfSize:14];
    [self.textView addSubview:_remindLab];
    
    _textLengthLab = [[UILabel alloc]initWithFrame:CGRectMake(self.textView.width - 42, kScreen_Height - 20 - 64 -24, 46, 20)];
    if (IS_IPHONE_5) {//如果设备是iphone5或5S
        _textLengthLab.top = kScreen_Height - 20 - 64 -6 - 253;
    }
    if (IS_iPhone6) {
        _textLengthLab.top = kScreen_Height - 20 - 64 -6 - 258;
    }
    if (IS_iPhone6Plus) {
        _textLengthLab.top = kScreen_Height - 20 - 64 -6 - 271;
    }
    _textLengthLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    _textLengthLab.textAlignment = NSTextAlignmentRight;
    _textLengthLab.text = @"1000";
    _textLengthLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_textLengthLab];
    
    //为textView添加轻扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp; //默认向右
    [self.textView addGestureRecognizer:swipeGesture];
}

//点击了提交按钮之后
-(void)sending{
    [self.textView resignFirstResponder];
    if (self.textView.text.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在提交意见";
        NSString *requestUrl = [NSString stringWithFormat:@"%@/api/datacollect/addsuggestion?Token=%@",BaseUrl1,[UserInfo getToken]];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:self.textView.text forKey:@"Content"];
        [AFNetClient POST_Path:requestUrl params:param completed:^(NSData *stringData, id JSONDict) {
            NSInteger code = [JSONDict[@"Code"] integerValue];
            if (code == 0) {
                [hud hide:YES];
                [self rebuildUI];
            }
        } failed:^(NSError *error) {
            [hud hide:YES];
            [MBProgressHUD showMessage:@"提交失败，请稍后再试" toView:self.view];
            NSLog(@"请求失败Error--%ld",(long)error.code);
        }];
    }else{
        [MBProgressHUD showMessage:@"意见不能为空"];
    }
}

//提交成功之后视图的改变
-(void)rebuildUI{
    UIView *baseView = [[UIView alloc]initWithFrame:self.view.bounds];
    baseView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    [self.view addSubview:baseView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreen_Width - 274)/2, 60, 274, 176)];
    imageView.image = [UIImage imageNamed:@"success_opinion"];
    [baseView addSubview:imageView];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(goBackToAbout)];
    [doneButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = doneButton;
}

//回到上一个界面
-(void)goBackToAbout{
    [self.navigationController popViewControllerAnimated:YES];
}

//轻扫手势
-(void)swipeGesture:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp){
        [self.textView resignFirstResponder];
    }
}

#pragma mark - UITextView delegateMethods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.textView.tag = 101;
    //_remindLab.hidden = YES;
    return YES;
}

#define MAX_LIMIT_NUMS 1000
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            _textLengthLab.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        _remindLab.hidden = YES;
    }else{
        _remindLab.hidden = NO;
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    _textLengthLab.text = [NSString stringWithFormat:@"%ld",MAX(0,MAX_LIMIT_NUMS - existTextNum)];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.textView.tag == 101) {
        [self.textView resignFirstResponder];
        self.textView.tag = 100;
        return;
    }
}

@end
