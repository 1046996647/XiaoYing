//
//  UrlHelpMac.h
//  XiaoYing
//
//  Created by ZWL on 15/10/27.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

// 线上
//#define BaseUrl1  @"http://api.yinglaijinrong.com"

// 本地
#define BaseUrl1  @"http://192.168.10.69"


//下载
#define downLoadBaseUrl  [NSString stringWithFormat:@"%@/bf/",BaseUrl1]


//1.1.2                   注册_验证验证码有效性
#define VerificateRegister   [NSString stringWithFormat:@"%@/api/register/Verificat",BaseUrl1]


//1.1.1                   注册_获取验证码

#define SendRegister   [NSString stringWithFormat:@"%@/api/register/sendcode",BaseUrl1]


//1.1.2                   注册_确认验证码

#define SubmitRegister   [NSString stringWithFormat:@"%@/api/register/submit",BaseUrl1]

//1.1.2                   找回密码 - 发送验证码
#define sendVerificateCodeReset   [NSString stringWithFormat:@"%@/api/account/sendcode",BaseUrl1]

//1.1.2                   找回密码 - 确认验证码
#define VerificateReset   [NSString stringWithFormat:@"%@/api/account/validatecode",BaseUrl1]

//1.1.2                   找回密码 - 设置密码
#define PasswordReset   [NSString stringWithFormat:@"%@/api/account/reset_password",BaseUrl1]

//1.1.2                   登录
#define Login   [NSString stringWithFormat:@"%@/api/login?",BaseUrl1]

//1.1.3                    发送验证码
#define SendCode     [NSString stringWithFormat:@"%@/api/password/sendcode",BaseUrl1]

//1.1.4                    验证验证码
#define ConfirmCode   [NSString stringWithFormat:@"%@/api/password/validatecode",BaseUrl1]

//1.1.5                    重置密码
#define ResetPassword  [NSString stringWithFormat:@"%@/api/password/reset",BaseUrl1]

//1.1.6                    获取个人信息

#define ProfileMy  [NSString stringWithFormat:@"%@/api/profile/my?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.1.7                    修改个人信息

#define Profile  [NSString stringWithFormat:@"%@/api/profile/edit?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.1.8                    上传用户头像

#define Userface  [NSString stringWithFormat:@"%@/api/profile/userface?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.1.9                    获取地区
#define Region  [NSString stringWithFormat:@"%@/api/lbs/region",BaseUrl1]



//1.2.1                   添加任务接口
#define AddTask        [NSString stringWithFormat:@"%@/api/task/add?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.2.2                   全量获取任务详情
#define ALlTask        [NSString stringWithFormat:@"%@/api/task/all?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.2.3                   获取当前任务信息情况
#define InfoTask       [NSString stringWithFormat:@"%@/api/task/info?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.2.4                   获取用户简介
#define UserProfile    [NSString stringWithFormat:@"%@/api/Profile",BaseUrl1]

//1.2.5                   修改任务接口
#define EditorTask     [NSString stringWithFormat:@"%@/api/task/edit?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.2.6                   插旗 (需要进行二次拼接)
#define InsertFlag     [NSString stringWithFormat:@"%@/api/task/flag?Token=%@",BaseUrl1,[UserInfo getToken]]
 
//1.2.7                    完成任务（需要进行二次拼接）
#define FinishTask     [NSString stringWithFormat:@"%@/api/task/done?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.2.8                    获取增量任务（需要进行二次拼接）
#define IncrementTask  [NSString stringWithFormat:@"%@/api/task/increment?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.3.1                    判断是否已经有公司了
#define MyCompany      [NSString stringWithFormat:@"%@/api/company/myCompany?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.3.2                    创建公司
#define CreateCompany  [NSString stringWithFormat:@"%@/api/company/create?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.3.3                    加入公司
#define JoinCompany    [NSString stringWithFormat:@"%@/api/company/join?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.3.4                    返回公司信息
#define  InfoCompany   [NSString stringWithFormat:@"%@/api/company/info?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.3.5                    设置某人所在部门

#define SetDepartmentMember [NSString stringWithFormat:@"%@/api/company/setdepartment?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.3.6                    得到公司部门成员

#define GetDepartmentMember [NSString stringWithFormat:@"%@/api/company/department?Token=%@",BaseUrl1,[UserInfo getToken]]

// ----------------------------联系人--------------------------


