//
//  BusinessTableViewCell.h
//  posApp
//
//  Created by apple on 2018/8/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessModel.h"
@interface BusinessTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)bandDataWithModel:(BusinessModel *)model;

@end
