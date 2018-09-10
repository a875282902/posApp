//
//  ShareViewController.m
//  posApp
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShareViewController.h"
#import "DirectlyRegisterViewController.h"
#import "QRCodeViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"我要分享"];
    
    [self.view setBackgroundColor:MDRGBA(248, 248, 248, 1)];
    
    for (NSInteger i = 0 ; i <  2; i ++) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 15+(85*i), KScreenWidth - 20, 70)];
        [backView.layer setCornerRadius:5];
        [backView setTag:i];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)]];
        [backView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:backView];
        
        [backView addSubview:[Tools creatImage:CGRectMake(15, 10, 50, 50) image:[NSString stringWithFormat:@"share_%ld",i]]];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(70, 0, (KScreenWidth -130 ), 70) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:@[@"推广二维码链接",@"面对面开通账号"][i]]];
        
        [backView addSubview:[Tools creatImage:CGRectMake((KScreenWidth - 30)-25,(70-15)/2.0, 15, 15) image:@"arrow_right"]];
        
        
        
    }
}

- (void)select:(UITapGestureRecognizer *)sender{
    
    if (sender.view.tag == 0) {
        QRCodeViewController *vc = [[QRCodeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        
        DirectlyRegisterViewController *vc = [[DirectlyRegisterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
