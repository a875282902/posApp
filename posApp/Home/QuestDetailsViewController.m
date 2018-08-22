//
//  QuestDetailsViewController.m
//  posApp
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QuestDetailsViewController.h"

@interface QuestDetailsViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *web;

@end

@implementation QuestDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    [self baseForDefaultLeftNavButton];

    [self getDetalis];
    
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
    [self.web setBackgroundColor:[UIColor whiteColor]];
    [self.web.scrollView setShowsVerticalScrollIndicator:YES];
    [self.web.scrollView setShowsHorizontalScrollIndicator:YES];
    [self.web setDelegate:self];
    [self.view addSubview:self.web];
    
}

- (void)getDetalis{
    NSDictionary *dic = @{@"service":@"Main.Qinfo",@"utoken":UTOKEN,@"id":self.questID};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            [weakSelf setTitle:responseObject[@"data"][@"title"]];
            
            [weakSelf.web loadHTMLString:[weakSelf stringToHtmlWith:responseObject[@"data"][@"content"]] baseURL:[NSURL URLWithString:KURL]];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}
- (NSString *)stringToHtmlWith:(NSString *)content{
    
    return [NSString stringWithFormat:@"<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><title>Title</title></head><body>%@</body></html>",content];
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
