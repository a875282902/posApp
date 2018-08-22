//
//  ShopMaintainViewController.m
//  posApp
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShopMaintainViewController.h"
#import "ShopMaintainView.h"

@interface ShopMaintainViewController ()<UIScrollViewDelegate>
{
    UIButton *channelBtn;
    UIView *_lineView;
}

@property (nonatomic,strong)UIScrollView *tmpScrollView;

@end

@implementation ShopMaintainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"商户维护"];
    
    [self setUpChannelButton];
    [self setUpChannelView];
    
}
- (void)setUpChannelButton{
    
    for (NSInteger i = 0 ; i < 2 ; i++) {
        
        UIButton *btn = [Tools creatButton:CGRectMake(KScreenWidth*i/2, 5, KScreenWidth/2, 35) font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] title:i==0?@"需回访商户":@"活跃商户" image:@""];
        [btn setTag:i+1000];
        [btn setTitleColor:RCOLOR forState:(UIControlStateSelected)];
        if (i==0) {
            [btn setSelected:YES];
            channelBtn = btn;
        }
        [btn addTarget:self action:@selector(selectType:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:btn];
        
    }
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth/2 - 50)/2, 45, 50, 2)];
    [_lineView setBackgroundColor:RCOLOR];
    [self.view addSubview:_lineView];
    
}

#pragma mark -- scrollview
-(UIScrollView *)tmpScrollView{
    
    if (!_tmpScrollView) {
        _tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, KViewHeight - 50)];
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
        ShopMaintainView *v = [[ShopMaintainView alloc] initWithFrame:CGRectMake(KScreenWidth*i, 0, KScreenWidth, self.tmpScrollView.frame.size.height)];
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
