//
//  LiveClassTableViewCell.m
//  posApp
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LiveClassTableViewCell.h"

@interface LiveClassTableViewCell ()

@property (nonatomic,strong)UIImageView   * coverImage;
@property (nonatomic,strong)UIView        * maskView;
@property (nonatomic,strong)UILabel       * nameLabel;

@end

@implementation LiveClassTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    self.coverImage = [Tools creatImage:CGRectMake(MDXFrom6(10), MDXFrom6(15), KScreenWidth - MDXFrom6(20), MDXFrom6(160)) image:@""];
    [self.coverImage setBackgroundColor:[UIColor blackColor]];
    [self.coverImage.layer setCornerRadius:5];
    [self addSubview:self.coverImage];
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, MDXFrom6(120), KScreenWidth - MDXFrom6(20), MDXFrom6(40))];
    [self.maskView setBackgroundColor:MDRGBA(33, 33, 33, .8)];
    [self.coverImage addSubview:self.maskView];
    
    self.nameLabel = [Tools creatLabel:CGRectMake(10, 0, KScreenWidth - 80, MDXFrom6(40)) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] alignment:(NSTextAlignmentLeft) title:@"name"];
    [self.maskView addSubview:self.nameLabel];
    
    [self.maskView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - MDXFrom6(55), MDXFrom6(7.5), MDXFrom6(25), MDXFrom6(25)) image:@"play"]];
    
}

- (void)bandDataWithDictionary:(NSDictionary *)dic{
    
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:dic[@"thumb"]]];
    [self.nameLabel setText:dic[@"title"]];
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
