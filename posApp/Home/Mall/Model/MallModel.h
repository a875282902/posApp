//
//  MallModel.h
//  posApp
//
//  Created by apple on 2018/8/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseModel.h"

@interface MallModel : BaseModel
/**a[id]    字符串    id
 data[thumb]    字符串    缩略图
 data[name]    字符串    商品名称
 data[price]    字符串    商品价格
 data[stocknum]*/

@property (nonatomic,copy) NSString * ID;
@property (nonatomic,copy) NSString * thumb;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * stocknum;
@end
