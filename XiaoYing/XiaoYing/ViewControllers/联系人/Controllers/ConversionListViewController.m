//
//  ConversionListViewController.m
//  XiaoYing
//
//  Created by hemiying on 15/11/23.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import "ConversionListViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "AppDelegate.h"
#import "DetailTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ConnectModel.h"
#import "ChatViewController.h"
#import "HeadPictureViewController.h"
#import "ConnectViewController.h"
#import "GroupListModel.h"

#define FriendPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Friend.data"]


@interface ConversionListViewController ()<RCIMUserInfoDataSource>
{
    NSMutableDictionary *_departmentWorkmatesDic; // 部门同事数组
    UIImageView * imageWorkmate;
    UIImageView * imageFriend;
    UIImageView * imageBoth;
    
}
@property (nonatomic,strong) NSArray *employees;
@property (nonatomic,strong) NSArray *myFriendArray;


@end

@implementation ConversionListViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        //        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        
        // 最好写在init里，不然可能显示不正常
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_SYSTEM),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
        
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    //    //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    //    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION)]];
    
    
    
    self.conversationListTableView.tableFooterView = [UIView new];
    self.conversationListTableView.backgroundColor =[UIColor colorWithHexString:@"#efeff4"];
    self.isShowNetworkIndicatorView = YES;
    
    // 监听删除会话
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteConversion:) name:kDeleteConversionNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FromMyFriendViewArray:) name:@"MYFRIENDARRAY" object:nil];
    
    // 会话列表通知注册(刷新会话列表)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction) name:@"kRefreshConversionList" object:nil];
    
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 10, 18);
    [backButton setImage:[UIImage imageNamed:@"Arrow-white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)notificationAction
{
    // 所有员工
//    NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
//    self.employees = employeesArr;
    [self.conversationListTableView reloadData];
    
//    [self refreshConversationTableViewIfNeeded];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    // 从本地读取数据
    _myFriendArray = [ZWLCacheData unarchiveObjectWithFile:FriendPath];
    
    // 所有员工
    NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
    self.employees = employeesArr;
    
}


//-(void)FromMyFriendViewArray:(NSNotification *)objc{
//    friendArr = objc.object;
//}
- (void)deleteConversion: (NSNotification *)notification {
    
    if ([[notification object] isKindOfClass:[ConnectWithMyFriend class]]) {
        ConnectWithMyFriend *friend = [notification object];
        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:friend.ProfileId];
    }
    else {
        GroupListModel *model = [notification object];
        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_DISCUSSION targetId:model.RongCloudChatRoomId];
    }

    [self.conversationListTableView reloadData];
}
/*
 *重写RCConversationListViewController的onSelectedTableRow事件
 *
 *  @param conversationModelType 数据模型类型
 *  @param model                 数据模型
 *  @param indexPath             索引
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    if (model.conversationType == ConversationType_PRIVATE) {//单聊
        
        ChatViewController *chatVC =[[ChatViewController alloc]init];
        chatVC.conversationType =model.conversationType;
        chatVC.targetId = model.targetId;
        chatVC.title = model.conversationTitle;
//        chatVC.unreadMessageCount = model.unreadMessageCount;
        [self.navigationController pushViewController:chatVC animated:YES];
    }else if (model.conversationType==ConversationType_DISCUSSION){
        // 讨论组
        ChatViewController * chatVC =[[ChatViewController alloc]init];
        chatVC.conversationType = model.conversationType;
        chatVC.targetId = model.targetId;
        chatVC.title = model.conversationTitle;
//        chatVC.unreadMessageCount = model.unreadMessageCount;
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

/*
 *  将要显示会话列表单元，可以有限的设置cell的属性或者修改cell,例如：setHeaderImagePortraitStyle
 *  // 给cell添加子视图
 *  @param cell      cell
 *  @param indexPath 索引
 */
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    RCConversationModel *model= self.conversationListDataSource[indexPath.row];
    
    if (model.conversationType == ConversationType_DISCUSSION) {
        
        UIImageView *headImage = (UIImageView *)((RCConversationCell *)cell).headerImageView;
        headImage.image = [UIImage imageNamed:@"group-chat"];
        
    }
