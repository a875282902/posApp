//
//  NoticeDetailsViewController.m
//  posApp
//
//  Created by apple on 2018/7/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NoticeDetailsViewController.h"
#import <WebKit/WebKit.h>


@interface NoticeDetailsViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
{
    NSString *fav_id;
}

@property (nonatomic , strong)UIScrollView * tmpScrollView;

@property (nonatomic , strong)NSMutableDictionary *data;

@property (nonatomic , strong)WKWebView *tmpWeView;



@end

@implementation NoticeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.data = [NSMutableDictionary dictionary];
    [self baseForDefaultLeftNavButton];
    
    [self setTitle:@"消息内容"];
    
    [self requestData];
    
    [self.view addSubview:[Tools setLineView:CGRectMake(0, 0, KScreenWidth, 1)]];
}

- (void)requestData{
    
    NSDictionary *dic = @{@"service":@"Notice.Info",
                          @"utoken":UTOKEN,
                          @"id":self.noticeID};
    
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"加载中···";
    __weak typeof(self) weakSelf = self;
    
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        if ([responseObject[@"ret"] intValue] == 200) {
            
            [self setUpView:responseObject[@"data"]];
            
            weakSelf.data = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
            [weakSelf.tmpWeView loadHTMLString:[weakSelf heard:[weakSelf HTML:weakSelf.data[@"content"]]] baseURL:nil];
            
            
            
        }
        else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [ViewHelps showHUDWithText:@"加载失败"];
    }];
}
- (void)setUpView:(NSDictionary *)dic{
    
    if (!self.tmpScrollView) {
        self.tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 65)];
        [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, KScreenWidth*2)];
        [self.view addSubview:self.tmpScrollView];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 40)];
    [titleLabel setText:dic[@"title"]];
    [titleLabel setNumberOfLines:0];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.tmpScrollView addSubview:titleLabel];
    
//    UIImageView *time = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MDXFrom6(20), MDXFrom6(20))];
//    [time setImage:[UIImage imageNamed:@"time"]];
//    [time setCenter:CGPointMake(MDXFrom6(30), MDXFrom6(100))];
//    [self.tmpScrollView addSubview:time];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, KScreenWidth - 20, 15)];
    [timeLabel setText:[self stringToDate:dic[@"createtime"]]];
    [timeLabel setTextColor:[UIColor grayColor]];
    [timeLabel setTextAlignment:(NSTextAlignmentLeft)];
    [timeLabel setFont:[UIFont systemFontOfSize:12]];
    [self.tmpScrollView addSubview:timeLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, KScreenWidth, MDXFrom6(1))];
    [lineView setBackgroundColor:MDRGBA(157, 157, 157, 1)];
    [self.tmpScrollView addSubview:lineView];
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
        _tmpWeView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 0) configuration:wkWebConfig];
        [_tmpWeView setNavigationDelegate:self];
        [_tmpWeView setUserInteractionEnabled:NO];
    }
    
    return _tmpWeView;
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
    NSLog(@"%@",webView.URL);
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.tmpWeView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.tmpWeView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionInitial context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.tmpWeView.scrollView && [keyPath isEqual:@"contentSize"]) {
        // we are here because the contentSize of the WebView's scrollview changed.
        
        UIScrollView *scrollView = self.tmpWeView.scrollView;
        [self.tmpWeView setFrame:CGRectMake(0,60, KScreenWidth, scrollView.contentSize.height)];
        [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth, 60+scrollView.contentSize.height)];
        [self.tmpScrollView addSubview:self.tmpWeView];
        
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
