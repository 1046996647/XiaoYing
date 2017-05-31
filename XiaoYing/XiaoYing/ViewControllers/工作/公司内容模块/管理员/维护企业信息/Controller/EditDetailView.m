//
//  EditDetailView.m
//  XiaoYing
//
//  Created by GZH on 16/8/25.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "EditDetailView.h"
@interface EditDetailView ()<UITextViewDelegate>
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UILabel *placeHolder;

@end

@implementation EditDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //基本设置
    [self basicSet];
    
    //textView的基本设置
    [self createDetailTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification" object:self.textView];
    
}

//基本设置
- (void)basicSet {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 10, 18);
    [backButton setImage:[UIImage imageNamed:@"Arrow-white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(setKeepAction)];
    rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}
- (void)setKeepAction {
    [_textView resignFirstResponder];
    NSLog(@"保存%@",self.textView.text);
    if ([self.delegate respondsToSelector:@selector(passvalue:)]) {
        [self.delegate passvalue:self.textView.text];
    }
    if ( self.type > 6) {
        [self CreateDescriptionWithTitle:self.title];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)CreateDescriptionWithTitle:(NSString *)title {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:title forKey:@"title"];
    [paraDic setObject:_textView.text forKey:@"content"];
    
    [AFNetClient POST_Path:AdddescriptionURl params:paraDic completed:^(NSData *stringData, id JSONDict) {
   
        [_hud setHidden:YES];
        if ([JSONDict[@"Code"] isEqual:@0]) {
            
            self.blockDescriptionId(JSONDict[@"Data"]);
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            [MBProgressHUD showMessage:JSONDict[@"Message"] toView:self.view];
        }
        NSLog(@"--添加介绍--+++++++++++%@-------------%@", JSONDict[@"Data"], JSONDict);
    } failed:^(NSError *error) {
        [_hud setHidden:YES];
        NSLog(@"---------------------->>>>>>%@",error);
    }];
}



////修改介绍
//- (void)ModifyDescriptionURLAction {
//    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
//    [paraDic setObject:self.mdifyDescriptionID forKey:@"iD"];
//    [paraDic setObject:self.title forKey:@"title"];
//    [paraDic setObject:_textView.text forKey:@"content"];
//    
//    [AFNetClient POST_Path:ModifyDescriptionURl params:paraDic completed:^(NSData *stringData, id JSONDict) {
//        NSNumber *code = JSONDict[@"Code"];
//        if ([code isEqual:@0]) {
//        }
//        NSLog(@"--介绍修改--%@=++++++++++++%@-------------%@", JSONDict[@"Data"], JSONDict,self.title);
//    } failed:^(NSError *error) {
//        NSLog(@"---------------------->>>>>>%@",error);
//    }];
//}


//textView的基本设置
-(void)createDetailTextView {
    _textView = [[UITextView alloc]init];
    _label = [[UILabel alloc]init];
    _placeHolder = [[UILabel alloc]init];
    
    //textView上边的基本设置
    [self setTextViewBasic];
    
    CGFloat height = self.textHeight;
    _label.text = [NSString stringWithFormat:@"%lu",self.textNumber - _text.length];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 12, kScreen_Width, height)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    _placeHolder.frame = CGRectMake(0, 5, kScreen_Width, 28);
    _placeHolder.backgroundColor = [UIColor clearColor];
    _placeHolder.textColor = [UIColor colorWithHexString:@"#cccccc"];
    
    
    _label.textAlignment = NSTextAlignmentRight;
    _label.frame = CGRectMake(kScreen_Width - 48 - 12, height - 28, 48, 28);
    _label.font = [UIFont systemFontOfSize:17];
    _label.textColor = [UIColor colorWithHexString:@"#cccccc"];
    
    
    _textView.frame = CGRectMake(12, 0, kScreen_Width - 24, height - 28);
    [_textView becomeFirstResponder];
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;
    _textView.delegate = self;
    if (self.textNumber < 50) {
        _textView.scrollEnabled = NO;
    }else {
        _textView.scrollEnabled = YES;
    }

    _textView.showsHorizontalScrollIndicator = NO;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:17];
    
    [_textView addSubview:_placeHolder];
    [view addSubview:_label];
    [view addSubview:_textView];
}

