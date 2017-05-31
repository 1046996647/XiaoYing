//
//  NoticeCell.m
//  XiaoYing
//
//  Created by ZWL on 15/12/22.
//  Copyright © 2015年 ZWL. All rights reserved.
//

#import "NoticeCell.h"
#import "CompanyDetailModel.h"

@interface NoticeCell()

@property (nonatomic,strong) UIImageView *imageviewheard;//添加图片
@property (nonatomic,strong) UILabel *labTitle;//标题
@property (nonatomic,strong) UILabel *labName;//发出公告人
@property (nonatomic,strong) UILabel *labContent;//公告内容

@property (nonatomic,strong) UILabel *labTime;//公告时间

@property (nonatomic,assign) BOOL flag;//判断是否是管理员
@end

@implementation NoticeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageviewheard = [[UIImageView alloc] initWithFrame:CGRectMake(12, 6, 107-24, 68)];
        _imageviewheard.image=[UIImage imageNamed:@"nitice_picture"];
        [self.contentView addSubview:_imageviewheard];
        
        _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(107, 12, kScreen_Width - 107 - 12, 20)];
        _labTitle.text= @"标题";
        _labTitle.font = [UIFont systemFontOfSize:14];
        _labTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_labTitle];
        
        _labName = [[UILabel alloc] initWithFrame:CGRectMake(108, _labTitle.bottom + 10, kScreen_Width-108-12, 12)];
        _labName.textColor = [UIColor colorWithHexString:@"#848484"];
        
        _labName.font = [UIFont systemFontOfSize:12];
        _labName.text = @"张珊";
        [self.contentView addSubview:_labName];
        
        _labContent = [[UILabel alloc] initWithFrame:CGRectMake(108, 41, kScreen_Width-108-12, 35)];
        _labContent.text= @"标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题";
        _labContent.numberOfLines=2;
        _labContent.font = [UIFont systemFontOfSize:13];
        _labContent.textColor = [UIColor colorWithHexString:@"#848484"];
    
        [self.contentView addSubview:_labContent];
        
        _labTime = [[UILabel alloc] initWithFrame:CGRectMake(108, _labName.bottom + 10, kScreen_Width - 130, 15)];
        _labTime.textColor = [UIColor colorWithHexString:@"#848484"];
        _labTime.font = [UIFont systemFontOfSize:12];
        _labTime.textAlignment = NSTextAlignmentLeft;
        _labTime.text = @"12:06";
        [self.contentView addSubview:_labTime];
        
        
//        _labDepartment = [[UILabel alloc] initWithFrame:CGRectMake(200, 6,kScreen_Width-200-19-6 , 20)];
//        _labDepartment.backgroundColor = [UIColor cyanColor];
//        _labDepartment.textAlignment = NSTextAlignmentRight;
//        _labDepartment.textColor = [UIColor colorWithHexString:@"#cccccc"];
//        _labDepartment.font = [UIFont systemFontOfSize:13];
//        [self.contentView addSubview:_labDepartment];
        
//        _buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom];
//        _buttonDelete.backgroundColor = [UIColor blackColor];
//        _buttonDelete.frame=CGRectMake(kScreen_Width-27, 3, 25, 25);
//        [_buttonDelete addTarget:self action:@selector(buttonDeleteAction:) forControlEvents: UIControlEventTouchUpInside];
//        [self.contentView addSubview:_buttonDelete];
        
        [self.contentView addSubview:self.selectbtn];
    }
           return self;
}


//- (void)getModel:(CompanyDetailModel *)model {
//    _labTitle.text = model.Title;
//    _labTime.text = model.CreateTime;
////    [_imageviewheard sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.10.69:8081%@",model]] placeholderImage:[UIImage imageNamed:@"banner"]];
//}

-(void)setModel:(CompanyDetailModel *)model{
    _model = model;
    _labTitle.text = model.Title;
    _labTitle.font = [UIFont systemFontOfSize:14];
    _labTime.text = [self getTimeFromString:model.CreateTime];
}

//是否是部门公告，如果是部门公告，则需要显示公告范围
-(void)setIsDepartment:(BOOL)isDepartment{
    _isDepartment = isDepartment;
    if (isDepartment == YES) {
        _labContent.hidden = YES;
        NSArray *ranges = self.model.Rangs;
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

        _labName.top = _labTitle.bottom + 10;
        _labTime.top = _labName.bottom + 10;
    }else{
        _labName.hidden = YES;
        _labContent.hidden = YES;
        _labTime.top = _labTitle.bottom + 10;
    }
}


- (UIButton *)selectbtn {
    if (_selectbtn == nil) {
        self.selectbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectbtn.frame = CGRectMake(kScreen_Width - 24, 12, 16, 16);
        self.selectbtn.layer.cornerRadius = 6.0;
        self.selectbtn.layer.masksToBounds = YES;
    }
    return _selectbtn;
}

//-(void)buttonDeleteAction:(UIButton *)btn{
////    [[NSNotificationCenter defaultCenter]postNotificationName:@"ClickCell" object:self];
//}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
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
