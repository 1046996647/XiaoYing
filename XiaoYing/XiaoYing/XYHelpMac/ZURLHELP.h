//
//  ZURLHELP.h
//  XiaoYing
//
//  Created by GZH on 16/8/16.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

//获取已加入公司列表
#define ListOfMyCompanyURl  [NSString stringWithFormat:@"%@/api/company/myCompany?Token=%@",BaseUrl1,[UserInfo getToken]]

//切换公司获取用户功能列表
#define SwitchCompany  [NSString stringWithFormat:@"%@/api/switch?Token=%@",BaseUrl1,[UserInfo getToken]]


//获取公司简要信息
#define GetMyCompanyURl  [NSString stringWithFormat:@"%@/api/company/overview?Token=%@",BaseUrl1,[UserInfo getToken]]

//获取公司信息
#define GetInfoCompanyURl  [NSString stringWithFormat:@"%@/api/company/info?Token=%@",BaseUrl1,[UserInfo getToken]]


//加入已有公司 输入公司ID
#define SearchCompanyURl  [NSString stringWithFormat:@"%@/api/company/overview?Token=%@",BaseUrl1,[UserInfo getToken]]

//发送请求（申请加入的公司）
#define SendRequestURl  [NSString stringWithFormat:@"%@/api/company/join?Token=%@",BaseUrl1,[UserInfo getToken]]

//获取加入公司请求
#define ListOfCompanyURl  [NSString stringWithFormat:@"%@/api/company/joinQueue?Token=%@",BaseUrl1,[UserInfo getToken]]


//同意加入公司
#define AgreeToJoinCompanyURl  [NSString stringWithFormat:@"%@/api/company/agreejoin?token=%@",BaseUrl1,[UserInfo getToken]]

//拒绝加入公司
#define RefuseToJoinCompanyURl  [NSString stringWithFormat:@"%@/api/company/ignorejoin?token=%@",BaseUrl1,[UserInfo getToken]]

//撤回加入公司
#define UndoToJoinCompanyURl  [NSString stringWithFormat:@"%@/api/company/canceljoin?token=%@",BaseUrl1,[UserInfo getToken]]

//删除加入公司
#define DeleteJoinCompanyURl  [NSString stringWithFormat:@"%@/api/company/delJoinRec?Token=%@",BaseUrl1,[UserInfo getToken]]


//创建公司和默认部门
#define CreateCompanyURl  [NSString stringWithFormat:@"%@/api/company/createcompany?token=%@",BaseUrl1,[UserInfo getToken]]


//添加公司描述信息
#define AdddescriptionURl  [NSString stringWithFormat:@"%@/api/company/adddescription?token=%@",BaseUrl1,[UserInfo getToken]]

//上传资质证书
#define FileUploadURl  [NSString stringWithFormat:@"%@/api/file/FileUpload?Token=%@",BaseUrl1,[UserInfo getToken]]

//删除描述信息
#define DeleteDescriptionURl  [NSString stringWithFormat:@"%@/api/company/deldescription?token=%@",BaseUrl1,[UserInfo getToken]]

//修改描述信息
#define ModifyDescriptionURl  [NSString stringWithFormat:@"%@/api/company/modifyDescription?Token=%@",BaseUrl1,[UserInfo getToken]]

//修改公司信息
#define ModifyCompanyURl  [NSString stringWithFormat:@"%@/api/company/modifycompany?token=%@",BaseUrl1,[UserInfo getToken]]


//添加子公司，输入验证码
#define SearchCompanyWithCodeURl  [NSString stringWithFormat:@"%@/api/company/overview?Token=%@",BaseUrl1,[UserInfo getToken]]

//发送验证
#define PostCodeToCompanyURl  [NSString stringWithFormat:@"%@/api/company/sendcode?Token=%@",BaseUrl1,[UserInfo getToken]]

//申请加为子公司
#define ApplyforJoinCompanyURl  [NSString stringWithFormat:@"%@/api/company/appendchild?Token=%@",BaseUrl1,[UserInfo getToken]]

/*---------------------------------新同事---------------------------*/
//获取新同事
#define GetNewColleaguesURL  [NSString stringWithFormat:@"%@/api/company/newColleagues?Token=%@",BaseUrl1,[UserInfo getToken]]

//查找新同事
#define findNewSudentsURL  [NSString stringWithFormat:@"%@/api/profile?Token=%@",BaseUrl1,[UserInfo getToken]]

//获取功能列表
#define GetlistOfFunctionURL  [NSString stringWithFormat:@"%@/api/auth/myfunc?Token=%@",BaseUrl1,[UserInfo getToken]]

//拒绝新同事的加入申请
#define RefusedApplyFor  [NSString stringWithFormat:@"%@/api/company/ignorejoin?token=%@",BaseUrl1,[UserInfo getToken]]

//提交保存
#define KeepURL  [NSString stringWithFormat:@"%@/api/Employee/add?Token=%@",BaseUrl1,[UserInfo getToken]]

//删除撤销申请/邀请的同事
#define DeleteNewStuURL  [NSString stringWithFormat:@"%@/api/company/delnewColleague?Token=%@",BaseUrl1,[UserInfo getToken]]