//1.4.1                    获取当前人员的好友列表[非企业好友仅个人好友]
#define  MyFriendRequest   [NSString stringWithFormat:@"%@/api/friend?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.4.1                    搜索用户信息列表
#define  ProfileList   [NSString stringWithFormat:@"%@/api/profile/search?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.4.2                     请求加某人为好友
#define  RequestAddFriend   [NSString stringWithFormat:@"%@/api/friend/requestadd?Token=%@",BaseUrl1,[UserInfo getToken]]
//1.4.3                      同意某用户的申请
#define  AgreeUserApply   [NSString stringWithFormat:@"%@/api/friend/agree?Token=%@",BaseUrl1,[UserInfo getToken]]

// 1.4.6                    拒绝用户请求
#define  RefuseFriend   [NSString stringWithFormat:@"%@/api/friend/refuse?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.4.4                     获取待我处理的好友请求
#define  FriendRequest   [NSString stringWithFormat:@"%@/api/friend/request?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.4.4                     删除加好友请求（id为空表示清空所有请求）
#define  DeleteRequest   [NSString stringWithFormat:@"%@/api/friend/deleterequest?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.4.4                     设置待处理请求为已查看
#define  SetViewed   [NSString stringWithFormat:@"%@/api/friend/SetViewed?Token=%@",BaseUrl1,[UserInfo getToken]]

// 1.4.5                    解除好友关系
#define  ReleaseFriend   [NSString stringWithFormat:@"%@/api/friend/delete?Token=%@",BaseUrl1,[UserInfo getToken]]

// 1.4.5                    修改好友备注
#define  FriendRemark   [NSString stringWithFormat:@"%@/api/friend/remark?Token=%@",BaseUrl1,[UserInfo getToken]]

// 1.4.5                    获取群聊列表(讨论组)
#define  GetDiscussionList   [NSString stringWithFormat:@"%@/api/chat/getroomlist?Token=%@",BaseUrl1,[UserInfo getToken]]

// 1.4.5                    发起群聊
#define  CreateDiscussion   [NSString stringWithFormat:@"%@/api/chat/create?Token=%@",BaseUrl1,[UserInfo getToken]]

// 1.4.5                    设置群聊名称
#define  SetName   [NSString stringWithFormat:@"%@/api/chat/setname?Token=%@",BaseUrl1,[UserInfo getToken]]

// 1.4.5                    添加成员
#define  Addmember   [NSString stringWithFormat:@"%@/api/chat/addmember?Token=%@",BaseUrl1,[UserInfo getToken]]

// 1.4.5                    移除成员或退出
#define  RemoveMember   [NSString stringWithFormat:@"%@/api/chat/removemember?Token=%@",BaseUrl1,[UserInfo getToken]]


// 1.4.5                    解散群聊
#define  ShieldDiscussion   [NSString stringWithFormat:@"%@/api/chat/shieldchat?Token=%@",BaseUrl1,[UserInfo getToken]]






// 1.4.7                     生成加好友的二维码
#define FriendGencode    [NSString stringWithFormat:@"%@/api/friend/gencode?Token=%@",BaseUrl1,[UserInfo getToken]]

// 1.4.7                     通过生成的二维码获取用户信息
#define ProfileByCode    [NSString stringWithFormat:@"%@/api/friend/profile_by_code?Token=%@",BaseUrl1,[UserInfo getToken]]

// 1.4.8                     通过扫描添加二维码
#define FriendAddByCode  [NSString stringWithFormat:@"%@/api/friend/add_by_code?Token=%@",BaseUrl1,[UserInfo getToken]]

//1.5.1                    获取融云token
#define IMToken        [NSString stringWithFormat:@"%@/api/IM?Token=%@",BaseUrl1,[UserInfo getToken]]


// ----------------------------管理员密码--------------------------
//  是否必须设置管理员初始密码
#define Needpassword [NSString stringWithFormat:@"%@/api/auth/needpassword?token=%@",BaseUrl1,[UserInfo getToken]]

//  管理员初次设置密码-只有管理员自己可以设置
#define ManangerPassword [NSString stringWithFormat:@"%@/api/auth/Password?token=%@",BaseUrl1,[UserInfo getToken]]

//  访问管理权限的模块时验证密码
#define AuthLogin [NSString stringWithFormat:@"%@/api/auth/Login?token=%@",BaseUrl1,[UserInfo getToken]]

//  修改管理员密码
#define ModifyManangerPassword [NSString stringWithFormat:@"%@/api/auth/ModifyPassword?token=%@",BaseUrl1,[UserInfo getToken]]

//  获取密保问题
#define AdminQuestion [NSString stringWithFormat:@"%@/api/auth/adminAsk?token=%@",BaseUrl1,[UserInfo getToken]]

//  验证密保答案是否正确, 成功返回注册邮箱（账户信息）
#define Validateanswer [NSString stringWithFormat:@"%@/api/auth/validateanswer?token=%@",BaseUrl1,[UserInfo getToken]]

