//
//  BusinessTableViewCell.m
//  posApp
//
//  Created by apple on 2018/8/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BusinessTableViewCell.h"

@implementation BusinessTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self = [[NSBundle mainBundle] loadNibNamed:@"BusinessTableViewCell" owner:self options:nil].lastObject;
    }
    return  self;
}

- (void)bandDataWithModel:(BusinessModel *)model{
    
    [self.titleLabel setText:model.title];
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    [self.timeLabel setText:[self stringToDate:model.createtime]];
}

//时间戳转时间
- (NSString *)stringToDate:(NSString *)str{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
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
