//
//  AddressModel.h
//  anjuyi1
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 lsy. All rights reserved.
//

#import "BaseModel.h"

@interface AddressModel : BaseModel
/*"data[id]    字符串    id
 data[name]    字符串    姓名
 data[phone]    字符串    手机号
 data[provinceid]    字符串    所在省
 data[cityid]    字符串    所在市
 data[areaid]    字符串    所在区
 data[address]    字符串    详细地址
 data[pca]    字符串    省市区
 data[isdefault]*/

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