// 通过密保问题找回密码 - 发送验证码
#define AuthSendcode [NSString stringWithFormat:@"%@/api/auth/sendcode?token=%@",BaseUrl1,[UserInfo getToken]]

// 通过密保问题找回密码时，判断验证码是否正确
#define validateAuthSendcode [NSString stringWithFormat:@"%@/api/auth/validatecode?token=%@",BaseUrl1,[UserInfo getToken]]

// 密保问题重置密码
#define ResetAuthPassword [NSString stringWithFormat:@"%@/api/auth/resetpassword?token=%@",BaseUrl1,[UserInfo getToken]]

/************************************企业文档管理**/
//  搜索
#define SearchURL [NSString stringWithFormat:@"%@/api/doc/query?token=%@",BaseUrl1,[UserInfo getToken]]

//  根据文件夹id查看该文件夹包含的文档
#define AllFilesURL [NSString stringWithFormat:@"%@/api/doc/get?token=%@",BaseUrl1,[UserInfo getToken]]

// 企业文档本地接口
#define FileManagerURL [NSString stringWithFormat:@"%@/api/doc/createroot?token=%@",BaseUrl1,[UserInfo getToken]]

// 创建文件夹
#define FileCreateURL [NSString stringWithFormat:@"%@/api/doc/addcatalog?token=%@",BaseUrl1,[UserInfo getToken]]

// 上传文档
#define UploadDocumentURL [NSString stringWithFormat:@"%@/api/doc/upload?token=%@",BaseUrl1,[UserInfo getToken]]

// 设置可见范围
#define VisibleURL [NSString stringWithFormat:@"%@/api/doc/setvisible?token=%@",BaseUrl1,[UserInfo getToken]]

// 删除文件夹及文档
#define DeleteFileURL [NSString stringWithFormat:@"%@/api/doc/delete?token=%@",BaseUrl1,[UserInfo getToken]]

// 重命名文件夹
#define ReNameFolderURL [NSString stringWithFormat:@"%@/api/doc/renamefolder?token=%@",BaseUrl1,[UserInfo getToken]]

// 重命名文件
#define ReNameFileURL [NSString stringWithFormat:@"%@/api/doc/renamefile?token=%@",BaseUrl1,[UserInfo getToken]]

// 移动
#define MoveFileURL [NSString stringWithFormat:@"%@/api/doc/remove?token=%@",BaseUrl1,[UserInfo getToken]]


/************************************公告**/
// 发布公告
#define PublishedURL [NSString stringWithFormat:@"%@/api/affiche/create?token=%@",BaseUrl1,[UserInfo getToken]]

// 查看公告详情
#define DetailNoticeURL [NSString stringWithFormat:@"%@/api/affiche/show?token=%@",BaseUrl1,[UserInfo getToken]]

// 获取公司公告
#define CompanyNoticeURL [NSString stringWithFormat:@"%@/api/affiche/getbycompany?token=%@",BaseUrl1,[UserInfo getToken]]

// 获取部门公告
#define DepartmentNoticeURL [NSString stringWithFormat:@"%@/api/affiche/getbydepartment?token=%@",BaseUrl1,[UserInfo getToken]]

// 删除公告
#define DeleteNoticeURL [NSString stringWithFormat:@"%@/api/affiche/delete?token=%@",BaseUrl1,[UserInfo getToken]]

// 给部门人员设置公告权限
#define SetPermissionURL [NSString stringWithFormat:@"%@/api/affiche/setpermission?token=%@",BaseUrl1,[UserInfo getToken]]

// 获取当前用户拥有的公告权限
#define GetPermissionURL [NSString stringWithFormat:@"%@/api/affiche/getpermission?token=%@",BaseUrl1,[UserInfo getToken]]



/********************断点下载**/
#define DownLoadURL [NSString stringWithFormat:@"%@/api/bigfile/download",BaseUrl1]



// ----------------------------人事管理接口--------------------------

#define NewColleagues       [NSString stringWithFormat:@"%@/api/company/newColleagues?Token=%@",BaseUrl1,[UserInfo getToken]]


// ----------------------------审批类型管理接口--------------------------

// 获取用户可使用的审批类型
#define GetCategory       [NSString stringWithFormat:@"%@/api/approvalmanager/AllCategory?Token=%@",BaseUrl1,[UserInfo getToken]]

// 创建新的审批类型
#define NewCategory       [NSString stringWithFormat:@"%@/api/approvalmanager/createcategory?Token=%@",BaseUrl1,[UserInfo getToken]]

