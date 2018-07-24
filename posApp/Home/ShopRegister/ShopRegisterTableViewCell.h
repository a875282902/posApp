//
//  ShopRegisterTableViewCell.h
//  posApp
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"

@class ShopRegisterTableViewCell;

@protocol ShopRegisterTableViewCellDelegate <NSObject>

- (void)editAddressWithCell:(ShopRegisterTableViewCell *)cell;
- (void)copeAddressWithCell:(ShopRegisterTableViewCell *)cell;

@end

@interface ShopRegisterTableViewCell : UITableViewCell

@property (nonatomic,weak)id<ShopRegisterTableViewCellDelegate>delegate;

- (void)bandDataWithShopModel:(ShopModel *)model;

@end
