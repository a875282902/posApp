//
//  ShopModel.h
//  posApp
//
//  Created by apple on 2018/7/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseModel.h"

@interface ShopModel : BaseModel

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *truename;
@property (nonatomic,copy)NSString *provinceid;
@property (nonatomic,copy)NSString *cityid;
@property (nonatomic,copy)NSString *areaid;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *pca;
@property (nonatomic,copy)NSString *status;

@end
