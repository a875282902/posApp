//
//  OrderTableViewCell.h
//  posApp
//
//  Created by apple on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderTableViewCell;

@protocol OrderTableViewCellDelegate <NSObject>

- (void)payWithCell:(OrderTableViewCell *)cell;

@end

@interface OrderTableViewCell : UITableViewCell

@property (nonatomic,weak)id<OrderTableViewCellDelegate>delegate;


@end
