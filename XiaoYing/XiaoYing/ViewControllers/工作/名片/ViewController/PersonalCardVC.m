//
//  PersonalCardVC.m
//  XiaoYing
//
//  Created by GZH on 16/8/15.
//  Copyright © 2016年 MengFanBiao. All rights reserved.
//

#import "PersonalCardVC.h"
#import "NextCardView.h"
#import "CardOfTheCompanyView.h"
#import "PersonalCardModel.h"

#import <UShareUI/UShareUI.h>

static NSString* const UMS_Title = @"欢迎使用【友盟+】社会化组件U-Share";
static NSString* const UMS_Text = @"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！";

static NSString* const UMS_THUMB_IMAGE = @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
static NSString* const UMS_IMAGE = @"https://mobile.umeng.com/images/pic/home/social/img-1.png";

//static NSString* const UMS_WebLink = @"http://192.168.10.67:2323/Home/CompanyCard";
//static NSString* const UMS_WebLink = @"http://192.168.10.67:2323/Home/PersonalCard";


static NSString *UMS_SHARE_TBL_CELL = @"UMS_SHARE_TBL_CELL";

@interface PersonalCardVC ()
@property (nonatomic, strong)UISegmentedControl *segment;
@property (nonatomic, strong)NextCardView *cardView;
@property (nonatomic, strong)CardOfTheCompanyView *cardViewOfCompany;
@property (nonatomic,strong) MBProgressHUD *hud;

@property (nonatomic, strong) NSString *webUrl;

@end

@implementation PersonalCardVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setSegmentAction];
}


- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self initBasic];
    
    //设置用户自定义的平台
    [UMSocialUIManager setPreDefinePlatforms:@[
                                               @(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Qzone),
                                               @(UMSocialPlatformType_Sina)
                                               ]
     ];
    
}





- (void)initBasic {
    
    [self.backButton setImage:nil forState:UIControlStateNormal];
    [self.backButton setTitle:@"收起" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#ffffff"]];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
  
    [self setSegmentAction];
    
    _cardView = [[NextCardView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64)];
    [self.view addSubview:_cardView];
    
    _cardViewOfCompany = [[CardOfTheCompanyView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
    _cardViewOfCompany.hidden = YES;
    [self.view addSubview:_cardViewOfCompany];
}

- (void)setSegmentAction {
    NSArray *array = [NSArray arrayWithObjects:@"个人名片",@"企业名片", nil];
    if (_segment == nil) {
        _segment = [[UISegmentedControl alloc]initWithItems:array];
         _segment.selectedSegmentIndex = 0;
    }
    _segment.frame = CGRectMake((kScreen_Width - 150)/2, 8.5, 150, 25);
    _segment.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    _segment.tintColor = [UIColor colorWithHexString:@"#ffffff"];
    [_segment addTarget:self action:@selector(segmentControllerAction:) forControlEvents:UIControlEventValueChanged];
    [self.navigationController.navigationBar addSubview:_segment];
}

- (void)segmentControllerAction:(UISegmentedControl *)sender {
    NSInteger selectedIndex = sender.selectedSegmentIndex;
    switch (selectedIndex) {
        case 0:
            _cardView.hidden = NO;
            _cardViewOfCompany.hidden = YES;
            break;
        case 1:
            _cardView.hidden = YES;
            _cardViewOfCompany.hidden = NO;
            break;
        default:
            break;
    }
}



- (void)rightBarButtonAction {
    
    if (_cardView.hidden) {// 公司名片
        _webUrl = [NSString stringWithFormat:@"http://192.168.10.67:2323/Home/CompanyCard?Token=%@&companyCode=%@",[UserInfo getToken], _cardViewOfCompany.model.Code];
    }
    else {
        _webUrl = [NSString stringWithFormat:@"http://192.168.10.67:2323/Home/PersonalCard?Token=%@&companyCode=%@&profileid=%@",[UserInfo getToken], _cardViewOfCompany.model.Code, [UserInfo userID]];

    }
    
    [self showBottomNormalView];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_segment removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showBottomNormalView
{
    //加入copy的操作
    //@see http://dev.umeng.com/social/ios/进阶文档#6
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2
                                     withPlatformIcon:[UIImage imageNamed:@"copy"]
                                     withPlatformName:@"复制链接"];
    
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //在回调里面获得点击的
        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
            NSLog(@"点击演示添加Icon后该做的操作");
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = @"de2332";
            [MBProgressHUD showMessage:@"链接复制成功，快去粘贴给小伙伴吧~"];
            
        }
        else {
            [self runShareWithType:platformType];
        }
    }];
}


- (void)runShareWithType:(UMSocialPlatformType)type
{
    [self shareWebPageToPlatformType:type];
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  UMS_THUMB_IMAGE;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:UMS_Title descr:UMS_Text thumImage:thumbURL];// UMS_Title不是输入的文本
    //设置网页地址
    shareObject.webpageUrl = _webUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }
    else{
        //        NSMutableString *str = [NSMutableString string];
        //        if (error.userInfo) {
        //            for (NSString *key in error.userInfo) {
        //                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
        //            }
        //        }
        //        if (error) {
        //            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        //        }
        //        else{
        //            result = [NSString stringWithFormat:@"Share fail"];
        //        }
        result = [NSString stringWithFormat:@"分享失败"];
        
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"确定", @"")
                                          otherButtonTitles:nil];
    [alert show];
}

@end