// 重命名审批类型
#define RenameCategory       [NSString stringWithFormat:@"%@/api/approvalmanager/renameCategory?Token=%@",BaseUrl1,[UserInfo getToken]]

// 根据名称模糊查询审批类型或种类
#define SearchCategory       [NSString stringWithFormat:@"%@/api/approvalmanager/Searchcategory?Token=%@",BaseUrl1,[UserInfo getToken]]

// 删除审批类型
#define DeleteCategory       [NSString stringWithFormat:@"%@/api/approvalmanager/delCategory?Token=%@",BaseUrl1,[UserInfo getToken]]

// 获取当前公司的职级列表信息
#define GetRanksList       [NSString stringWithFormat:@"%@/api/company/ranks?Token=%@",BaseUrl1,[UserInfo getToken]]

// 添加审批种类关联的范文
#define AddTemp       [NSString stringWithFormat:@"%@/api/approvalmanager/addcontentTemp?Token=%@",BaseUrl1,[UserInfo getToken]]

// 删除指定的范文
#define DeleteTemp       [NSString stringWithFormat:@"%@/api/approvalmanager/delcontentTemp?Token=%@",BaseUrl1,[UserInfo getToken]]

// 修改范文
#define ModifyTemp       [NSString stringWithFormat:@"%@/api/approvalmanager/modifycontentTemp?Token=%@",BaseUrl1,[UserInfo getToken]]

// 创建新的审批种类
#define Createtype       [NSString stringWithFormat:@"%@/api/approvalmanager/createtype?Token=%@",BaseUrl1,[UserInfo getToken]]

// 获取审批种类或查找审批种类
#define GetType       [NSString stringWithFormat:@"%@/api/approvalmanager/Searchcategory?Token=%@",BaseUrl1,[UserInfo getToken]]

// 获取审批种类的详细信息
#define GetTypeDetail       [NSString stringWithFormat:@"%@/api/approvalmanager/TypeDetail?Token=%@",BaseUrl1,[UserInfo getToken]]

// 删除种类
#define Deltype       [NSString stringWithFormat:@"%@/api/approvalmanager/deltype?Token=%@",BaseUrl1,[UserInfo getToken]]

// 修改种类
#define ModifyType       [NSString stringWithFormat:@"%@/api/ApprovalManager/ModifyType?Token=%@",BaseUrl1,[UserInfo getToken]]


// ----------------------------委派接口--------------------------

// 新建委派
#define NewDesignate       [NSString stringWithFormat:@"%@/api/designate/create?Token=%@",BaseUrl1,[UserInfo getToken]]

// 添加执行人
#define AddExecutor       [NSString stringWithFormat:@"%@/api/designate/addmember?Token=%@",BaseUrl1,[UserInfo getToken]]

// 添加任务
#define AddDuty       [NSString stringWithFormat:@"%@/api/designate/addtask?Token=%@",BaseUrl1,[UserInfo getToken]]


// 以委派人身份获取
#define GetDesignateAsCreator       [NSString stringWithFormat:@"%@/api/designate/get?Token=%@",BaseUrl1,[UserInfo getToken]]

// 以执行人身份获取
#define GetDesignateAsExecutor       [NSString stringWithFormat:@"%@/api/designate/getasexecutor?Token=%@",BaseUrl1,[UserInfo getToken]]

// 获取委派详情
#define GetDesignateDetail       [NSString stringWithFormat:@"%@/api/designate/detail?Token=%@",BaseUrl1,[UserInfo getToken]]

// 小文件批量上传
#define Bulkupload       [NSString stringWithFormat:@"%@/api/file/bulkupload?Token=%@",BaseUrl1,[UserInfo getToken]]

// 文件断断点上传
#define GetFileToken       [NSString stringWithFormat:@"%@/api/bigfile/getToken?",BaseUrl1]
#define UploadFile         [NSString stringWithFormat:@"%@/api/bigfile/upload?",BaseUrl1]


// ----------------------------用户设备信息接口--------------------------

// 存储用户设备信息
#define DataCollect       [NSString stringWithFormat:@"%@/api/datacollect/set_app_clientinfo?Token=%@",BaseUrl1,[UserInfo getToken]]


// 刷新部门和员工信息！
#define kRefreshInfoNotification @"kRefreshInfoNotification"


// 删除会话通知
#define kDeleteConversionNotification @"kDeleteConversionNotification"
//
//// 删除搜索好友的表
//#define kDeleteSearchTableView @"kDeleteSearchTableView"
//// 删除 同事页面搜索好友的表
//#define kDeleteSearchConnect @"kDeleteSearchConnect"

#define kGetCompanyNotification @"kGetCompanyNotification"
