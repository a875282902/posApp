//
//  LiveClassViewController.m
//  posApp
//
//  Created by apple on 2018/7/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LiveClassViewController.h"
#import "LiveClassTableViewCell.h"

@interface LiveClassViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
}

@property (nonatomic,strong)UITableView     * tmpTableView;
@property (nonatomic,strong)NSMutableArray  * dataArr;

@end

@implementation LiveClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self baseForDefaultLeftNavButton];
    [self setTitle:@"视频教程"];
    
    _page = 1;
    
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
//        [weakSelf.tmpTableView.footer resetNoMoreData];
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
        
        [weakSelf.tmpTableView reloadData];
        [weakSelf.tmpTableView.footer endRefreshing];
        
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LiveClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LiveClassTableViewCell"];
    if (!cell) {
        cell = [[LiveClassTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"LiveClassTableViewCell"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return MDXFrom6(180);
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
