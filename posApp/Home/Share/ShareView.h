//
//  ShareView.h
//  posApp
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareView;

@protocol ShareViewDelegate <NSObject>

- (void)share:(NSInteger)index; //声明协议方法

@end

@interface ShareView : UIView

- (void)show;

- (void)remove;

@property (nonatomic,weak)id <ShareViewDelegate>delegate;

@end
