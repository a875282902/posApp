//
//  TixianViewController.m
//  posApp
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TixianViewController.h"
#import "TixianListViewController.h"

@interface TixianViewController ()
@property (nonatomic,strong) UIView         * navView;
@property (nonatomic,strong)NSString *validbalance;
@property (nonatomic,strong)NSMutableArray *textArr;

@end

@implementation TixianViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textArr = [NSMutableArray array];
    [self baseForDefaultLeftNavButton];
    [self.view addSubview:self.navView];

    [self getData];
}

- (void)getData{
    
    NSDictionary *dic = @{@"service":@"Member.Memberinfo",@"utoken":UTOKEN};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            weakSelf.validbalance = responseObject[@"data"][@"validbalance"];
            
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
- (UIView *)navView{
    
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KTopHeight)];
        [_navView setBackgroundColor:MDRGBA(255, 255, 255, 0)];
        
        [_navView addSubview:[Tools creatLabel:CGRectMake(0, KStatusBarHeight, KScreenWidth , 44) font:[UIFont systemFontOfSize:18] color:[UIColor blackColor] alignment:(NSTextAlignmentCenter) title:@"提现记录"]];
        
        UIButton *back = [Tools creatButton:CGRectMake(MDXFrom6(10), KStatusBarHeight + 2, 40, 40) font:[UIFont systemFontOfSize:12] color:[UIColor whiteColor] title:@"" image:@"ss_back"];
        [back addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
        [_navView addSubview:back];
        
        UIButton *share = [Tools creatButton:CGRectMake(KScreenWidth - 80, KStatusBarHeight + 2, 80, 40) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#999999"] title:@"历史提现" image:@""];
        [share addTarget:self action:@selector(checkHistoryEarning) forControlEvents:(UIControlEventTouchUpInside)];
        [_navView addSubview:share];
        
        [_navView addSubview:[Tools setLineView:CGRectMake(0, KTopHeight -1, KScreenWidth, 1)]];
        
    }
    return _navView;
}

#pragma mark -- 事件
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkHistoryEarning{
    
    TixianListViewController *vc = [[TixianListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setUpUI{

    CGFloat height = KTopHeight + 20;
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(0, height, KScreenWidth, 20) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentCenter) title:@"可提金额"]];
    
    height += 30;
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(0, height, KScreenWidth, 20) font:[UIFont systemFontOfSize:16] color:[UIColor redColor] alignment:(NSTextAlignmentCenter) title:self.validbalance]];
    
    height += 30;
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, height, KScreenWidth, 1)]];
    
    
    
    for (NSInteger i = 0 ; i < 3 ; i++) {
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, height , KScreenWidth - 30 , 60)];
        [textField setPlaceholder:@[@"请输入提现金额",@"请输入支付宝账号",@"请输入支付宝名称"][i]];
        [textField setTag:i];
        [textField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:(UIControlEventEditingChanged)];
        [textField setKeyboardType:(UIKeyboardTypeEmailAddress)];
        [textField setFont:[UIFont systemFontOfSize:16]];
        [self.view addSubview:textField];
        [self.textArr addObject:@""];
        [self.view addSubview:[Tools setLineView:CGRectMake(15, height+59, KScreenWidth - 30, 1)]];
        
        height += 60;
    }
    
    height += 20;
    
    UIButton *btn = [Tools creatButton:CGRectMake(15, height , KScreenWidth - 30 , 40) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"申请提现" image:@""];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#1c83d4"]];
    [btn addTarget:self action:@selector(tixian) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    height += 60;
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(15, height, KScreenWidth -30, 50) font:[UIFont systemFontOfSize:16] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentLeft) title:@"说明：提现金额最低为10元，10元以下不予提现。每笔收取手续费2元，扣取6个点个数"]];
    
}

- (void)textFieldValueChange:(UITextField *)sender{
    
    [self.textArr replaceObjectAtIndex:sender.tag withObject:sender.text];
}

- (void)tixian{
    
    NSDictionary *dic = @{@"service":@"Main.Applytx",@"utoken":UTOKEN,@"amount":self.textArr[0],@"alipayaccount":self.textArr[1],@"alipayname":self.textArr[2]};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            [ViewHelps showHUDWithText:@"提现成功"];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
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
