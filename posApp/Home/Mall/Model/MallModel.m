//
//  MallModel.m
//  posApp
//
//  Created by apple on 2018/8/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MallModel.h"

@implementation MallModel


- (void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    else{
        
        [super setValue:value forKey:key];
    }
}

@end
