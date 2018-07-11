//
//  FriendsNoTableViewCell.h
//  posApp
//
//  Created by apple on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendsNoTableViewCell;

@protocol FriendsNoTableViewCellDelegate <NSObject>

- (void)contactUserWithCell:(FriendsNoTableViewCell *)cell;

@end

@interface FriendsNoTableViewCell : UITableViewCell

@property (nonatomic,weak)id<FriendsNoTableViewCellDelegate>delegate;

@end
