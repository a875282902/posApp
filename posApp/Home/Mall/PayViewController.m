//
//  PayViewController.m
//  posApp
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PayViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AddressListViewController.h"

@interface PayViewController ()
{
    NSDictionary *_address;
    NSInteger _index;
}
@property (nonatomic,strong) UIView *addressView;
@property (nonatomic,strong) NSMutableArray *payStautsArr;
@property (nonatomic,strong) NSMutableArray *payImageArr;

@end

@implementation PayViewController

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZFB_PaySuccess" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"结算中心"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ZFBPaySuceess:) name:@"ZFB_PaySuccess" object:nil];
    
    self.payStautsArr = [NSMutableArray array];
    self.payImageArr = [NSMutableArray array];
    
    _index = 0;
    
    [self setUpUI];
    
    [self getAddress];
    
}

- (void)getAddress{
    
    NSDictionary *dic = @{@"service":@"Member.Addresslists",@"utoken":UTOKEN};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *arr = responseObject[@"data"];
                
                if (arr.count>0) {
                    self->_address = arr[0];
                    [weakSelf refreshAddressView];
                }
            }
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}

- (void)setUpUI{
    
    self.addressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 80)];
    [self.addressView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAddress:)]];
    [self.addressView addSubview:[Tools creatLabel:CGRectMake(0, 0, KScreenWidth, 80) font:[UIFont systemFontOfSize:15] color:[UIColor grayColor] alignment:(NSTextAlignmentCenter) title:@"请设置收货地址 >"]];
    [self.view addSubview:self.addressView];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 80, KScreenWidth, 1)]];
    
    CGFloat h = 94;
    
    [self.view addSubview:[Tools creatImage:CGRectMake(10, h, 70, 70) url:self.goodsDic[@"thumb"] image:@"thumb"]];
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(90, h, KScreenWidth - 100, 25) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:self.goodsDic[@"name"]]];
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(90, h+25, KScreenWidth - 100, 25) font:[UIFont systemFontOfSize:15] color:[UIColor redColor] alignment:(NSTextAlignmentLeft) title:[NSString stringWithFormat:@"￥:%@",self.goodsDic[@"price"]]]];
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(90, h+50, KScreenWidth - 100, 20) font:[UIFont systemFontOfSize:12] color:[UIColor grayColor] alignment:(NSTextAlignmentLeft) title:[NSString stringWithFormat:@"%@台",self.goodsDic[@"stocknum"]]]];
    
    h+= 84;
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, h, KScreenWidth, 10)]];
    
    h+= 25;
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(10, h, KScreenWidth, 18) font:[UIFont systemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@"支付方式"]];
    
    h += 18+15;
    
    for (NSInteger i = 0 ; i < 2; i++) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, h+(60*i), KScreenWidth - 20, 50)];
        [backView.layer setCornerRadius:7];
        [backView.layer setBorderWidth:1];
        [backView setTag:i];
        [backView.layer setBorderColor:i==0?[UIColor orangeColor].CGColor:[UIColor grayColor].CGColor];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPayType:)]];
        [self.view addSubview:backView];
        
        [backView addSubview:[Tools creatImage:CGRectMake(10, 7.5, 35, 35) image:@[@"pay_wx",@"pay_ali"][i]]];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(55, 0, 120 , 50) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@[@"微信支付",@"支付宝支付"][i]]];
        
        UIImageView *imageView = [Tools creatImage:CGRectMake(KScreenWidth - 50, 15, 20, 20) image:i==0?@"selected":@"unselected"];
        
        [backView addSubview:imageView];
        [self.payImageArr  addObject:imageView];
        [self.payStautsArr addObject:backView];
    }
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, KViewHeight - 50, KScreenWidth, 50)];
    [self.view addSubview:footView];
    
    [footView addSubview:[Tools creatLabel:CGRectMake(0, 0, 50, 50) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#3b3b3b"] alignment:(NSTextAlignmentRight) title:@"总计："]];
    
    [footView addSubview:[Tools creatLabel:CGRectMake(50, 0, (KScreenWidth*2/3.0)-50, 50) font:[UIFont systemFontOfSize:15] color:MDRGBA(255, 60, 17, 1) alignment:(NSTextAlignmentLeft) title:[NSString stringWithFormat:@"%@元",self.goodsDic[@"price"]]]];
    
    UIButton *btn = [Tools creatButton:CGRectMake(KScreenWidth*2/3.0, 0,  KScreenWidth/3.0, 50) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] title:@"立即付款" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 60, 17, 1)];
    [btn addTarget:self action:@selector(pay) forControlEvents:(UIControlEventTouchUpInside)];
    [footView addSubview:btn];
    
    
    
}

