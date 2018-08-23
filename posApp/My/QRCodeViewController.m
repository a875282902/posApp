//
//  QRCodeViewController.m
//  posApp
//
//  Created by apple on 2018/8/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()

@property (nonatomic,strong) NSDictionary *data;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"二维码分享"];
    [self getData];
    
}

- (void)getData{
    NSDictionary *dic = @{@"service":@"Main.Getshare",@"utoken":UTOKEN};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            weakSelf.data = responseObject[@"data"];
            
            [weakSelf setUpUI];
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
    
    [self.view addSubview:[Tools creatImage:CGRectMake((KScreenWidth-100)/2, 40, 100, 100) url:self.data[@"qrcode"] image:@""]];
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(0, 150, KScreenWidth, 14) font:[UIFont systemFontOfSize:14] color:[UIColor grayColor] alignment:(NSTextAlignmentCenter) title:@"扫码即可注册"]];
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(20),200, KScreenWidth - MDXFrom6(40), MDXFrom6(50)) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"邀请盟友加入" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(shareFriend:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    
}

- (void)shareFriend:(UIButton *)sender{
    
    
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