//邀请加入公司
#define InviteNewStuURL  [NSString stringWithFormat:@"%@/api/company/inviteJoin?Token=%@",BaseUrl1,[UserInfo getToken]]

/*---------------------------------组织架构----------------------------*/
//获取公司所有部门
#define GetDepartmentURl  [NSString stringWithFormat:@"%@/api/department/alldepartment?token=%@",BaseUrl1,[UserInfo getToken]]

//创建部门
#define AddDepartment  [NSString stringWithFormat:@"%@/api/department/add?token=%@",BaseUrl1,[UserInfo getToken]]

//删除部门
#define DelDepartment  [NSString stringWithFormat:@"%@/api/department/del?token=%@",BaseUrl1,[UserInfo getToken]]

//编辑部门
#define EditDepartment  [NSString stringWithFormat:@"%@/api/department/edit?token=%@",BaseUrl1,[UserInfo getToken]]

//获取公司所有职员信息
#define GetAllEmployee  [NSString stringWithFormat:@"%@/api/Employee/AllEmployee?Token=%@",BaseUrl1,[UserInfo getToken]]

//获取员工详细信息
#define GetDetailOfEmployee  [NSString stringWithFormat:@"%@/api/Employee/detail?Token=%@",BaseUrl1,[UserInfo getToken]]

//修改员工详细信息
#define ModifyDetailOfEmployee  [NSString stringWithFormat:@"%@/api/Employee/modify?Token=%@",BaseUrl1,[UserInfo getToken]]

//设置部门领导人
#define SetLeaderURL  [NSString stringWithFormat:@"%@/api/department/setleader?Token=%@",BaseUrl1,[UserInfo getToken]]

//删除部门领导人
#define ClearLeaderURL  [NSString stringWithFormat:@"%@/api/department/clearleader?Token=%@",BaseUrl1,[UserInfo getToken]]

//设置员工为离职状态
#define LeavedEmloyee  [NSString stringWithFormat:@"%@/api/employee/leaved?token=%@",BaseUrl1,[UserInfo getToken]]




/*---------------------------------公告----------------------------*/

//发公告
#define CreateAdvertise  [NSString stringWithFormat:@"%@/api/affiche/create?Token=%@",BaseUrl1,[UserInfo getToken]]

//获取公司公告
#define GetCompanyAdvertise  [NSString stringWithFormat:@"%@/api/affiche/getbycompany?Token=%@",BaseUrl1,[UserInfo getToken]]

//获取部门公告
#define GetDepartmentAdvertise  [NSString stringWithFormat:@"%@/api/affiche/getbydepartment?Token=%@",BaseUrl1,[UserInfo getToken]]

//获取公告
#define GetAdvertiseAll  [NSString stringWithFormat:@"%@/api/affiche/getall?token=%@",BaseUrl1,[UserInfo getToken]]

/*------------------------------------权限管理----------------------------*/


//获取指定用户可用功能权限 只能获取可用权限
#define GetMyManageFunc  [NSString stringWithFormat:@"%@/api/auth/MyManageFunc?Token=%@",BaseUrl1,[UserInfo getToken]]

//获取指定用户可用功能列表
#define GetlistOfAlreadyURL  [NSString stringWithFormat:@"%@/api/auth/getfunc?token=%@",BaseUrl1,[UserInfo getToken]]

//给员工附加功能模块（原模块全删除）
#define GivePerssionToSommeOneURL  [NSString stringWithFormat:@"%@/api/auth/attachFuncsToEmpolyee?Token=%@",BaseUrl1,[UserInfo getToken]]

//初始化管理员的密码
#define ReSetSecretURL  [NSString stringWithFormat:@"%@/api/Auth?Token=%@",BaseUrl1,[UserInfo getToken]]

//获取指定功能包含的权限
#define getfuncPerURL  [NSString stringWithFormat:@"%@/api/auth/getfuncperm?Token=%@",BaseUrl1,[UserInfo getToken]]



/*----------------------------------我的名片---------------------------*/

//工作界面的名片
#define GetDetailofMyBusinessCard  [NSString stringWithFormat:@"%@/api/Employee/BusinessCar?Token=%@",BaseUrl1,[UserInfo getToken]]

//个人名片
#define GetDetailofPersonalCard  [NSString stringWithFormat:@"%@/api/card/personal?Token=%@",BaseUrl1,[UserInfo getToken]]

//个人名片上边的  正面身份证上传
#define UploadUrlOfCardFron  [NSString stringWithFormat:@"%@/api/card/setcardfronturl?token=%@",BaseUrl1,[UserInfo getToken]]

//个人名片上边的  反面身份证上传
#define UploadUrlOfCardBack  [NSString stringWithFormat:@"%@/api/card/setcardbackurl?token=%@",BaseUrl1,[UserInfo getToken]]

//企业名片
#define GetDetailofCompanyCard  [NSString stringWithFormat:@"%@/api/card/company?Token=%@",BaseUrl1,[UserInfo getToken]]



