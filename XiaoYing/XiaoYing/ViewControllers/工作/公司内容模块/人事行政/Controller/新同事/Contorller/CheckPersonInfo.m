//
//  CheckColleaguesInfoVC.m
//  XiaoYing
//
//  Created by MengFanBiao on 16/6/12.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "CheckPersonInfo.h"

@interface CheckPersonInfo ()
{
    UIView *_baseView;
    AppDelegate *_appDelegate;
    
}

@end

@implementation CheckPersonInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 540/2, 0)];
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.layer.cornerRadius = 6;
    _baseView.clipsToBounds = YES;
    [self.view addSubview:_baseView];
    
    UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 112/2, 112/2)];
//    userImg.image = [UIImage imageNamed:@"ying"];
    NSString *iconURL = [NSString replaceString:_FaceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
    [userImg sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"newfriends"]];
    userImg.layer.cornerRadius = 5;
    userImg.clipsToBounds = YES;
    [_baseView addSubview:userImg];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(userImg.right+12, 33, _baseView.width - userImg.right - 24, 16)];
    titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLab.text = _Nick;
    titleLab.font = [UIFont systemFontOfSize:16];
    [_baseView addSubview:titleLab];
    
    UILabel *emailLab = [[UILabel alloc] initWithFrame:CGRectMake(userImg.right+12, titleLab.bottom+7, 200, 12)];
    emailLab.textColor = [UIColor colorWithHexString:@"#848484"];
    emailLab.text = _XiaoYinCode;
    emailLab.font = [UIFont systemFontOfSize:12];
    [_baseView addSubview:emailLab];
    
    UILabel *regionLab = [[UILabel alloc] initWithFrame:CGRectMake(userImg.left, userImg.bottom+15, 112/2, 14)];
    regionLab.textColor = [UIColor colorWithHexString:@"#848484"];
    regionLab.text = @"地区";
    regionLab.textAlignment = NSTextAlignmentRight;
    regionLab.font = [UIFont systemFontOfSize:14];
    [_baseView addSubview:regionLab];
    

    
    UILabel *regionDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(regionLab.right+12, userImg.bottom+15, _baseView.width-(regionLab.right+12)-12, 14)];
    regionDetailLab.textColor = [UIColor colorWithHexString:@"#333333"];
    if ([_region isEqual: @""]|| _region == nil) {
        regionDetailLab.text = @"(空)";
        regionDetailLab.textColor = [UIColor colorWithHexString:@"#848484"];
    }else {
        regionDetailLab.text = _region;
    }
    
    //    regionDetailLab.backgroundColor = [UIColor redColor];
    //    regionDetailLab.textAlignment = NSTextAlignmentRight;
    regionDetailLab.font = [UIFont systemFontOfSize:14];
    [_baseView addSubview:regionDetailLab];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(regionDetailLab.left, regionDetailLab.bottom+7, regionDetailLab.width, .5)];
    line1.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [_baseView addSubview:line1];
    
    
    UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(regionLab.left - 8, line1.bottom+7, 112/2 + 8, 14)];
    addressLab.textColor = [UIColor colorWithHexString:@"#848484"];
    addressLab.text = @"个性签名";
    addressLab.textAlignment = NSTextAlignmentRight;
    addressLab.font = [UIFont systemFontOfSize:14];
    [_baseView addSubview:addressLab];
    
    UILabel *addressDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(addressLab.right+12, addressLab.top, _baseView.width-(addressLab.right+12)-12, 14)];
    addressDetailLab.textColor = [UIColor colorWithHexString:@"#333333"];
    //    addressDetailLab.textAlignment = NSTextAlignmentRight;
    if ([_Singer isEqual: @""] || _Singer == nil) {
        addressDetailLab.text = @"(空)";
        addressDetailLab.textColor = [UIColor colorWithHexString:@"#848484"];
    }else {
        addressDetailLab.text = _Singer;
    }
    addressDetailLab.font = [UIFont systemFontOfSize:14];
    [_baseView addSubview:addressDetailLab];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(addressDetailLab.left, addressDetailLab.bottom+7, addressDetailLab.width, .5)];
    line2.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
    [_baseView addSubview:line2];
    
//    UILabel *personnalLab = [[UILabel alloc] initWithFrame:CGRectMake(regionLab.left, line2.bottom+7, 112/2, 14)];
//    personnalLab.textColor = [UIColor colorWithHexString:@"#848484"];
//    personnalLab.text = @"个性签名";
//    personnalLab.textAlignment = NSTextAlignmentRight;
//    personnalLab.font = [UIFont systemFontOfSize:14];
//    [_baseView addSubview:personnalLab];
//    
//    UILabel *personnalDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(personnalLab.right+12, personnalLab.top, _baseView.width-(personnalLab.right+12)-12, 14)];
//    personnalDetailLab.textColor = [UIColor colorWithHexString:@"#333333"];
//    if ([_Singer isEqual: @""] || _Singer == nil) {
//        personnalDetailLab.text = @"(空)";
//        personnalDetailLab.textColor = [UIColor colorWithHexString:@"#848484"];
//    }else {
//       personnalDetailLab.text = _Singer;
//    }
//    //    personnalDetailLab.textAlignment = NSTextAlignmentRight;
//    personnalDetailLab.font = [UIFont systemFontOfSize:14];
//    [_baseView addSubview:personnalDetailLab];
//    
//    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(personnalDetailLab.left, personnalDetailLab.bottom+7, personnalDetailLab.width, .5)];
//    line3.backgroundColor = [UIColor colorWithHexString:@"d5d7dc"];
//    [_baseView addSubview:line3];
    
        
    _baseView.frame = CGRectMake((kScreen_Width-540/2)/2, (kScreen_Height-(line2.bottom+10) - 100)/2, 540/2, line2.bottom+10);
    
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



@end
