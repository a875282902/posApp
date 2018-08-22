//
//  FirendsRealTableViewCell.h
//  posApp
//
//  Created by apple on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirendsRealTableViewCell;

@protocol FirendsRealTableViewCellDelegate <NSObject>

- (void)contactUserWithCell:(FirendsRealTableViewCell *)cell;

@end

@interface FirendsRealTableViewCell : UITableViewCell

@property (nonatomic,weak)id<FirendsRealTableViewCellDelegate>delegate;

- (void)bandDataWithDictionary:(NSDictionary *)dic;

@end
