//
//  NoticeListView.h
//  posApp
//
//  Created by apple on 2018/7/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol NoticeListViewDelegate <NSObject>

- (void)pushNoticeDetails:(BaseViewController *)vc;

@end

@interface NoticeListView : UIView

- (instancetype)initWithFrame:(CGRect)frame withType:(NSString *)type;

@property (nonatomic,weak)id<NoticeListViewDelegate>delegate;

@end
