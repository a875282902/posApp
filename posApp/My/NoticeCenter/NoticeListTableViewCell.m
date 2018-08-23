//
//  NoticeListTableViewCell.m
//  posApp
//
//  Created by apple on 2018/7/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NoticeListTableViewCell.h"

@interface NoticeListTableViewCell ()

@property (nonatomic,strong)UILabel      * timeLabel;
@property (nonatomic,strong)UILabel      * titleLael;
@property (nonatomic,strong)UILabel      * descLabel;
@property (nonatomic,strong)UIImageView  * readImage;

@end

@implementation NoticeListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    [self setBackgroundColor:[UIColor colorWithHexString:@"#f6f6f6"]];
    self.timeLabel = [Tools creatLabel:CGRectMake(0, 0, KScreenWidth, 45) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentCenter) title:@""];
    [self addSubview:self.timeLabel];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 45, KScreenWidth - 40, 155)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:backView];
    
    self.titleLael = [Tools creatLabel:CGRectMake(0, 20,  KScreenWidth - 40, 15) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentCenter) title:@""];
    [backView addSubview:self.titleLael];
    
    self.readImage = [Tools creatImage:CGRectMake(KScreenWidth - 60, 10, 10, 10) image:@""];
    [self.readImage setBackgroundColor:[UIColor redColor]];
    [self.readImage setHidden:YES];
    [self.readImage.layer setCornerRadius:5];
    [backView addSubview:self.readImage];
    
    self.descLabel = [Tools creatLabel:CGRectMake(15, 52, KScreenWidth - 70, 50) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentLeft) title:@""];
    [self.descLabel setNumberOfLines:3];
    [backView addSubview:self.descLabel];
    
    [backView addSubview:[Tools setLineView:CGRectMake(0, 119, KScreenWidth, 1)]];

    
    [backView addSubview:[Tools creatLabel:CGRectMake(0 , 120, KScreenWidth - 40, 35)  font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#666666"] alignment:(NSTextAlignmentCenter) title:@"查看更多 >"]];

}

- (void)bandDataWithDic:(NSDictionary *)dic{
    
    [self.titleLael setText:dic[@"title"]];
    [self.timeLabel setText:dic[@"createtime"]];
    [self.descLabel setText:dic[@"desc"]];
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