//    UILabel * departLab =[cell.contentView viewWithTag:10008];
//    [departLab removeFromSuperview];
    
    /*
    UIImageView * imageL =[cell.contentView viewWithTag:111];
    UIImageView * imageR =[cell.contentView viewWithTag:112];
    UIImageView * imageRR =[cell.contentView viewWithTag:113];
    
    if (imageL) {
        [imageL removeFromSuperview];
    }
    if (imageR) {
        [imageR removeFromSuperview];
    }
    if (imageRR) {
        [imageRR removeFromSuperview];
    }
    
    [self creatTitleImage];
    
    
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    
    for (ConnectWithMyFriend *fri in  _myFriendArray) {
        if ([fri.ProfileId isEqualToString:model.targetId]) {
            imageBoth.hidden =YES;
            imageWorkmate.hidden =YES;
            imageFriend.hidden =NO;
            [cell.contentView addSubview:imageFriend];
        }
    }
    
    for (NSString *key in _departmentWorkmatesDic) {
        NSArray *workmates = _departmentWorkmatesDic[key];
        for (ConnectWithMyFriend *workmate in workmates) {
            if ([workmate.ProfileId isEqualToString:model.targetId]) {
                
//                UILabel * departmentLab =[[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 122, 44, 90, 20)];
//                departmentLab.tag =10008;
//                departmentLab.text = key;
//                departmentLab.font = [UIFont systemFontOfSize:14];
//                departmentLab.textColor =[UIColor colorWithHexString:@"#848484"];
//                departmentLab.textAlignment =NSTextAlignmentRight;
//                [cell.contentView addSubview:departmentLab];
                
                imageFriend.hidden =YES;
                imageBoth.hidden =YES;
                imageWorkmate.hidden =NO;
                [cell.contentView addSubview:imageWorkmate];
            }
        }
    }
    
    
    for (NSString *key in _departmentWorkmatesDic) {
        NSArray *workmates = _departmentWorkmatesDic[key];
        for (ConnectWithMyFriend *workmate in workmates) {
            for (ConnectWithMyFriend * fri in _myFriendArray) {
                if ([fri.ProfileId isEqualToString:model.targetId] && [workmate.ProfileId isEqualToString:model.targetId]){
                    imageWorkmate.hidden =YES;
                    imageFriend.hidden =YES;
                    imageBoth.hidden =NO;
                    [cell.contentView addSubview:imageBoth];
                }
            }
        }
    }
     */
}

- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


//-(void)creatTitleImage{
//    imageBoth =[[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width-80, 36, 80, 25)];
//    imageBoth.tag =113;
//    //    imageBoth.hidden =YES;
//    imageBoth.image =[UIImage imageNamed:@"both"];
//    imageWorkmate =[[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width-80, 36, 80, 25)];
//    
//    
//    imageWorkmate.tag =112;
//    //    imageWorkmate.hidden =YES;
//    imageWorkmate.image =[UIImage imageNamed:@"colleagues"];
//    imageFriend =[[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width-80, 36, 80, 25)];
//    
//    imageFriend.tag =111;
//    //    imageFriend.hidden =YES;
//    imageFriend.image =[UIImage imageNamed:@"friend"];
//    
//}

#pragma mark - RCIMUserInfoDataSource
/**
 *  设置用户信息提供者,页面展现的用户头像及昵称
 *
 *  @param userId
 *  @param completion
 */
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion{
    
    RCUserInfo *userSelf = [RCIM sharedRCIM].currentUserInfo;
    if ([userId isEqualToString:userSelf.userId]) {
        RCUserInfo * user =[[RCUserInfo alloc]init];
        user.userId =userSelf.userId;
        user.name = userSelf.name;
        user.portraitUri = userSelf.portraitUri;
        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
        return completion(user);
    }
    
    for (NSDictionary *dic in self.employees) {

        
        if ([dic[@"ProfileId"] isEqualToString:userId]) {
            RCUserInfo * user =[[RCUserInfo alloc]init];
            user.userId = dic[@"ProfileId"];
            user.name = dic[@"EmployeeName"];
            NSString *iconURL = [NSString replaceString:dic[@"FaceURL"] Withstr1:@"100" str2:@"100" str3:@"c"];
            user.portraitUri = iconURL;
            return completion(user);
        }
    }
    
    for (ConnectWithMyFriend *friend in _myFriendArray) {
        if ([friend.ProfileId isEqualToString:userId]) {
            RCUserInfo * user =[[RCUserInfo alloc]init];
            user.userId =friend.ProfileId;
            user.name = friend.Nick;
            NSString *iconURL = [NSString replaceString:friend.FaceUrl Withstr1:@"100" str2:@"100" str3:@"c"];
            user.portraitUri = iconURL;
            
//            for (NSDictionary *dic in self.employees) {
//                
//                if ([dic[@"ProfileId"] isEqualToString:friend.ProfileId]) {
//                    return;
//                }
//            }
            
            return completion(user);

        }
    }
    
    
    
}

//#pragma mark - RCIMGroupInfoDataSource
//- (void)getGroupInfoWithGroupId:(NSString *)groupId
//                     completion:(void (^)(RCGroup *groupInfo))completion{
//    for (NSInteger i = 0; i<[AppDelegate shareAppDelegate].groupsArray.count; i++) {
//        RCGroup *aGroup = [AppDelegate shareAppDelegate].groupsArray[i];
//        if ([groupId isEqualToString:aGroup.groupId]) {
//            completion(aGroup);
//            break;
//        }
//    }
//}


#pragma mark - 返回按钮事件
- (void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
