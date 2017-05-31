//
//  CUrlHelp.h
//  XiaoYing
//
//  Created by chenchanghua on 16/10/31.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

/*=======================申请APPLY========================*/

/// 分页获取进行中的申请
#define APPLY_GET_ONGING_APPLICATION    [NSString stringWithFormat:@"%@/api/Apply/Record",BaseUrl1]

/// 分页获取已结束的申请
#define APPLY_GET_COMPLETED_APPLICATION    [NSString stringWithFormat:@"%@/api/Apply/history",BaseUrl1]

/// 获取该身份可使用的申请类型
#define APPLY_GET_APPLICATION_CATEGORY    [NSString stringWithFormat:@"%@/api/Apply/GetCategory",BaseUrl1]

/// 获取指定审批类型下的审批种类
#define APPLY_GET_APPLICATION_TYPE    [NSString stringWithFormat:@"%@/api/Apply/GetTypes",BaseUrl1]

/// 获取指定审批种类关联的范文
#define APPLY_GET_APPLICATION_CONTENT_TEMP    [NSString stringWithFormat:@"%@/api/apply/getcontentTemp",BaseUrl1]

/// 创建审批申请
#define APPLY_CREATE_APPLICATION    [NSString stringWithFormat:@"%@/api/Apply/Create",BaseUrl1]

/// 获取申请详情
#define APPLY_GET_APPLICATION_DETAIL    [NSString stringWithFormat:@"%@/api/Apply/detail",BaseUrl1]

/// 根据申请的种类名称，搜索符合条件的记录，并分页返回记录
#define APPLY_SEARCH_APPLICATION    [NSString stringWithFormat:@"%@/api/Apply/search",BaseUrl1]

/// 撤销申请
#define APPLY_REVOKE_APPLICATION    [NSString stringWithFormat:@"%@/api/Apply/Revoke",BaseUrl1]

/// 越级申请
#define APPLY_SKIP_APPLICATION    [NSString stringWithFormat:@"%@/api/Apply/Skip",BaseUrl1]

/// 获取 我的岗位列表中的“部门-职位”名称数组和部门Id数组
#define APPLY_GET_EMPLOYEE_MESSAGE    [NSString stringWithFormat:@"%@/api/Employee/myjobs",BaseUrl1]


/*========================职位POSITION管理==========================*/

/// 职位类别 的获取
#define POSITION_GET_CATEGORY    [NSString stringWithFormat:@"%@/api/companyjob/getcategory",BaseUrl1]

/// 职位类别 的添加
#define POSITION_ADD_CATEGORY    [NSString stringWithFormat:@"%@/api/companyjob/addcategory",BaseUrl1]

/// 职位类别 的重命名
#define POSITION_RENAME_CATEGORY    [NSString stringWithFormat:@"%@/api/companyjob/renamecategory",BaseUrl1]

/// 职位类别 的删除
#define POSITION_DELETE_CATEGORY    [NSString stringWithFormat:@"%@/api/companyjob/deletecategory",BaseUrl1]

/// 判断该职位类别下是否有员工，返回员工数量
#define POSITION_GET_COUNT_FROM_CATEGORY    [NSString stringWithFormat:@"%@/api/companyjob/isexistempolyee_category",BaseUrl1]

/// 职位 的获取
#define POSITION_GET_JOBNAME    [NSString stringWithFormat:@"%@/api/companyjob/getjob",BaseUrl1]

/// 职位 的添加
#define POSITION_ADD_JOBNAME    [NSString stringWithFormat:@"%@/api/companyjob/create",BaseUrl1]

/// 职位 的编辑
#define POSITION_EDIT_JOBNAME    [NSString stringWithFormat:@"%@/api/companyjob/edit",BaseUrl1]

/// 职位 的删除
#define POSITION_DELETE_JOBNAME    [NSString stringWithFormat:@"%@/api/companyjob/delete",BaseUrl1]

/// 判断该职位下是否有员工，返回员工数量
#define POSITION_GET_COUNT_FROM_JOBNAME    [NSString stringWithFormat:@"%@/api/companyjob/isexistempolyee",BaseUrl1]

/*========================企业文档DOCUMENT管理==========================*/








































