//
//  ShopRegisterTableViewCell.m
//  posApp
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FirendsRealTableViewCell.h"

@interface FirendsRealTableViewCell ()

@property (nonatomic,strong)UIView   * backView;
@property (nonatomic,strong)UILabel  * nameLabel;
@property (nonatomic,strong)UILabel  * phoneLabel;
@property (nonatomic,strong)UILabel  * addressLabel;
@property (nonatomic,strong)UILabel  * stateLabel;
@property (nonatomic,strong)UIButton * editBtn;
@property (nonatomic,strong)UIButton * copBtn;


@end

@implementation FirendsRealTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, KScreenWidth - 30 , 135)];
    [self.backView.layer setCornerRadius:5];
    [self.backView.layer setBorderColor:LCOLOR.CGColor];
    [self.backView.layer setBorderWidth:1];
    [self.backView setClipsToBounds:YES];
    [self addSubview:self.backView];
    
    
    [self.backView addSubview:[Tools creatImage:CGRectMake(10, 15, 15, 15) image:@"add_name"]];
    [self.backView addSubview:[Tools creatImage:CGRectMake(10, 50, 15, 15) image:@"add_add"]];
    [self.backView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 160, 15, 15, 15) image:@"add_phone"]];
    
    self.nameLabel = [Tools creatLabel:CGRectMake(30, 15, KScreenWidth - 210, 15) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@""];
    [self.backView addSubview:self.nameLabel];
    
    self.phoneLabel = [Tools creatLabel:CGRectMake(KScreenWidth - 140, 15, 120, 15) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@""];
    [self.backView addSubview:self.phoneLabel];
    
    self.addressLabel = [Tools creatLabel:CGRectMake(30, 39, KScreenWidth - 70, 37) font:[UIFont systemFontOfSize:15] color:GCOLOR alignment:(NSTextAlignmentLeft) title:@""];
    [self.backView addSubview:self.addressLabel];
    
    [self.backView addSubview:[Tools setLineView:CGRectMake(0, 90, KScreenWidth - 30, 1)]];
    
    self.stateLabel = [Tools creatLabel:CGRectMake(10, 90, 200, 45) font:[UIFont systemFontOfSize:12] color:GCOLOR alignment:(NSTextAlignmentLeft) title:@""];
    [self.backView addSubview:self.stateLabel];
    
    self.copBtn = [Tools creatButton:CGRectMake(KScreenWidth - 130 , 97.5, 90, 30) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:@"联系TA" image:@"phone_white"];
    [self.copBtn addTarget:self action:@selector(copeAddress) forControlEvents:(UIControlEventTouchUpInside)];
    [self.copBtn.layer setCornerRadius:15];
    [self.copBtn setBackgroundColor:MDRGBA(255, 193, 0, 1)];
    [self.backView addSubview:self.copBtn];
    
}

- (void)bandDataWithDictionary:(NSDictionary *)dic{
    
    if ([dic[@"name"] isKindOfClass:[NSString class]]) {
        [self.nameLabel setText:dic[@"name"]];
    }
    
    [self.phoneLabel setText:dic[@"phone"]];
    if ([dic[@"pca"] isKindOfClass:[NSString class]]) {
       [self.addressLabel setText:dic[@"pca"]];
    }
    if ([dic[@"createtime"] isKindOfClass:[NSString class]]) {
        [self.stateLabel setText:[NSString stringWithFormat:@"注册时间:%@",[self stringToDate:dic[@"createtime"]]]];
    }
    
}
//时间戳转时间
- (NSString *)stringToDate:(NSString *)str{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
}
- (void)copeAddress{
    
    [self.delegate contactUserWithCell:self];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    // Configure the view for the selected state
}

@end
