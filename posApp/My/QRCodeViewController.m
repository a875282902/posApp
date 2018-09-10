//
//  QRCodeViewController.m
//  posApp
//
//  Created by apple on 2018/8/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QRCodeViewController.h"
#import "ShareView.h"
#import "WXApi.h"

@interface QRCodeViewController ()<ShareViewDelegate>

@property (nonatomic,strong) NSDictionary *data;

@property (nonatomic,strong) ShareView *shareView;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:MDRGBA(248, 248, 248, 1)];
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"二维码分享"];
    [self getData];
    
    [self createShareView];
    
}
- (void)createShareView{
    
    self.shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.shareView setDelegate:self];
    [[UIApplication sharedApplication].windows.firstObject addSubview:self.shareView];
}

- (void)getData{
    NSDictionary *dic = @{@"service":@"Main.Getshare",@"utoken":UTOKEN};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            weakSelf.data = responseObject[@"data"];
            
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

- (void)setUpUI{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, KScreenWidth  -30, 250)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:backView];
    
    [backView addSubview:[Tools creatImage:CGRectMake((KScreenWidth-130)/2, 40, 100, 100) url:self.data[@"qrcode"] image:@""]];
    
    [backView addSubview:[Tools creatLabel:CGRectMake(0, 150, KScreenWidth-30, 14) font:[UIFont systemFontOfSize:14] color:[UIColor grayColor] alignment:(NSTextAlignmentCenter) title:@"扫码即可注册"]];
    
    [backView addSubview:[Tools creatImage:CGRectMake(10, 199, 12, 12) image:@"add_name"]];
    
    [backView addSubview:[Tools creatLabel:CGRectMake(30, 190, KScreenWidth - 60, 30) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:[[NSUserDefaults standardUserDefaults] valueForKey:@"name"]]];
    
    [backView addSubview:[Tools setLineView:CGRectMake(0, 219, KScreenWidth - 30, 1)]];
    
    [backView addSubview:[Tools creatImage:CGRectMake(10, 229, 12, 12) image:@"add_phone"]];
    
    [backView addSubview:[Tools creatLabel:CGRectMake(30, 220, KScreenWidth - 60, 30) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] alignment:(NSTextAlignmentLeft) title:[[NSUserDefaults standardUserDefaults] valueForKey:@"phone"]]];
    
    
    
    UIButton *btn = [Tools creatButton:CGRectMake(MDXFrom6(20),280, KScreenWidth - MDXFrom6(40), MDXFrom6(50)) font:[UIFont systemFontOfSize:16] color:[UIColor whiteColor] title:@"邀请盟友加入" image:@""];
    [btn setBackgroundColor:MDRGBA(255, 181, 0, 1)];
    [btn.layer setCornerRadius:5];
    [btn setClipsToBounds:YES];
    [btn addTarget:self action:@selector(shareFriend:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    
}

- (void)shareFriend:(UIButton *)sender{
    
    [self.shareView show];
}

- (void)share:(NSInteger)index{
    
    
    [self.shareView remove];

    [self shareWithType:index title:@"快来注册易激活！" description:@"快来注册易激活！" url:self.data[@"url"] image:@""];
}
- (void)shareWithType:(NSInteger)type title:(NSString *)title description:(NSString *)description  url:(NSString *)url image:(NSString *)image{
    
    int i = [[NSNumber numberWithInteger:type] intValue];
    
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = i;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = title;//分享标题
    urlMessage.description = description;//分享描述
    [urlMessage setThumbImage:[UIImage imageNamed:@"logo"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
    
    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = url;//分享链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    
    //发送分享信息
    [WXApi sendReq:sendReq];
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
