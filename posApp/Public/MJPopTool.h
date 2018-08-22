//
//  MJPopTool.h
//  MJPopToolDemo
//
//  Created by Mengjie.Wang on 2016/06/22.
//  Copyright © 2016年 王梦杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MJPopTool : NSObject

+ (instancetype)sharedInstance;

/**
 *  弹出视图
 *
 *  @param view     被弹出的视图
 *  @param animated 是否需要动画
 */
- (void)popView:(UIView *)view animated:(BOOL)animated;

/**
 *
 *  关闭视图
 *
 *  @param animated 是否需要动画
 */
- (void)closeAnimated:(BOOL)animated;

@end
