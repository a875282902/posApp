//
//  FriendsViewController.m
//  posApp
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HistoryResultsViewController.h"

#import "NavHidden.h"

#import "HistoryInfoView.h"

@interface HistoryResultsViewController ()<UIScrollViewDelegate>
{
    UIButton *channelBtn;
    UIView *_lineView;
}

@property (nonatomic,strong)UIScrollView *tmpScrollView;

@end

@implementation HistoryResultsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.navigationController setNavigationBarHidden:[NavHidden shareInstance].isHidden animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpChannelButton];
    
    [self setUpChannelView];
}

- (void)setUpChannelButton{
    
    for (NSInteger i = 0 ; i < 2 ; i++) {
        
        UIButton *btn = [Tools creatButton:CGRectMake(KScreenWidth*i/2, KStatusBarHeight + 10, KScreenWidth/2, 35) font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] title:i==0?@"按日查询":@"按月查询" image:@""];
        [btn setTag:i+1000];
        [btn setTitleColor:RCOLOR forState:(UIControlStateSelected)];
        if (i==0) {
            [btn setSelected:YES];
            channelBtn = btn;
        }
        [btn addTarget:self action:@selector(selectType:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:btn];
        
    }
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth/2 - 50)/2, KStatusBarHeight + 45, 50, 2)];
    [_lineView setBackgroundColor:RCOLOR];
    [self.view addSubview:_lineView];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(10, KStatusBarHeight, 25, 44)];
    [rightButton setImage:[UIImage imageNamed:@"ss_back"] forState:UIControlStateNormal];
    [rightButton setTag:1];
    [rightButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,  KStatusBarHeight + 47, KScreenWidth, KScreenHeight  - KStatusBarHeight - 47)];
        [_tmpScrollView setShowsVerticalScrollIndicator:NO];
        [_tmpScrollView setShowsHorizontalScrollIndicator:NO];
        [_tmpScrollView setPagingEnabled:YES];
        [_tmpScrollView setDelegate:self];
    }
    return _tmpScrollView;
}

- (void)setUpChannelView{
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth*2, self.tmpScrollView.frame.size.height)];
    [self.view addSubview:self.tmpScrollView];
    
    for (NSInteger i = 0 ; i < 2 ; i ++) {
        HistoryInfoView *v = [[HistoryInfoView alloc] initWithFrame:CGRectMake(KScreenWidth*i, 0, KScreenWidth, self.tmpScrollView.frame.size.height)];
        [v setIndex:i];
        [self.tmpScrollView addSubview:v];
    }
}

- (void)selectType:(UIButton *)sender{
    
    if (!sender.selected) {
        
        [channelBtn setSelected:NO];
        [sender setSelected:YES];
        channelBtn = sender;
        
        [UIView animateWithDuration:.3 animations:^{
            [self->_lineView setCenter:CGPointMake(sender.center.x, self->_lineView.center.y)];
            [self.tmpScrollView setContentOffset:CGPointMake(KScreenWidth *(sender.tag - 1000), 0) animated:YES];
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger i = scrollView.contentOffset.x/KScreenWidth;
    [self selectType:[self.view viewWithTag:i+1000]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate) {
        NSInteger i = scrollView.contentOffset.x/KScreenWidth;
        [self selectType:[self.view viewWithTag:i+1000]];
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
