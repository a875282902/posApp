//
//  RegisterViewController.m
//  posApp
//
//  Created by apple on 2018/7/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RegisterViewController.h"
#import "RootViewController.h"

@interface RegisterViewController ()
{
    NSString *phone;
    NSString *yzm;
    NSString *password;
    NSString *inviterphone;
    NSInteger time;
}

@property (weak, nonatomic) IBOutlet UIButton *getCode;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *inviterPhone;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation RegisterViewController


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //消除定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.timer invalidate];
    self.timer = nil;
    
    [self.getCode setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [self.getCode addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationLeftBarButtonWithImageNamed:@"back_pass"];
    
    time = 60;

    [self.getCode.layer setBorderColor:OCOLOR.CGColor];
    [self.getCode.layer setBorderWidth:1];
    [self.getCode.layer setCornerRadius:5];
    
    [self.registerButton.layer setCornerRadius:5];
    
    NSString *str = @"我已阅读和同意《瑞联盟注册协议》";
    
    NSMutableAttributedString *attS = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attS setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#3b3b3b"]} range:NSMakeRange(0, str.length)];
    [attS setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(7, 9)];
    [self.agreeLabel setAttributedText:attS];
    
    [self.agreeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkAgree:)]];
    
}

- (void)checkAgree:(UITapGestureRecognizer *)sender{
    
    
}

- (IBAction)phoneValueChange:(UITextField *)sender {
    phone =sender.text;
}
- (IBAction)codeValueChange:(UITextField *)sender {
    yzm = sender.text;
}

- (IBAction)passwordValueChange:(UITextField *)sender {
    password = sender.text;
}
- (IBAction)inviterValueChange:(UITextField *)sender {
    inviterphone = sender.text;
}
- (IBAction)getCode:(UIButton *)sender {

    
    if ([phone length]==0) {
        
        [ViewHelps showHUDWithText:@"请输入正确的手机号"];
        return;
    }

    
    
    NSDictionary *dic = @{@"service":@"Member.Sendsms",@"phone":phone,@"token":[[NSUserDefaults standardUserDefaults] valueForKey:@"token"]};

    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {

        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            [ViewHelps showHUDWithText:@"验证码发送成功，请注意查收"];
            
            [sender removeTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
            
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
            }
            //开启定时器
            [self.timer setFireDate:[NSDate distantPast]];
        }
        else{

            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }

    } failure:^(NSError *error) {

        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}



- (void)changeTime{
    
    if (time >0) {
        [self.getCode setTitle:[NSString stringWithFormat:@"%ld S",time] forState:(UIControlStateNormal)];
        time --;
    }
    else{
        
        [self.getCode setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.getCode addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
        time = 60;
    }
}


- (IBAction)sureReadAgreement:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}
- (IBAction)registerAccount:(UIButton *)sender {
    
    if (!phone && [phone length] == 0) {
        [ViewHelps showHUDWithText:@"请输入手机号码"];
        return;
    }
    if (!password && [password length] == 0) {
        [ViewHelps showHUDWithText:@"请输入密码"];
        return;
    }
    if (!yzm && [yzm length] == 0) {
        [ViewHelps showHUDWithText:@"请输入验证码"];
        return;
    }
   
    
    NSDictionary *dic = @{@"service":@"Member.Register",@"phone":phone,@"utoken":@"123456",@"yzm":yzm,@"password":password};
    
    if (inviterphone && [inviterphone length] > 0) {
       
        dic = @{@"service":@"Member.Register",@"phone":phone,@"yzm":yzm,@"password":password,@"inviterphone":inviterphone};
    }
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            [ViewHelps showHUDWithText:@"注册成功"];
            [weakSelf login];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}

- (void)login{
    
    NSDictionary *dic = @{@"service":@"Member.Login",@"phone":phone,@"password":password};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            [ViewHelps showHUDWithText:@"登录成功"];
            
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

- (IBAction)passwordIsVisible:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    
    [self.passwordTextField setSecureTextEntry:!sender.selected];
    
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
