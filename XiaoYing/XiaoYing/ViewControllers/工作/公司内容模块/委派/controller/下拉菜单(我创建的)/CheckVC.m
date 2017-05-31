//
//  CheckVC.m
//  XiaoYing
//
//  Created by ZWL on 16/5/18.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "CheckVC.h"
#import "PlayView.h"

@interface CheckVC ()
{
    UIView *_baseView;
}

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *detailLab;

@end

@implementation CheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-(540/2))/2, (kScreen_Height-(800/2))/2, 540/2, 800/2)];
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.layer.cornerRadius = 6;
    _baseView.clipsToBounds = YES;
    [self.view addSubview:_baseView];

    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 16)];
    _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLab.text = @"任务1 : 标题";
    _titleLab.font = [UIFont systemFontOfSize:16];
    [_baseView addSubview:_titleLab];
    
    UILabel *proportionLab = [[UILabel alloc] initWithFrame:CGRectMake(10, _titleLab.bottom+6, 150, 12)];
    proportionLab.text = @"任务比重 : 高";
    proportionLab.font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:proportionLab.text];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#848484"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(0, 6)];
    [attribute addAttributes:@{
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#fc5834"],
                               NSFontAttributeName : [UIFont systemFontOfSize:12]
                               }range:NSMakeRange(6, proportionLab.text.length - 6)];
    proportionLab.attributedText = attribute;
    [_baseView addSubview:proportionLab];

    _detailLab = [[UILabel alloc] initWithFrame:CGRectMake(10, proportionLab.bottom+6, _baseView.width-10*2, 14)];
    _detailLab.text = @"任务成功任务成功任务成功任务成功任";
    _detailLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _detailLab.font = [UIFont systemFontOfSize:14];
    [_baseView addSubview:_detailLab];
    

    // 播放语音视图
    PlayView *playView = [[PlayView alloc] initWithFrame:CGRectMake(10, _detailLab.bottom+6, _baseView.width-20, 30)];
    playView.timeStr = @"60";
//    playView.contentURL = url;
    [_baseView addSubview:playView];
    
    // 获取按钮的宽度
    float itemWidth = (_baseView.width-(10*4))/3.0;
    for (int i = 0; i < 5; i++) {
        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imgBtn.frame = CGRectMake(10+(i%3)*(itemWidth+10), playView.bottom+6+(i/3)*(itemWidth+6), itemWidth, itemWidth);
        [imgBtn setImage:[UIImage imageNamed:@"003"] forState:UIControlStateNormal];
//        imgBtn.backgroundColor = [UIColor greenColor];
        [imgBtn addTarget:self action:@selector(imgBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        [_baseView addSubview:imgBtn];
    }
    

}

- (void)imgBtnAction:(UIButton *)imgBtn
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches anyObject].view == self.view) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
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
