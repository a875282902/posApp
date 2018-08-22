//
//  SelectCity.h
//  anjuyi1
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectCity;

@protocol SelectCityDelegate <NSObject>

- (void)sureProvince:(NSDictionary *)province city:(NSDictionary *)city area:(NSDictionary *)area;

@end

@interface SelectCity : UIView

- (void)show;

- (void)hidden;

@property (nonatomic,weak)id<SelectCityDelegate>delegate;


@end
