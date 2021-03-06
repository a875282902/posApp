//
//  LiveClassViewController.m
//  posApp
//
//  Created by apple on 2018/7/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LiveClassViewController.h"
#import "LiveClassTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Rotating.h"

@interface LiveClassViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
}

@property (nonatomic,strong)UITableView     * tmpTableView;
@property (nonatomic,strong)NSMutableArray  * dataArr;

@end

@implementation LiveClassViewController
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
        
    }
    
    [Rotating shareRotating].isflag = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"视频教程"];
    
    _page = 1;
    self.dataArr = [NSMutableArray array];
    [self.view addSubview:self.tmpTableView];
    
    [self load];
    
    [self.tmpTableView.header beginRefreshing];
}

#pragma mark -- refresh
- (void)load{
    __weak typeof(self) weakSelf = self;
    
    self.tmpTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->_page = 1;
        
        [weakSelf.dataArr removeAllObjects];
        [weakSelf.tmpTableView.footer resetNoMoreData];
        [weakSelf pullDownRefresh];
    }];
    
    self.tmpTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self->_page ++;
        [weakSelf pullUpLoadMore];
    }];
    
}
//下拉刷新
- (void)pullDownRefresh{
    
    NSDictionary *dic = @{@"service":@"Video.Lists",@"utoken":UTOKEN,@"p":[NSString stringWithFormat:@"%ld",_page]};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in responseObject[@"data"]) {
                    [weakSelf.dataArr addObject:dict];
                }
            }else{
                
                [weakSelf.tmpTableView.footer noticeNoMoreData];
            }
        }
        else{
            
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        
        if (weakSelf.dataArr.count < self->_page*10) {
            [weakSelf.tmpTableView.footer noticeNoMoreData];
        }
        [weakSelf.tmpTableView reloadData];
        [weakSelf.tmpTableView.header endRefreshing];
        
    } failure:^(NSError *error) {
        [weakSelf.tmpTableView.header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
    
}
//上拉加载
- (void)pullUpLoadMore{
    
    NSDictionary *dic = @{@"service":@"Video.Lists",@"utoken":UTOKEN,@"p":[NSString stringWithFormat:@"%ld",_page]};
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:KURL parameters:dic success:^(id responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if ([responseObject[@"ret"] integerValue]==200) {
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in responseObject[@"data"]) {
                    [weakSelf.dataArr addObject:dict];
                }
            }else{
                
                [weakSelf.tmpTableView.footer noticeNoMoreData];
            }
            
        }
        else{
            self->_page --;
            [ViewHelps showHUDWithText:responseObject[@"msg"]];
        }
        [weakSelf.tmpTableView.footer endRefreshing];
        if (weakSelf.dataArr.count < self->_page*10) {
            [weakSelf.tmpTableView.footer noticeNoMoreData];
        }
        
        [weakSelf.tmpTableView reloadData];

        
    } failure:^(NSError *error) {
        self->_page --;
        [weakSelf.tmpTableView.footer endRefreshing];
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [RequestSever showMsgWithError:error];
    }];
}

#pragma mark -- tableView
- (UITableView *)tmpTableView{
    
    if (!_tmpTableView) {
        _tmpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight) style:(UITableViewStylePlain)];
        [_tmpTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            [_tmpTableView setContentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentNever)];
        }
        [_tmpTableView setShowsVerticalScrollIndicator:NO];
        [_tmpTableView setShowsHorizontalScrollIndicator:NO];
        [_tmpTableView setDataSource:self];
        [_tmpTableView setDelegate:self];
    }
    return _tmpTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LiveClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LiveClassTableViewCell"];
    if (!cell) {
        cell = [[LiveClassTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"LiveClassTableViewCell"];
    }
    if (indexPath.row<self.dataArr.count) {
        
        [cell bandDataWithDictionary:self.dataArr[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return MDXFrom6(180);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataArr[indexPath.row][@"filepath"] length] !=0) {
        [self showUrl:self.dataArr[indexPath.row][@"filepath"]];
    }
}

- (void)showUrl:(NSString *)url{
    
    MPMoviePlayerViewController *playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:url]];
    
    // 开启模态对话窗体
    [self presentViewController:playerController animated:YES completion:^{
        [Rotating shareRotating].isflag = YES;
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            
            SEL selector = NSSelectorFromString(@"setOrientation:");
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            
            [invocation setSelector:selector];
            
            [invocation setTarget:[UIDevice currentDevice]];
            
            int val = UIInterfaceOrientationLandscapeRight;
            
            [invocation setArgument:&val atIndex:2];
            
            [invocation invoke];
        }
    }];
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
