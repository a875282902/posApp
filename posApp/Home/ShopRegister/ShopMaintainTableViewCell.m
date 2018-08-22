//
//  ShopRegisterTableViewCell.m
//  posApp
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShopMaintainTableViewCell.h"

@interface ShopMaintainTableViewCell ()

@property (nonatomic,strong)UIView   * backView;
@property (nonatomic,strong)UILabel  * nameLabel;
@property (nonatomic,strong)UILabel  * phoneLabel;
@property (nonatomic,strong)UILabel  * addressLabel;
@property (nonatomic,strong)UILabel  * SNLabel;


@end

@implementation ShopMaintainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(15, 20, KScreenWidth - 30 , 105)];
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
    
    self.SNLabel = [Tools creatLabel:CGRectMake(10, 80, KScreenWidth - 50, 14) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:@"SN码:S4444"];
    [self.backView addSubview:self.SNLabel];

}

- (void)bandDataWithShopModel:(ShopModel *)model{
    
    [self.nameLabel setText:model.truename];
    [self.phoneLabel setText:model.phone];
    [self.addressLabel setText:[NSString stringWithFormat:@"%@%@",model.pca,model.address]];
    //    self.SNLabel setText:[NSString stringWithFormat:@"SN码:%@",model.]
    
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
