//
//  NavHidden.m
//  posApp
//
//  Created by apple on 2018/7/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NavHidden.h"

@implementation NavHidden

static NavHidden* _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
        _instance.isHidden = YES;
    }) ;
    
    return _instance ;
}

@end
