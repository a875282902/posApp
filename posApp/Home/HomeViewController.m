//
//  HomeViewController.m
//  posApp
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomeViewController.h"
#import "IanScrollView.h"

#import "NavHidden.h"
#import "MJPopTool.h"

#import "ShopRegisterViewController.h"
#import "MallViewController.h"
#import "BusinessViewController.h"

#import "ShopMaintainViewController.h"
#import "ShareViewController.h"
#import "ActivityListViewController.h"

#import "LiveClassViewController.h"
#import "MyEarningsViewController.h"
#import "OnlineServicesViewController.h"

#import "RealNameViewController.h"

@interface HomeViewController ()<UIScrollViewDelegate>
{
    BOOL isHiddenBar;
    BOOL isOpne;
}
@property (nonatomic,strong)UIScrollView *channelView;

@property (nonatomic,strong)UIView *tishi;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self getMemberinfo];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    if (!isHiddenBar) {
        [self.navigationController setNavigationBarHidden:[NavHidden shareInstance].isHidden animated:YES];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setUpIanScrollView];
    
    [self.view addSubview:self.channelView];
    
    [self setUpChannelView];
    
  
}

- (void)getMemberinfo{
    
    NSDictionary *dic = @{@"service":@"Member.Memberinfo",@"utoken":UTOKEN};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            self->isOpne = [responseObject[@"data"][@"status"] integerValue]==1?NO:YES;
            [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"name"] forKey:@"name"];
            [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"phone"] forKey:@"phone"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}
#pragma mark -- UI
- (void)setUpIanScrollView{
    
    NSDictionary *dic = @{@"service":@"Main.Kvlists",@"utoken":UTOKEN};
    
    NSMutableArray *iArr = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                [iArr addObject:dic[@"img"]];
            }
            
            IanScrollView *scrollView = [[IanScrollView alloc] initWithFrame:CGRectMake(0, KStatusBarHeight, self.view.frame.size.width, MDXFrom6(210))];
    
            scrollView.slideImagesArray = iArr;
            scrollView.ianEcrollViewSelectAction = ^(NSInteger i){
                
                NSLog(@"点击了%ld张图片",(long)i);
                
            };
            scrollView.ianCurrentIndex = ^(NSInteger index){
                NSLog(@"测试一下：%ld",(long)index);
            };
            scrollView.PageControlPageIndicatorTintColor = [UIColor colorWithRed:255/255.0f green:244/255.0f blue:227/255.0f alpha:0.5];
            scrollView.pageControlCurrentPageIndicatorTintColor = [UIColor colorWithHexString:@"#fff600"];
            //轮播时间
            scrollView.autoTime = [NSNumber numberWithFloat:4.0f];
            [scrollView startLoading];
            [weakSelf.view addSubview:scrollView];
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}

#pragma mark -- scrollview
-(UIScrollView *)channelView{
    
    if (!_channelView) {
        _channelView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KStatusBarHeight +MDXFrom6(210), KScreenWidth, KScreenHeight - KStatusBarHeight - MDXFrom6(210)-KTabBarHeight)];
        [_channelView setShowsVerticalScrollIndicator:NO];
        [_channelView setShowsHorizontalScrollIndicator:NO];
        [_channelView setDelegate:self];
    }
    return _channelView;
}

- (void)setUpChannelView{
    
    NSArray * tArr = @[@"资料登记",@"机具领取",@"辅助资料",
                       @"客户维护",@"我要分享",@"活动专区",
                       @"视频课程",@"我的收益",@"在线客服"];
    
    NSArray * dtArr = @[@"点击记录，方便未来",@"手指一点，货品到家",@"兵马未动，物流先行",
                        @"关怀商户，提升收入",@"分享商机，扩大联盟",@"各项活动，一手掌握",
                        @"学无止境，联盟动力",@"一分耕耘一分财",@"你有疑惑，我来回答"];

    
    
    CGFloat w = KScreenWidth/3.0;
    CGFloat h = MDXFrom6(80);
    CGFloat x = (KScreenWidth/3 - MDXFrom6(30))/2.0;
    
    for (NSInteger i = 0 ; i < 9 ; i ++) {

        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(w*(i%3), h*(i/3), w, h)];
        [backView setTag:i];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChannel:)]];
        [self.channelView addSubview:backView];
        
        
        [backView addSubview:[Tools creatImage:CGRectMake(x, MDXFrom6(15), MDXFrom6(30), MDXFrom6(30)) image:[NSString stringWithFormat:@"index_menu%ld",i+1]]];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(55), w, 14) font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] alignment:(NSTextAlignmentCenter) title:tArr[i]]];
        
//        [backView addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(62)+14, w, 10) font:[UIFont systemFontOfSize:10] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentCenter) title:dtArr[i]]];
    }
    
    [self.channelView addSubview:[Tools setLineView:CGRectMake(w, 0, 1, h*3)]];
    [self.channelView addSubview:[Tools setLineView:CGRectMake(w*2, 0, 1, h*3)]];
    [self.channelView addSubview:[Tools setLineView:CGRectMake(0, h, KScreenWidth, 1)]];
    [self.channelView addSubview:[Tools setLineView:CGRectMake(0, h*2, KScreenWidth, 1)]];
    [self.channelView addSubview:[Tools setLineView:CGRectMake(0, h*3, KScreenWidth, 1)]];
    
    [self.channelView setContentSize:CGSizeMake(KScreenWidth , h*3)];
}


-(UIView *)tishi{
    if (!_tishi) {
        _tishi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 40, 80)];
        [_tishi setBackgroundColor:[UIColor redColor]];
    }
    return _tishi;
}


- (void)tapChannel:(UITapGestureRecognizer *)sender{

    if (!isOpne) {
        [self creatAlertViewControllerWithMessage];
    }
    else{
    
    isHiddenBar = NO;
    switch (sender.view.tag) {
        case 0:
        {
            ShopRegisterViewController *vc = [[ShopRegisterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            MallViewController *vc = [[MallViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            BusinessViewController *vc = [[BusinessViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            ShopMaintainViewController *vc = [[ShopMaintainViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            ShareViewController *vc = [[ShareViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 5:
        {
            ActivityListViewController *vc = [[ActivityListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            LiveClassViewController *vc = [[LiveClassViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            isHiddenBar = YES;

            MyEarningsViewController *vc = [[MyEarningsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 8:
        {
            OnlineServicesViewController *vc = [[OnlineServicesViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
            
        default:
            break;
    }
        
    }
    
}


- (void)creatAlertViewControllerWithMessage{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你还未认证，是否需要认证" preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"去认证" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        RealNameViewController *vc = [[RealNameViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"暂不认证" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
