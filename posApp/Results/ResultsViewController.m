//
//  ResultsViewController.m
//  posApp
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ResultsViewController.h"
#import "NavHidden.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self.navigationController setNavigationBarHidden:[NavHidden shareInstance].isHidden animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}

#pragma mark -- UI & 背景渐变色  &  上面的信息   &下面的信息
- (void)setUpUI{
    
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KStatusBarHeight + MDXFrom6(145))];
    [self setUpBackgroundColor:back];
    [self.view addSubview:back];
    

    [self.view addSubview:[Tools creatLabel:CGRectMake(0, KStatusBarHeight, KScreenWidth, MDXFrom6(55)) font:[UIFont boldSystemFontOfSize:19] color:[UIColor whiteColor] alignment:(NSTextAlignmentCenter) title:@"6月业界"]];
    
    CGFloat height = KStatusBarHeight + MDXFrom6(55);
    
    UIView *resultsView = [[UIView alloc] initWithFrame:CGRectMake(15, height , KScreenWidth - 30, MDXFrom6(180))];
    [resultsView setBackgroundColor:[UIColor whiteColor]];
    [resultsView.layer setShadowColor:[UIColor blackColor].CGColor];
    [resultsView.layer setCornerRadius:5];
    [resultsView.layer setShadowOpacity:0.1];
    [resultsView.layer setShadowOffset:CGSizeMake(2, 4)];
    [self.view addSubview:resultsView];
    
    [self createFristResults];
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(0, height + MDXFrom6(190), KScreenWidth, MDXFrom6(45)) font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] alignment:(NSTextAlignmentCenter) title:@"5月业绩"]];
    
    [self createSecondResults];
    
    height += MDXFrom6(190+ 20 + 130 + 45);
    
    UIView *historyBtn = [[UIView alloc] initWithFrame:CGRectMake(15, height , KScreenWidth - 30, MDXFrom6(45))];
    [self setUpBackgroundColor:historyBtn];
    [historyBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHistoryOrder:)]];
    [historyBtn setUserInteractionEnabled:YES];
    [historyBtn.layer setCornerRadius:5];
    [historyBtn setClipsToBounds:YES];
    [self.view addSubview:historyBtn];
    
    [historyBtn addSubview:[Tools creatLabel:CGRectMake(15, 0, KScreenWidth - 60, MDXFrom6(45)) font:[UIFont systemFontOfSize:15] color:[UIColor whiteColor] alignment:(NSTextAlignmentLeft) title:@"历史业绩详情"]];
    [historyBtn addSubview:[Tools creatImage:CGRectMake(KScreenWidth - 60, (MDXFrom6(45) -15)/2.0, 15, 15) image:@"arrow_right_w"]];
    
    height += MDXFrom6(70);
    
    [self.view addSubview:[Tools creatLabel:CGRectMake(0, height, KScreenWidth, 20) font:[UIFont systemFontOfSize:15] color:[UIColor colorWithHexString:@"#9da9bc"] alignment:(NSTextAlignmentCenter) title:@"今日商盟已登记商户:0个"]];
}

- (void)setUpBackgroundColor:(UIView *)view{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    UIColor *color1= [UIColor colorWithHexString:@"#f75f5a"];
    UIColor *color2 = [UIColor colorWithHexString:@"#fdac50"];
    gradientLayer.colors = @[(__bridge id)color1.CGColor, (__bridge id)color2.CGColor];
    gradientLayer.locations = @[@0.3, @0.7];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [view.layer addSublayer:gradientLayer];
}


- (void)createFristResults{
    
    CGFloat height = KStatusBarHeight + MDXFrom6(55);
    
    NSArray *tArr = @[@"联盟交易额（元）",@"新增商户（个）",@"个人交易额（元）",@"新增商户（个）"];
    
    for (NSInteger i = 0 ; i < 4 ; i ++) {
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(15+(KScreenWidth/2 - 15)*(i%2), MDXFrom6(90*(i/2)) + height , (KScreenWidth/2 - 15), MDXFrom6(90))];
        [self.view addSubview:back];
        
        [back addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(20), (KScreenWidth/2 - 15), MDXFrom6(25)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentCenter) title:tArr[i]]];
        
        [back addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(45), (KScreenWidth/2 - 15), 25) font:[UIFont systemFontOfSize:24] color:[UIColor colorWithHexString:@"#f86959"] alignment:(NSTextAlignmentCenter) title:@"21312.11"]];
    }
    
    [self setUpLine:CGRectMake(KScreenWidth/2, height+MDXFrom6(20), 1, MDXFrom6(50))];
    [self setUpLine:CGRectMake(15, height+MDXFrom6(90), KScreenWidth - 30, MDXFrom6(1))];
    [self setUpLine:CGRectMake(KScreenWidth/2, height+MDXFrom6(110), 1, MDXFrom6(50))];
}

- (void)createSecondResults{
    
    CGFloat height = KStatusBarHeight + MDXFrom6(100) + MDXFrom6(190);
    
    [self setUpLine:CGRectMake(0, height, KScreenWidth, 1)];
    
    NSArray *tArr = @[@"联盟交易额（元）",@"新增商户（个）",@"个人交易额（元）",@"新增商户（个）"];
    
    for (NSInteger i = 0 ; i < 4 ; i ++) {
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(15+(KScreenWidth/2 - 15)*(i%2), MDXFrom6(65*(i/2)) + height , (KScreenWidth/2 - 15), MDXFrom6(65))];
        [self.view addSubview:back];
        
        [back addSubview:[Tools creatLabel:CGRectMake(15, MDXFrom6(20), (KScreenWidth/2 - 15) - 15 , MDXFrom6(25)) font:[UIFont systemFontOfSize:12] color:[UIColor colorWithHexString:@"#9da9bc"] alignment:(NSTextAlignmentLeft) title:tArr[i]]];
        
        [back addSubview:[Tools creatLabel:CGRectMake(15, MDXFrom6(45), (KScreenWidth/2 - 15), 25) font:[UIFont systemFontOfSize:18] color:[UIColor colorWithHexString:@"#6d7989"] alignment:(NSTextAlignmentLeft) title:@"21312.11"]];
    }
}

- (void)setUpLine:(CGRect)rect{
    
    UIView *lien = [[UIView alloc] initWithFrame:rect];
    [lien setBackgroundColor:[UIColor colorWithHexString:@"#eeeeee"]];
    [self.view addSubview:lien];
}

#pragma mark -- 点击事件

- (void)showHistoryOrder:(UITapGestureRecognizer *)sender{
    
    NSLog(@"历史");
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
