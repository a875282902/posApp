//
//  ShopRegisterTableViewCell.m
//  posApp
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShopRegisterTableViewCell.h"

@interface ShopRegisterTableViewCell ()

@property (nonatomic,strong)UIView   * backView;
@property (nonatomic,strong)UILabel  * nameLabel;
@property (nonatomic,strong)UILabel  * phoneLabel;
@property (nonatomic,strong)UILabel  * addressLabel;
@property (nonatomic,strong)UILabel  * SNLabel;
@property (nonatomic,strong)UILabel  * stateLabel;
@property (nonatomic,strong)UIButton * editBtn;
@property (nonatomic,strong)UIButton * copBtn;


@end

@implementation ShopRegisterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(15, 20, KScreenWidth - 30 , 150)];
    [self.backView.layer setCornerRadius:5];
    [self.backView.layer setBorderColor:LCOLOR.CGColor];
    [self.backView.layer setBorderWidth:1];
    [self.backView setClipsToBounds:YES];
    [self addSubview:self.backView];
    
    
    [self.backView addSubview:[Tools creatImage:CGRectMake(10, 15, 15, 15) image:@"add_name"]];
    [self.backView addSubview:[Tools creatImage:CGRectMake(10, 50, 15, 15) image:@"add_add"]];
    [self.backView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 160, 15, 15, 15) image:@"add_phone"]];
    
    self.nameLabel = [Tools creatLabel:CGRectMake(30, 15, KScreenWidth - 210, 15) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@"name"];
    [self.backView addSubview:self.nameLabel];
    
    self.phoneLabel = [Tools creatLabel:CGRectMake(KScreenWidth - 140, 15, 120, 15) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@""];
    [self.backView addSubview:self.phoneLabel];
    
    self.addressLabel = [Tools creatLabel:CGRectMake(30, 39, KScreenWidth - 70, 37) font:[UIFont systemFontOfSize:15] color:GCOLOR alignment:(NSTextAlignmentLeft) title:@"addres"];
    [self.backView addSubview:self.addressLabel];
    
    self.SNLabel = [Tools creatLabel:CGRectMake(10, 80, KScreenWidth - 50, 14) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@"snma:123123"];
    [self.backView addSubview:self.SNLabel];
    
    [self.backView addSubview:[Tools setLineView:CGRectMake(0, 105, KScreenWidth - 30, 1)]];
    
    self.stateLabel = [Tools creatLabel:CGRectMake(10, 105, 200, 45) font:[UIFont systemFontOfSize:15] color:OCOLOR alignment:(NSTextAlignmentLeft) title:@"资料已提交"];
    [self.backView addSubview:self.stateLabel];
    
    self.copBtn = [Tools creatButton:CGRectMake(KScreenWidth - 90 , 110, 50, 35) font:[UIFont systemFontOfSize:15] color:TCOLOR title:@"复制" image:@"copy"];
    [self.copBtn addTarget:self action:@selector(copeAddress) forControlEvents:(UIControlEventTouchUpInside)];
    [self.backView addSubview:self.copBtn];
    
    self.editBtn = [Tools creatButton:CGRectMake(KScreenWidth - 160 , 110, 50, 35) font:[UIFont systemFontOfSize:15] color:TCOLOR title:@"编辑" image:@"edit"];
    [self.editBtn addTarget:self action:@selector(editAddress) forControlEvents:(UIControlEventTouchUpInside)];
    [self.backView addSubview:self.editBtn];
}

- (void)bandDataWithShopModel:(ShopModel *)model{
    
    [self.nameLabel setText:model.truename];
    [self.phoneLabel setText:model.phone];
    [self.addressLabel setText:[NSString stringWithFormat:@"%@%@",model.pca,model.address]];
    
    
    
}

- (void)copeAddress{
    [self.delegate copeAddressWithCell:self];
}

- (void)editAddress{
    [self.delegate editAddressWithCell:self];
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
