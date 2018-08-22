//
//  ShopRegisterTableViewCell.m
//  posApp
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HistioryResultTableViewCell.h"

@interface HistioryResultTableViewCell ()

@property (nonatomic,strong)UIView   * backView;
@property (nonatomic,strong)UILabel  * numberLabel1;
@property (nonatomic,strong)UILabel  * numberLabel2;
@property (nonatomic,strong)UILabel  * numberLabel3;
@property (nonatomic,strong)UILabel  * numberLabel4;
@property (nonatomic,strong)UILabel  * timeLabel;


@end

@implementation HistioryResultTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, KScreenWidth - 30 , 170)];
    [self.backView.layer setCornerRadius:5];
    [self.backView setBackgroundColor:MDRGBA(234, 234, 234, 1)];
    [self.backView setClipsToBounds:YES];
    [self addSubview:self.backView];
    
    [self.backView addSubview:[Tools creatLabel:CGRectMake(10, 50, KScreenWidth - 50, 30) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@"联盟交易额"]];
    [self.backView addSubview:[Tools creatLabel:CGRectMake(10, 80, KScreenWidth - 50, 30) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@"当前盟友新增商户数"]];
    [self.backView addSubview:[Tools creatLabel:CGRectMake(10, 110, KScreenWidth - 50, 30) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@"个人交易额"]];
    [self.backView addSubview:[Tools creatLabel:CGRectMake(10, 140, KScreenWidth - 50, 30) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@"个人新增商户"]];

    
    self.numberLabel1 = [Tools creatLabel:CGRectMake(10, 50, KScreenWidth - 50, 30) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentRight) title:@""];
    [self.backView addSubview:self.numberLabel1];
    
    self.numberLabel2 = [Tools creatLabel:CGRectMake(10, 80, KScreenWidth - 50, 30) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentRight) title:@""];
    [self.backView addSubview:self.numberLabel2];
    self.numberLabel3 = [Tools creatLabel:CGRectMake(10, 110, KScreenWidth - 50, 30) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentRight) title:@""];
    [self.backView addSubview:self.numberLabel3];
    self.numberLabel4 = [Tools creatLabel:CGRectMake(10, 140, KScreenWidth - 50, 30) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentRight) title:@""];
    [self.backView addSubview:self.numberLabel4];
    
    
    self.timeLabel = [Tools creatLabel:CGRectMake(10+(KScreenWidth - 50)/4, 10, (KScreenWidth - 50)/2, 30) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentCenter) title:@""];
    [self.timeLabel.layer setCornerRadius:15];
    [self.timeLabel setBackgroundColor:[UIColor whiteColor]];
    [self.backView addSubview:self.timeLabel];
    
}

- (void)bandDataWithDictionary:(NSDictionary *)dic{
    
    [self.numberLabel1 setText:[NSString stringWithFormat:@"%@",dic[@"lianmengjiaoyie"]]];
    [self.numberLabel2 setText:[NSString stringWithFormat:@"%@",dic[@"lianmengshanghu"]]];
    [self.numberLabel3 setText:[NSString stringWithFormat:@"%@",dic[@"gerenjiaoyie"]]];
    [self.numberLabel4 setText:[NSString stringWithFormat:@"%@",dic[@"gerenshanghu"]]];
    [self.timeLabel setText:dic[@"month"]];
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