#pragma mark ---  事件

- (void)selectAddress:(UITapGestureRecognizer *)sender{
    
    AddressListViewController *vc = [[AddressListViewController alloc] init];
    
    [vc setSelectAddress:^(NSDictionary *dic) {
        self->_address = dic;
        [self refreshAddressView];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshAddressView{
    
    [self.addressView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.addressView addSubview:[Tools creatImage:CGRectMake(10, 15, 15, 15) image:@"add_name"]];
    [self.addressView addSubview:[Tools creatImage:CGRectMake(10, 50, 15, 15) image:@"add_add"]];
    [self.addressView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 160, 15, 15, 15) image:@"add_phone"]];
    
    [self.addressView addSubview:[Tools creatLabel:CGRectMake(30, 15, KScreenWidth - 210, 15) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:_address[@"name"]]];

    [self.addressView addSubview:[Tools creatLabel:CGRectMake(KScreenWidth - 140, 15, 120, 15) font:[UIFont systemFontOfSize:15] color:TCOLOR alignment:(NSTextAlignmentLeft) title:_address[@"phone"]]];
    
    [self.addressView addSubview:[Tools creatLabel:CGRectMake(30, 39, KScreenWidth - 70, 37) font:[UIFont systemFontOfSize:15] color:GCOLOR alignment:(NSTextAlignmentLeft) title:_address[@"pca"]]];
    
}

- (void)selectPayType:(UITapGestureRecognizer *)sender{
    
    for (UIView *v in self.payStautsArr) {
        [v.layer setBorderColor:[UIColor grayColor].CGColor];
    }

    for (UIImageView *v in self.payImageArr) {
        [v setImage:[UIImage imageNamed:@"unselected"]];
    }
    
    [((UIImageView *)self.payImageArr[sender.view.tag]) setImage:[UIImage imageNamed:@"selected"]];
    [sender.view.layer setBorderColor:[UIColor orangeColor].CGColor];
    
    _index = sender.view.tag;
}



- (void)pay{
 
    if (_index == 0) {
        
    }
    else{
        
        [self payInfoWithZhifubao];
    }
    
}


#pragma mark -- 支付
- (void)payInfoWithZhifubao{
    
    NSDictionary *dic = @{@"service":@"Order.Orderpay",
                          @"utoken":UTOKEN,
                          @"addressid":_address[@"id"],
                          @"paypath":@"2",
                          @"goodid":self.goodsDic[@"id"]};
    
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        if ([responseObject[@"ret"] integerValue]==200) {
            
            NSString *appScheme = @"pos";
            
            NSString *content = [responseObject[@"data"][@"content"] stringByAddingPercentEscapesUsingEncoding:(NSUTF8StringEncoding)];
            //            NSString *content = responseObject[@"data"][@"content"];
            
            NSArray *arr = [content  componentsSeparatedByString:@"&sign="];
            NSArray *arr1 = [arr[1] componentsSeparatedByString:@"&"];
            
            NSString *orderString;
            
            NSString *newsign= (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)arr1[0] , NULL, (CFStringRef)@"!*'();:@&=+ $,./?%#[]", kCFStringEncodingUTF8));
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (arr1.count>1) {
                
                NSString *type=@"";
                
                for (NSInteger i = 1; i < arr1.count; i++) {
                    type = [NSString stringWithFormat:@"%@&%@",type,arr1[i]];
                }
                
                orderString = [NSString stringWithFormat:@"%@&sign=%@%@",arr[0], newsign,type];
            }
            
            else{
                
                orderString = [NSString stringWithFormat:@"%@&sign=%@",arr[0], newsign];
            }
            
            
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:responseObject[@"data"][@"content"]  fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"ZFB_PaySuccess" object:nil userInfo:resultDic];
            }];
            
        }
        else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [ViewHelps showHUDWithText:@"支付失败，请再次支付"];
    }];
    
}
- (void)ZFBPaySuceess:(NSNotification *)sender{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSDictionary *resultDic = sender.userInfo;
    
    if([resultDic[@"resultStatus"] intValue] == 9000){ //成功付款
        [ViewHelps showHUDWithText:@"支付成功"];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
        
    }else if([resultDic[@"resultStatus"] intValue] == 6001){ //中途取消订单了
        
        [ViewHelps showHUDWithText:@"中途取消订单了"];
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
