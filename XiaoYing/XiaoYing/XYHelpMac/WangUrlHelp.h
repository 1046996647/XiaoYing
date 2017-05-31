//
//  WangUrlHelp.h
//  XiaoYing
//
//  Created by YL20071 on 16/11/10.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

/*=======================审批APPROVAL========================*/

//分页获取待审批的申请
#define APPROVAL_GET_TOBEAPPROVALED [NSString stringWithFormat:@"%@/api/Approval/my?Token=%@&PageIndex=%ld&PageSize=%ld",BaseUrl1,[UserInfo getToken]

//分页获取已结束的申请审批
#define APPROVAL_GET_OVERAPPROVALED [NSString stringWithFormat:@"%@/api/Approval/history?Token=%@&PageIndex=%ld&PageSize=%ld",BaseUrl1,[UserInfo getToken]

//搜索符合条件的审批
#define APPROVAL_SEARCHAPPROVAL [NSString stringWithFormat:@"%@/api/Approval/search?Token=%@&searchText=%@&PageIndex=%ld&PageSize=%ld",BaseUrl1,[UserInfo getToken]

//获取申请详情
#define APPROVAL_GET_DETAILAPPROVAL [NSString stringWithFormat:@"%@/api/Approval/recorddetail?Token=%@&ApplyRequestID=%@",BaseUrl1,[UserInfo getToken]

//同意申请的批复操作
#define APPROVAL_AGREE [NSString stringWithFormat:@"%@/api/Approval/agree?Token=%@",BaseUrl1,[UserInfo getToken]]

//拒绝申请的批复操作
#define APPROVAL_REFUSE [NSString stringWithFormat:@"%@/api/Approval/refuse?Token=%@",BaseUrl1,[UserInfo getToken]]


/*=======================公告AFFICHE========================*/
//发布公告
#define AFFICHE_CREAT [NSString stringWithFormat:@"%@/api/affiche/create?Token=%@",BaseUrl1,[UserInfo getToken]]

//删除公告
#define AFFICHE_DELETE [NSString stringWithFormat:@"%@/api/affiche/delete?Token=%@&strIds=%@",BaseUrl1,[UserInfo getToken]


//获取部门对应的公告审批人，0表示未设置审批人
#define AFFICHE_GETDEPARTMENTAPPROVER [NSString stringWithFormat:@"%@/api/affiche/getdepartmentapprover?Token=%@",BaseUrl1,[UserInfo getToken]]

//查看公告详情
#define AFFICHE_DETAIL [NSString stringWithFormat:@"%@/api/affiche/show?Token=%@&_afficheId=%@",BaseUrl1,[UserInfo getToken]

//获取所有公告
#define AFFICHE_GETALL [NSString stringWithFormat:@"%@/api/affiche/getall?Token=%@&key=%@&pageindex=%ld&pagesize=%ld&start=%@&end=%@",BaseUrl1,[UserInfo getToken]

//获取公司公告
#define AFFICHE_GETBYCOMPANY [NSString stringWithFormat:@"%@/api/affiche/getbycompany?Token=%@&start=%@&end=%@&key=%@&pageindex=%ld&pagesize=%ld",BaseUrl1,[UserInfo getToken]

//获取部门公告
#define AFFICHE_GETBYDEPARTMENT [NSString stringWithFormat:@"%@/api/affiche/getbydepartment?Token=%@&start=%@&end=%@&key=%@&pageindex=%ld&pagesize=%ld",BaseUrl1,[UserInfo getToken]

//获取当前用户拥有的公告权限
#define AFFICHE_GETPERMISSION [NSString stringWithFormat:@"%@/api/affiche/getpermission?Token=%@",BaseUrl1,[UserInfo getToken]]

//获取公司部门对应公告申请审批删除权限
#define AFFICHE_GETPERMISSIONBYDEP [NSString stringWithFormat:@"%@/api/affiche/getpermissionbydept?Token=%@&deptId=%@",BaseUrl1,[UserInfo getToken]

//给部门人员设置公告权限
#define AFFICHE_SETPERMISSION [NSString stringWithFormat:@"%@/api/affiche/setpermission?Token=%@",BaseUrl1,[UserInfo getToken]]

/*=======================备忘录MEMORY========================*/
// 新增备忘录
#define Create  [NSString stringWithFormat:@"%@/api/note/create?Token=%@",BaseUrl1,[UserInfo getToken]]

// 获取备忘录
#define GetMemory  [NSString stringWithFormat:@"%@/api/note/get?Token=%@",BaseUrl1,[UserInfo getToken]]

// 修改备忘录
#define EditMemory  [NSString stringWithFormat:@"%@/api/note/edit?Token=%@",BaseUrl1,[UserInfo getToken]]

// 删除备忘录
#define DeleteMemory  [NSString stringWithFormat:@"%@/api/note/delete?Token=%@",BaseUrl1,[UserInfo getToken]]

/*=======================企业文档DOCUMENT========================*/
//查看文档
#define GETDOC [NSString stringWithFormat:@"%@/api/doc/get?Token=%@&_catalogId=%@",BaseUrl1,[UserInfo getToken]
//搜索文档
#define SEARCHDOC [NSString stringWithFormat:@"%@/api/doc/query?Token=%@&key=%@",BaseUrl1,[UserInfo getToken]
//断点下载
#define DOWNLOADDOC [NSString stringWithFormat:@"%@/api/bigfile/download?path=%@%@",BaseUrl1
