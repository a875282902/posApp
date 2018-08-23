//
//  AddressListViewController.h
//  posApp
//
//  Created by apple on 2018/8/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface AddressListViewController : BaseViewController

@property (nonatomic,copy)void(^selectAddress)(NSDictionary *dic);

@end
