//
//  XYNoteCountViewController.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/9/8.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "XYNoteCountViewController.h"
#import "XYNoteModel.h"
#import "XYNoteTool.h"

@interface XYNoteCountViewController ()<UITextViewDelegate>

@property(nonatomic,strong)UILabel * placeholderLabel;
@property(nonatomic,strong)UITextView * countView;

@end

@implementation XYNoteCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑便签";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self setNav];
    [self initUI];
    [self showNote];
}

-(void)setNav{
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 18)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(saveButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc]initWithFrame:rightButton.frame];
    [rightView addSubview:rightButton];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void)initUI{
    
    self.countView = [[UITextView alloc]initWithFrame:CGRectMake(12, 0, kScreen_Width - 12, kScreen_Height - 64)];
    [self.view addSubview:self.countView];
    //让countView成为第一响应者
    [self.countView becomeFirstResponder];
    self.countView.textColor = [UIColor colorWithHexString:@"#333333"];
    self.countView.font = [UIFont systemFontOfSize:14];
    self.countView.delegate = self;

    //对键盘进行监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeKeyboard:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

#pragma mark - 键盘通知方法 methodsForKeyBoard

-(void)changeKeyboard:(NSNotification*)notification{
    NSDictionary *dic = notification.userInfo;
    CGRect keyBoardframe = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[dic[UIKeyboardAnimationCurveUserInfoKey] longValue] animations:^{
        
        if (keyBoardframe.origin.y == kScreen_Height) {
            self.countView.height = kScreen_Height - 64;
        }
        
        self.countView.height = keyBoardframe.origin.y - 64;

        //通过动画，修改约束
        [self.view layoutIfNeeded];
    } completion:nil];
}

//取消对键盘的监听
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for (UIView *view in self.view.subviews) {
        [view resignFirstResponder];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



// 填充内容
- (void)showNote
{
    self.countView.text = self.model.NoteContent;
}


- (NSString *)getTodayDate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSString *nowStr = [dateFormatter stringFromDate:now];
    return nowStr;
}

-(void)saveButton{
    NSLog(@"保存按钮");
    if (self.countView.text.length > 0) {//如果文本输入框的字数大于0才可以保存
        XYNoteModel *modifyModel = self.model;
        modifyModel.NoteContent = self.countView.text;
        modifyModel.NoteTime = [self getTodayDate];
        
        //修改数据
        [XYNoteTool modifyData:modifyModel];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showMessage:@"便签内容不能为空"];
    }
   
}

//当滚动时，收起键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.countView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
