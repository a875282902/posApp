//
//  ShopRegisterTableViewCell.m
//  posApp
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FriendsNoTableViewCell.h"

@interface FriendsNoTableViewCell ()

@property (nonatomic,strong)UIView   * backView;
@property (nonatomic,strong)UILabel  * phoneLabel;
@property (nonatomic,strong)UILabel  * stateLabel;
@property (nonatomic,strong)UILabel  * timeLabel;
@property (nonatomic,strong)UIButton * copBtn;


@end

@implementation FriendsNoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, KScreenWidth - 30 , 95)];
    [self.backView.layer setCornerRadius:5];
    [self.backView.layer setBorderColor:LCOLOR.CGColor];
    [self.backView.layer setBorderWidth:1];
    [self.backView setClipsToBounds:YES];
    [self addSubview:self.backView];
    
    
    [self.backView addSubview:[Tools creatImage:CGRectMake(10, 15, 15, 15) image:@"add_phone"]];
    
    self.phoneLabel = [Tools creatLabel:CGRectMake(30, 15, KScreenWidth - 80, 15) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@"13213692344"];
    [self.backView addSubview:self.phoneLabel];
    
    self.stateLabel = [Tools creatLabel:CGRectMake(KScreenWidth - 160, 15, 120, 15) font:[UIFont systemFontOfSize:15] color:RCOLOR alignment:(NSTextAlignmentRight) title:@"审核未通过"];
    [self.backView addSubview:self.stateLabel];
    
    [self.backView addSubview:[Tools setLineView:CGRectMake(0, 50, KScreenWidth - 30, 1)]];
    
    self.timeLabel = [Tools creatLabel:CGRectMake(10, 50, 200, 45) font:[UIFont systemFontOfSize:12] color:GCOLOR alignment:(NSTextAlignmentLeft) title:@"注册时间：2013-12-3"];
    [self.backView addSubview:self.timeLabel];
    
    self.copBtn = [Tools creatButton:CGRectMake(KScreenWidth - 130 , 57.5, 90, 30) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:@"联系TA" image:@"phone_white"];
    [self.copBtn addTarget:self action:@selector(copeAddress) forControlEvents:(UIControlEventTouchUpInside)];
    [self.copBtn.layer setCornerRadius:15];
    [self.copBtn setBackgroundColor:MDRGBA(255, 193, 0, 1)];
    [self.backView addSubview:self.copBtn];
    
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
