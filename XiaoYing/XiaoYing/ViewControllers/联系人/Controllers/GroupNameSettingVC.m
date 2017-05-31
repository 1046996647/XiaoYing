                                                                                                                  //
//  GroupNameSetyingVC.m
//  XiaoYing
//
//  Created by ZWL on 16/8/17.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "GroupNameSettingVC.h"
#import "RCIM.h"

@interface GroupNameSettingVC ()<UITextViewDelegate>
{
    UITextView *_textView;
    UILabel *_remindLab;
    MBProgressHUD *_hud;

}

@end

@implementation GroupNameSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"群名称";
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 12, kScreen_Width, 55)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];

    
    //文本视图
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(12, 0, kScreen_Width-12, 55)];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.delegate = self;
    _textView.text = self.name;
    _textView.textColor = [UIColor colorWithHexString:@"333333"];
    [_textView becomeFirstResponder];
    [baseView addSubview:_textView];
    
    //剩余字数label
    _remindLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 20 - 12, 30, 40, 20)];
    _remindLab.text = @"12";
    _remindLab.font = [UIFont systemFontOfSize:12];
    _remindLab.textColor = [UIColor colorWithHexString:@"#848484"];
    [baseView addSubview:_remindLab];
    
    //导航栏的保存按钮
    [self initRightBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:_textView];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.view computeWordCountWithTextView:_textView remindLab:nil warningLabel:_remindLab maxNumber:12];
}


//导航栏的保存按钮
- (void)initRightBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 20);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightBar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//保存
- (void)saveAction
{
    
    //键盘收起
    [_textView resignFirstResponder];
    
    if (_textView.text.length == 0) {
        
        [MBProgressHUD showMessage:@"群名称不能为空"];
          return;
    }
    
    if ([_textView.text isEqualToString:self.name]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"正在加载...";
        
        NSString *strUrl = [NSString stringWithFormat:@"%@&roomId=%@&name=%@",SetName, self.model.RoomId, _textView.text];
        [AFNetClient  POST_Path:strUrl completed:^(NSData *stringData, id JSONDict) {
            
            [[RCIMClient sharedRCIMClient] setDiscussionName:self.model.RongCloudChatRoomId name:_textView.text success:^{
                
            } error:^(RCErrorCode status) {
                
            }];
            
            if (self.clickBlock) {
                self.clickBlock(_textView.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
            // 刷新讨论组列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDiscussionListNotification" object:nil];
    

        } failed:^(NSError *error) {
            [_hud hide:YES];
            NSLog(@"请求失败Error--%ld",(long)error.code);
        }];
        
    }

    
}

#pragma mark - Notification Method
-(void)textViewEditChanged:(NSNotification *)obj
{
    
    UITextView *textView = (UITextView *)obj.object;
    
    if ([textView.text containsString:@"\n"]) {
        
        NSMutableString *mStr = [NSMutableString stringWithString:textView.text];
        [mStr deleteCharactersInRange:NSMakeRange(mStr.length-1, 1)];
        textView.text = mStr;
        [self saveAction];
        return;
    }
    
    [self.view computeWordCountWithTextView:_textView remindLab:nil warningLabel:_remindLab maxNumber:12];
}


@end
