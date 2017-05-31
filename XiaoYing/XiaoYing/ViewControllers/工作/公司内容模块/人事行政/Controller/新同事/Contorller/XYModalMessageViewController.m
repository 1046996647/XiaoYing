//
//  XYModalMessageViewController.m
//  XiaoYing
//
//  Created by qj－shanwen on 16/7/23.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "XYModalMessageViewController.h"

@interface XYModalMessageViewController ()
{
    UIView * _messageBackView;
    AppDelegate *_appDelegate;
}


@end

@implementation XYModalMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    _messageBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 540/2, 0)];
    _messageBackView.backgroundColor = [UIColor whiteColor];
    _messageBackView.layer.cornerRadius = 6;
    _messageBackView.clipsToBounds = YES;
    [self.view addSubview:_messageBackView];

    UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 112/2, 112/2)];
    userImg.image = [UIImage imageNamed:@"ying"];
    userImg.layer.cornerRadius = 5;
    userImg.clipsToBounds = YES;
    [_messageBackView addSubview:userImg];
    

    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(userImg.right+12, 33, 200, 16)];
    titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLab.text = @"标题标题标题标题";
    titleLab.userInteractionEnabled = YES;
    titleLab.font = [UIFont systemFontOfSize:16];
    [_messageBackView addSubview:titleLab];
    
 
    UILabel *emailLab = [[UILabel alloc] initWithFrame:CGRectMake(userImg.right+12, titleLab.bottom+7, 200, 12)];
    emailLab.textColor = [UIColor colorWithHexString:@"#848484"];
    emailLab.text = @"31313232@qq.com";
    emailLab.font = [UIFont systemFontOfSize:12];
    [_messageBackView addSubview:emailLab];

    UILabel *regionLab = [[UILabel alloc] initWithFrame:CGRectMake(userImg.left, userImg.bottom+15, 112/2, 14)];
    regionLab.textColor = [UIColor colorWithHexString:@"#848484"];
    regionLab.text = @"地区";
    regionLab.textAlignment = NSTextAlignmentRight;
    regionLab.font = [UIFont systemFontOfSize:14];
    [_messageBackView addSubview:regionLab];

    UILabel *regionDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(regionLab.right+12, userImg.bottom+15, _messageBackView.width-(regionLab.right+12)-12, 14)];
    regionDetailLab.textColor = [UIColor colorWithHexString:@"#333333"];
    regionDetailLab.text = @"杭州江干区";
    regionDetailLab.font = [UIFont systemFontOfSize:14];
    [_messageBackView addSubview:regionDetailLab];
    

    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(regionDetailLab.left, regionDetailLab.bottom+7, regionDetailLab.width, .5)];
    line1.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [_messageBackView addSubview:line1];
    

    UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(regionLab.left, line1.bottom+7, 112/2, 14)];
    addressLab.textColor = [UIColor colorWithHexString:@"#848484"];
    addressLab.text = @"联系地址";
    addressLab.textAlignment = NSTextAlignmentRight;
    addressLab.font = [UIFont systemFontOfSize:14];
    [_messageBackView addSubview:addressLab];
    

    UILabel *addressDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(addressLab.right+12, addressLab.top, _messageBackView.width-(addressLab.right+12)-12, 14)];
    addressDetailLab.textColor = [UIColor colorWithHexString:@"#333333"];
    addressDetailLab.text = @"迪凯银座1301";
    //    addressDetailLab.textAlignment = NSTextAlignmentRight;
    addressDetailLab.font = [UIFont systemFontOfSize:14];
    [_messageBackView addSubview:addressDetailLab];
    

    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(addressDetailLab.left, addressDetailLab.bottom+7, addressDetailLab.width, .5)];
    line2.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [_messageBackView addSubview:line2];
    

    UILabel *personnalLab = [[UILabel alloc] initWithFrame:CGRectMake(regionLab.left, line2.bottom+7, 112/2, 14)];
    personnalLab.textColor = [UIColor colorWithHexString:@"#848484"];
    personnalLab.text = @"个性签名";
    personnalLab.textAlignment = NSTextAlignmentRight;
    personnalLab.font = [UIFont systemFontOfSize:14];

    UILabel *personnalDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(personnalLab.right+12, personnalLab.top, _messageBackView.width-(personnalLab.right+12)-12, 14)];
    personnalDetailLab.textColor = [UIColor colorWithHexString:@"#333333"];
    personnalDetailLab.text = @"我就是我";
    personnalDetailLab.font = [UIFont systemFontOfSize:14];
    [_messageBackView addSubview:personnalDetailLab];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(personnalDetailLab.left, personnalDetailLab.bottom + 7,personnalDetailLab.width, .5)];
    line.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [_messageBackView addSubview:line];
    
    _messageBackView.frame = CGRectMake((kScreen_Width-540/2)/2, (kScreen_Height-line.bottom)/2, 540/2, line.bottom + 12);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches anyObject].view == self.view) {
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
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
