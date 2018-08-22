//
//  AboutUsViewController.m
//  posApp
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"关于我们"];

    [self setUpUI];
}

- (void)setUpUI{
    
    CGFloat height = 20.0f;
    
    [self.view addSubview:[Tools creatImage:CGRectMake((KScreenWidth - 70)/2, height+15, 70, 70) image:@"logo"]];
    
    height += 110;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(0, height, KScreenWidth, 20) font:[UIFont systemFontOfSize:16] color:MDRGBA(129, 129, 129, 1) alignment:(NSTextAlignmentCenter) title:[NSString stringWithFormat:@"V%@",appCurVersion]]];
    
    height += 50;
    
    NSArray *tArr = @[@"微信公众号",@"联系电话",@"电子邮箱"];
    NSArray *dArr = @[@"易激活",@"400-168-4256",@"ruilianm@163.com"];
    
    for (NSInteger i = 0 ; i < 3 ; i++) {
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, height, KScreenWidth, 45)];
        [self.view addSubview:back];
        
        [back addSubview:[Tools creatLabel:CGRectMake(10, 0, KScreenWidth - 20, 45) font:[UIFont systemFontOfSize:14] color:[UIColor lightGrayColor] alignment:(NSTextAlignmentLeft) title:tArr[i]]];
        
        
        [back addSubview:[Tools creatLabel:CGRectMake(10, 0, KScreenWidth - 20, 45) font:[UIFont systemFontOfSize:14] color:TCOLOR alignment:(NSTextAlignmentRight) title:dArr[i]]];
        
        [back addSubview:[Tools setLineView:CGRectMake(0, 44, KScreenWidth, 1)]];
        
        height+= 45;
    }

    [self.view addSubview:[Tools creatLabel:CGRectMake(0, KViewHeight - 60, KScreenWidth, 60) font:[UIFont systemFontOfSize:12] color:[UIColor grayColor] alignment:(NSTextAlignmentCenter) title:@"瑞联盟 版本所有 \nCopyRight @ 2018.ALL Rights Reserved"]];
    
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
