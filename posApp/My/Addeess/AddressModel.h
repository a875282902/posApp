//
//  AddressModel.h
//  anjuyi1
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface AddressModel : BaseModel
/*"id":"20",
 "userName":"马骋",
 "phone":"17600739244",
 "is_default":"1",
 "province":"北京市",
 "city":"北京市",
 "area":"东城区",
 "detail":"阿斯达所多"*/

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *isdefault;
@property (nonatomic,copy)NSString *provinceid;
@property (nonatomic,copy)NSString *cityid;
@property (nonatomic,copy)NSString *areaid;
@property (nonatomic,copy)NSString *pca;
@property (nonatomic,copy)NSString *address;

@end
