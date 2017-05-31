//
//  DetailView.m
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/15.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "DetailView.h"
#import "CompanyDetailVC.h"
@interface DetailView ()<UITextViewDelegate>


@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UILabel *placeHolder;
@end

@implementation DetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    //基本设置
    [self basicSet];
    
    //textView的基本设置
    [self createDetailTextView];
    

}

//基本设置
- (void)basicSet {
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(setKeepAction)];
    rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}
- (void)setKeepAction {
    [_textView resignFirstResponder];
     NSLog(@"确定%@",self.textView.text);
    if ([self.delegate respondsToSelector:@selector(passvalue:)]) {
            [self.delegate passvalue:self.textView.text];
    }
    if ( self.type > 6) {
        [self ModifyDescriptionURLAction];
    }
     [self.navigationController popViewControllerAnimated:YES];
}



//修改介绍
- (void)ModifyDescriptionURLAction {
     NSLog(@"----------------=========%@",_mdifyDescriptionID);
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.mdifyDescriptionID forKey:@"iD"];
    [paraDic setObject:self.title forKey:@"title"];
    [paraDic setObject:_textView.text forKey:@"content"];
    
    [AFNetClient POST_Path:ModifyDescriptionURl params:paraDic completed:^(NSData *stringData, id JSONDict) {
        NSLog(@"--介绍修改--%@=++++++++++++%@-------------%@", JSONDict[@"Data"], JSONDict,self.title);
    } failed:^(NSError *error) {
        NSLog(@"---------------------->>>>>>%@",error);
    }];
}


//textView的基本设置
-(void)createDetailTextView {
    _textView = [[UITextView alloc]init];
    _label = [[UILabel alloc]init];
    _placeHolder = [[UILabel alloc]init];
    
    //textView上边的基本设置
    [self setTextViewBasic];

    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 12, kScreen_Width, _textHeight)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    if (![_text isEqualToString:@"(空)"]) {
        _label.text = [NSString stringWithFormat:@"%ld",self.textNumber - _text.length];
    }else {
        _label.text = [NSString stringWithFormat:@"%ld",self.textNumber];
    }
    _placeHolder.frame = CGRectMake(0, 3, kScreen_Width, 28);
    _placeHolder.backgroundColor = [UIColor clearColor];
    _placeHolder.textColor = [UIColor colorWithHexString:@"#cccccc"];
 
    _textView.frame = CGRectMake(12, 0, kScreen_Width - 24, _textHeight - 28);
    [_textView becomeFirstResponder];
    _textView.delegate = self;
    if (self.textNumber < 50) {
        _textView.scrollEnabled = NO;
    }else {
         _textView.scrollEnabled = YES;
    }
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.contentSize = CGSizeMake(kScreen_Width - 24, _textHeight - 28);
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:17];
    
    _label.textAlignment = NSTextAlignmentRight;
    _label.frame = CGRectMake(kScreen_Width - 48 - 12, _textView.bottom, 48, 28);
    _label.font = [UIFont systemFontOfSize:17];
    _label.textColor = [UIColor colorWithHexString:@"#cccccc"];
    
    [_textView addSubview:_placeHolder];
    [view addSubview:_textView];
    [view addSubview:_label];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification" object:_textView];
}

- (void)setTextViewBasic {
    switch (self.type) {
        case 1:
        {
            self.title = @"名称";
            self.textNumber = 30;
            self.textHeight = 85;
            if (_text.length > 0) {
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
           if (_text.length > 0) {
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
            if (_text.length > 0) {
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
            if (_text.length > 0) {
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
            if (_text.length > 0) {
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
            if (_text.length > 0) {
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
            if (_text.length > 0 && ![_text isEqualToString:@"(空)"]) {
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
            if (_text.length > 0 && ![_text isEqualToString:@"(空)"]) {
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
            if (_text.length > 0 && ![_text isEqualToString:@"(空)"]) {
                _textView.text = _text;
            }else {
                self.placeHolder.text = @"  请输入业务范围介绍";
            }
        }
            break;
        case 10:
        {
            self.placeHolder.text = [NSString stringWithFormat:@"请输入%@", self.title];
            self.textNumber = 300;
            self.textHeight = 250;
        }
            break;
        default:
            break;
    }
}


-(void)textViewEditChanged:(NSNotification *)obj
{
    UITextView *textView = (UITextView *)obj.object;
    
      [self.view computeWordCountWithTextView:textView remindLab:_placeHolder warningLabel:_label maxNumber:_textNumber];
}






- (void)textViewDidChange:(UITextView *)textView {

    if ([textView.text containsString:@"\n"]) {
        NSMutableString *mStr = [NSMutableString stringWithString:textView.text];
        [mStr deleteCharactersInRange:NSMakeRange(mStr.length-1, 1)];
        textView.text = mStr;
        return;
    }
//
//    if (textView.text.length >= _textNumber) {
//        
//        textView.text = [textView.text substringToIndex:_textNumber];
//        
//    }

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


#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




#pragma mark - 返回按钮事件
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
