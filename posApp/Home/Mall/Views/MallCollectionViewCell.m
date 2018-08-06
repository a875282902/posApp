//
//  MallCollectionViewCell.m
//  posApp
//
//  Created by apple on 2018/8/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MallCollectionViewCell.h"

@implementation MallCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"MallCollectionViewCell" owner:self options:nil].lastObject;
    }
    return self;
}

- (void)bandDataWithModel:(MallModel*)model{
    
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    
    [self.titleLabel setText:model.name];
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%@",model.price]];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.backView.layer setBorderWidth:1];
    [self.backView.layer setBorderColor:[UIColor colorWithHexString:@"#eeeeee"].CGColor];

}

@end
