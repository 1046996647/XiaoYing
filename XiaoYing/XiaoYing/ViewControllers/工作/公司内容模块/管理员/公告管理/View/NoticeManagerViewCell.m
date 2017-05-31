//
//  NoticeManagerViewCell.m
//  XiaoYing
//
//  Created by Ge-zhan on 16/6/1.
//  Copyright © 2016年 ZWL. All rights reserved.
//

#import "NoticeManagerViewCell.h"


@implementation NoticeManagerViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.selectbtn];
        [self.contentView addSubview:self.imageviewheard];
        [self.contentView addSubview:self.labTitle];
        [self.contentView addSubview:self.labName];
        [self.contentView addSubview:self.labContent];
        [self.contentView addSubview:self.labTime];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor colorWithHexString:@"#d5d7dc"]);

    }
    return self;
}

- (UIButton *)selectbtn {
    if (_selectbtn == nil) {
        self.selectbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectbtn.frame = CGRectMake(kScreen_Width - 24, 12, 16, 16);
        CGPoint btnCenter = self.selectbtn.center;
        btnCenter.y = 40;
        self.selectbtn.center = btnCenter;
        self.selectbtn.layer.cornerRadius = 6.0;
        self.selectbtn.layer.masksToBounds = YES;
    }
    return _selectbtn;
}


- (UIImageView *)imageviewheard {
    if (_imageviewheard == nil) {
        self.imageviewheard = [[UIImageView alloc] initWithFrame:CGRectMake(12, 6, 107-24, 68)];
        self.imageviewheard.image=[UIImage imageNamed:@"nitice_picture"];
   }
    return _imageviewheard;
}

- (UILabel *)labTitle {
    if (_labTitle == nil) {
        self.labTitle = [[UILabel alloc] initWithFrame:CGRectMake(107, 12, kScreen_Width - 107 - 12, 12)];
        self.labTitle.text= @"标题";
        self.labTitle.font = [UIFont systemFontOfSize:16];
        self.labTitle.textColor = [UIColor blackColor];
    }
    return _labTitle;
}

- (UILabel *)labName {
    if (_labName == nil) {
        self.labName = [[UILabel alloc] initWithFrame:CGRectMake(107, 36, kScreen_Width - 107 - 12 - 10, 12)];
        self.labName.textAlignment = NSTextAlignmentLeft;
        self.labName.textColor = [UIColor colorWithHexString:@"#333333"];
        
        self.labName.font = [UIFont systemFontOfSize:14];
        self.labName.text = @"杭州赢莱金融有限公司";
    }
    return _labName;
}


- (UILabel *)labContent {
    if (_labContent == nil) {
        self.labContent = [[UILabel alloc] initWithFrame:CGRectMake(107, 57, 50, 12)];
        self.labContent.text= @"张三";
        self.labContent.font = [UIFont systemFontOfSize:14];
//        self.labContent.backgroundColor = [UIColor cyanColor];
        self.labContent.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _labContent;
}

- (UILabel *)labTime {
    if (_labTime == nil) {
        self.labTime = [[UILabel alloc] initWithFrame:CGRectMake(160, 57, 175, 12)];
        self.labTime.textColor = [UIColor colorWithHexString:@"#848484"];
        self.labTime.font = [UIFont systemFontOfSize:14];
        self.labTime.text = @"12:06";
    }
    return _labTime;
}




-(void)setModel:(CompanyDetailModel *)model{
    _model = model;
    _labContent.text = [self getNameFromString:model.Creator];
    NSArray *ranges = model.Rangs;
    NSMutableArray *departmenNames = [NSMutableArray array];
    for (NSString *dpid in ranges) {
        [departmenNames addObject:[self getDepartmentNameFromString:dpid]];
    }
    if (departmenNames.count == 1 && [departmenNames.firstObject isEqualToString:@"0"]) {
        _labName.text = [UserInfo getcompanyName];
    }else{
        NSString *departments = @"";
        for (int i =0; i<departmenNames.count; i++) {
            if (i==0) {
                departments = [departments stringByAppendingString:[NSString stringWithFormat:@"%@",departmenNames[i]]];
            }else{
                departments = [departments stringByAppendingString:[NSString stringWithFormat:@",%@",departmenNames[i]]];
            }
        }
        _labName.text = departments;
    }
    _labTitle.text = model.Title;
    _labTime.text = [self getTimeFromString:model.CreateTime];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//获取发布公告的人的名字
-(NSString *)getNameFromString:(NSString *)profieldID{
    NSArray *employeesArr = [ZWLCacheData unarchiveObjectWithFile:EmployeesPath];
    NSString *name = nil;
    for (NSDictionary *dic in employeesArr) {
        if ([profieldID isEqualToString:dic[@"ProfileId"]]) {
            name = dic[@"EmployeeName"];
        }
    }
    return name;
}

//获取发布公告的部门范围的部门名
-(NSString *)getDepartmentNameFromString:(NSString *)departmentID{
    NSArray *depArr = [ZWLCacheData unarchiveObjectWithFile:DepartmentsPath];
    NSString *departmentName = @"0";
    for (NSDictionary *dic in depArr) {
        if ([departmentID isEqualToString:dic[@"DepartmentId"]]) {
            departmentName = dic[@"Title"];
        }
    }
    return departmentName;
}

//获取经处理的发布公告的时间
-(NSString *)getTimeFromString:(NSString *)timeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:timeString];
    NSDateFormatter *outFormatter = [[NSDateFormatter alloc]init];
    [outFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *stringDate = [outFormatter stringFromDate:date];
    return stringDate;
}

@end
