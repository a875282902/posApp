//
//  ActivityDetailsViewController.m
//  posApp
//
//  Created by apple on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ActivityDetailsViewController.h"

@interface ActivityDetailsViewController ()<UIWebViewDelegate>

@end

@implementation ActivityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setTitle:@"活动详情"];
    [self baseForDefaultLeftNavButton];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
    [web setBackgroundColor:[UIColor whiteColor]];
    [web.scrollView setShowsVerticalScrollIndicator:YES];
    [web.scrollView setShowsHorizontalScrollIndicator:YES];
    [web loadHTMLString:[self stringToHtmlWith:self.img] baseURL:[NSURL URLWithString:KURL]];
    [web setDelegate:self];
    [self.view addSubview:web];
}


- (NSString *)stringToHtmlWith:(NSString *)content{
    
    return [NSString stringWithFormat:@"<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><title>Title</title><style>img{width: 100%%;}</style></head><body><img src=%@></body></html>",content];
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
