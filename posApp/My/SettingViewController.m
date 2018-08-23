//
//  SettingViewController.m
//  posApp
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "BaseNaviViewController.h"

#import "ChangeBankViewController.h"
#import "ChangePasswordViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    
    [self setTitle:@"更多设置"];
    
    [self setUpUI];
}

- (void)setUpUI{
    
    NSArray *tArr = @[@"更换结算卡",@"修改密码"];
    
    for (NSInteger i = 0 ; i < 2 ; i ++) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 45*i, KScreenWidth, 45)];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSetting:)]];
        [backView setTag:i];
        [self.view addSubview:backView];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(15, 0, KScreenWidth - 30, 45) font:[UIFont systemFontOfSize:16] color:TCOLOR alignment:(NSTextAlignmentLeft) title:tArr[i]]];
        
        [backView addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 20,15 , 15, 15) image:@"arrow_right"]];
        
        [backView addSubview:[Tools setLineView:CGRectMake(0, 44, KScreenWidth, 1)]];
    }
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(20), 120, KScreenWidth - MDXFrom6(40), MDXFrom6(50)) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"注销" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(backLogin) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
}

- (void)selectSetting:(UITapGestureRecognizer *)sender{
    
    switch (sender.view.tag) {
        case 0:
        {
            if (self.isReal) {
                ChangeBankViewController *vc = [[ChangeBankViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else{
                
                [ViewHelps showHUDWithText:@"请先进行实名认证"];
            }
            
        }
            break;
        case 1:
        {
            ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
    
        }
            break;
            
        default:
            break;
    }
}

- (void)backLogin{
    
    [self creatAlertViewControllerWithMessage:@"确定要注销该用户吗？"];
    
}

- (void)creatAlertViewControllerWithMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"utoken"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        LoginViewController *vc = [[LoginViewController alloc] init];
        BaseNaviViewController *navvc = [[BaseNaviViewController alloc] initWithRootViewController:vc];
        [self presentViewController:navvc animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
