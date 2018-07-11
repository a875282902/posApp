//
//  NavHidden.h
//  posApp
//
//  Created by apple on 2018/7/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavHidden : NSObject

+(instancetype) shareInstance ;

// 点击tabbaritem 为yes  puch其他页面为 no
@property (nonatomic,assign)BOOL isHidden;

@end
