//
//  BusinessDetailsViewController.m
//  posApp
//
//  Created by apple on 2018/8/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BusinessDetailsViewController.h"
#import <WebKit/WebKit.h>

@interface BusinessDetailsViewController ()<WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *tmpWeView;

@end

@implementation BusinessDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    
    [self setTitle:@"业务辅助"];
    
    [self.view addSubview:self.tmpWeView];
    
    [self getData];
}

- (void)getData{
    
    NSDictionary *dic = @{@"service":@"Yewu.Info",@"utoken":UTOKEN,@"id":self.businessID};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            [weakSelf.tmpWeView loadHTMLString:[weakSelf heard:[weakSelf HTML:[weakSelf addTitleAndTime:responseObject[@"data"]]]] baseURL:[NSURL URLWithString:KURL]];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}

- (NSString *)addTitleAndTime:(NSDictionary *)dic{
    
    NSString *str = [NSString stringWithFormat:@"<h1 style=\"font-size:20px;\">%@</h1> <p style=\"color:LightGray;font-size:12px;\">%@</p> \n %@",dic[@"title"],[self stringToDate:dic[@"createtime"]],dic[@"content"]];
    
    return str;
}
//时间戳转时间
- (NSString *)stringToDate:(NSString *)str{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
}
#pragma mark - tmpWeView
- (WKWebView *)tmpWeView{
    
    if (!_tmpWeView) {
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        // 自适应屏幕宽度js
        NSString *jSString =@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        
        // 添加自适应屏幕宽度js调用的方法
        [userContentController addUserScript:wkUserScript];
        wkWebConfig.userContentController = userContentController;
        _tmpWeView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight) configuration:wkWebConfig];
        [_tmpWeView setNavigationDelegate:self];
    }
    
    return _tmpWeView;
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
