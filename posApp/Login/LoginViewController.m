//
//  LoginViewController.m
//  posApp
//
//  Created by apple on 2018/7/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "RootViewController.h"

@interface LoginViewController ()
{
    NSString *phone;
    NSString *password;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *pawwwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *passwordVisible;

@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (strong, nonatomic) IBOutlet UIView *forgetView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [self.registerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerAccount)]];
    
    [self.forgetView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetAccount)]];
    
    [self.loginButton.layer setCornerRadius:5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (IBAction)passwordIsVisible:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    
    [self.pawwwordTextField setSecureTextEntry:!sender.selected];
}
- (IBAction)passwordValueChange:(UITextField *)sender {
    
    password = sender.text;
}
- (IBAction)userNameValueChange:(UITextField *)sender {
    phone = sender.text;
}


- (IBAction)login:(UIButton *)sender {
    
    if (!phone && [phone length] == 0) {
        [ViewHelps showHUDWithText:@"请输入手机号码"];
        return;
    }
    if (!password && [password length] == 0) {
        [ViewHelps showHUDWithText:@"请输入密码"];
        return;
    }
    NSDictionary *dic = @{@"service":@"Member.Login",@"phone":phone,@"password":password};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            [ViewHelps showHUDWithText:@"登录成功"];
            [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"utoken"] forKey:@"utoken"];
            
            RootViewController *vc = [[RootViewController alloc] init];
            [weakSelf presentViewController:vc animated:YES completion:nil];
            
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}

- (void)registerAccount{
    
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)forgetAccount{
    
    
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
