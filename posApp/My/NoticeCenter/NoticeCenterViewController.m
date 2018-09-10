//
//  NoticeCenterViewController.m
//  posApp
//
//  Created by apple on 2018/7/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NoticeCenterViewController.h"
#import "NoticeListView.h"

@interface NoticeCenterViewController ()<NoticeListViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)NSMutableArray   * buttonArr;
@property (nonatomic,strong)UIScrollView     * listScrollView;
@property (nonatomic,strong)UIView           * lineView;

@end

@implementation NoticeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"消息中心"];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
//    [self setNavigationRightBarButtonWithTitle:@"清空消息" color:TCOLOR];
    
    self.buttonArr = [NSMutableArray array];
    
    [self.view addSubview:self.listScrollView];
    
    [self createChannelView];
}

- (void)leftButtonTouchUpInside:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- scrollview
-(UIScrollView *)listScrollView{
    
    if (!_listScrollView) {
        _listScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, KScreenWidth, KViewHeight-35)];
        [_listScrollView setContentSize:CGSizeMake(KScreenWidth *4, KViewHeight-35)];
        [_listScrollView setShowsVerticalScrollIndicator:NO];
        [_listScrollView setPagingEnabled:YES];
        [_listScrollView setShowsHorizontalScrollIndicator:NO];
        [_listScrollView setDelegate:self];
    }
    return _listScrollView;
}

- (void)createChannelView{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 35)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:backView];
    
    CGFloat X = (KScreenWidth - 245)/2.0;
    
    NSArray *tArr = @[@"公告",@"提醒",@"定货",@"实名"];
    
    for (NSInteger i = 0 ; i < 4 ; i ++) {
        
        UIButton *btn = [Tools creatButton:CGRectMake(X+65*i, 0 , 50, 35) font:[UIFont systemFontOfSize:15] color:[UIColor blackColor] title:tArr[i] image:@""];
        [btn setTitleColor:[UIColor colorWithHexString:@"#ff5941"] forState:(UIControlStateSelected)];
        [btn setTag:i];
        if (i==0) {
            [btn setSelected:YES];
        }
        [btn addTarget:self action:@selector(selectChannel:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:btn];
     
        [self.buttonArr addObject:btn];
    }
    
    for (NSInteger i = 0 ; i < 4; i++) {
        NoticeListView *listV = [[NoticeListView alloc] initWithFrame:CGRectMake(KScreenWidth *i, 0, KScreenWidth, KViewHeight-35) withType:[NSString stringWithFormat:@"%ld",i+1]];
        [listV setDelegate:self];
        [self.listScrollView addSubview:listV];
    }
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(X, 33, 50, 2)];
    [self.lineView setBackgroundColor:[UIColor colorWithHexString:@"#ff5941"]];
    [self.view addSubview:self.lineView];
}

- (void)selectChannel:(UIButton *)sender{
    
    if (!sender.selected) {
        
        for (UIButton *btn in self.buttonArr) {
            [btn setSelected:NO];
        }
        
        [sender setSelected:YES];
        
        [UIView animateWithDuration:.2 animations:^{
            [self.lineView setCenter:CGPointMake(sender.center.x, self.lineView.center.y)];
            [self.listScrollView setContentOffset:CGPointMake(KScreenWidth * sender.tag, 0)];
        }];
    }
}



- (void)pushNoticeDetails:(BaseViewController *)vc{
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -- scrollVIew 协议 、、 数据刷新
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.listScrollView) {
        
        // 如果在拖动结束的时候，没有减速的过程
        if (!decelerate){
            
            NSInteger page = scrollView.contentOffset.x/KScreenWidth;
            
            [self selectChannel:self.buttonArr[page]];
        }
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.listScrollView) {
        NSInteger page = scrollView.contentOffset.x/KScreenWidth;
        
        [self selectChannel:self.buttonArr[page]];
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
