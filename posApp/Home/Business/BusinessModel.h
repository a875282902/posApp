//
//  BusinessModel.h
//  posApp
//
//  Created by apple on 2018/8/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseModel.h"

@interface BusinessModel : BaseModel

@property (nonatomic,copy) NSString * ID;
@property (nonatomic,copy) NSString * thumb;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * createtime;

@end
