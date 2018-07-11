//
//  OrderTableViewCell.m
//  posApp
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OrderTableViewCell.h"

@interface OrderTableViewCell ()

@property (nonatomic,strong)UILabel      * numLabel;
@property (nonatomic,strong)UILabel      * stateLabel;
@property (nonatomic,strong)UILabel      * nameLabel;
@property (nonatomic,strong)UILabel      * priceLabel;
@property (nonatomic,strong)UIImageView  * goodsCover;
@property (nonatomic,strong)UIButton     * payBtn;


@end

@implementation OrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    self.numLabel = [Tools creatLabel:CGRectMake(15, 0, KScreenWidth - 90, 40) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@"订单编号：--"];
    [self addSubview:self.numLabel];
    
    self.stateLabel = [Tools creatLabel:CGRectMake(KScreenWidth - 90, 0, 75, 40) font:[UIFont systemFontOfSize:15] color:RCOLOR alignment:(NSTextAlignmentRight) title:@"提交成功"];
    [self addSubview:self.stateLabel];
    
    [self addSubview:[Tools setLineView:CGRectMake(0, 40, KScreenWidth, 1)]];
    
    self.goodsCover = [Tools creatImage:CGRectMake(15, 52.5, 60, 60) image:@""];
    [self.goodsCover setBackgroundColor:GCOLOR];
    [self addSubview:self.goodsCover];
    
    self.nameLabel = [Tools creatLabel:CGRectMake(80, 52.5, KScreenWidth - 165, 40) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@"商品名称商品名称商品名称商品名称商品名称商品名称商品名称商品名称商品名称商品名称"];
    [self addSubview:self.nameLabel];
    
    self.priceLabel = [Tools creatLabel:CGRectMake(80, 97.5, KScreenWidth - 165, 15) font:[UIFont systemFontOfSize:15] color:RCOLOR alignment:(NSTextAlignmentLeft) title:@"price"];
    [self addSubview:self.priceLabel];
    
    self.payBtn = [Tools creatButton:CGRectMake(KScreenWidth - 85 , 87.5, 70, 25) font:[UIFont systemFontOfSize:13] color:RCOLOR title:@"去支付" image:@""];
    [self.payBtn.layer setCornerRadius:12.5];
    [self.payBtn.layer setBorderColor:RCOLOR.CGColor];
    [self.payBtn.layer setBorderWidth:1];
    [self.payBtn addTarget:self action:@selector(pay) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.payBtn];
    
    [self addSubview:[Tools setLineView:CGRectMake(0, 125, KScreenWidth, 10)]];
    
}

- (void)pay{
    [self.delegate payWithCell:self];
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
