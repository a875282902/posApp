//
//  ShopModel.m
//  posApp
//
//  Created by apple on 2018/7/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel

- (void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    else{
        
        [super setValue:value forKey:key];
    }
}

@end
