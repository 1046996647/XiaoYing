//
//  InputMemberIinfo.m
//  XiaoYing
//
//  Created by MengFanBiao on 16/6/28.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "InputMemberInfoVC.h"

@interface InputMemberInfoVC ()<UITextViewDelegate>
{
    UITextView *_tv;
    UITextField *_tf;
}

@property (nonatomic, strong)UILabel *remindLab;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic )NSInteger number;


@end

@implementation InputMemberInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];

    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 12, kScreen_Width, 70)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    _tv = [[UITextView alloc] initWithFrame:CGRectMake(12, 0, kScreen_Width-24, 70)];
    _tv.font = [UIFont systemFontOfSize:17];
    _tv.showsHorizontalScrollIndicator = NO;
    _tv.showsVerticalScrollIndicator = NO;
    [_tv becomeFirstResponder];
    _tv.autocorrectionType = UITextAutocorrectionTypeNo;
    _tv.delegate = self;
    [view addSubview:_tv];

    _remindLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 12, 250, 14)];
    _remindLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _remindLab.font = [UIFont systemFontOfSize:17];
    [_tv addSubview:_remindLab];
    
    _label = [[UILabel alloc]init];
    _label.textAlignment = NSTextAlignmentRight;
    _label.font = [UIFont systemFontOfSize:17];
    _label.textColor = [UIColor colorWithHexString:@"#cccccc"];
//    [view addSubview:_label];

    
    if (self.indexPath.section == 0) {

        if (self.indexPath.row == 0) {
            self.title = @"真实姓名";
            _number = 20;
            if (_DetailOfCell.length > 0) {
                _tv.text = [NSString stringWithFormat:@"%@", _DetailOfCell];
                _tv.textColor = [UIColor colorWithHexString:@"#333333"];
            }else {
                _remindLab.text = @"请输入姓名";
                 _remindLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];
            }
            
        } else if (self.indexPath.row == 1) {
            self.title = @"员工号";
            
            _tv.keyboardType = UIKeyboardTypeNumberPad;
            _number = 12;
            
            if (_DetailOfCell.length > 0) {
                _tv.text = [NSString stringWithFormat:@"%@", _DetailOfCell];
                _tv.textColor = [UIColor colorWithHexString:@"#333333"];
            }else {
               _remindLab.text = @"请输入员工号";
                _remindLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];
            }
            

        } else if (self.indexPath.row == 2){
            self.title = @"号码";
            
            _tv.keyboardType = UIKeyboardTypeNumberPad;
            _number = 11;
            if (_DetailOfCell.length > 0) {
                _tv.text = [NSString stringWithFormat:@"%@", _DetailOfCell];
                _tv.textColor = [UIColor colorWithHexString:@"#333333"];
            }else {
               _remindLab.text = @"请输入手机号";
                _remindLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];
            }

        }else {
            self.title = @"地址";
            
            _number = 30;
            if (_DetailOfCell.length > 0) {
                _tv.text = [NSString stringWithFormat:@"%@", _DetailOfCell];
                _tv.textColor = [UIColor colorWithHexString:@"#333333"];
            }else {
                _remindLab.text = @"请输入地址";
                _remindLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];
            }

        }
        
        _label.frame = CGRectMake(_tv.right - 28, _tv.bottom - 25, 28, 25);
        
    } else {
        
        self.title = @"备注";
        view.frame = CGRectMake(0, 12, kScreen_Width, 250);
        _tv.frame = CGRectMake(12, 0, kScreen_Width - 24, 225);
        _label.frame = CGRectMake(view.width - 40 - 12, view.bottom - 40, 40, 30);
        _number = 300;
        // 提醒标签
        
        
        if (_DetailOfCell.length > 0) {
            _tv.text = [NSString stringWithFormat:@"%@", _DetailOfCell];
            _tv.textColor = [UIColor colorWithHexString:@"#333333"];
        }else {
            _remindLab.text = @"请输入";
            _remindLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];
        }

        

    }
   _label.text = [NSString stringWithFormat:@"%ld",(long)_number - _DetailOfCell.length];
    [view addSubview:_label];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification" object:_tv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)textViewEditChanged:(NSNotification *)obj
{
    UITextView *textView = (UITextView *)obj.object;
    
    [self.view computeWordCountWithTextView:textView remindLab:_remindLab warningLabel:_label maxNumber:_number];
}

//右上角按钮点击事件
- (void)rightBtnAction:(UIButton *)btn
{
    [_tv resignFirstResponder];
    if (![_tv.text isEqualToString:@""]) {
        _valueBlock(_tv.text);
    }else {
        _valueBlock(@"$");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    
    if ([textView.text containsString:@"\n"]) {
        NSMutableString *mStr = [NSMutableString stringWithString:textView.text];
        [mStr deleteCharactersInRange:NSMakeRange(mStr.length-1, 1)];
        textView.text = mStr;
        return;
    }
    
//    if (textView.text.length >= _number) {
//        
//        textView.text = [textView.text substringToIndex:_number];
//    }
    
    
        
        if (self.indexPath.section == 0) {
            
            if (self.indexPath.row == 0) {
                    _remindLab.text = @"请输入姓名";
                    _remindLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];

            } else if (self.indexPath.row == 1) {
                    _remindLab.text = @"请输入员工号";
                    _remindLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];
            } else if (self.indexPath.row == 2){
                     _remindLab.text = @"请输入手机号";
                    _remindLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];
            }else if (self.indexPath.row == 5){
                    _remindLab.text = @"请输入地址";
                    _remindLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];
            }
        }else {

                    _remindLab.text = @"请输入";
                    _remindLab.textColor = [UIColor colorWithHexString:@"aaaaaa"];
            
        }
    

   
}







- (void) textViewDidBeginEditing:(UITextView *)textView {
   
}




@end
