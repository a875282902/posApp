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

#import "ShopRegisterViewController.h"
#import "LiveClassViewController.h"
#import "MallViewController.h"
#import "BusinessViewController.h"
#import "ActivityListViewController.h"


@interface HomeViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *channelView;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:[NavHidden shareInstance].isHidden animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setUpIanScrollView];
    
    [self.view addSubview:self.channelView];
    
    [self setUpChannelView];
}

#pragma mark -- UI
- (void)setUpIanScrollView{
    
    IanScrollView *scrollView = [[IanScrollView alloc] initWithFrame:CGRectMake(0, KStatusBarHeight, self.view.frame.size.width, MDXFrom6(210))];
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 1; i < 7; i ++) {
        [array addObject:[NSString stringWithFormat:@"http://childmusic.qiniudn.com/huandeng/%ld.png", (long)i]];
    }
    scrollView.slideImagesArray = array;
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
    [self.view addSubview:scrollView];
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
    
    NSArray * tArr = @[@"商户登记",@"机具申请",@"业务辅助",
                       @"商户维护",@"我要分享",@"活动专区",
                       @"视频课程",@"我的收益",@"在线客服"];
    
    NSArray * dtArr = @[@"点击记录，方便未来",@"手指一点，货品到家",@"兵马未动，物流先行",
                        @"关怀商户，提升收入",@"分享商机，扩大联盟",@"各项活动，一手掌握",
                        @"学无止境，联盟动力",@"一分耕耘一分财",@"你有疑惑，我来回答"];

    
    
    CGFloat w = KScreenWidth/3.0;
    CGFloat h = MDXFrom6(110);
    CGFloat x = (KScreenWidth/3 - MDXFrom6(30))/2.0;
    
    for (NSInteger i = 0 ; i < 9 ; i ++) {

        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(w*(i%3), h*(i/3), w, h)];
        [backView setTag:i];
        [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChannel:)]];
        [self.channelView addSubview:backView];
        
        
        [backView addSubview:[Tools creatImage:CGRectMake(x, MDXFrom6(15), MDXFrom6(30), MDXFrom6(30)) image:[NSString stringWithFormat:@"index_menu%ld",i+1]]];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(55), w, 14) font:[UIFont systemFontOfSize:14] color:[UIColor blackColor] alignment:(NSTextAlignmentCenter) title:tArr[i]]];
        
        [backView addSubview:[Tools creatLabel:CGRectMake(0, MDXFrom6(62)+14, w, 10) font:[UIFont systemFontOfSize:10] color:[UIColor colorWithHexString:@"#999999"] alignment:(NSTextAlignmentCenter) title:dtArr[i]]];
    }
    
    [self.channelView addSubview:[Tools setLineView:CGRectMake(w, 0, 1, h*3)]];
    [self.channelView addSubview:[Tools setLineView:CGRectMake(w*2, 0, 1, h*3)]];
    [self.channelView addSubview:[Tools setLineView:CGRectMake(0, h, KScreenWidth, 1)]];
    [self.channelView addSubview:[Tools setLineView:CGRectMake(0, h*2, KScreenWidth, 1)]];
    [self.channelView addSubview:[Tools setLineView:CGRectMake(0, h*3, KScreenWidth, 1)]];
    
    [self.channelView setContentSize:CGSizeMake(KScreenWidth , h*3)];
}

- (void)tapChannel:(UITapGestureRecognizer *)sender{
    
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
            
        default:
            break;
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