- (void)setTextViewBasic {
    switch (self.type) {
        case 1:
        {
            self.title = @"名称";
            self.textNumber = 30;
            self.textHeight = 85;
            if (![_text isEqual:@""] && _text != NULL ) {
//                _textView.backgroundColor = [UIColor redColor];
                _textView.text = _text;
            }else {
                self.placeHolder.text = @"  请输入公司名称";
            }
        }
            break;
        case 2:
        {
            self.title = @"股东";
            self.textNumber = 300;
            self.textHeight = 250;
            if (![_text isEqual:@""] && _text != NULL) {
                _textView.text = _text;
            }else {
                self.placeHolder.text = @"  请输入股东";
            }
        }
            break;
        case 3:
        {
            self.title = @"电话";
            self.textNumber = 11;
            self.textView.keyboardType = UIKeyboardTypeNumberPad;
            self.textHeight = 85;
            if (![_text isEqual:@""] && _text != NULL) {
                _textView.text = _text;
            }else {
                self.placeHolder.text = @"  请输入电话";
            }
        }
            break;
        case 4:
        {
            self.title = @"备用电话";
            self.textView.keyboardType = UIKeyboardTypeNumberPad;
            self.textNumber = 11;
            self.textHeight = 85;
            if (![_text isEqual:@""] && _text != NULL) {
                _textView.text = _text;
            }else {
                self.placeHolder.text = @"  请输入备用电话";
            }
        }
            break;
        case 5:
        {
            self.title = @"公司网址";
            self.textNumber = 30;
            self.textHeight = 85;
            if (![_text isEqual:@""] && _text != NULL) {
                _textView.text = _text;
            }else {
                self.placeHolder.text = @"  请输入公司网址";
            }
        }
            break;
        case 6:
        {
            self.title = @"地址";
            self.textNumber = 30;
            self.textHeight = 85;
            if (![_text isEqual:@""] && _text != NULL) {
                _textView.text = _text;
            }else {
                self.placeHolder.text = @"  请输入地址";
            }
        }
            break;
        case 7:
        {
            self.title = @"公司简介";
            self.textNumber = 300;
            self.textHeight = 250;
            if (![_text isEqual:@""] && _text != NULL) {
                _textView.text = _text;
            }else {
                
                self.placeHolder.text = @"  请输入公司简介";
            }
        }
            break;
        case 8:
        {
            self.title = @"企业管理团队介绍";
            self.textNumber = 300;
            self.textHeight = 250;
            if (![_text isEqual:@""] && _text != NULL) {
                _textView.text = _text;
            }else {
                self.placeHolder.text = @"  请输入管理团队介绍";
            }
        }
            break;
        case 9:
        {
            self.title = @"业务范围介绍";
            self.textNumber = 300;
            self.textHeight = 250;
            if (![_text isEqual:@""] && _text != NULL) {
                _textView.text = _text;
            }else {
                self.placeHolder.text = @"  请输入业务范围介绍";
            }
        }
            break;
        case 10:
        {
//          self.title = @"内容";
            self.textNumber = 300;
            self.textHeight = 250;
            if (![_text isEqual:@""] && _text != NULL && ![_text isEqualToString:@"(空)"]) {
                _textView.text = _text;
            }else {
//                 self.placeHolder.text = @"  请输入内容";
                self.placeHolder.text = [NSString stringWithFormat:@"请输入%@", self.title];
            }
        }
            break;
        default:
            break;
    }
}








- (void)textViewDidChange:(UITextView *)textView {
    
    if ([textView.text containsString:@"\n"]) {
        NSMutableString *mStr = [NSMutableString stringWithString:textView.text];
        [mStr deleteCharactersInRange:NSMakeRange(mStr.length-1, 1)];
        textView.text = mStr;
        return;
    }
    
//    if (textView.text.length >= _textNumber) {
//        
//        textView.text = [textView.text substringToIndex:_textNumber];
//        
//    }
    
    if (_textView.text.length > 0) {
        _placeHolder.hidden = YES;
    }else {
        _placeHolder.hidden = NO;
        
        switch (self.type) {
            case 1:
                
                self.placeHolder.text = @"  请输入公司名称";
                break;
            case 2:

                self.placeHolder.text = @"  请输入股东";
                break;
            case 3:
                self.placeHolder.text = @"  请输入电话";

                break;
            case 4:
                    self.placeHolder.text = @"  请输入备用电话";

                break;
            case 5:

                    self.placeHolder.text = @"  请输入公司网址";
                break;
            case 6:

                    self.placeHolder.text = @"  请输入地址";
                break;
            case 7:

                self.placeHolder.text = @"  请输入公司简介";
                break;
            case 8:

                self.placeHolder.text = @"  请输入管理团队介绍";
                break;
            case 9:
                
                self.placeHolder.text = @"  请输入业务范围介绍";
                break;
            case 10:
                
                    self.placeHolder.text = @"  请输入内容";
                break;
            default:
                break;
        }
    }


//    NSInteger count = _textNumber - textView.text.length;
//    [_label setText:[NSString stringWithFormat:@"%ld",(long)count]];
    
}

-(void)textViewEditChanged:(NSNotification *)obj
{
    UITextView *textView = (UITextView *)obj.object;
    
    [self.view computeWordCountWithTextView:textView remindLab:_placeHolder warningLabel:_label maxNumber:_textNumber];
}




#pragma mark - 返回按钮事件
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
